function B = CreateSpikeShapeDisplay(nSections,RowsPerSection,ColumnsPerSection,xlim)

    bargraph_size   = [150 150] ;
    max_window_size = [1900 900];
    SectionSize = [bargraph_size(1)*ColumnsPerSection bargraph_size(2)*RowsPerSection];
    
    maxSections = floor(max_window_size./SectionSize);    
    nSections   = min(nSections,maxSections(1)*maxSections(2));
    
    nRows       = maxSections(2);
    nColumns    = ceil(nSections/nRows);
    
    h = figure('Position' , [50 50 nColumns*SectionSize(1)+15*(nColumns-1) nRows*SectionSize(2)+15*(nRows-1) ],'Units','pixel');
    B.h = h ;
    P1 = get(h,'Position');
    s = bargraph_size;  
    
    xl = xlim;
    x = xl(1):round((xl(2)-xl(1))/20):xl(2);
    B.x = x;
    
    for i=1:nColumns
        for j = 1:nRows
            for k=1:ColumnsPerSection
                for l=1:RowsPerSection          
                    
                 v = [((i-1)*ColumnsPerSection + (k-1)) (RowsPerSection*nRows-((j-1)*RowsPerSection+l))];
                 P  = [v(1)*s(1)+(i-1)*15 v(2)*s(2)+(nRows-j)*15 s(1) s(2)] ;                 
                 Pax=P;Pax(4) = Pax(4) - 15;                 
                 Pax(1:2:3) = Pax(1:2:3)./P1(3);
                 Pax(2:2:4) = Pax(2:2:4)./P1(4);
                 h = axes('Position',Pax);   
                 
                 B.SpikeAxis{(i-1)*nRows+j , k , l}.ax=h;                 
                 set(h,'XLim',[-25 75],'YLim',[-100 100],'YLimMode','manual','XLimMode','manual','XTick',[],'YTick',[]); 
                
                 %Create Text
                 B.SpikeAxis{(i-1)*nRows+j , k , l}.ht = text('Position',[5 15],'String','','Parent',h);  
                 
                 %Create Label
                 Pl = P;
                 Pl(2) =Pl(2) + s(2) -15;
                 Pl(4) = 15;
                 B.SpikeAxis{(i-1)*nRows+j , k , l}.hl = uicontrol('Style', 'text','Position', Pl,'String','hh','HorizontalAlignment','left','FontWeight','bold'); 
                end
            end
        end
    end
    
end
