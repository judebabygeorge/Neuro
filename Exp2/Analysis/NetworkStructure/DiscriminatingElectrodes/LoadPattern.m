
function Patterns = LoadPattern(path)
    a = load(sprintf('%s/data_PatternCheck_2_250_two_time_seq4_1.mat',path));
    PatternData = a.PatternData;
    
    Patterns = PatternData.Pattern;
    E = PatternData.StimConfig.Electrodes(1,1:8) ;
    E = reshape(E,[1 numel(E)]);
    E = E(E~=0);
    Patterns(E,:,:)=nan;
    DecodeCheckWindow= 150;
    Patterns(Patterns<5*50) = nan;
    Patterns(Patterns>DecodeCheckWindow*50) = nan;
    
    P1 = ones(size(Patterns));
    P1(isnan(Patterns)) = 0;
    Patterns = P1;
end