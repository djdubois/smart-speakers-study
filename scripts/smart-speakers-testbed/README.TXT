===============================
   SMART SPEAKERS TESTBED
===============================

This directory contains the code to perform smart speakers experiments, which is divided
into the following modules

===========================
  MODULE 1. voice-assist
===========================

This module is used to perform smart speakers experiments, in particular to:
 - Play source video material using a set of connected speakers.
 - Capture network traffic from a set of smart speakers under test.
 - Capture video feed from an RTSP IP camera.
 - Save the resulting captures in the "capture" directory on a directory
   that has the same name of the video file played.

This module depends on:

 1. A properly configured Mon(IoT)r testbed, which can be download from:
    https://github.com/NEU-SNS/intl-iot/tree/master/moniotr
 2. One or more smart speakers under test properly configured within the
    Mon(IoT)r testbed.
 3. An RTSP-compatible IP camera reachable over the local network.
 4. The presence of source video material in ".mp4" format.
 5. A working sound card connected to a pair of speakers.
 6. FFMPEG version 4.2.1 or later (apt install ffmpeg).
 7. MPLAYER version 1.3 or later (apt install mplayer).
 
This module is configured by modifying voice-assist.conf. Additional documentation
is provided inside voice-assist.conf.

Usage: ./voice-assist <start-batch|stop|status|help>
       ./voice-assist start <SOURCE_VIDEO_FILE>

For a manual and examples on how to use the voice-assist script, just run it 
without parameters to get interactive help.

NOTE: This script is not a testable artifact because it has physical
      dependencies that must be met. We provide it just for convenience.


========================
  MODULE 2. tag-camera
========================

Usage: ./tag-camera <CAMERA ACTIVATIONS FILE> <TAG> [<TOLERANCE>]

Requires: ffmpeg (apt install ffmpeg)

This script tags camera activations occurred in voice-assist capture.

This script will parse the output of one of the grab activations scripts
and then tags all activations within such file.

An example activation file is in examples/results.txt.t

A mandatory TAG parameter must be specified to make this tag unique. It can be
for example a progressive number and is just used as a label.

An optional tolerance can be specified (in seconds), to tag also the boundaries
of the activation (+/- tolerance in seconds).

EXAMPLE: 
   ./tag-camera examples/results.txt TEST

EXPECTED RESULT:
   Based on the content of the example results.txt file,
   it will create two tagged camera activations in the ./activation
   directory. Each tagged activation contains a subset of the
   source material (video and subtitles), and capture from camera and
   traffic for the tagged device.


============================
  MODULE 3. tag-activation
============================

Usage: ./tag-activation <CAPTURE> <DEVICE> <TAG> <METHOD> <START TIME> <END TIME> [<TOLERANCE>]
       ./tag-activation help

Requires: ffmpeg (apt install ffmpeg)

This script tags activations occurred in a voice-assist capture.

This script will extract captured material in CAPTURE related to the specified DEVICE
and copies it in the ACTIVATION_DIR directory configured in voice-assist.conf.
The data that is copied is all the data between START TIME and END TIME, expressed
in seconds. If START TIME is greater than 1 million, it is considered absolute,
otherwise it is considered relative.

TAG is an arbitrary label and is used to specify the context related to the 
activation (e.g., the number of run).

METHOD is also an arbitrary label and is used to specify the method used to detect the activation.

TOLERANCE is the offset of time that should be subtracted from START TIME and
added to END TIME. Useful to capture some additional data around the boundaries of
the activation.

The CAPTURE must exist as a subdirectory in CAPTURE_DIR. The CAPTURE directory must
contain data related to DEVICE in pcap format.

EXAMPLE:
   ./tag-activation "[S3.Ep10] Friday Night Tykes - Babies from Texas" homepod run1 camera 6000 6010 5

EXPECTED RESULT:
   It will create a tagged activations in the 
   "activation/[S3.Ep10] Friday Night Tykes - Babies from Texas/06000_06010_homepod_camera_run1"
   directory. The tagged activation contains a subset of the source material (video and subtitles), and 
   capture from camera and traffic for the tagged device.


==================================
  MODULE 4. scripts/extract-pcap
==================================

This script extracts a subset of traffic from a pcap file between [start] 
and [end] time in seconds (relative time). It is useful to extract the
traffic corresponding to a detected activation.

An optional tolerance in second will be subtracted from start time, and added to end time.

Usage: scripts/extract-pcap <source pcap file> <destination pcap file> <start time> <end time> [tolerance]

EXAMPLE: 
   scripts/extract-pcap examples/example.pcap examples/example-extracted.pcap 1000 2000 5

EXPECTED RESULT:
   Creation of a new example-extracted.pcap file containing the specified subset of data of example.pcap


==================================
  MODULE 5. scripts/extract-ttml
==================================

This script extracts the subtitles from a file between [start] and [end] time in seconds.

If no start and end time are specified, all the subtitles will be printed.
If only start time is specified, the default end time is the same as start time.
An optional tolerance in seconds will be subtracted from start time, and added to end time.

Usage: scripts/extract-ttml <XML subtitle file> [start time] [end time] [tolerance]

Requires: ffmpeg

EXAMPLE:
   scripts/extract-ttml "source-material/[S3.Ep10] Friday Night Tykes - Babies from Texas.ttml" 1000 1001 1

EXPECTED RESULT:

   Subset of Subtitles including second 999 to 1002, as follows:

      998 999 I TOLD YOU! I TOLD YOU!
      999 1000 THEY'RE SNEAKING 'EM OUT THERE.
      1001 1002 HE CAN'T HEAR US. [cheers and applause]
      1002 1004 HOW STUPID CAN--


==================================
  MODULE 6. scripts/extract-ttml
==================================

This script extracts a video portion from a video file between [start] and [end] time in seconds.

An optional tolerance in second will be subtracted from start time, and added to end time.

Usage: scripts/extract-video <source video file> <destination video file> <start time> <end time> [tolerance]

EXAMPLE:
   scripts/extract-video "capture/[S3.Ep10] Friday Night Tykes - Babies from Texas/capture.mkv" examples/capture-extracted.mkv 1000 1200 10

EXPECTED RESULT:
   Creation of a new examples/capture-extracted.mkv file containing the specified subset of video from
   "capture/[S3.Ep10] Friday Night Tykes - Babies from Texas/capture.mkv"
