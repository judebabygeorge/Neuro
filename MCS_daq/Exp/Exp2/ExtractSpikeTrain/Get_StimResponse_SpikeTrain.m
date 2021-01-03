function [P hit] = Get_StimResponse_SpikeTrain(SpikeCounts,SpikeTimes,MarkTime,window,maxSpikes)

%Extract the spike Train for first 100 ms
nEl = numel(SpikeCounts);
P = zeros(120,maxSpikes)*nan;
hit = [0 0];
offset = cumsum(SpikeCounts) ;
offset = [1 ; (1 + offset(1:end-1))];

for i=1:nEl
    times = SpikeTimes(offset(i):(offset(i)+SpikeCounts(i)-1));
    times = times((times >= (MarkTime+5*50))&(times < (MarkTime + window) ));
    if(numel(times) > 0)
        hit(1) = hit(1) + numel(times);
      if(numel(times) >  maxSpikes)
          hit(2) = hit(2) + numel(times) - maxSpikes;
          times = times(1:maxSpikes);
      end
       P(i,1:numel(times)) = times - MarkTime ;
    end
end

%P = P(:);
end