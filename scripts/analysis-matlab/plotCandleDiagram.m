function plotCandleDiagram(name, titleText, nameLabel, dataLabel, data, pairs)
%plotCandleDiagram - Plot a customized candle diagram in PDF format.
%  INPUT
%    name: File name of the figure (without extension) to be created
%    titleText: Title for the diagram (currently not used)
%    nameLanel: name of the devices (used as y labels)
%    dataLabel: label for the x axis
%    data: values for the x axis (to control the size of the bars)
%    pairs: a second set of data, if showing a pair of values
%  OUTPUT
%    Create file "plots/name.pdf"

h=figure('DefaultAxesFontSize',12);

c=candle(data(:,[4 5 1 2]),[0.3010, 0.7450, 0.9330]);
%Uncomment the following to add a title
%title(titleText);
grid on
grid minor
box off
ylabel(dataLabel);
set(gca,'xtick',1:length(nameLabel),'xticklabel',nameLabel,'xticklabelrotation',45)
hold on

if nargin<6
	 set(gca, 'YGrid', 'on', 'XGrid', 'off', 'XMinorGrid', 'off')
	 p=plot([0.65:(length(nameLabel)-0.35);1.35:(length(nameLabel)+0.35)], ...
		 [data(:,3) data(:,3)]','color',[0, 0.4470, 0.7410],'LineWidth',2);
    legend([c(1) c(2) p(1)],"P10 to P90 (only for n>10)","P25 to P75","Median",'Location', 'best');
else
	 set(gca, 'YGrid', 'on', 'XGrid', 'off', 'XMinorGrid', 'on')
	 ax=gca;
	 ax.XAxis.MinorTickValues = ax.XAxis.Limits(1):ax.XAxis.Limits(2);
	 p=plot([0.65:2:(length(nameLabel)-0.35);1.35:2:(length(nameLabel)+0.35)], ...
		 [data(1:2:end,3) data(1:2:end,3)]','color',[0, 0.4470, 0.7410],'LineWidth',2);
	 q=plot([1.65:2:(length(nameLabel)-0.35);2.35:2:(length(nameLabel)+0.35)], ...
		 [data(2:2:end,3) data(2:2:end,3)]','color',[0.6350, 0.0780, 0.1840],'LineWidth',2);
	for ii=3:2:length(c)
		c(ii).FaceColor=[0.9290, 0.6940, 0.1250];
		c(ii).EdgeColor=[0.9290, 0.6940, 0.1250];
	end
	legend([c(1) c(2) p(1) c(3) q(1)], ...
		"P10 to P90 (only for n>10)",strcat("P25 to P75 (",pairs(1),")"), ...
		strcat("Median (",pairs(1),")"), ...
		strcat("P25 to P75 (",pairs(2),")"),...
		strcat("Median (",pairs(2),")"), ...
		'Location', 'best');
end

set(gcf,'color','white');
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);

print(h,strcat(name,'.pdf'),'-dpdf','-r0');

close(h);

end

