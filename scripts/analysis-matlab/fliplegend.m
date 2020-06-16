function []=fliplegend(labels, location)
%fliplegend - Create a flipped legend for a MATLAB plot.
%  INPUT
%    labels: labels to be displayed on the legend
%    location: location for the legend

fig=gcf;
bb=fig.Children.Children';
l=legend(bb, labels,'Location',location);
legholder=l.String;
for i=1:length(legholder)
    l.String{i}=legholder{end+1-i};
end
end