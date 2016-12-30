; This code calculate some basic properties of a square waveguide using a dipole source.
; It is initially modified from an example from http://isblokken.dk/wiki/doku.php/note/201210_3d_waveguide_model .
; By Xiaodong Qi (i2000s@hotmail.com), 2016-11-28.

(reset-meep)
; Materials
(define SiO2 (make dielectric (index 1.46)))
(define Vac (make dielectric (index 1.0)))
(define SiN (make dielectric (index 1.98)))

; Waveguide
(define-param mwg SiN) ; waveguide material
(define-param wwg 0.3) ; waveguide width. Nanometer is the unit for length.
(define-param hwg 0.3) ; waveguide height
(define-param lwg 2) ; initial waveguide length


; Cladding
(define-param mcl Vac) ; cladding material
;	(define-param mcl SiO2) ; cladding material

; Light
(define-param lwavelength 0.895) ; light pulse center wavelength (frequency)
(define-param ldf 0.02)  ; light pulse width [in frequency]. Unit freq is 3e14 in Hz.

; Paddings and pmls
(define-param tpml 0.8) ; thickness of PML
(define-param xpad 1.5) ; thickness of x-padding
(define-param ypad 1.5) ; thickness of y-padding
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
		(make lattice (size xsz ysz zsz))
)

; MAKE GEOMETRY

(set! geometry
	(list
		; Build WG and extend it thru PMLs and PADs
		(make block (center 0 0 0) (size wwg hwg infinity) (material mwg))
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
		       		  (src (make gaussian-src (wavelength lwavelength) (fwidth ldf) ))
					          (component Ex) (size 0 0 0) (center (+ (/ wwg 2) 0.2) 0 0)

			      )
		 )
)

; (run-sources+
; (stop-when-fields-decayed 50 Ex
(run-until 240
	(at-beginning output-epsilon)
	(at-every 40 output-efield-x)
	(at-every 40 output-efield-y)
	(at-every 40 output-efield-z)
	(to-appended "Ert"
  		(at-every 0.2
				(in-volume (volume (center (+ (/ wwg 2) 0.2) 0 0) (size 0 0 0)) output-efield-x)
			 	(in-volume (volume (center (+ (/ wwg 2) 0.2) 0 0) (size 0 0 0)) output-efield-y)
				(in-volume (volume (center (+ (/ wwg 2) 0.2) 0 0) (size 0 0 0)) output-efield-z)))
)
