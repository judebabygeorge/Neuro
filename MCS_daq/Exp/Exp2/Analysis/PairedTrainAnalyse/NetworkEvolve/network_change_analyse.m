function B = network_change_analyse(path,DIV,El,NominalProbe)
    opengl software
    nSections = numel(DIV);
    
    RowsPerSection = 1 ;
    ColumnsPerSection = 1;

    %Load Data from files
    Data{nSections} = [] ;
    
    for i=1:nSections
      [~,Y] = AnalyseNetworkEvolve_Full( path, DIV(i) );
      Data{i}.Y = Y;
    end
    
    B = CreateNetworkEvolveDisplay(nSections+1,RowsPerSection,ColumnsPerSection);
    
    a = load([path '/' DIV{1} '/StimConfigProbe.mat']);
    
    B.DIV = DIV;
    B.Data = Data;
    B.El = El;
    B.NominalProbe = NominalProbe;
    B.CurrentProbe = 1;
    B.StimConfig = a.StimConfigProbe;
    
    B.UpdateDisplay = @UpdateDisplay;
    set(B.h,'WindowKeyPressFcn',@ChangeVector);
    guidata(B.h,B);
    UpdateDisplay(B);
    
end
function ChangeVector(h,ev)
  B = guidata(h);
  
  if strcmp(ev.Key,'uparrow')
      B.CurrentProbe = B.CurrentProbe + 1 ;
      if(B.CurrentProbe > size(B.Data{1}.Y,2))
          B.CurrentProbe = 1;
      end
  end
  if strcmp(ev.Key,'downarrow')
      B.CurrentProbe = B.CurrentProbe - 1 ;
      if(B.CurrentProbe == 0)
          B.CurrentProbe = size(B.Data{1}.Y,2);
      end
  end
  
  UpdateDisplay(B);
  guidata(B.h,B);
end
function UpdateDisplay(B)
   HighlightProbes = [B.NominalProbe B.CurrentProbe];
   HighlightColors = [1 0 0 ; 0 0 1];
  
   [nps,npid] = GetPatternDescription_C(B.StimConfig ,B.NominalProbe);
   [cps,cpid] = GetPatternDescription_C(B.StimConfig ,B.CurrentProbe);
   probe = sprintf('Nominal : %d(%s) Current %d(%s)',B.NominalProbe,nps,B.CurrentProbe,cps);
   
   for i=1:numel(B.DIV)
       s = sprintf('%s %s',B.DIV{i},probe);
       set(B.nAxis{i}.hl,'String',s);
       v = B.Data{i}.Y(B.El,:,:) ; 
       v = reshape(v,[size(v,2) size(v,3)])';       
       C = 0.5*ones(size(v,2),3);
       for j=1:numel(HighlightProbes)
           C(HighlightProbes(j),:) = HighlightColors(j,:);
       end
       
       %Reorder vectors
       id = 1:1:size(v,2);
       id(HighlightProbes) = [];
       id = [id HighlightProbes];
       
       v = v(:,id);
       C = C(id,:);
       
       cla(B.nAxis{i}.ax);
       
       x = (1:1:size(v,1))*0.15;
       
       for j=1:size(v,2)
         plot(B.nAxis{i}.ax,x,v(:,j),'Color',C(j,:),'LineWidth',2, 'LineSmoothing','on');
         hold(B.nAxis{i}.ax,'on');
       end
       hold(B.nAxis{i}.ax,'off');
   end
   
   %Draw Electrodes
   Activity = zeros(120,1);
   Visibility = ones(120,1)*0.1;
   Mark     = zeros(120,1);
   
   Activity(npid) = 0.5;
   Activity(cpid) = 1;
   
   Mark(B.El) = 1;
   Visibility([cpid npid]) = 1;
   ShowElectrodeActivity(B.ElectrodeView,[Activity Visibility], Mark)
   
end
function B = CreateNetworkEvolveDisplay(nSections,RowsPerSection,ColumnsPerSection)
    
    graph_size   = [400 400] ;
    max_window_size = [1900 900];
    SectionSize = [graph_size(1)*ColumnsPerSection graph_size(2)*RowsPerSection];
    
    maxSections = floor(max_window_size./SectionSize);    
    nSections   = min(nSections,maxSections(1)*maxSections(2));
    
    nRows       = maxSections(2);
    nColumns    = ceil(nSections/nRows);
    
    h = figure('Position' , [50 50 nColumns*SectionSize(1)+15*(nColumns-1) nRows*SectionSize(2)+15*(nRows-1) ],'Units','pixel','Name','Network Evolve');
    B.h = h ;
    P1 = get(h,'Position');
    s = graph_size;  
    
%     xl = xlim;
%     x = xl(1):round((xl(2)-xl(1))/20):xl(2);
%     B.x = x;
    
    for i=1:nRows
        for j = 1:nColumns
            for k=1:ColumnsPerSection
                for l=1:RowsPerSection          
                    
                 v = [((j-1)*ColumnsPerSection + (k-1)) (RowsPerSection*nRows-((i-1)*RowsPerSection+l))];
                 P  = [v(1)*s(1)+(j-1)*15 v(2)*s(2)+(nRows-i)*15 s(1) s(2)] ;                 
                 Pax=P;Pax(4) = Pax(4) - 15;                 
                 Pax(1:2:3) = Pax(1:2:3)./P1(3);
                 Pax(2:2:4) = Pax(2:2:4)./P1(4);
                 h = axes('Position',Pax);   
                 
                 B.nAxis{(i-1)*nColumns+j , k , l}.ax=h;                 
                 set(h,'YLim',[-0.100 1.1],'YLimMode','manual','XLimMode','manual','XTick',[],'YTick',[]); 
                
                 %Create Text
                 B.nAxis{(i-1)*nColumns+j , k , l}.ht = text('Position',[5 15],'String','zz','Parent',h);  
                 
                 %Create Label
                 Pl = P;
                 Pl(2) =Pl(2) + s(2) -15;
                 Pl(4) = 15;
                 B.nAxis{(i-1)*nColumns+j , k , l}.hl = uicontrol('Style', 'text','Position', Pl,'String','div0','HorizontalAlignment','left','FontWeight','bold'); 
                end
            end
        end
    end
    
    a = load('ChannelMap.mat') ;
    B.ChannelMapping     = a.ChannelMapping;
   
    [hL, hPoints, hMask] = SetupElectrodeAxis(B.nAxis{nSections}.ax,B.ChannelMapping.row,B.ChannelMapping.col);
    B.ElectrodeView.h  = B.nAxis{nSections}.ax;
    B.ElectrodeView.hL = hL ;
    B.ElectrodeView.hPoints = hPoints ;
    B.ElectrodeView.hMask = hMask ;
    
end

function [s,id] = GetPatternDescription_C(PatternConfig,pid)
    El = PatternConfig.Electrodes(1,1:8);
    P = PatternConfig.Patterns(:,pid);
    s = [];
    id = [];
    isFast = 0;
    for i=1:numel(P)
        if(P(i) ~=0)
            [s0,id1]=GetElectrodeLables(PatternConfig,P(i));
            s = [s s0];
            id = [id id1];
        else
            isFast = 1;
        end
    end
    
    s = strtrim(s);
    if isFast == 1
        s = [s ' 0.5 ms'];
    else
        s = [s ' 3 ms'];
    end    
    id = El(id);
    
    function [s0,id] = GetElectrodeLables(PatternConfig,eid)  
        E = PatternConfig.Electrodes(:,eid);        
        s0 = [];
        id = [];
        for j=1:numel(E)
            if(E(j) ~= 0)
                id0 = find(El==E(j),1);
                id  = [id id0];
                s0 = [s0 char(uint8('A')+id0-1) ' '];
            end
        end
    end
end

function ShowElectrodeActivity(h,Activity, Mark)

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
    %  W = ones(120,3);
    %  W((Mark==1),:) = 0 ;
    %  set(handles.ElectrodeView{DisplayId}.hMask,'CData',W);

     set(h.hPoints,'CData',V);
     set(h.hPoints,'SizeData',S);
     
end

function [hL, hPoints, hMask] = SetupElectrodeAxis(h,row,col)

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
