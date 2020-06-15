function t2( Patterns)

    B=CreateBarGraphDisplay();     
    ShowSpikeTimes(B,Patterns,1:3,1:4);
     
    
end

function ShowSpikeTimes(B,P,E,pid)
    %Clear display
    for i=1:numel(B.BarAxis)
        cla(B.BarAxis{i}.ax);
    end
    xl = [4 10];
    for i=1:min(size(B.BarAxis,1),numel(E))
        for j=1:min(size(B.BarAxis,2),numel(pid))
            x = xl(1):10/50:xl(2);
            t = P(E(i),pid(j),:);
            t = reshape(t,[numel(t) 1])/50;         
            hist(B.BarAxis{i,j}.ax,t,x);            
            set(B.BarAxis{i,j}.ax,'XLim',xl,'YLim',[0 45]);
        end
    end
end
function B = CreateBarGraphDisplay()
    h = figure('Position' , [50 50 800 800],'Units','pixel');
    B.h = h ;
    P1 = get(h,'Position');
    s = [200 200];    
    
    for k=1:4
        for l=1:4
         P  = [(l-1)*s(1) ((4-k)*s(2)) s(1) s(2)] ;
         P(1:2:3) = P(1:2:3)./P1(3);
         P(2:2:4) = P(2:2:4)./P1(4);
         h = axes('Position',P);             
         B.BarAxis{l,k}.ax=h;
         %set(h,'XLimMode' , 'Manual' , 'YLimMode' , 'Manual' , 'ZLimMode' , 'Manual' );
         %set(h,'XLim',[0 10],'YLim',[0 50]);
        end
    end
    
end
