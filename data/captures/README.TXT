============
  CAPTURES
============

Captures are not included in this repository because of their size.
They can be downloaded at the following link:

https://www.dropbox.com/sh/rcm5y7o0e14mrjm/AACrxNEPcd7jkhpsYkxvSn0da?dl=0


-----------------------
1. RELEVANT DIRECTORIES
-----------------------

captures-us: captures from the US
captures-uk: captures from the UK

Each directory contains one archieve for each experiments.

-----------------
2. US EXPERIMENTS
-----------------

final1a.tar.bz2 - First round of experiments
final1b.tar.bz2 - Second round of experiments
  For these two round the devices are configured as follows:
    google-home-mini2: Google Home Mini
    homepod: Apple Homepod
    invoke: Harman Kardon Invoke
    echodot: Amazon Echo Dot 2nd gen. - Echo wake word
    t-echodot: Amazon Echo Dot 2nd gen. - Amazon wake word
    echodot3a: Amazon Echo Dot 3rd gen. - Alexa wake word
    echodot3b: Amazon Echo Dot 3rd gen. - Computer wake word


final2a.tar.bz2 - Third round of experiments
final2b.tar.bz2 - Fourth round of experiments
  For these two round the devices are configured as follows:
    google-home-mini2: Google Home Mini
    homepod: Apple Homepod
    invoke: Harman Kardon Invoke
    echodot: Amazon Echo Dot 2nd gen. - Alexa wake word
    t-echodot: Amazon Echo Dot 2nd gen. - Computer wake word
    echodot3a: Amazon Echo Dot 3rd gen. - Echo wake word
    echodot3b: Amazon Echo Dot 3rd gen. - Amazon wake word


finalr.tar.bz2   - Confirmatory experiments
    Internal headers ending in:
      *-camera  -> repetitions associated to non-Amazon devices
      *-camera1 -> repetitions associate to Amazon devices (wake words configured
                   like the first and second round of experiments)
      *-camera2 -> repetitions associated to Amazon devices (wake words configured
                   like the third and fourth round of experiments)

-----------------
3. UK EXPERIMENTS
-----------------

capture-UK-0.tar.bz2 - First round of experiments
capture-UK-1.tar.bz2 - Second round of experiments
  For these two round the devices are configured as follows:
    google-home-mini: Google Home Mini
    homepod: Apple Homepod
    hb-echodot-1: Amazon Echo Dot 3rd gen. - Alexa wake word
    hb-echodot-2: Amazon Echo Dot 3rd gen. - Amazon wake word
    hb-echodot-3: Amazon Echo Dot 3rd gen. - Computer wake word
    hb-echodot-4: Amazon Echo Dot 3rd gen. - Echo wake word
    hb-echodot-5: Amazon Echo Dot 2nd gen. - Alexa wake word
    hb-echodot-6: Amazon Echo Dot 2nd gen. - Computer wake word

capture-UK-2.tar.bz2 - Third round of experiments
capture-UK-3.tar.bz2 - Fourth round of experiments
  For these two round the devices are configured as follows:
    google-home-mini: Google Home Mini
    homepod: Apple Homepod
    hb-echodot-1: Amazon Echo Dot 3rd gen. - Alexa wake word
    hb-echodot-2: Amazon Echo Dot 3rd gen. - Amazon wake word
    hb-echodot-3: Amazon Echo Dot 3rd gen. - Computer wake word
    hb-echodot-4: Amazon Echo Dot 3rd gen. - Echo wake word
    hb-echodot-5: Amazon Echo Dot 2nd gen. - Echo wake word
    hb-echodot-6: Amazon Echo Dot 2nd gen. - Amazon wake word


--------------------------------
4. CAPTURE ARCHIVE CONTENTS (US)
--------------------------------

The content of each archive is organized by episode name (in the case of repetitions, also the timestamp).

Each episode directory contains the following files:
    capture.mkv - Video capture from the camera
    echodot.pcap - Traffic capture for Amazon Echo Dot 2nd gen. #1
    echodot_nodup.pcap - Traffic capture for Amazon Echo Dot 2nd gen. #1 (duplicates removed)
    t-echodot.pcap - Traffic capture for Amazon Echo Dot 2nd gen. #2
    t-echodot_nodup.pcap - Traffic capture for Amazon Echo Dot 2nd gen. #2 (duplicates removed)
    echodot3a.pcap - Traffic capture for Amazon Echo Dot 3nd gen. #3
    echodot3a_nodup.pcap - Traffic capture for Amazon Echo Dot 3nd gen. #3 (duplicates removed)
    echodot3b.pcap - Traffic capture for Amazon Echo Dot 3nd gen. #4
    echodot3b_nodup.pcap - Traffic capture for Amazon Echo Dot 3nd gen. #4 (duplicates removed)
    google-home-mini2.pcap - Traffic capture for Google Home Mini
    google-home-mini2_nodup.pcap - Traffic capture for Google Home Mini (duplicates removed)
    homepod.pcap - Traffic capture for Apple Homepod
    homepod_nodup.pcap - Traffic capture for Apple Homepod (duplicates removed)
    invoke.pcap - Traffic capture for Harman Kardom Invoke
    invoke_nodup.pcap - Traffic capture for Harman Kardom Invoke (duplicates removed)
    time.txt - Start and end timme in which the video has been played

--------------------------------
5. CAPTURE ARCHIVE CONTENTS (UK)
--------------------------------

The content of each archive is organized by episode name.

Each episode directory contains the following files:
    capture.mkv - Video capture from the camera
    hb-echodot-1.pcap - Traffic capture for Amazon Echo Dot 3rd gen. #1
    hb-echodot-2.pcap - Traffic capture for Amazon Echo Dot 3rd gen. #2
    hb-echodot-3.pcap - Traffic capture for Amazon Echo Dot 3rd gen. #3
    hb-echodot-4.pcap - Traffic capture for Amazon Echo Dot 3rd gen. #4
    hb-echodot-5.pcap - Traffic capture for Amazon Echo Dot 2nd gen. #1
    hb-echodot-6.pcap - Traffic capture for Amazon Echo Dot 2nd gen. #2
    google-home-mini.pcap - Traffic capture for Google Home Mini
    homepod.pcap - Traffic capture for Apple Homepod
    time.txt - Start and end timme in which the video has been played
