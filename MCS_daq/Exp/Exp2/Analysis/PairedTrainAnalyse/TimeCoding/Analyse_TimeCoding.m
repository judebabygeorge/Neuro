function  Analyse_TimeCoding(PatternData)
%ANALYSEPAIREDSTIM Summary of this function goes here
%   Detailed explanation goes here


B = CreateBarGraphDisplay(1,6,12,[4 80]);

[Patterns , StimConfigProbe ]= EditPatterns(PatternData);  

P = ones(size(Patterns));
P(isnan(Patterns)) = 0;
P = mean(P,3);
P = sum(P,1);
P = P(:);
[~,J] = sort(P,'descend');


for k = 1:numel(J)
    
    PatternId = J(k);
    
    P = Patterns(:,PatternId,:);
    PP = reshape(P ,[size(P,1) size(P,3)]);
    P = ones(size(PP));
    P(isnan(PP)) = 0;
    P = mean(P,2);
    [~,I] = sort(P,'descend');

    for i=1:6           
        for j=1:12
            ShowSpikeTimes(B,[1 j i],Patterns,StimConfigProbe,I(j + (i-1)*12),PatternId);     
        end    
    end
    
    waitforbuttonpress;
end
% F = getframe(B.h);
% imwrite(F.cdata,[save_path  '/el/' DIV '.png']);
% F = getframe(S.h);
% imwrite(F.cdata,[save_path  '/sp/' DIV '.png']);
% close(B.h)
% close(S.h);
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


function [Patterns , PatternConfig ]= EditPatterns(PatternData)
    %Extract The relevent patterns
    Patterns = PatternData.Pattern;
    PatternConfig = PatternData.StimConfig;
    %Patterns = Patterns(:,V,:);

    E = PatternData.StimConfig.Electrodes(1,1:8) ;
    E = reshape(E,[1 numel(E)]);
    E = E(E~=0);
    Patterns(E,:,:)=nan;
    DecodeCheckWindow= 150;
    Patterns(Patterns<5*50) = nan;
    Patterns(Patterns>DecodeCheckWindow*50) = nan;
end
function tm =  GetMeanFireTime(Patterns,El,Pid)
    tm = Patterns(El,Pid,:);
    tm=  tm(~isnan(tm));
    tm = mean(tm)/50;
end