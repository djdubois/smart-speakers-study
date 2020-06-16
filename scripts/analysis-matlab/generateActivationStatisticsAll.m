function [stats]=generateActivationStatisticsAll(allCam,allCloud,allTraffic,allUK)
%generateActivationStatisticsAll - Generate statistics among a set of activations
%                                  for all the devices
%  INPUT
%    allCam: activations from camera for all the devices (US)
%    allCloud: activations from cloud for all the devices (US)
%    allTraffic: activations from traffic for all the devices(US)
%    allUK: activations from camera for all the devices (UK)
%  OUTPUT
%    stats: array of structs containing statistics related to the set of activations
%           for all the devices

numStats=length(allCam);
stats=[];

% Generate the statistics
for ii=1:numStats
	if isempty(allCloud)
		myAllCloud=[];
	else
		myAllCloud=allCloud{ii};
	end
		
	if isempty(allTraffic)
		myAllTraffic=[];
	else
		myAllTraffic=allTraffic{ii};
	end
	
	if isempty(allUK)
		myAllUK=[];
	else
		myAllUK=allUK{ii};
	end
	
	if isempty(stats)		
		stats=generateActivationStatistics(allCam{ii},myAllCloud,myAllTraffic,myAllUK);
	else
		stats=[stats generateActivationStatistics(allCam{ii},myAllCloud,myAllTraffic,myAllUK)];
	end
end

end