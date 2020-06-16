function [activations] = loadRepeatedActivations(resultsFile,deviceName, word, ...
	experimentBaseIndex,totalExperiments,type,filter,previousActivations)
%loadRepeatedActivations - Load repeated activations from a results file
% This function specifically loads activations from confirmatory experiments
% instead of complete experiments (as loadActivations does).
% This function assumes that a file 'data/material.txt' is available with the
% list of video material (file names) as it appears on the results.txt file.
%  INPUT
%    resultsFile: name of a valid results.txt file for repeated activations.
%    deviceName: the device name as it appears within the resultsFile
%    word: wake word (google, siri, cortana, alexa, computer, echo, amazon)
%    experimentBaseIndex: progressive index number of the experiment (starting from 1)
%    totalExperiments: total number of experiments (i.e., maximum index)
%    type: type of experiment: 1=camera, 2=traffic, 3=cloud, 4=uk(camera)
%    filter: select repeated activations by experiment set (e.g., camera1 and
%            camera2, where 1 and 2 have the same meaning as experiment type in
%            loadAllActivations.
%    previousActivations: any previous activations (new activations will be appended)
%  OUTPUT
%    activations: set of activations extracted from the result file for the
%    given device.


materialMap=loadMap('data/material.txt');

fileID=fopen(resultsFile,'rt');
materialId=0;

sprintf("Loading %s, looking for %s (base index %d/%d)...", resultsFile, ...
	deviceName, experimentBaseIndex, totalExperiments);

isActive=false(4,totalExperiments);

if nargin<8
    activations=struct('materialId',{},'materialName',{},'start',{},'stop',{},'duration',{},'isActive',{},'numCamera', ...
		{},'numTraffic',{},'numCloud',{},'numCameraTraffic',{},'numCameraCloud',{},'numTrafficCloud',...
		{},'numCameraTrafficCloud',{},'numConsolidated',{},'device',{},'numUK',{},'numCameraUK',{},'file',{}, 'word',{});
else
    activations=previousActivations;	
end

while true
	line = fgetl(fileID);
	if ~ischar(line)
		break
	end
	
	if contains(line,'/')
		linesplit=split(line,'/');
		desc=linesplit(end-1);
		descsplit=split(desc{1},'_');
		materialName=descsplit(1);
		currentDevice=descsplit(2);
		start=str2double(descsplit(3));
		stop=str2double(descsplit(4));
		method=descsplit(end);
		methodsplit=split(method{1},'-');
		if ~strcmp(methodsplit(1),filter)
			currentDevice="none";
		end
		experimentIndex=experimentBaseIndex+str2double(methodsplit(end));
		materialId=materialMap(materialName{1});
		sprintf("Processing %s (%d)...", materialName{1}, materialId);
	elseif startsWith(line,strcat(deviceName,':')) && startsWith(line,strcat(currentDevice,':'))
		substr=extractBetween(line,strcat(deviceName,':('),')');
		linesplit=split(substr,',');
		duration=str2double(linesplit(2))-str2double(linesplit(1));
		sprintf("Found repeated activation: %s (%d, %d, duration: %d)", deviceName, ...
			start, stop, duration);
		activation.materialId=materialId;
		activation.materialName=materialName{1};
		activation.start=start;
		activation.stop=stop;
		activation.duration=duration;
		activation.isActive=isActive;
		activation.isActive(type,experimentIndex)=true;
		activation.numCamera=sum(isActive(1,:));
		activation.numTraffic=sum(isActive(2,:));
		activation.numCloud=sum(isActive(3,:));
		activation.numUK=sum(isActive(4,:));
		activation.numCameraTraffic=min([activation.numTraffic activation.numCamera]);
		activation.numCameraCloud=min([activation.numCloud activation.numCamera]);
		activation.numCameraUK=min([activation.numUK activation.numCamera]);
		activation.numTrafficCloud=min([activation.numCloud activation.numTraffic]);
		activation.numCameraTrafficCloud=min([activation.numCamera activation.numCloud activation.numTraffic]);
		activation.numConsolidated=1;
		activation.device=deviceName;
		activation.file='';
		activation.word=word;
		activations(end+1)=activation;
	end
	
end

fclose(fileID);

end

