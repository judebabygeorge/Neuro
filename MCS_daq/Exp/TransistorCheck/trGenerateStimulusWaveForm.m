function Array = trGenerateStimulusWaveForm(StimParams,SegmentID)

Array = zeros(1022,1);

Array(1)=   0        ;%Number of bytes and type %Filled Later
Array(2)=   SegmentID;
Array(3)=   numel(StimParams.SignalConfig)        ;%NumberofPatterns

ArrayLen = 3;

for i=1:numel(StimParams.SignalConfig)
    C = StimParams.SignalConfig{i};
    switch C.Type
        case 'Pulse'
            A = trGenerateStimulusWaveForm_Pulse(C);
            Array(ArrayLen+1:ArrayLen+numel(A)) = A;
            ArrayLen=ArrayLen+numel(A);
    end
end

Array = Array(1:ArrayLen);
Array(1) = combine_halfwords(4*numel(Array),1) ;
numel(Array)
end

function Array = trGenerateStimulusWaveForm_Pulse(Config)

    Array = uint32(zeros(8,1)) ;

    VoltageScale = 0.571 ; %mV per unit
    TimeScale    = 20/1000; %20uS per unit (input in ms)
    len      = 4*numel(Array);
    Array(1) = combine_halfwords(len,1) ;
    typecast(Array(1),'uint8')
    Up = floor(Config.Up/VoltageScale) ; 
    Un = floor(Config.Un/VoltageScale) ;
    
    Tp = floor(Config.Tp/TimeScale);
    Tn = floor(Config.Tn/TimeScale);
    StartDelay = floor(Config.StartDelay/TimeScale);
    InterPulseDelay = floor(Config.InterPulseDelay/TimeScale);
    InterTrainDelay = floor(Config.InterTrainDelay/TimeScale);

    Array(2) = combine_halfwords(Up,Un) ;

    Array(3) = Tp ;
    Array(4) = Tn ;

    Array(5) = StartDelay;
    Array(6) = InterPulseDelay;
    Array(7) = InterTrainDelay;
    Array(8) = combine_halfwords(Config.nPulses,Config.nTrains) ;

end


