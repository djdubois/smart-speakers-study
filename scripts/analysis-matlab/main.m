function main()

disp('*** STARTING VOICE-ASSIST ANALYSIS SCRIPTS ***');

disp('STEP 1 of 7. Loading camera activations (US)...');
allCam=loadAllActivations('camera');

disp('STEP 2 of 7. Loading traffic activations (US)...');
allTraffic=loadAllActivations('traffic');

disp('STEP 3 of 7. Loading cloud activations (US)...');
allCloud=loadAllActivations('cloud');

disp('STEP 4 of 7. Loading camera activations (UK)...');
allUK=loadAllActivations('uk');

disp('STEP 5 of 7. Computing statistics...');
stats=generateActivationStatisticsAll(allCam,allCloud,allTraffic,allUK);

disp('STEP 6 of 7. Generating plots and tables...');
plotActivationStatistics(stats);

disp('STEP 7 of 7. Generating list of repeatable activations from camera (US)...');
selectShows('output/results-repeatable.txt',stats,@(x)[x.numCamera]>2)

disp('*** DONE ***');
