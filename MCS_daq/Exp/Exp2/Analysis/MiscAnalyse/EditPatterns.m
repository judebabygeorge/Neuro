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
    
    %i=2;P(StimConfig.PatternDetails.Train{i}.ElectrodesToObserve,StimConfig.PatternDetails.Train{i}.Patterns)
end