function [strongInc,inc,neutral,dec,strongDec]=trend(activations,type,oldrepetitions)
%trend - Calculate the repeatability trend for a set of activations.
%  INPUT
%    activations: set of activations
%    type: type of experiment (1=camera-us, 2=traffic-us, 3=cloud-us,
%    4=camera-uk)
%    oldrepetitions: number of repetitions of full experiments (i.e., 
%                      excluding confirmatory ones).
%  OUTPUT
%    strongInc: array of booleans, true for activations having a strong
%               increasing trend.
%    inc: array of booleans, true for activations having a weak increasing
%         trend.
%    neutral: array of booleans, true for activations having a neutral
%             trend.
%    dec: array of booleans, true for activations having a weak decreasing
%         trend.
%    strongDec: array of booleans, true for activations having a weak decreasing
%               trend.

n_activations=length(activations);
inc=false(1,n_activations);
strongInc=false(1,n_activations);
neutral=false(1,n_activations);
dec=false(1,n_activations);
strongDec=false(1,n_activations);

for ii=1:n_activations
	n_experiments=size(activations(ii).isActive,2);
	newrepetitions=n_experiments-oldrepetitions;
	
	old_experiments=1:(n_experiments-newrepetitions);
	new_experiments=(n_experiments-newrepetitions+1):n_experiments;
	old_activations=activations(ii).isActive(type,old_experiments);
	new_activations=activations(ii).isActive(type,new_experiments);

	p51_100old=mean(old_activations)>=0.501;
	p0_50old=mean(old_activations)<0.501;
	p0_25new=mean(new_activations)<=0.251;
	p0_50new=mean(new_activations)<=0.501;
	p51_100new=mean(new_activations)>=0.501;
	p75_100new=mean(new_activations)>=0.751;
	
	if p51_100old && p0_25new
		strongDec(ii)=true;
	elseif p51_100old && p0_50new
		dec(ii)=true;
	elseif p0_50old && p51_100new
		inc(ii)=true;
	elseif p0_50old && p75_100new
		strongInc(ii)=true;
	else
		neutral(ii)=true;
	end
	
end

end