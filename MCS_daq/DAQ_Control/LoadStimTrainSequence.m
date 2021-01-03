function LoadStimTrainSequence(DS,StimTrain)
    nElements = size(StimTrain.Elements,1);
    A = uint32(zeros(2 + nElements*2,1));
    i=1;
    
    A(i) = StimTrain.nSequenceRepeat; i = i+1;  
    A(i) = nElements ; i = i+1;  
    
    for j=1:nElements
        A(i) =  typecast(uint16(StimTrain.Elements(j,1:2)),'uint32') ; i= i+1;
        A(i) =  typecast(uint8(StimTrain.Elements(j,3:6)),'uint32') ; i= i+1;
    end
    
    SendCommand(DS,18,A)    ;
end