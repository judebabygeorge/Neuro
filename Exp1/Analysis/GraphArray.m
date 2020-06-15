function h = GraphArray
%PATTERNVIEW Summary of this function goes here
%   Detailed explanation goes here

h = figure('Position' , [50 50 1600 800]);
hO.h = h ;

hO.GraphView{32} = [];

P1 = get(h,'Position');

    s = [200 200];
    for j = 1:4
        for k=1:8    
            i = k + (j-1)*8 ;
            l = 4-j+1;
            P  = [(0 + (k-1)*s(1)) (0 + (l-1)*s(2)) s(1) s(2)] ;
            P(1:2:3) = P(1:2:3)./P1(3);
            P(2:2:4) = P(2:2:4)./P1(4);
            h = axes('Position',P);   
           
            set(h,'XTick', [],'YTick',[], 'ZTick',[]);
            set(h,'XTickMode', 'Manual', 'YTickMode', 'Manual', 'ZTickMode', 'Manual');
            set(h,'XColor',[1 1 1], 'YColor',[1 1 1], 'ZColor',[1 1 1])
            box(h,'on')
            hO.GraphView{i}.hAxis = h ;
            
        end
    end
    
    hO.AddPlot=@AddPlot;
    hO.PlotBar = @PlotBar;
    hO.add_scatter = @add_scatter;
    hO.set_ylim = @set_ylim;
    guidata(h, hO);
end


function add_scatter(hO,x,y,c,id,hold_axis)
     if(hold_axis)
         hold(hO.GraphView{id}.hAxis,'on');
     end
     scatter(hO.GraphView{id}.hAxis,x,y,10,c,'filled');     
     hold(hO.GraphView{id}.hAxis,'off');
end

function AddPlot(hO,x,y,c,id,hold_axis)

     if(hold_axis)
         hold(hO.GraphView{id}.hAxis,'on');
     end
     plot(hO.GraphView{id}.hAxis,x,y,c);     
     hold(hO.GraphView{id}.hAxis,'off');
      
     %set(hO.GraphView{id}.hAxis,'Ylim', [-1 1]*6000);
end

function set_ylim(hO,lim)
  for id=1:numel(hO.GraphView)
     set(hO.GraphView{id}.hAxis,'Ylim', lim); 
  end
end
function PlotBar(hO,x,y,id)
   cla(hO.GraphView{id}.hAxis);
   bar(hO.GraphView{id}.hAxis,x,y);
   set(hO.GraphView{id}.hAxis,'XTick', [],'YTick',[], 'ZTick',[]);
   %set(hO.GraphView{id}.hAxis,'Ylim', [-800 400]);
end