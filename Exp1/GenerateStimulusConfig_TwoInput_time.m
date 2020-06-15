function StimConfig = GenerateStimulusConfig_TwoInput_time (Electrodes,max,PatternInterval,PulseInterval)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time

 maxPatterns = max ; 
 if(maxPatterns>127)
  maxPatterns = 127 ;
 end
 
 
 r = 2 ; 
 %number of electrode groups for check
 nG = floor(numel(Electrodes)/r); % 2 stim (Divide into groups of 2)
 Electrodes = reshape(Electrodes,[1 numel(Electrodes)]);
 StimConfig.Electrodes = Electrodes(1:(nG*r)) ;
 
 %Properties
 StimConfig.PatternInterval = PatternInterval ;
 StimConfig.PulseInterval   = PulseInterval   ;
 StimConfig.PulseInterval_x = [10 5 2]        ; 

    
 %Two sets of all sequences 
 n = numel(StimConfig.Electrodes);
 ElectrodeSets = reshape(randperm(n),[2,nG]);
 
 %Each electrode set would have 4 patterns
 
 %Total patterns = nG*4
 p = nG*6;
 StimConfig.Patterns = zeros(r,p);
 StimConfig.PatternDelay  = zeros(size(StimConfig.Patterns)); 
 
 
 D1 = 2*StimConfig.PulseInterval - StimConfig.PulseInterval_x ;
 D2 = StimConfig.PulseInterval_x;
 for i=1:nG
     
      E1 = ElectrodeSets(1,i);
      E2 = ElectrodeSets(2,i);
      StimConfig.Patterns(1,((i-1)*6+1):i*6) = [E1 E1 E1 E2 E2 E2] ;
      StimConfig.Patterns(2,((i-1)*6+1):i*6) = [E2 E2 E2 E1 E1 E1] ;
      
      StimConfig.PatternDelay(1,((i-1)*6+1):i*6) = [D1 D1];
      StimConfig.PatternDelay(2,((i-1)*6+1):i*6) = [D2 D2];
      
 end

 
 nSeq      = floor(maxPatterns/p) ;   
 StimConfig.PatternSequence = zeros(1,p*nSeq) ;  
 for i=1:nSeq
     StimConfig.PatternSequence(((i-1)*p +1):i*p) = randperm(p) ;
 end
 
 StimConfig.r              = r    ;
 StimConfig.p              = p    ;
 StimConfig.nSeq           = nSeq ;
 StimConfig.nLoop          = 1    ;
end

