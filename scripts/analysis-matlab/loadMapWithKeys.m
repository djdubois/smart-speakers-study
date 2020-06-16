function [map] = myLoadMapWithKeys(file)
%myLoadMapWithKeys - Loads a "key value" map from a file.
%  INPUT
%    filename: name of the file that contains the list of keys and values 
%              separated by a space (one per line)
%  OUTPUT
%    map: map data structure (containers.Map) with keys and values loaded from the file.

fileID = fopen(file,'rt');
map = containers.Map;
while true
	line = fgetl(fileID);
	if ~ischar(line)
		break
	end
	linesplit=split(line,' ');
	value=linesplit(1);
	key=join(linesplit(2:end),' ');
	map(key{1})=str2double(value{1});
end

fclose(fileID);
	
end

