function matrix2latex(destination,matrix,prefix,suffix,firstPrefix,firstSuffix)
% matrix2latex - Converts a matrix into the body of a latex table.
%  INPUT
%    destination: text file containing latex commands for the table
%    matrix: matrix of strings or numberic values to be added to the table
%    prefix (optional): latex commands to be added before each value (except
%                       first row)
%    suffix (optional): latex commands to be added after each value (except
%                       first row)
%    firstPrefix (optional): latex commands to be added before each value (only
%                            first row)
%    firstSuffix (optional): latex commands to be added after each value (only
%                            first row)
fid=fopen(destination,'w');

if exist('prefix','var')~=1
	prefix="";
end
if exist('suffix','var')~=1
	suffix="";
end
if exist('firstPrefix','var')~=1
	firstPrefix=prefix;
end
if exist('firstSuffix','var')~=1
	firstSuffix=suffix;
end

[r,c]=size(matrix);

for ii=1:r
	for jj=1:c
		if iscell(matrix(ii,jj))
			value=matrix{ii,jj};
		else
			value=matrix(ii,jj);
		end
		
		if isnumeric(value)
			value=num2str(value);
		end
		
		if jj==1
			fprintf(fid,"%s%s%s",firstPrefix,value,firstSuffix);
		else
			fprintf(fid," & %s%s%s",prefix,value,suffix);
		end
	end
	fprintf(fid," \\\\\n");
end

fclose(fid);

end