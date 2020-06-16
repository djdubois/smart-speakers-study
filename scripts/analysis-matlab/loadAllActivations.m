function [a] = loadAllActivations(method)
%loadAllActivations - Load all the activations from results files
% This function assumes that a file 'data/material.txt' is available with the
% list of video material (file names) as it appears on the results.txt file.
% It also assumes that results files are in
% "data/results-method-finalXY-filtered.txt", where X is the experiment type
% between 1 and 2. And Y is the repetition of such experiment between "a" and "b".
% In experiments of type "1" the Amazon devices are configured as follows:
% - echodot (2nd gen): Echo
% - t-echodot (2nd gen): Amazon
% - echodot3a (3rd gen): Alexa
% - echodot3b (3rd gen): Computer
% In experiments of type "2" the Amazon devices are configured as follows:
% - echodot (2nd gen): Alexa
% - t-echodot (2nd gen): Computer
% - echodot3a (3rd gen): Echo
% - echodot3b (3rd gen): Amazon
% All additional repetitions for the experiments are in the file
% "data/results-method-finalr.txt"
%  INPUT
%    method: method used to get the activations, it can be "camera", "traffic",
%            and "cloud" for the US, and "uk" for the UK (camera only)
%  OUTPUT
%    Array containing activations for all the devices. The index is fixed as
%    follows: (1) Google Home Mini
%             (2) Apple Homepod
%             (3) Invoke with Cortana
%             (4) Echo dot 2nd gen. (Alexa wake word)
%             (5) Echo dot 3rd gen. (Alexa wake word)
%             (6) Echo dot 2nd gen. (Echo wake word)
%             (7) Echo dot 3rd gen. (Echo wake word)
%             (8) Echo dot 2nd gen. (Computer wake word)
%             (9) Echo dot 3rd gen. (Computer wake word)
%            (10) Echo dot 2nd gen. (Amazon wake word)
%            (11) Echo dot 3rd gen. (Amazon wake word)
%    see "data/devicex.txt" for details.

if method=="camera"
	type=1;
elseif method=="traffic"
	type=2;
elseif method=="cloud"
	type=3;
elseif method=="uk"
	type=4;
else
	type=0;
end

delta=5;
final1a=strcat('data/results-',method,'-final1a-filtered.txt');
final1b=strcat('data/results-',method,'-final1b-filtered.txt');
final2a=strcat('data/results-',method,'-final2a-filtered.txt');
final2b=strcat('data/results-',method,'-final2b-filtered.txt');
finalr=strcat('data/results-',method,'-finalr.txt');

%1 google
a{1}=loadActivations(final1a,'google-home-mini2','google',2,12,type);
a{1}=loadActivations(final2a,'google-home-mini2','google',1,12,type,a{1});
a{1}=consolidateActivations(a{1},delta);
a{1}=loadRepeatedActivations(finalr,'google-home-mini2','google',2,12,type,'camera',a{1});
a{1}=consolidateActivations(a{1},0);
a{1}=removeUnwantedActivations(a{1},2);

%2 homepod
a{2}=loadActivations(final1a,'homepod','siri',2,12,type);
a{2}=loadActivations(final2a,'homepod','siri',1,12,type,a{2});
a{2}=consolidateActivations(a{2},delta);
a{2}=loadRepeatedActivations(finalr,'homepod','siri',2,12,1,'camera',a{2});
a{2}=consolidateActivations(a{2},0);
a{2}=removeUnwantedActivations(a{2},2);

%3 invoke
a{3}=loadActivations(final1a,'invoke','cortana',2,4,type);
a{3}=loadActivations(final1b,'invoke','cortana',3,4,type,a{3});
a{3}=loadActivations(final2a,'invoke','cortana',1,4,type,a{3});
a{3}=loadActivations(final2b,'invoke','cortana',4,4,type,a{3});
a{3}=consolidateActivations(a{3},delta);
a{3}=removeUnwantedActivations(a{3},2);

%4 echo2-alexa
a{4}=loadActivations(final2a,'echodot','alexa',1,12,type);
a{4}=loadActivations(final2b,'echodot','alexa',2,12,type,a{4});
a{4}=consolidateActivations(a{4},delta);
a{4}=loadRepeatedActivations(finalr,'echodot','alexa',2,12,type,'camera2',a{4});
a{4}=consolidateActivations(a{4},0);
a{4}=removeUnwantedActivations(a{4},2);

%5 echo3-alexa
a{5}=loadActivations(final1a,'echodot3a','alexa',1,12,type);
a{5}=loadActivations(final1b,'echodot3a','alexa',2,12,type,a{5});
a{5}=consolidateActivations(a{5},delta);
a{5}=loadRepeatedActivations(finalr,'echodot3a','alexa',2,12,type,'camera1',a{5});
a{5}=consolidateActivations(a{5},0);
a{5}=removeUnwantedActivations(a{5},2);

%6 echo2-echo
a{6}=loadActivations(final1a,'echodot','echo',1,12,type);
a{6}=loadActivations(final1b,'echodot','echo',2,12,type,a{6});
a{6}=consolidateActivations(a{6},delta);
a{6}=loadRepeatedActivations(finalr,'echodot','echo',2,12,type,'camera1',a{6});
a{6}=consolidateActivations(a{6},0);
a{6}=removeUnwantedActivations(a{6},2);

%7 echo3-echo
a{7}=loadActivations(final2a,'echodot3a','echo',1,12,type);
a{7}=loadActivations(final2b,'echodot3a','echo',2,12,type,a{7});
a{7}=consolidateActivations(a{7},delta);
a{7}=loadRepeatedActivations(finalr,'echodot3a','echo',2,12,type,'camera2',a{7});
a{7}=consolidateActivations(a{7},0);
a{7}=removeUnwantedActivations(a{7},2);

%8 echo2-computer
a{8}=loadActivations(final2a,'t-echodot','computer',1,12,type);
a{8}=loadActivations(final2b,'t-echodot','computer',2,12,type,a{8});
a{8}=consolidateActivations(a{8},delta);
a{8}=loadRepeatedActivations(finalr,'t-echodot','computer',2,12,type,'camera2',a{8});
a{8}=consolidateActivations(a{8},0);
a{8}=removeUnwantedActivations(a{8},2);

%9 echo3-computer
a{9}=loadActivations(final1a,'echodot3b','computer',1,12,type);
a{9}=loadActivations(final1b,'echodot3b','computer',2,12,type,a{9});
a{9}=consolidateActivations(a{9},delta);
a{9}=loadRepeatedActivations(finalr,'echodot3b','computer',2,12,type,'camera1',a{9});
a{9}=consolidateActivations(a{9},0);
a{9}=removeUnwantedActivations(a{9},2);

%10 echo2-amazon
a{10}=loadActivations(final1a,'t-echodot','amazon',1,12,type);
a{10}=loadActivations(final1b,'t-echodot','amazon',2,12,type,a{10});
a{10}=consolidateActivations(a{10},delta);
a{10}=loadRepeatedActivations(finalr,'t-echodot','amazon',2,12,type,'camera1',a{10});
a{10}=consolidateActivations(a{10},0);
a{10}=removeUnwantedActivations(a{10},2);

%11 echo3-amazon
a{11}=loadActivations(final2a,'echodot3b','amazon',1,12,type);
a{11}=loadActivations(final2b,'echodot3b','amazon',2,12,type,a{11});
a{11}=consolidateActivations(a{11},delta);
a{11}=loadRepeatedActivations(finalr,'echodot3b','amazon',2,12,type,'camera2',a{11});
a{11}=consolidateActivations(a{11},0);
a{11}=removeUnwantedActivations(a{11},2);

end

