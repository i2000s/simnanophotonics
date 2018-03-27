README
======

Codes for simulating waveguide properties using MEEP, BEM and analytical solutions.
Two major waveguides are considered for these demons:

1. An optical nanofiber with a cylindrical geometry

2. A square waveguide with a square cross-section

## List of major files:
Note: I am not distinguishing capitalizations.

### 1. FDTD simulations with MEEP (computationally too costly for our subject)
+ vacuum.ctl: MEEP script for simulating a dipole radiation in vacuum for calibration purpose.
+ nanofiber.ctl: MEEP configuration file for a nanofiber.
+ nanofiber_2D.ctl: only a 2D simulation is used.
+ nanofiber.ipynb: Jupyter notebook reading the simulation data (in the /data folder) of `nanofiber.ctl`. Julia is used for scripting.
+ nanofiber_2D.ipynb
+ sqwg.ctl: MEEP script for a square waveguide (only 2D is used, as tested by the nanofiber case).
+ sqwg.ipynb

### 2. BEM approach (simulation package source code not available in public)
+ nanofiber_BEM.ipynb: visualizing the data, compared with analytical solutions and the data set from another approach (done in Matlab). Only D1 line transitions of Cesium (133) atoms are considered.
+ nanofiber_BEM_D2.ipynb: D2 line transitions are used.
+ sqwg_BEM.ipynb
+ sqwg_BEM_D2.ipynb

Data files follow a similar naming convention, and should be explicit following the notebooks on where they are utilized.

## To cite this source:
+ Pleae fetch information from this DOI: [![DOI](https://zenodo.org/badge/75046845.svg)](https://zenodo.org/badge/latestdoi/75046845)

***Thanks to CQuIC.unm.edu and CARC.unm.edu for the high-performance cluster services, and Prof. Alejandro Manjavacas for the BEM supports.***
