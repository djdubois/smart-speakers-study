function plotBarDiagram(name, titleText, nameLabel, dataLabel, data, values, colors, legendText, location, stacked)
%plotBarDiagram - Plot a customized bar diagram in PDF format.
%  INPUT
%    name: File name of the figure (without extension) to be created
%    titleText: Title for the diagram (currently not used)
%    nameLanel: name of the devices (used as y labels)
%    dataLabel: label for the x axis
%    data: values for the x axis (to control the size of the bars)
%    values: values for the x avis (to label each bar)
%    colors: colors for the bars
%    legendText: text of the legend
%    location: location of the legend (according to MATLAB plot format)
%    stacked: stacking option according to MATLAB syntax (e.g., "stacked")
%  OUTPUT
%    Create file "plots/name.pdf"

if nargin<9
	location='best';
elseif isempty(location)
	location='best';
end

h=figure('DefaultAxesFontSize',13);
pos = get(h,'Position');

if length(nameLabel)<=5
	pos(4)=pos(4)*0.75;
	set(gcf, 'Position',  [pos(1), pos(2), pos(3), pos(4)])
end

if nargin>9
    b=barh(data,stacked);
	 if ~strcmp(location,'none')
		legend(legendText,'location',location);
	 end
else
	 b=barh(data);
	 if nargin>7 && ~strcmp(location,'none')
	     fliplegend(legendText,location);
	 end
end

%Uncomment this to add a title to the figure
%title(titleText);
grid on
grid minor
set(gca, 'XGrid', 'on', 'YGrid', 'off', 'YMinorGrid', 'off')
box off
xlabel(dataLabel);
yticklabels(nameLabel);

for ii=1:size(colors,2)
	b(ii).FaceColor=colors(:,ii);
end

if ~isempty(values)
	a = (1:size(data,1)).';
	y = [a-0.22 a a+0.22];
	for k=1:size(data,1)
		 for m = 1:size(data,2)
			  text(data(k,m)+0.005,y(k,m),num2str(round(values(k,m))),...
					'HorizontalAlignment','left',...
					'VerticalAlignment','middle', 'FontSize',10)
		 end
	end
end

set(gcf,'color','white');
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);

print(h,strcat(name,'.pdf'),'-dpdf','-r0');
close(h);

end

