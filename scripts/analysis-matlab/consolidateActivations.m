function [res] = consolidateActivations(activations, delta)
%consolidateActivations Merge activations that are similar in time
%  INPUT
%    activations: array of activations to be consolidated
%    delta: minimum time between activations, to be considered separate 
%  OUTPUT
%    list of consolidated activations

res=[];

if isempty(activations)
	res = struct('materialId',{},'materialName',{},'start',{},'stop',{},'duration',{},'isActive',{},'numCamera', ...
		{},'numTraffic',{},'numCloud',{},'numCameraTraffic',{},'numCameraCloud',{},'numTrafficCloud',...
		{},'numCameraTrafficCloud',{},'numConsolidated',{},'device',{},'numUK',{},'numCameraUK',{},'file',{}, 'word',{});
	return
end

materialIDs=unique([activations.materialId]);

% Cycle all the material
for materialId=materialIDs
    a=activations([activations.materialId]==materialId);

    % Sort activations first, based on end time
    [~,idx]=sort([a.stop]);
    a=a(idx);
    n=length(a);
	 
    % Cycle through activations, from the one before the last to the first. 
    % if the end time of the current activation is greater than the start time
    % of the previous one, minus delta, then combine the two.

	for ii=(n-1):-1:1
		if a(ii).stop>=a(ii+1).start-delta
			a(ii+1).duration=max([a(ii+1).duration a(ii).duration]);
			a(ii+1).start=min([a(ii+1).start a(ii+1).start]);
			a(ii+1).numConsolidated=a(ii+1).numConsolidated+a(ii).numConsolidated;
			a(ii+1).isActive=a(ii+1).isActive|a(ii).isActive;
			a(ii+1).numCamera=sum(a(ii+1).isActive(1,:));
			a(ii+1).numTraffic=sum(a(ii+1).isActive(2,:));
			a(ii+1).numCloud=sum(a(ii+1).isActive(3,:));
			a(ii+1).numUK=sum(a(ii+1).isActive(4,:));
			a(ii+1).numCameraTraffic=min([a(ii+1).numTraffic a(ii+1).numCamera]);
			a(ii+1).numCameraCloud=min([a(ii+1).numCloud a(ii+1).numCamera]);
			a(ii+1).numCameraUK=min([a(ii+1).numUK a(ii+1).numCamera]);
			a(ii+1).numTrafficCloud=min([a(ii+1).numCloud a(ii+1).numTraffic]);
			a(ii+1).numCameraTrafficCloud=min([a(ii+1).numCamera a(ii+1).numCloud a(ii+1).numTraffic]);
			if isempty(a(ii+1).file)
				a(ii+1).file=a(ii).file;
			end
			a(ii)=[];
		end
	end
	
	if isempty(res)
		res=a;
	else
		res=[res a];
	end
end

end

