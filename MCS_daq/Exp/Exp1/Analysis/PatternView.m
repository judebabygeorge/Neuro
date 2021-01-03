function h = PatternView
%PATTERNVIEW Summary of this function goes here
%   Detailed explanation goes here

h = figure('Position' , [50 50 1600 800]);
hO.h = h ;

P1 = get(h,'Position');

a = load('ChannelMap.mat') ;
hO.ChannelMapping     = a.ChannelMapping;


    s = [200 200];
    for j = 1:4
        for k=1:8    
            i = k + (j-1)*8 ;
            l = 4-j+1;
            P  = [(0 + (k-1)*s(1)) (0 + (l-1)*s(2)) s(1) s(2)] ;
            P(1:2:3) = P(1:2:3)./P1(3);
            P(2:2:4) = P(2:2:4)./P1(4);
            h = axes('Position',P);
            [hL hPoints hMask] = SetupElectrodeAxis(h,hO.ChannelMapping.row,hO.ChannelMapping.col);
            hO.ElectrodeView{i}.hAxis = h ;
            hO.ElectrodeView{i}.hPoints=hPoints;
            hO.ElectrodeView{i}.hL = hL ;
            hO.ElectrodeView{i}.hMask = hMask ;   
        end
    end
    
    hO.ShowElectrodeActivity=@ShowElectrodeActivity;

    guidata(h, hO);
end


function ShowElectrodeActivity(handles,DisplayId,Activity, Mark)

     nEL  = size(Activity,1);
     nPad = 3 - size(Activity,2);
     V = [Activity ones(nEL,nPad)] ;  
     lim_in = [0 1] ;
     lim    = [2/3 0] ; %[r to g]
     %lim    = [1/3 0] ; %[r to g]

     m      = (lim(2) - lim(1))/(lim_in(2) - lim_in(1)) ;    
     c      = lim(1) - m*lim_in(1)   ;
     V(:,1) = m.*V(:,1)+c ;  
     V = hsv2rgb(V) ;   

     S = ones(size(V,1),1)*100;
     marks = find(Mark==1);
     for i=1:numel(marks)
      V(marks(i),:) = [0 0 1] ; 
      S(marks(i)) = 200;
     end
     
    
     
     %set(handles.ElectrodeView{DisplayId}.hMask,'FaceAlpha',Mark);

     set(handles.ElectrodeView{DisplayId}.hPoints,'CData',V);
     set(handles.ElectrodeView{DisplayId}.hPoints,'SizeData',S);
     
end

function [hL hPoints hMask] = SetupElectrodeAxis(h,row,col)

    th = 0:pi/500:2*pi;
    r  = 7.5            ;
    c  = [6.5 6.5]    ;  
    x  = c(1) + r*sin(th)      ;
    y  = c(2) + r*cos(th)      ;

    axes(h);
    hold(h,'on')
    hL = plot(x,y,'LineWidth',3);

    m = numel(row) ;

  
    cl = [1 1 1] ;
    CData = repmat(cl,m,1);
    hMask     = scatter(h,col,row,300,CData,'filled');
  


    cl = [44 147 225]/255 ;
    CData = repmat(cl,m,1);
    hPoints   = scatter(h,col,row,ones(size(col))*100,CData,'filled');

    
    set(h,'XLimMode' , 'Manual' , 'YLimMode' , 'Manual' , 'ZLimMode' , 'Manual' );
    set(h,'XLim',[c(1)-r-1 c(1) + r + 1],'YLim',[c(2)-r-1 c(2) + r + 1],'YDir','reverse');
    set(h,'XTick', [],'YTick',[], 'ZTick',[]);
    set(h,'XTickMode', 'Manual', 'YTickMode', 'Manual', 'ZTickMode', 'Manual');
    set(h,'XColor',[1 1 1], 'YColor',[1 1 1], 'ZColor',[1 1 1])

end