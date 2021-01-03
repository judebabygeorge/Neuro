

figure;
row= ChannelMapping.row;
col = ChannelMapping.col;


    th = 0:pi/500:2*pi;
    r  = 7.5            ;
    c  = [6.5 6.5]    ;  
    x  = c(1) + r*sin(th)      ;
    y  = c(2) + r*cos(th)      ;

    h = gca ;
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


