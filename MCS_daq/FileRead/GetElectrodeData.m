function [Data SpikeTimes SpikeCount StimTimes]  = GetElectrodeData(file, t , Ch )
%GETELECTRODEDATA Summary of this function goes here
%   Detailed explanation goes here

tx    = zeros(size(t)); 
tx(1) = floor(t(1))      ;
tx(2) = ceil(t(2))       ;

Frames = (tx(1)+1):1:tx(2) ;

t = t*50000;
t = t - tx(1)*50000 ;


idx  = 0:50000:(50000*(numel(Frames)+1));

idx(1)   = t(1) ;
idx(end) = t(2) ;

Data = zeros(idx(end),numel(Ch))  ;
id = zeros(2,1);

u_SpikeTimes  = zeros(10000,1);
u_SpikeCounts = zeros(120,1)  ;

SpikeTimes  = zeros(10000,numel(Ch));
SpikeCount  = zeros(numel(Ch),1);

StimTimes = zeros(100,1);
nStim     = 0 ;

for i=1:numel(Frames)
  [D0 SpikeEncoded StimTrigger] = get_stream(file,Frames(i));
  id(1) = rem(idx(i),50000);
  id(2) = rem(idx(i+1),50001);  
  Data((idx(i)+1):(idx(i+1)),:) = (D0(Ch,:))';
  
 SpikeDecode(u_SpikeTimes,u_SpikeCounts,SpikeEncoded);
 
 [StimConfig StimEvents] = StimDecode(StimTrigger)   ;
 for j=1:size(StimConfig,2)
   if (nStim < 100)
       nStim = nStim + 1 ;
       StimTimes(nStim) = StimConfig(1,j)/50000 + Frames(i)- 1  ;
   end
 end
 
  Offset  = cumsum(u_SpikeCounts);
  Offset  = [1 ; (1  + Offset(1:end-1))];
  
  for j=1:numel(Ch)
      tt = u_SpikeTimes(Offset(Ch(j)):(Offset(Ch(j)) + u_SpikeCounts(Ch(j))-1)) ;
      tt = (tt/50000) + Frames(i)- 1 ;
      SpikeTimes((SpikeCount(j)+1):(SpikeCount(j)+u_SpikeCounts(Ch(j))),j) = tt ;
      SpikeCount(j)=SpikeCount(j) + u_SpikeCounts(Ch(j));
  end
  
  
end

x = max(SpikeCount);
SpikeTimes = SpikeTimes(1:x,:);
StimTimes = StimTimes(1:nStim);
end

