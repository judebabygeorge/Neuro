
function Start_StimPatternSequence(DS,Start, End , nLoop , Triggers , StartTime)
    Array = zeros(5,1);
    Array(1) = Start ;
    Array(2) = End  ;
    Array(3) = nLoop ;
    Array(4) = Triggers ;
    Array(5) = StartTime;
    SendCommand(DS,12,Array) ;
end