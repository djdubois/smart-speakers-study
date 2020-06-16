function [stats] = generateActivationStatistics(aCam, aCloud, aTraffic, aUK)
%generateActivationStatistics - Generate statistics among a set of activations
%                               for a single device.
%  INPUT
%    aCam: activations from camera (US)
%    aCloud: activations from cloud (US)
%    aTraffic: activations from traffic (US)
%    aUK: activations from camera (UK)
%  OUTPUT
%    stats: struct containing statistics related to the set of activations

 a=consolidateActivations([aCam aCloud aTraffic],60);
 a2=consolidateActivations([aCam aCloud aTraffic aUK],60);
 
 stats.a=a;
 stats.totalActivationsCameraAll=sum([a.numCamera]>0);
 stats.totalActivationsCloudAll=sum([a.numCloud]>0);
 stats.totalActivationsTrafficAll=sum([a.numTraffic]>0);
 stats.totalActivationsUKAll=sum([a.numUK]>0);
 stats.totalActivationsCameraTraffic=sum([a.numCameraTraffic]>0);
 stats.totalActivationsCameraCloud=sum([a.numCameraCloud]>0);
 stats.totalActivationsTrafficCloud=sum([a.numTrafficCloud]>0);
 stats.totalActivationsCameraTrafficCloud=sum([a.numCameraTrafficCloud]>0);
 
 stats.a2=a2;
 stats.totalActivationsCameraAll2=sum([a2.numCamera]>0);
 stats.totalActivationsUKAll2=sum([a2.numUK]>0);
 stats.totalActivationsCameraUK=sum([a2.numCameraUK]>0);
 
 stats.longActivationsCameraAll=sum([a.numCamera]>0&[a.duration]>3);
 stats.longActivationsCloudAll=sum([a.numCloud]>0&[a.duration]>3);
 stats.longActivationsTrafficAll=sum([a.numTraffic]>0&[a.duration]>3);
 stats.longActivationsCameraTraffic=sum([a.numCameraTraffic]>0&[a.duration]>3);
 stats.longActivationsCameraCloud=sum([a.numCameraCloud]>0&[a.duration]>3);
 stats.longActivationsTrafficCloud=sum([a.numTrafficCloud]>0&[a.duration]>3);
 stats.longActivationsCameraTrafficCloud=sum([a.numCameraTrafficCloud]>0&[a.duration]>3);
 
stats.totalActivationsCamera=sum([aCam.numCamera]>0);
stats.totalActivationsUK=sum([aUK.numUK]>0);

[strongInc,inc,neutral,dec,strongDec]=trend(aCam,1,2); % From cameras (2 full repetitions!)
stats.strongIncActivationsCameraRelative=sum(strongInc)/stats.totalActivationsCamera;
stats.incActivationsCameraRelative=sum(inc)/stats.totalActivationsCamera;
stats.neutralActivationsCameraRelative=sum(neutral)/stats.totalActivationsCamera;
stats.decActivationsCameraRelative=sum(dec)/stats.totalActivationsCamera;
stats.strongDecActivationsCameraRelative=sum(strongDec)/stats.totalActivationsCamera;

tmp=aCam.isActive;
numMax=size(tmp,2);
tmp=aCam([aCam.numCamera]>0);
stats.cameraConfidence=sort([tmp.numCamera]./numMax,'ascend');

tmp=aCam([aCam.numTraffic]>0);
stats.trafficConfidence=sort([tmp.numTraffic]./numMax,'ascend');

tmp=aCam([aCam.numCloud]>0);
stats.cloudConfidence=sort([tmp.numCloud]./numMax,'ascend');

stats.meanCameraConfidence=mean(stats.cameraConfidence);
stats.stdCameraConfidence=std(stats.cameraConfidence);
stats.meanTrafficConfidence=mean(stats.trafficConfidence);
stats.stdTrafficConfidence=std(stats.trafficConfidence);
stats.meanCloudConfidence=mean(stats.cloudConfidence);
stats.stdCloudConfidence=std(stats.cloudConfidence);

stats.Q1ConfidenceActivationsCamera=sum([stats.cameraConfidence]<=0.26);
stats.Q2ConfidenceActivationsCamera=sum([stats.cameraConfidence]>0.26 & [stats.cameraConfidence]<=0.51);
stats.Q3ConfidenceActivationsCamera=sum([stats.cameraConfidence]>0.51 & [stats.cameraConfidence]<=0.76);
stats.Q4ConfidenceActivationsCamera=sum([stats.cameraConfidence]>=0.76);

stats.Q1ConfidenceActivationsTraffic=sum([stats.trafficConfidence]<=0.26);
stats.Q2ConfidenceActivationsTraffic=sum([stats.trafficConfidence]>0.26 & [stats.trafficConfidence]<=0.51);
stats.Q3ConfidenceActivationsTraffic=sum([stats.trafficConfidence]>0.51 & [stats.trafficConfidence]<=0.76);
stats.Q4ConfidenceActivationsTraffic=sum([stats.trafficConfidence]>=0.76);

stats.Q1ConfidenceActivationsCloud=sum([stats.cloudConfidence]<=0.26);
stats.Q2ConfidenceActivationsCloud=sum([stats.cloudConfidence]>0.26 & [stats.cloudConfidence]<=0.51);
stats.Q3ConfidenceActivationsCloud=sum([stats.cloudConfidence]>0.51 & [stats.cloudConfidence]<=0.76);
stats.Q4ConfidenceActivationsCloud=sum([stats.cloudConfidence]>=0.76);


% Duration of recordings

stats.durations=[aCam.duration];
stats.durationsMin=min(stats.durations);
stats.durationsQ1=prctile(stats.durations,25);
stats.durationsQ2=prctile(stats.durations,50);
stats.durationsQ3=prctile(stats.durations,75);
stats.durationsMax=max(stats.durations);

if length(stats.durations)<=10
	stats.durationsP10=NaN;
	stats.durationsP90=NaN;
else
	stats.durationsP10=prctile(stats.durations,10);
	stats.durationsP90=prctile(stats.durations,90);
end

stats.durations2=[aUK.duration];
if isempty(stats.durations2)
    stats.durations2=NaN;
end
stats.durations2Min=min(stats.durations2);
stats.durations2Q1=prctile(stats.durations2,25);
stats.durations2Q2=prctile(stats.durations2,50);
stats.durations2Q3=prctile(stats.durations2,75);
stats.durations2Max=max(stats.durations2);

if length(stats.durations2)<=10
	stats.durations2P10=NaN;
	stats.durations2P90=NaN;
else
	stats.durations2P10=prctile(stats.durations2,10);
	stats.durations2P90=prctile(stats.durations2,90);
end

% STATISTICS BY SHOW

durationsMap=loadMapWithKeys('data/durations.txt');
wordsCountsMap=loadMapWithKeys('data/words.txt');
showsMap=loadMap('data/shows.txt');
showsNames=keys(showsMap);
materialMap=loadMap('data/material.txt');
materialNames=keys(materialMap);
materialValues=values(materialMap);

currentMaterialIds=[aCam.materialId];

for ii=1:length(showsMap)
	
	stats.totalTime(ii)=0;
	stats.wordsCounts(ii)=0;
	
	% Sum duration
	for jj=1:length(durationsMap)
		durationsValues=values(durationsMap);
		durationsKeys=keys(durationsMap);
		if any(strfind(durationsKeys{jj},showsNames{ii}))
		    stats.totalTime(ii)=stats.totalTime(ii)+durationsValues{jj};
		end
	end
	
	% Sum words
	for jj=1:length(wordsCountsMap)
		wordsCountsValues=values(wordsCountsMap);
		wordsCountsKeys=keys(wordsCountsMap);
		if any(strfind(wordsCountsKeys{jj},showsNames{ii}))
		    stats.wordsCounts(ii)=stats.wordsCounts(ii)+wordsCountsValues{jj};
		end
	end
	
	materialIds=cell2mat(materialValues(~cellfun('isempty', strfind(materialNames,showsNames{ii}))));
	
	stats.totalActivationsMin(ii)=0;
	stats.totalActivationsMax(ii)=0;

	for jj=1:length(currentMaterialIds)
		
		if ~any(materialIds==currentMaterialIds(jj))
			continue;
		end

		if aCam(jj).numCamera>0
			stats.totalActivationsMax(ii)=stats.totalActivationsMax(ii)+1;
		end

		if aCam(jj).numCamera==size(aCam(jj).isActive,2)
			stats.totalActivationsMin(ii)=stats.totalActivationsMin(ii)+1;
		end
	end
	
	% Calculate density
	stats.activationDensityDurations(ii)=stats.totalActivationsMax(ii)/stats.totalTime(ii);
	stats.activationDensityWordsCounts(ii)=stats.totalActivationsMax(ii)/stats.wordsCounts(ii);
	
	% Calculate general density (in words/seconds)
	stats.generalDensity(ii)=stats.wordsCounts(ii)/stats.totalTime(ii);
end


end

