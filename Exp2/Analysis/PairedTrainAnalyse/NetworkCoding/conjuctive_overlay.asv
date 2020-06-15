figure;
%scatter(xx,yy,d2(:)*500+0.001,'k','filled');
hold on;
%scatter(xx,yy,d3(:)*500+0.001,'r','filled');
scatter(xx,yy,d2(:)*500+0.001,'r','LineWidth',1);
scatter(xx,yy,d3(:)*500+0.001,'b','LineWidth',1);

str = ['ABCDEFGH']     ;
idx = 0;

for i=1:8
    text(i-0.2,9,str(i),'Rotation',0,'Color',[0,0,0],'FontName','Cambria','FontSize',14,'FontWeight','bold')
    text(0-0.2,i,str(i),'Rotation',0,'Color',[0,0,0],'FontName','Cambria','FontSize',14,'FontWeight','bold')
end
set(gca,'XTickLabel',{'','A','B','C','D','E','F','G','H',''})
set(gca,'YTickLabel',{'','A','B','C','D','E','F','G','H',''})
set(gca,'XTickLabel',{})
set(gca,'YTickLabel',{})
axis square
grid on
set(gca,'YDir','reverse')
set(gca,'YTick',-1.5:1:9.5)
ylim([-1.5 10])
set(gca,'XTick',-1.5:1:9.5)
xlim([-.5 10])
