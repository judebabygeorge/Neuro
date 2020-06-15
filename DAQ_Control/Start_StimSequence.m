function Start_StimSequence(SYS,Offset, nElements , nLoop , nJumpBack ,Triggers , StartTime)
    Array = zeros(6,1);
    Array(1) = Offset ;
    Array(2) = nElements ;
    Array(3) = nLoop ;
    Array(4) = nJumpBack ;
    Array(5) = Triggers ;
    Array(6) = StartTime;
    SendCommand(SYS,8,Array) ;
end