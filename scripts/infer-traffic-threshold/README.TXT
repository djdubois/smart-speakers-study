==========================================
  Infer the traffic detection thresholds
==========================================

This subfolder shows samples of inferring the traffic detection thresholds from the network traffic. 
The output is a list of values from background and active traffic that will help on inferring the threshold during the next step, "threshold_validation". 

1) Copy the content of this directory to any location

2) Run "sudo ./setup.sh" for installing the libraries for python

3) be sure you are using pip install pandas==0.22

4) You should create a file devices.txt containing the MAC address and the name of the device (example devices.txt in the folder). 

5) For getting a file with the value of max amount of traffic when an activation is detected, run ./compute_max_th.sh $CAPT $RES_DIR $device_name
E.g., ./compute_max_th.sh ~/infer-traffic-threshold/active_capture/echodot3a.pcap  ~/infer-traffic-threshold/active_capture/res echodot3a

6) For getting a file with the value of max amount of traffic for the background traffic, run ./compute_max_th_quiet.sh $CAPT $RES_DIR $device_name
E.g., ./compute_max_th_quiet.sh ~/infer-traffic-threshold/quiet_capture/2020-01-20_22.00.45_192.168.30.103.pcap  ~/infer-traffic-threshold/quiet_capture/res echodot_quiet
Warning!! It could take few minutes to be executed.

7) You will get a file named threshold_max.csv with a list of values: a) the max amount of bytes sent per sec in a 20 sec window for quiet experiments and b) max amount of bytes sent per sec during an activation. 
The files will be located in ~/infer-traffic-threshold/active_capture/res/threshold_max.csv and ~/infer-traffic-threshold/quiet_capture/res/threshold_max.csv 
