

fr = create_datastream('C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\G19042013A\DIV40\data_PatternCheck_8_250_ndim_all.dat');

SpikeTimes = zeros(10000,1) ;
SpikeCounts = zeros(120,1)  ;

StimPattern = 3 ;

figure;hold on;
E = I(1:5);
Es = 1;
[b,a]=ellip(2,0.1,40,[300 3000]*2/50e3);
for i=1:size(PatternData.FrameNumber,3)
     Ei = E(Es);
     [Data,SpikeEncoded,StimTrigger] = get_stream(fr,PatternData.FrameNumber(1,StimPattern,i));
     %Data = filter(b,a,Data')';
     Data = CubicFitFilter(Data')';
     [StimConfig StimEvents] = StimDecode(StimTrigger) ;
     SpikeDecode(SpikeTimes,SpikeCounts,SpikeEncoded);  
     MarkTime = PatternData.MarkTime(1,StimPattern,i);
     t = MarkTime:1:(MarkTime + 5000);
     plot(1:numel(t),Data(Ei,t(1):t(end))+200*i);
     
%      window  = 200e-3*50000;
%      offset = cumsum(SpikeCounts) ;
%      offset = [1 ; (1 + offset(1:end-1))];
%      times = SpikeTimes(offset(Ei):(offset(Ei)+SpikeCounts(Ei)-1));
%      times = times((times > MarkTime)&(times < (MarkTime + window) ));
%      times = times - MarkTime;
%      times = times(times > 5*50);
%      times = times(times < 5000);
     times = PatternData.Pattern(Ei,StimPattern,i);
     scatter(times , ones(size(times))*(200*i + 100), 10,'filled','r');
end    