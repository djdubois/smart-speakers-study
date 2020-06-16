# ffmpeg -i capture.mkv -codec copy capture2.mkv

import cv2
import math
import numpy as np
import os
import errno
import sys
import subprocess
import uuid

recordings = []
for root, dirs, files in os.walk(sys.argv[1]):
    for file in files:
        if file.endswith(".mkv"):
            recordings.append(os.path.join(root, file))


# For detecting consecutive integers in a list
# https://stackoverflow.com/questions/2361945/detecting-consecutive-integers-in-a-list
def ranges(nums):
    nums = sorted(set(nums))
    gaps = [[s, e] for s, e in zip(nums, nums[1:]) if s+1 < e]
    edges = iter(nums[:1] + sum(gaps, []) + nums[-1:])
    return list(zip(edges, edges))


# Toggle between modes
device_specific_mode = True

# Define bounding-box co-ordinates for devices in the reference frame in the format: (x1, y1) + (x2, y2)
cords = {
    "invoke": [(224, 76), (327, 138)],
    "homepod": [(412, 40), (506, 70)],
    "google-home-mini2": [(941, 352), (1053, 411)],
    "t-echodot": [(670, 432), (794, 513)],
    "echodot": [(666, 293), (763, 366)],
    "echodot3a": [(796, 100), (916, 148)],
    "echodot3b": [(853, 212), (992, 268)],
}

cords_control = [(0, 590), (40, 640)]

# Define threshold
diff_threshold = 50
diff_threshold_2 = 10

count = 0

for recording in recordings:
    print(recording)
    count += 1

    task = subprocess.Popen(
        "ffmpeg -i \"" + recording + "\" -y -codec copy capture-proc.mkv",
        shell=True, stdout=subprocess.PIPE)
    data = task.stdout.read().decode()
    assert task.wait() == 0


    # Define the input video file path
    input_recording = "capture-proc.mkv"

    # Make directory where we will store frames of interest
    try:
        os.makedirs('frames')
    except OSError as e:
        if e.errno != errno.EEXIST:
            raise


    # Load video
    vidcap = cv2.VideoCapture(input_recording)
    vidcap.set(cv2.CAP_PROP_POS_FRAMES, 5) # Fast forward 5 frames to remove the clutter in start, if any

    # Display video information
    (major_ver, minor_ver, subminor_ver) = (cv2.__version__).split('.')
    if int(major_ver) < 3:
        fps = vidcap.get(cv2.cv.CV_CAP_PROP_FPS)
    else:
        fps = vidcap.get(cv2.CAP_PROP_FPS)
    length = int(vidcap.get(cv2.CAP_PROP_FRAME_COUNT))
    print("Video information (fps, total_frames):", fps, length)

    # Get a reference frame either from file or video
    try:
        assert os.path.exists("reference-frame-1.jpg")
        reference_frame = cv2.imread("reference-frame-1.jpg")
    except:
        success, reference_frame = vidcap.read()

    reference_frame = reference_frame[90:,:] # Remove the time information on top of frame
    frameRate = int(vidcap.get(5))

    secondsRelevant = []
    frames = {}
    min_val = sys.maxsize

    tot_frame = 5
    fps = int(math.floor(fps))
    while vidcap.isOpened():
        success, image = vidcap.read()
        if not success:
            break
        else:
            tot_frame += 1

        # Only check a frame per second
        if not int(tot_frame % fps) == 0:
           continue

        # Get the difference of current frame with reference
        currentFrame = image[90:,:]
        diff_frame = cv2.absdiff(currentFrame, reference_frame)

        # Binarize using global thresholding
        processed = cv2.threshold(diff_frame, 127, 255, cv2.THRESH_BINARY)[1]

        # Test if any of the audio devices have been activated
        # (i.e. any device which illuminates light not in reference frame)
        x = processed == 255
        n_white_pix = np.sum(processed == 255)

        # DEBUG
        print("Processing second: ", int(tot_frame / fps))
        # cv2.imshow("non-zero", processed)
        # cv2.waitKey(0)
        # input()

        if n_white_pix > diff_threshold:
            # Check if this did not happen due to change in bg color
            ref_static = reference_frame[cords_control[0][1]:cords_control[1][1],
                         cords_control[0][0]:cords_control[1][0]]
            current_static = currentFrame[cords_control[0][1]:cords_control[1][1],
                             cords_control[0][0]:cords_control[1][0]]
            diff_frame_static = cv2.absdiff(current_static, ref_static)

            # Binarize using global thresholding, but at a lower level
            processed_static = cv2.threshold(diff_frame_static, 30, 255, cv2.THRESH_BINARY)[1]

            if np.sum(processed_static == 255) > diff_threshold_2:
                print("Skipping false-positive due to bg color change...")
                continue

            second = int(tot_frame / fps)
            print("Found a relevant frame at second: ", second)
            # second = int(int(vidcap.get(cv2.CAP_PROP_POS_MSEC)) / 1000)
            secondsRelevant.append(second)
            frames[second] = processed
            uniq_id = str(count)
            cv2.imwrite("frames/" + "frame%d" % second + "-" + uniq_id + ".jpg", processed)
            cv2.imwrite("frames/" + "frame%d" % second + "-" + uniq_id + "-original" + ".jpg", image)
    with open("statistics.txt", 'a') as statsf:
        statsf.write(recording + ":Relevant seconds from the video are listed below: \n")
        for i in ranges(secondsRelevant):
            statsf.write(str(i) + ": ")

            # Check which device(s) caused the trigger
            if device_specific_mode:
                for device in cords:
                    for x in range(i[0], i[1] + 1):
                        processed = frames[x]
                        currentFrameDeviceCrop = processed[cords[device][0][1]:cords[device][1][1],
                                                 cords[device][0][0]:cords[device][1][0]]
                        if np.sum(currentFrameDeviceCrop == 255) > diff_threshold_2:
                            statsf.write(device + ",")
                            break
            statsf.write("\n")
    if device_specific_mode:
        with open("devices.txt", 'a') as devicesf:
            devicesf.write(recording + ":Devices with corresponding times are listed below: \n")
            for device in cords:
                dSecondsRelevant = []
                for i in ranges(secondsRelevant):
                    for x in range(i[0], i[1] + 1):
                        processed = frames[x]
                        currentFrameDeviceCrop = processed[cords[device][0][1]:cords[device][1][1],
                                                 cords[device][0][0]:cords[device][1][0]]
                        if np.sum(currentFrameDeviceCrop == 255) > diff_threshold_2:
                            dSecondsRelevant.append(x)
                for i in ranges(dSecondsRelevant):
                    devicesf.write(device + ":" + str(i) + "\n")
