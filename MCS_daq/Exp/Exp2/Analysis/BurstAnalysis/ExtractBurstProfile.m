function [y, e] = ExtractBurstProfile(PatternData)
    window = 5;
    Pattern = PatternData.Pattern;
    y  = zeros((numel(Pattern))*1000/window,1);
    e  = zeros((numel(Pattern))*1000/window,120);
    for i=12:numel(Pattern)
        for j=1:1000/window
            t = [(j-1)*window j*window]*50;
            y((i-1)*(1000/window) + j )=sum(Pattern{i}.SpikeTimes >= t(1) & Pattern{i}.SpikeTimes < t(2));

            Offset = [0;cumsum(Pattern{i}.SpikeCounts)];
            for k=1:120
               S = Pattern{i}.SpikeTimes(Offset(k)+1:Offset(k+1));
               e((i-1)*(1000/window) + j,k ) = sum(S >= t(1) & S < t(2));
            end
        end
    end
end
