function [Array P ] = Stim_GenPulseTrain(Up,Un,Tp,Tn,StartDelay , InterPulseDelay , InterTrainDelay , nPulses , nTrains)
%STIM_GENPULSETRAIN Summary of this function goes here
%   Un,Up in mV Tn Tp in uS

P.Type = 1  ;
P.Un = Un ;
P.Up = Up ;
P.Tn = Tn ;
P.Tp = Tp ;

P.StartDelay = StartDelay ;
P.InterPulseDelay = InterPulseDelay ;
P.InterTrainDelay = InterTrainDelay ;
P.nPulses = nPulses ;
P.nTrains = nTrains ;

Array = uint32(zeros(8,1)) ;


VoltageScale = 0.571 ; %mV per unit
TimeScale    = 20    ; %uS per unit

len      = 4*numel(Array);
Array(1) = combine_halfwords(len,P.Type) ;

% A = uint16(zeros(8,1)) ;
% for i=1:numel(ElectrodeList)
%     El = ElectrodeList(i) ;
%     i1 = ceil(El/15) ;
%     i2 = rem(El,15)-1 ; 
%     A(i1) = A(i1) + uint16(2^(i2)) ;
% end
% 
% A = typecast(A,'uint32') ;
% 
% Array(2:5) = A ;

Up = floor(Up/VoltageScale) ;
Un = floor(Un/VoltageScale) ;
Tp = floor(Tp/TimeScale);
Tn = floor(Tn/TimeScale);
StartDelay = floor(StartDelay/TimeScale);
InterPulseDelay = floor(InterPulseDelay/TimeScale);
InterTrainDelay = floor(InterTrainDelay/TimeScale);

Array(2) = combine_halfwords(Up,Un) ;
Array(3) = Tp ;
Array(4) = Tn ;

Array(5) = StartDelay;
Array(6) = InterPulseDelay;
Array(7) = InterTrainDelay;
Array(8) = combine_halfwords(nPulses,nTrains) ;
end

