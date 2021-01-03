
function [Array P] = Stim_GenStimulusPattern(Id,InterElectrodeInterval)

InterPulseInterval =1000;
InterTrainInterval = 100;
nPulses= 1;
nTrains= 1; 

InterElectrodeInterval = InterElectrodeInterval*1000 ;%Convert to uS

P.nPatterns = 3  ;
P.SegmentId = Id ;

Array = uint32(zeros(3 + P.nPatterns*8,1)) ;

StimVoltage = 500 ;

%DAC 1 Pattern
[A Pi] = Stim_GenPulseTrain(StimVoltage,-StimVoltage,500,500,100, InterPulseInterval , InterTrainInterval , nPulses , nTrains);
Pid = 1 ;
Array(4+(Pid-1)*8:(4+Pid*8-1)) = A ;
P.P{Pid}  = Pi ;

%DAC 2 Pattern
[A Pi] = Stim_GenPulseTrain(StimVoltage,-StimVoltage,500,500,100+InterElectrodeInterval, InterPulseInterval , InterTrainInterval , nPulses , nTrains);
Pid = 2 ;
Array(4+(Pid-1)*8:(4+Pid*8-1)) = A ;
P.P{Pid}  = Pi ;

%DAC 3 Pattern
[A Pi] = Stim_GenPulseTrain(StimVoltage,-StimVoltage,500,500,100+2*InterElectrodeInterval, InterPulseInterval , InterTrainInterval , nPulses , nTrains);
Pid = 3 ;
Array(4+(Pid-1)*8:(4+Pid*8-1)) = A ;
P.P{Pid}  = Pi ;

Array(1) = combine_halfwords(4*numel(Array),Pi.Type) ;
Array(2) = P.SegmentId ;
Array(3) = P.nPatterns ;

end

