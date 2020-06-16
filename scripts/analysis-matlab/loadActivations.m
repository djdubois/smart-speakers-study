function [activations] = loadActivations(resultsFile,deviceName,word, ...
	experimentIndex,totalExperiments,type, previousActivations)
%loadActivations - Load activations from a results file
% This function assumes that a file 'data/material.txt' is available with the
% list of video material (file names) as it appears on the results.txt file.
%  INPUT
%    resultsFile: name of a valid results.txt file.
%    deviceName: the device name as it appears within the resultsFile
%    experimentIndex: progressive index number of the experiment (starting from 1)
%    totalExperiments: total number of experiments (i.e., maximum index)
%    type: type of experiment: 1=camera, 2=traffic, 3=cloud, 4=uk(camera)
%    previousActivations: any previous activations (new activations will be appended)
%  OUTPUT
%    activations: set of activations extracted from the result file for the
%    given device.

materialMap=loadMap('data/material.txt');

fileID=fopen(resultsFile,'rt');
materialId=0;

sprintf("Loading %s, looking for %s (index %d/%d)...", resultsFile, ...
	deviceName, experimentIndex, totalExperiments);

isActive=false(4,totalExperiments);
isActive(type,experimentIndex)=true;

if nargin<7
	 activations = struct('materialId',{},'materialName',{},'start',{},'stop',{},'duration',{},'isActive',{},'numCamera', ...
		{},'numTraffic',{},'numCloud',{},'numCameraTraffic',{},'numCameraCloud',{},'numTrafficCloud',...
		{},'numCameraTrafficCloud',{},'numConsolidated',{},'device',{},'numUK',{},'numCameraUK',{},'file',{},'word',{});
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
		materialName=linesplit(end-1);
		materialId=materialMap(materialName{1});
		sprintf("Processing %s (%d)...", materialName{1}, materialId);
	elseif startsWith(line,strcat(deviceName,':'))
		substr=extractBetween(line,strcat(deviceName,':('),')');
		linesplit=split(substr,',');
		start=str2double(linesplit(1));
		stop=str2double(linesplit(2));
		if stop-start>600 % Ignore activations longer than five minutes
			continue
		end
		sprintf("Found activation: %s (%d, %d)", deviceName, ...
			start, stop);
		activation.materialId=materialId;
		activation.materialName=materialName{1};
		activation.start=start;
		activation.stop=stop;
		activation.duration=stop-start;
		activation.isActive=isActive;
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
		activation.file=resultsFile;
		activation.word=word;
		activations(end+1)=activation;
	end
	
end

fclose(fileID);

end

