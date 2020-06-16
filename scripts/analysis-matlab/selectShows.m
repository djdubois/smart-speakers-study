function selectShows(resultsfile, stats, eval, which)
%selectShows - Select shows based on statistics and export them as using
%results.txt format.
%  INPUT
%    resultFile: prints the results to the specified file using results.txt
%                format.
%    stats: statistics for all the devices (output of
%           generateActivationStatisticsAll)
%    eval: handle to the function which selects the activations.
%          for example, to select activations that have been detected in at
%          least three experiments, the function handle should be as follows:
%          @(x)...
%    which: indexes of the devices to be evaluated (for a list of indexes,
%           please refer to loadAllActivations function.
%  OUTPUT
%    a file resultFile will be created with the selected activations.

if nargin<4
    which=1:length(stats);
end

fid = fopen(resultsfile,'w');

for ii=which
   current=stats(ii);
	selection=current.a(eval(current.a));

	for jj=1:length(selection)
		mya=selection(jj);
		if contains(mya.file,'final1a')
			file='final1a';
		elseif contains(mya.file, 'final1b')
			file='final1b';
		elseif contains(mya.file, 'final2a')
			file='final2a';
		elseif contains(mya.file, 'final2b')
			file='final2b';
		else
			file='unknown';
		end

		fakestart=mya.start-5;
		if fakestart<0
			fakestart=0;
		end
      fprintf(fid,'/opt/voice-assist/capture/%s/%s/capture.mkv:Devices with corresponding times are listed below:\n%s:(%d, %d)\n',...
					file, mya.materialName, mya.device, fakestart, mya.start+2);

	end
end

fclose(fid);

end

