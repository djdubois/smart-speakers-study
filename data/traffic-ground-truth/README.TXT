========================
  GROUND TRUTH TRAFFIC
========================

To recognize activations from the traffic, we needed some
network traffic ground truth of the device being:

  - active (to provide activation data when the device is active)
  - idle (to provide background data when the device is quiet)


---------------
1. AVAILABILITY
---------------

Since network traffic is very large, we did not include it in this
repository, but it can be downloaded from here (ground-truth-traffic directory):

https://www.dropbox.com/sh/rcm5y7o0e14mrjm/AACrxNEPcd7jkhpsYkxvSn0da?dl=0

Active data is in the active.tar.bz2 archive
Idle data is in the idle.tar.bz2 archive

-----------------------------------
2. CONTENTS FOR ACTIVE GROUND TRUTH
-----------------------------------

The content of file active.tar.bz2 is organized into several directories,
one for each device we test.

Each of these directories contains a list of PCAP files containing exacting
one activation each.

---------------------------------
3. CONTENTS FOR IDLE GROUND TRUTH
---------------------------------

The content of file idle.tar.bz2 is also organized into several directories,
one for each device we test.

Each of these directories contains a list of PCAP files containing background
data for an extended amount of time.
