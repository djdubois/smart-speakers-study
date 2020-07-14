======================================================
  Extract traffic activations from traffic captures
======================================================

This subfolder shows samples of processing each PCAP file for extracting activations from the network traffic

1) Copy the content of this directory to any location

2) Run "sudo ./setup.sh" for installing the libraries for python

3) be sure you are using pip install pandas==0.22

4) Run ./peaks.sh -i IN_PCAP -d DEV
E.g., ./peaks.sh -i echodot3a.pcap -d echodot3a

5) You will get a file named $name_pcap_file_peak.csv with the time when the activation start and when the activation end.
The format is: start_pcap,time_start_pcap,rel_time_pcap,start_peak,time_start_peak,rel_time_start_peak,end_peak,time_end_peak,rel_time_end_peak
