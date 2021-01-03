

a = [1 2 3 4 1 2 3 4] +5;
y = 1:8 ;

cl = [44 147 225]/255 ;
scatter(a,y,100,cl,'filled')
set(gca,'XLim',[0 20]);
set(gca,'YLim',[-2 13]);
set(gca,'YTick',1:1:8)
xlabel('t(ms)');
ylabel('Electrode');
text(2,10,'Input = [3 2 1 3 2 1 3 2 1]','FontName','Cambria','FontWeight','bold','FontSize',14)
axis('square')
set(gcf,'Color',[1 1 1]);