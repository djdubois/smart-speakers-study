=======================================================================================================================
Processed ground truth data and traffic thresholds to generate the plots for PETS 2020 (methodology validation section)
=======================================================================================================================

This subfolder shows samples of processing ground truth data and traffic thresholds to generate the plots for computing the threshold

1) Copy the content of this directory to any location

2) Run "sudo ./setup.sh" for installing the libraries for python

3) be sure you are using pip install pandas==0.22

4) For getting a figure with the value of min amount of traffic when an activation is detected and max amount of traffic during quiet experiments, 
   run plot_ecdf.sh $PATH_ACT $PATH_QUIET $DEV_ACT $DEV_QUIET
   E.g., ./plot_ecdf.sh ~/threshold_validation/active_capture/res/threshold_max.csv  ~/threshold_validation/quiet_capture/res/threshold_max.csv echodot echodot_quiet

5) You will get a plot named ecdf_th.eps in the folder ./fig with the visualisation of the threshold that can be used for detecting activations.
