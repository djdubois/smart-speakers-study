===========================
  CAMERA GRAB ACTIVATIONS
===========================

This directory contains the script to grab portions of the recorded raw videos with device activations from camera. 
It is written in Python 3 and requires opencv-python (apt install python3-opencv). 
It simply parses one frame/second, and diffs it with a reference frame to detect changes in color in the video above a given threshold. 
To customize the script (e.g., device names, coordinates, other settings), you can open the file script.py and customize the variables
in its header.

Usage: python3 script.py <DIRECTORY CONTAINING VIDEO>

To use the script, please provide a directory containing all stored videos as input to the script. 

The script outputs a devices.txt file, and a statistics.txt file summarizing the results, along with a "frames/" directory containing all frames of interest. 
Each frame file is named with the format "{random-uuid}-frame-{time-at-which-frame-was-taken-in-seconds}.jpg". 

EXAMPLE:
  python3 script.py example


EXPECTED RESULT:
  devices.txt should contain one detected activation for homepod at second 6 as follows:

    example/capture.mkv:Devices with corresponding times are listed below:
    homepod:(6, 6)
