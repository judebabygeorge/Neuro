function [Prob P] = InvNetworkStructure(PatternData)
%INVNETWORKSTRUCTURE Summary of this function goes here
%   Detailed explanation goes here

    V = 2:2:112;
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
    
    %Calculate The firing probabilities at each electrode 
    P = ones(size(Patterns)) ;
    P(isnan(Patterns)) = 0   ;
    P = mean(P,3);

    Prob{numel(UniqueEl)} = {};
    
    for i=1:numel(UniqueEl)
        Prob{i}.El = UniqueEl(i);
        %Patterns where El occurs first
        Prob{i}.ElPre = StimEl(2, (StimEl(1,:) == Prob{i}.El));
        Prob{i}.PPre  = P(:,StimEl(1,:) == Prob{i}.El);
        
        Prob{i}.ElPost = StimEl(1, (StimEl(2,:) == Prob{i}.El));
        Prob{i}.PPost  = P(:,StimEl(2,:) == Prob{i}.El);
    end
    
end

