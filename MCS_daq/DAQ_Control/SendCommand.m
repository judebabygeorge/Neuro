function SendCommand(SYS,CommandId,Data)
    assert((numel(Data)<=1022),'Cannot Send Commands > 1022')
    
        Data = uint32(Data);
        
        addr = hex2dec('1004');
        SYS.WriteRegister(addr,numel(Data)); 
        
        for i=1:numel(Data)
           addr = addr+4;
           SYS.WriteRegister(addr,Data(i))  ;
        end
        SYS.WriteRegister(hex2dec('1000'),CommandId) ;
   
        pause(0.02)
end


