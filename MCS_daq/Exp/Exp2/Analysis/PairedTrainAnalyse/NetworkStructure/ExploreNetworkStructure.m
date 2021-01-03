function ExploreNetworkStructure(path,DIV)

close all
path = [path '\' DIV '\'];
B = CreateBarGraphDisplay(12,1,6,[4 80]);


a=load([path '\data_PatternCheck_2_250_two_time_seq4_1.mat']);
[Patterns , PatternConfig ]= EditPatterns(a.PatternData);

id = 0;
for a=1:7
    for b=a+1:8
        Pid=[(id*4+[1 2 3 4])  (112+a) (112+b)];
        id=id+1
        %Pid = [1 2 3 4 113 114];
        Pid = Pid([1 2 4 3 5 6]);
        for i=1:10
            for j=1:12
                Eid = (i-1)*12 +j ;
                for k=1:numel(Pid)
                    ShowSpikeTimes(B,[j k 1],Patterns,PatternConfig,Eid,Pid(k));
                end
            end
            getkey;
        end
    end
end
    
end

function ShowSpikeTimes(B,loc,Patterns,PatternConfig,E,Pid)
        t = Patterns(E,Pid,:);
        t = reshape(t,[numel(t) 1])/50; 
        [n,~] = hist(B.BarAxis{loc(1),loc(2),loc(3)}.ax,t,B.x);                
        set(B.BarAxis{loc(1),loc(2),loc(3)}.bh,'YData',n);

        P=sum(~isnan(t))/numel(t);
        tm = mean(t(~isnan(t)));
        stim  = GetPatternDescription(PatternConfig,Pid);
        s =sprintf('P=%.2f,T_m = %2.1f ms  (%s)',P,tm,stim);
        set(B.BarAxis{loc(1),loc(2),loc(3)}.hl,'String',s);
end