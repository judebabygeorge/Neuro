function test_US2(PatternData)
    SpikeCounts = zeros(120,numel(PatternData.Pattern));
    for i=1:numel(PatternData.Pattern)
    SpikeCounts(:,i)=PatternData.Pattern{i}.SpikeCounts;
    end
    figure;plot(sum(SpikeCounts));
end