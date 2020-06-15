function P = Get_StimResponse_SpikeTrain(SpikeCounts,SpikeTimes,MarkTime,window,nSpikes)


nEl = numel(SpikeCounts);
P = ones(nEl,nSpikes)*NaN;

offset = cumsum(SpikeCounts) ;
offset = [1 ; (1 + offset(1:end-1))];

for i=1:nEl
    times = SpikeTimes(offset(i):(offset(i)+SpikeCounts(i)-1));
    times = times((times >= (MarkTime+5*50))&(times < (MarkTime + window) ));
    if(numel(times) > 0)
      times = times   - MarkTime ;  
      for j=1:min(nSpikes,numel(times))
          P(i,j) = times(j) ;
      end      
    end
end

end