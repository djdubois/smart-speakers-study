function [map] = loadMap(filename)
%loadMap - Loads a map from a file using line numbers as keys.
%  INPUT
%    filename: name of the file that contains the list of values (one per line)
%  OUTPUT
%    map: map data structure (containers.Map) with data loaded from the file.
%         keys in the map are the line number in the file, values are the
%         actual content of such lines.

fileID = fopen(filename);
values=[];

while true
	line = fgetl(fileID);
	if ~ischar(line)
		break
	end
	values{end+1}=strtrim(line);
end

fclose(fileID);
map=containers.Map(values,1:length(values));

end

