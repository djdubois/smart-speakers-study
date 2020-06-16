function [res] = addCountToStrings(text,count,unit)
%addCountToStrings - This function adds ' (n=...)' information to a list of text labels.
%  INPUT
%    text: array of strings used as a base
%    count: array of "count" numbers to be added to each string.
%    unit: measurement unit (default: "n")
%  OUTPUT
%    res: variation of the "text" array with counts and measurement unit.

if nargin<3
	unit="n";
end

res=text;

for ii=1:length(text)
	res{ii}=strcat(res{ii}," (",unit,"=",num2str(round(count(ii))),")");
end

end

