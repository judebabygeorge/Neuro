
function P = m3(PatternData,StimConfig)
[Patterns , PatternConfig ]= EditPatterns(PatternData);
P = ones(size(Patterns));
P(isnan(Patterns)) = 0;
P=mean(P,3);
P(StimConfig.PatternDetails.Train{i}.ElectrodesToObserve,StimConfig.PatternDetails.Train{i}.Patterns)
end