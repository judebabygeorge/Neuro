function D = create_evolve_display()
  h   = figure('Position',[25 100 (150 + 24*75) 900],'color','w');
  D.h = h;
  P = get(D.h,'Position');
  D.ax= axes('Position',[75/P(3) 75/P(4) 24*75/P(3) 600/P(4)],'XTick',[],'YTick',[]); 
  
  xl = [4 80];
  x = xl(1):round((xl(2)-xl(1))/20):xl(2);
  D.x = x;
  y = 0*ones(size(x));
  
  for i=1:24     
     D.Spikes{i}.ax = axes('Position',[((i-1)*75+75)/P(3) 725/P(4) 75/P(3) 75/P(4)],'XTick',[],'YTick',[]); 
     D.Hist{i}.ax   = axes('Position',[((i-1)*75+75)/P(3) 805/P(4) 75/P(3) 75/P(4)],'XTick',[],'YTick',[]);
     D.Hist{i}.bh   = bar(x,y);
     set(D.Hist{i}.ax,'XLim',[xl(1) xl(end)],'YLim',[0 20],'YLimMode','manual','XLimMode','manual','XTick',[],'YTick',[]); 
  end
end