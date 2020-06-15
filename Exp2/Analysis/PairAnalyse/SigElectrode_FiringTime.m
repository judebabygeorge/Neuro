function SigElectrode_FiringTime(PatternData)

    V = 1:2:112;

    StimEl = PatternData.StimConfig.Patterns(:,V);
    %Check If the pattern uses 2 dacs
    if(StimEl(2,1)== 0) %Extract from electrode config info
        StimEl = PatternData.StimConfig.Electrodes(:,StimEl(1,:));
    end
    UniqueEl = PatternData.StimConfig.Electrodes(1,1:8); % The eightelectrodes that are used for stimulation
    
    %Extract The relevent patterns
    Patterns = PatternData.Pattern;
    Patterns = Patterns(:,V,:);

    E = PatternData.StimConfig.Electrodes(1,1:8) ;
    E = reshape(E,[1 numel(E)]);
    E = E(E~=0);
    Patterns(E,:,:)=nan;
    DecodeCheckWindow= 100;
    Patterns(Patterns<5*50) = nan;
    Patterns(Patterns>DecodeCheckWindow*50) = nan;
    
    %Find Significant Electrodes
     
    %Calculate The firing probabilities at each electrode 
    P = ones(size(Patterns)) ;
    P(isnan(Patterns)) = 0   ;
    P = mean(P,3);
    
    %Electrodes that show a sinificant change in their
    %Probability of firing on reversing order
    th= 0.7;
    X = abs(P(:,1:2:end) - P(:,2:2:end)) > th;
    Y = sum(X,2);
    I = find(Y>0);
    [~,i] = sort(Y(I),'descend');
    %Index of electrodes which show     
    I = I(i);
    display(sprintf('%d Electrodes that show change in response to pairing',numel(I)));
    display(Y(I)')
    
    B=CreateBarGraphDisplay();
    for i = 1:numel(I)
        ShowSpikeTimes_Pair(B,Patterns,I(i),find(X(I(i),:)~=0));
        waitforbuttonpress;
    end

    X = sum(P>th,2);
%     [~,I] = sort(X,'descend');
%     for i=1:4
%         ShowSpikeTimes(B,Patterns,I(1+(i-1)*16:i*16));
%         waitforbuttonpress;
%     end
end
function ShowSpikeTimes_Pair(B,P,E,Pid)
    %Clear display
    for i=1:numel(B.BarAxis)
        cla(B.BarAxis{i}.ax);
    end
    Pid = Pid(1:min(8,numel(Pid)));
    xl = [4 10];
    for i=1:numel(Pid)
        x = xl(1):10/100:xl(2);
        t = reshape(P(E,2*Pid(i) -1,:),[45 1])/50; 
        
        hist(B.BarAxis{i,1}.ax,t,x);        
        t = reshape(P(E,2*Pid(i),:),[45 1])/50 ; 
        hist(B.BarAxis{i,2}.ax,t,x);
        
        set(B.BarAxis{i,1}.ax,'XLim',xl,'YLim',[0 45]);
        set(B.BarAxis{i,2}.ax,'XLim',xl,'YLim',[0 45]);
    end
end
function ShowSpikeTimes(B,P,E)
    %Clear display
    for i=1:numel(B.BarAxis)
        cla(B.BarAxis{i}.ax);
    end
    xl = [4 20];
    for i=1:min(numel(B.BarAxis),numel(E))
        x = xl(1):10/50:xl(2);
        t = P(E(i),:,:);
        t = reshape(t,[numel(t) 1])/50;         
        hist(B.BarAxis{i}.ax,t,x);          
        set(B.BarAxis{i}.ax,'XLim',xl,'YLim',[0 45]);
    end
end
function B = CreateBarGraphDisplay()
    h = figure('Position' , [50 50 800 800],'Units','pixel');
    B.h = h ;
    P1 = get(h,'Position');
    s = [200 200];    
    for j = 1:2
        for k=1:4
            for l=1:2
             P  = [((j-1)*2 + l-1)*s(1) ((4-k)*s(2)) s(1) s(2)] ;
             P(1:2:3) = P(1:2:3)./P1(3);
             P(2:2:4) = P(2:2:4)./P1(4);
             h = axes('Position',P);             
             B.BarAxis{4*(j-1)+k,l}.ax=h;
             %set(h,'XLimMode' , 'Manual' , 'YLimMode' , 'Manual' , 'ZLimMode' , 'Manual' );
             %set(h,'XLim',[0 10],'YLim',[0 50]);
            end
        end
    end
end

