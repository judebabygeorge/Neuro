function  AnalysePairing( PatternData )
%ANALYSEPAIRING Summary of this function goes here
%   Detailed explanation goes here

B = CreateBarGraphDisplay(6,2,4,[4 80]);
[Patterns , PatternConfig ]= EditPatterns(PatternData);
P = ones(size(Patterns));
P(isnan(Patterns)) = 0;
P=mean(P,3);

if(1)
 i = 1;
 E = 73;
 pid  = PatternData.StimConfig.PatternListDetails.Tuples(i).P; 
 ShowSpikeTimes_Sweep(B,Patterns,PatternConfig,E,pid); 
 waitforbuttonpress
end

for i=1:numel(PatternData.StimConfig.PatternListDetails.Tuples)
    display(sprintf('Combination %d',i));
    pid = PatternData.StimConfig.PatternListDetails.Tuples(i).P;
    %PatternData.StimConfig.Patterns(:,pid)

    %Evaluate the electrodes to look at
    Q = P(:,pid);
    E = zeros(120,1);
    %Change in probability of firing on changing 
    %The time of firing from 0.5 to 3ms
    s = [1 3 5 7];
    for j=1:3
        for k=1:numel(s)-1
            for l=k+1:numel(s)
                E = E + (abs(Q(:,3+s(k)+(j-1)*8)-Q(:,3+s(l)+ (j-1)*8))>0.4);
            end
        end
    end
    
    E = find(E>0)
    for j=1:numel(E)        
        display(sprintf('Electrode %d',E(j)));
        ShowSpikeTimes_Sweep(B,Patterns,PatternConfig,E(j),pid);
        %saveas(B.h,'./pics/pic.png');
        waitforbuttonpress;
        
    end
end

end

function ShowSpikeTimes_Sweep(B,Patterns,PatternConfig,E,Pid)
    %Same Electrode for different Patterns
    %Clear display
    
    clear_BarGraphdisplay(B);
    
    %Paired
    for i=1:3
        for k=1:2
           for j=1:4
                    p = Pid(3 + (i-1)*8 + (k-1)*4 + j);
                    ShowSpikeTimes(B,[i j k],Patterns,PatternConfig,E,p);
            end
        end
    end
    
    %Single
    for j=1:3
        p = Pid(j);
        ShowSpikeTimes(B,[4 j 1],Patterns,PatternConfig,E,p);
    end
    
    %3comb
    for k=1:2
        for j=1:3
            p = Pid(3 + 24 + (k-1)*3 + j);
            ShowSpikeTimes(B,[5 j k],Patterns,PatternConfig,E,p);
        end
    end
end

function ShowSpikeTimes(B,loc,Patterns,PatternConfig,E,Pid)
        t = reshape(Patterns(E,Pid,:),[45 1])/50; 
        [n,~] = hist(B.BarAxis{loc(1),loc(2),loc(3)}.ax,t,B.x);                
        set(B.BarAxis{loc(1),loc(2),loc(3)}.bh,'YData',n);

        P=sum(~isnan(t))/numel(t);
        tm = mean(t(~isnan(t)));
        stim  = GetPatternDescription(PatternConfig,Pid);
        s =sprintf('P=%1.1f,T_m = %2.1f ms  (%s)',P,tm,stim);
        set(B.BarAxis{loc(1),loc(2),loc(3)}.hl,'String',s);
end
function [Patterns , PatternConfig ]= EditPatterns(PatternData)
    %Extract The relevent patterns
    Patterns = PatternData.Pattern;
    PatternConfig = PatternData.StimConfig;
    %Patterns = Patterns(:,V,:);

    E = PatternData.StimConfig.Electrodes(1,1:8) ;
    E = reshape(E,[1 numel(E)]);
    E = E(E~=0);
    Patterns(E,:,:)=nan;
    DecodeCheckWindow= 100;
    Patterns(Patterns<5*50) = nan;
    Patterns(Patterns>DecodeCheckWindow*50) = nan;
end
