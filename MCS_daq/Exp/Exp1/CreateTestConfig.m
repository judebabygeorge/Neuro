function Config = CreateTestConfig

Electrodes = [37;38;39;40;48;60;62;78;82;83;84;85;]' ;

 
 Config.Electrodes = Electrodes ;
 
 %Properties
 Config.PatternInterval = 1000 ;
 Config.PulseInterval   = 100  ;
 Config.nLoop           = 1    ;
 
 p         = numel(Electrodes)    ;
 nSeq      = 1 ;
            
 I        = 1:1:p       ;
 Config.Patterns = I    ;
 
 Config.PatternSequence = zeros(p*nSeq,1) ;
 
 for i=1:nSeq
     Config.PatternSequence(((i-1)*p +1):i*p) = 1:1:p ;
 end
 
 
 
end