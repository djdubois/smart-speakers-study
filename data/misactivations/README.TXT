==========================
  LIST OF MISACTIVATIONS
==========================

-----------
1. OVERVIEW
-----------
This directory contains the list of misactivations detected by
camera (US and UK testbeds), traffic (US testbed only), and cloud (US testbed only).

-----------------------------------
2. CONTENTS (FIRST LEVEL DIRECTORY)
-----------------------------------
Each directory is in the form misactivations-by-XXXXX-YY, where XXXXX is the detection
methd (camera, traffic, or cloud), and YY is the country (US or UK).

------------------------------------
3. CONTENTS (SECOND LEVEL DIRECTORY)
------------------------------------
Each directory contains one or more results with the following pattern:
results-ZZZZZ-TTTTT-filtered.txt

where ZZZZZ can be camera, traffic, cloud, or uk. All the detection methods refer
to the US testbed, except for UK, which refers to camera on the UK testbed.

TTTTT represents the experiment configuration, defined as follows:

final1a - First round of experiments
final1b - Second round of experiments
  For these two round the devices are configured as follows:
    google-home-mini2: Google Home Mini
    homepod: Apple Homepod
    invoke: Harman Kardon Invoke
    echodot: Amazon Echo Dot 2nd gen. - Echo wake word
    t-echodot: Amazon Echo Dot 2nd gen. - Amazon wake word
    echodot3a: Amazon Echo Dot 3rd gen. - Alexa wake word
    echodot3b: Amazon Echo Dot 3rd gen. - Computer wake word

final2a - Third round of experiments
final2b - Fourth round of experiments
  For these two round the devices are configured as follows:  
    google-home-mini2: Google Home Mini
    homepod: Apple Homepod
    invoke: Harman Kardon Invoke
    echodot: Amazon Echo Dot 2nd gen. - Alexa wake word
    t-echodot: Amazon Echo Dot 2nd gen. - Computer wake word
    echodot3a: Amazon Echo Dot 3rd gen. - Echo wake word
    echodot3b: Amazon Echo Dot 3rd gen. - Amazon wake word

finalr - Additional confirmatory experiments 
    Internal headers ending in: 
      *-camera  -> repetitions associated to non-Amazon devices
      *-camera1 -> repetitions associate to Amazon devices (wake words configured
                   like the first and second round of experiments)
      *-camera2 -> repetitions associated to Amazon devices (wake words configured
                   like the third and fourth round of experiments)

----------------------
4. RESULTS FILE FORMAT
----------------------

Each results*.txt file is organized in blocks following this format:

DIRECTORY/EPISODE/capure.mkv:Devices with corresponding times are listed below:
DEVICE1:(INIT, END)
DEVICE2:(INIT, END)

The first line is the header and identifies one single esperiment.

DIRECTORY is the directory containing the source material, which also identifies the
          type of experiment (final1a, final2b, finalr, etc.)

  EPISODE is the full title of the episode. In case of confirmatory experiment, the title
          includes the special tag *-camera, *-camera1, *-camera2, to identify how the
          wake words are configured in case of Amazon devices (which can change wake word).

   DEVICE is the device that triggered a misactivation.

     INIT is the time (in second) when the misactivation is started.

      END is the time (in second) when the misactivation ended.


Example of misactivation in case of regular experiment (during the forth round) where an
Amazon 2nd gen. device (t-echodot) is configured with wake word "Computer":

/opt/voice-assist/capture/final2b/[S9.Ep23] The Office (U.S.) - Finale/capture.mkv:Devices with corresponding times are listed below:
t-echodot:(1692, 1692)


Example of misactivation in case of confirmatory experiment involving an Amazon 2nd gen. device
(t-echodot) is configured with wake word "Amazon" (because it is tagged as "camera1"):

/opt/voice-assist/capture/finalr/[S11.Ep23] The Big Bang Theory - The Sibling Realignment_t-echodot_00014_00028_t-echodot_camera1-1/capture.mkv:Devices with corresponding times are listed below:
t-echodot:(14, 14)
