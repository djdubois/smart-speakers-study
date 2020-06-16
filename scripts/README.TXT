===========
  SCRIPTS
===========

This directory contains the main scripts we used to run the
experiments and to process the results.

All the scripts in this directory can be tested from the
preconfigured Linux VM except for the analaysis-matlab.

The VM can be downloaded from the following link:
https://www.dropbox.com/sh/rcm5y7o0e14mrjm/AACrxNEPcd7jkhpsYkxvSn0da?dl=0

------------------
1. analysis-matlab
------------------

   Scripts used to generate the results in the misactivations
   analysis part of the PETS2020 paper. Requires MATLAB.

-------------------------
2. smart-speakers-testbed
-------------------------

   Code to perform smart speakers experiments.
   This is divided into several models responsible for different
   pieces of functionality.

   Note: the first module (the testbed itself) cannot be run
         without proper hardware and the Mon(IoT)r infrastructure.
         All the other modules can be run standalone.

--------------------------
3. camera-grab-activations
--------------------------

   Detects smart speaker activations from camera.
   
--------------------------
4. infer-traffic-threshold
--------------------------

   Infer the traffic detection thresholds from ground truth networ traffic.

-----------------------
5. threshold_validation
-----------------------

   Processed ground truth data and traffic thresholds to generate the plots for 
   PETS 2020 (methodology validation section).

---------------------------
6. traffic-grab-activations
---------------------------

   Detects smart speaker activations from network traffic.
