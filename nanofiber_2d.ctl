; This code calculate some basic properties of a square waveguide using a dipole source.
; It is initially modified from an example from http://isblokken.dk/wiki/doku.php/note/201210_3d_waveguide_model .
; By Xiaodong Qi (i2000s@hotmail.com), 2016-11-28.

(reset-meep)
; Materials
(define SiO2 (make dielectric (index 1.46)))
(define Vac (make dielectric (index 1.0)))
(define SiN (make dielectric (index 1.98)))

; Waveguide
(define-param mwg SiO2) ; waveguide material
(define-param r 0.225)
(define-param wwg 0.45) ; waveguide width. Nanometer is the unit for length.
(define-param hwg 0.45) ; waveguide height
(define-param lwg 5) ; initial waveguide length


; Cladding
(define-param mcl Vac) ; cladding material
;	(define-param mcl SiO2) ; cladding material

; Light
(define-param lwavelength 0.895) ; light pulse center wavelength (frequency)
(define-param ldf 0.02)  ; light pulse width [in frequency]. I set to 2e-8 before to reflect the real pulse width of an Cs atom, but this doesn't have to be so.
												; Unit freq is 3e14 in Hz.

; Paddings and pmls
(define-param tpml 1) ; thickness of PML
(define-param xpad 2) ; thickness of x-padding
(define-param ypad 2) ; thickness of y-padding
(define-param zpad 0) ; thickness of z-padding


; Resolution
(define-param res 100) ; resolution of computational cell

; Default material
(set! default-material mcl)

; Run with sub-pixel averaging?
(set! eps-averaging? false)

; Use complex field.
(set! force-complex-fields? true)

; Set Curant factor S which relates the time step size to the spatial discretization: cΔt = SΔx. Default is 0.5. For numerical stability,
; the Courant factor must be at most n_\textrm{min}/\sqrt{\textrm{\# dimensions}}, where nmin is the minimum refractive index (usually 1), and in practice S should be slightly smaller.
(set! Courant 0.4)

; Calculation of parameters
(define xsz (+ wwg (* 2 xpad) (* 2 tpml)) ) ; x-size of computational cell
(define ysz (+ hwg (* 2 ypad) (* 2 tpml)) ) ; y-size of computational cell
(define zsz (+ lwg (* 2 zpad) (* 2 tpml)) ) ; z-size of computational cell

; SET COMPUTATIONAL CELL SIZE
(set! geometry-lattice
		(make lattice (size xsz ysz no-size))
)

; MAKE GEOMETRY: Build Cylindrical WG and extend it thru PMLs and PADs
(set! geometry  (list (make cylinder (center 0 0 0) (radius r) (height infinity) (axis 0 0 1)
                      (material mwg))
								)
)


; SET PMLs
(set! pml-layers (list (make pml (thickness tpml))))

; SET RESOLUTION
(set-param! resolution res)

; SET SOURCES
(set! sources
		(list
            (make source
		       		  (src (make continuous-src (wavelength lwavelength) (fwidth ldf) (cutoff 5.0) ))
					          (component Ex) (size 0 0 0) (center (+ (/ wwg 2) 0.2) 0 0)

			      )
		 )
)

(define (announce-source-time) (print "source excitation should be finished at time " (meep-fields-last-source-time fields) "\n") )

(init-fields)
(define dt (meep-fields-dt-get fields))
(define (print-time-step-size) (print "time step size: " dt "\n"))

; (run-sources+
; (stop-when-fields-decayed 50 Ex
(run-until 240
	(at-beginning output-epsilon announce-source-time print-time-step-size)
	(at-every 40 output-efield-x)
	(at-every 40 output-efield-y)
	(at-every 40 output-efield-z)
	(to-appended "Ert"
  		(at-every dt
				(in-volume (volume (center (+ (/ wwg 2) 0.2) 0 0) (size 0 0 0)) output-efield-x)
			 	(in-volume (volume (center (+ (/ wwg 2) 0.2) 0 0) (size 0 0 0)) output-efield-y)
				(in-volume (volume (center (+ (/ wwg 2) 0.2) 0 0) (size 0 0 0)) output-efield-z)))
)
