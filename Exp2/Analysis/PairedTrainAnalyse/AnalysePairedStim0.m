function  AnalysePairedStim(PatternData)
%ANALYSEPAIREDSTIM Summary of this function goes here
%   Detailed explanation goes here

[Patterns , PatternConfig ]= EditPatterns(PatternData);

P = ones(size(Patterns));
P(isnan(Patterns)) = 0;

%ElectrodesToObserve = PatternConfig.PatternDetails.ElectrodesToObserve;
ElectrodesToObserve =  [118    38];
for i=1:numel(ElectrodesToObserve)
    Q = P(ElectrodesToObserve(i),(50*(i-1)+1):(50*(i-1)+12),:);
    S1 = mean(Q(:,0 + [1 5 9],:),2);
    S2 = mean(Q(:,1 + [1 5 9],:),2);
    S3 = mean(Q(:,2 + [1 5 9],:),2);
    S4 = mean(Q(:,3 + [1 5 9],:),2);
    S1 =S1(:);S2 =S2(:);S3 =S3(:);S4 =S4(:);
    
    display('................')
    [mean(S1(1:10)) mean(S1(35:45))]
    [mean(S2(1:10)) mean(S2(35:45))]
    [mean(S3(1:10)) mean(S3(35:45))]
    [mean(S4(1:10)) mean(S4(35:45))]
    display('................')
    
    Q = P(ElectrodesToObserve(i),(50*(i-1)+13):(50*(i-1)+50),:);
    Q  = mean(Q,2);
    Q  = Q(:);
    [mean(Q(1:10)) mean(Q(35:45))]
    %figure;hold on;    
    %waitforbuttonpress;
end

    

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