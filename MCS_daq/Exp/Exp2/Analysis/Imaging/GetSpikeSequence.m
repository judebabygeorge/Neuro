function [SpikeTimes SpikeData]= GetSpikeSequence( PatternData , Electrode )
%GETSPIKESEQUENCE Summary of this function goes here
%   Detailed explanation goes here


load ChannelMap
E = GetElectrodeNumber(Electrode,ChannelMapping);

nSpikes = 0;
for i=1:numel(PatternData.Pattern)
       nSpikes = nSpikes + PatternData.Pattern{i}.SpikeCounts(E);
end

SpikeTimes = zeros(nSpikes,1);
SpikeData  = zeros(101,nSpikes);
id=0;
for i=1:numel(PatternData.Pattern)
    n = (1 + sum(PatternData.Pattern{i}.SpikeCounts(1:(E-1)))):sum(PatternData.Pattern{i}.SpikeCounts(1:(E)));
    SpikeTimes((id+1):(id+numel(n)))=(i-1) + PatternData.Pattern{i}.SpikeTimes(n)/50000;
    SpikeData(:,(id+1):(id+numel(n)))= PatternData.Pattern{i}.SpikeData(:,n);
    id = id + numel(n);
end

end

