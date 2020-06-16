function res=removeUnwantedActivations(a,fullActivations)
% removeUnwantedActivations - Remove activations that should be excluded from
% the result. This is needed because some devices have more experiments than
% others. This function levels the number of activations to "fullActivations"
% so that the comparison among all the devices can be even.
% If the remanining experiment do not have an activation, the whole activation
% is removed.
%   INPUT
%     a: list of activations that has to be filtered by removing excessive
%         experiments
%     fullActivations: number of experiments to be kept. For example, if the
%                      value if "2", the first two experiments are kept, and 
%                      the others are removed.
%  OUTPUT
%    res: subset of "a", with the unwanted activations removed
for ii=length(a):-1:1
	totalActivations=size(a(ii).isActive,2);
	for jj=(fullActivations+1):totalActivations
		 a(ii).isActive(:,jj)=a(ii).isActive(:,jj)&any(a(ii).isActive(:,1:fullActivations),2);
	end
   if max(max(a(ii).isActive))==0
	    a(ii)=[];
   end
end

res=a;

end