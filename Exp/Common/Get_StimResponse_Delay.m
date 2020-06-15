function P = Get_StimResponse_Delay(SpikeCounts,SpikeTimes,MarkTime,window)

nEl = numel(SpikeCounts);
P = ones(nEl,1)*NaN;

offset = cumsum(SpikeCounts) ;
offset = [1 ; (1 + offset(1:end-1))];

for i=1:nEl
    times = SpikeTimes(offset(i):(offset(i)+SpikeCounts(i)-1));
    times = times((times >= (MarkTime+5*50))&(times < (MarkTime + window) ));
    if(numel(times) > 0)
      P(i) = times(1) - MarkTime ;
    end
end

end