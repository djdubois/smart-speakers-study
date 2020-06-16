===================
  ANALYSIS MATLAB
===================

The code in this directory performs the various analysis steps on the activation data.
The input data for the analysis is included in the 'data' directory, which is the
actual data we obtained from our experiments.

Customization for different dataset can be done, by editing the file 'loadAllActivations.m"

This MATLAB code is run by invoking "main.mat" using MATLAB R2019b (or later) with the
Financial Toolbox installed.

This can be done either by clicking "run" on MATLAB once selecting main.mat, or by
typing "main" at the MATLAB command window.

EXPECTED RESULT:

>> main
*** STARTING VOICE-ASSIST ANALYSIS SCRIPTS ***
STEP 1 of 7. Loading camera activations (US)...
STEP 2 of 7. Loading traffic activations (US)...
STEP 3 of 7. Loading cloud activations (US)...
STEP 4 of 7. Loading camera activations (UK)...
STEP 5 of 7. Computing statistics...
STEP 6 of 7. Generating plots and tables...
STEP 7 of 7. Generating list of repeatable activations from camera (US)...
*** DONE ***

Once all the steps have been done, the output directory will be populated
with the following:

1) All the plots for the results section of the paper in PDF format
2) All the tables for the paper in LaTeX format
3) The list of repeatable activations, which are used to extract the
   subtitles for the appendix.
