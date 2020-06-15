function B = burst_analyse( PatternData ,Data )
%BURST_ANALYSE Summary of this function goes here
%   Detailed explanation goes here
opengl software
B = CreateUI();

if isempty(Data)
    [y,b,bb,ee] = ExtractBurstInfo(PatternData);
    B.Data.y = y;
    B.Data.b  = b;
    B.Data.bb = bb;
    B.Data.ee = ee;
else
    B.Data = Data;
end

UpdateUI(B);

end
function UpdateUI(B)  
  plot(B.Main.ax,B.Data.bb,'Color',[0.5 0.5 0.5]); 
  hold(B.Main.ax, 'on');
  plot(B.Main.ax,mean(B.Data.bb,2),'LineWidth',2,'LineSmoothing','on');   
  hold(B.Main.ax, 'off');
  set(B.Main.ax,'XTick',[],'YTick',[],'YLimMode','manual','YLim',[-1 20]);
  
  for i=1:120
        e = reshape(B.Data.ee(:,i,:),[size(B.Data.ee,1) size(B.Data.ee,3)]);
        plot(B.ElectrodeActivity{i}.ax,e,'Color',[0.5 0.5 0.5]); 
        hold(B.ElectrodeActivity{i}.ax, 'on');
        plot(B.ElectrodeActivity{i}.ax,mean(e,2),'LineWidth',2,'LineSmoothing','on'); 
        hold(B.ElectrodeActivity{i}.ax, 'off');
        set(B.ElectrodeActivity{i}.ax,'XTick',[],'YTick',[],'YLimMode','manual','YLim',[-.1 1.5]);
  end
end
function B = CreateUI()

    a = load('ChannelMap.mat') ;
    B.ChannelMapping     = a.ChannelMapping;
    
    el_graph_size   = [1 1]*70 ;
    el_pos = [10 50];
    m_graph_size    = [400 400];
    main_pos = [900 100];
    max_window_size = [1600 900];
    
    h = figure('Position' , [10 10 max_window_size ],'Units','pixel','Name','Burst Analyse');
    
    B.h = h;
    
    
    P1 = get(h,'Position');
    
    %Create Electrode Axis
    s = el_graph_size;
    for i=1:numel(B.ChannelMapping.row)        
       v = [B.ChannelMapping.col(i)-1  B.ChannelMapping.row(i)-1 ];
       P  = [v(1)*s(1)+el_pos(1) v(2)*s(2)+el_pos(2) s(1) s(2)] ;                 
       Pax=P;Pax(4) = Pax(4) - 0;                 
       Pax(1:2:3) = Pax(1:2:3)./P1(3);
       Pax(2:2:4) = Pax(2:2:4)./P1(4);
       h = axes('Position',Pax);   
       set(h,'XTick',[],'YTick',[],'XColor','w','YColor','w');           
       B.ElectrodeActivity{i}.ax = h;
    end
    
    %Create Main axis
   
   s = m_graph_size;
   v = [0  0];
   P  = [v(1)*s(1)+main_pos(1) v(2)*s(2)+main_pos(2) s(1) s(2)] ;                 
   Pax=P;Pax(4) = Pax(4) - 0;                 
   Pax(1:2:3) = Pax(1:2:3)./P1(3);
   Pax(2:2:4) = Pax(2:2:4)./P1(4);
   h = axes('Position',Pax);   
   set(h,'XTick',[],'YTick',[],'XColor','w','YColor','w');           
   B.Main.ax = h;
end