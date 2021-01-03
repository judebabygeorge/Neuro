function StimConfig = GenerateStimulusConfig_test (Electrodes,p,r,max,PatternInterval,PulseInterval)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time

 maxPatterns = max ; 
 if(maxPatterns>127)
  maxPatterns = 127 ;
 end
 
  
 StimConfig.Electrodes = [59 41 81; 3 21 101] ;
 
 %Properties
 StimConfig.PatternInterval = PatternInterval ;
 StimConfig.PulseInterval   = PulseInterval ;
 
   
 nSeq      = floor(maxPatterns/p) ;
  

 StimConfig.Patterns = [1 2 3];
  
 StimConfig.PatternSequence = [1 2 3] ; 
 
 r = 1;
 p = 3;
 
 StimConfig.r              = r    ;
 StimConfig.p              = p    ;
 StimConfig.nSeq           = nSeq ;
 StimConfig.nLoop          = 1    ;
 
 StimConfig.PatternDelay  = ones(size(StimConfig.Patterns))* StimConfig.PulseInterval;
end