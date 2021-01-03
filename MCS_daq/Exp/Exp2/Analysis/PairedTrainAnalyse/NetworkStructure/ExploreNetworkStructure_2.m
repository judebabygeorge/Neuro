function ExploreNetworkStructure_2(path,DIV)

close all
path = [path '\' DIV '\'];
B1 = CreateBarGraphDisplay(12,1,6,[4 80]);
%B2 = CreateBarGraphDisplay(12,1,6,[4 80]);

a=load([path '\data_PatternCheck_2_250_two_time_seq4_1.mat']);
[Patterns , PatternConfig ]= EditPatterns(a.PatternData);

Probes = zeros(8,8);
id=0;
for i=1:7
    for j=i+1:8
        id=id+1;
        Probes(i,j)=id;
        Probes(j,i)=id;        
    end
end
for Eid = 1:120

 getkey;
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