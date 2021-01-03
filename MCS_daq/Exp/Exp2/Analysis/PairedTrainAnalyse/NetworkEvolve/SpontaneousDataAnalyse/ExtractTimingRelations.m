function T =  ExtractTimingRelations(PatternData)
  T{120,120} = {};
  for i=1:120
      for j=1:120
          if(i ~= j)
            y1 = ExtractSpikeTimes(PatternData,i);
            y2 = ExtractSpikeTimes(PatternData,j);
            T{i,j}.next = CalculateDelayToNextSpike(y1,y2);
            T{i,j}.perv = CalculateDelayToPreviousSpike(y1,y2);
          end
      end
      s = sprintf('%2.2f ', 100*i/j)
  end
end

%Number of times y2 follows y1 with td ms
function T = CalculateDelayToNextSpike(y1,y2)
  id2=1;
  N1 = numel(y1);
  N2 = numel(y2);
  T =  nan*ones(N1,1);
  if(N1>0 && N2>0)
      for id1=1:N1
          %Search for y2 > y1
          while((y1(id1)>y2(id2))&&(N2>id2))
              id2 = id2 + 1;              
          end
          d = y2(id2)-y1(id1);
          if(d>0)
              T(id1)=d;
          else
              break;
          end
      end
  end
end

%Number of times y2 follows y1 with td ms
function T = CalculateDelayToPreviousSpike(y1,y2)
  
  N1 = numel(y1);
  N2 = numel(y2);
  T =  nan*ones(N1,1);
  id2 = N2;
  if(N1>0 && N2>0)             
      for id1=N1:-1:1
          %Search for y2 > y1
          while((y2(id2)>y1(id1))&&(id2>1))
              id2 = id2 - 1;              
          end
          d = y1(id1)-y2(id2);
          if(d>0)
              T(id1)=d;
          else
              break;
          end
      end
  end
end

function y = ExtractSpikeTimes(PatternData,ElectrodeNumber)
  nSpikes = 0; 
  for i=1:numel(PatternData.Pattern)
      nSpikes = nSpikes + PatternData.Pattern{i}.SpikeCounts(ElectrodeNumber);
  end
  y = zeros(nSpikes,1);
  idx = 1;
  for i=1:numel(PatternData.Pattern)
     off = sum(PatternData.Pattern{i}.SpikeCounts(1:ElectrodeNumber-1))+1; 
     y(idx:(idx + PatternData.Pattern{i}.SpikeCounts(ElectrodeNumber) - 1))=(i-1)*50000 + PatternData.Pattern{i}.SpikeTimes(off:(off + PatternData.Pattern{i}.SpikeCounts(ElectrodeNumber) - 1));
     idx = idx + PatternData.Pattern{i}.SpikeCounts(ElectrodeNumber);
  end
end