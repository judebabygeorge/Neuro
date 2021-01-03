function StimConfig = GenerateStimulusConfig_Random8 (Electrodes,max,PatternInterval,PulseInterval)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time

 maxPatterns = max ; 
 if(maxPatterns>127)
  maxPatterns = 127 ;
 end
 
 Electrodes = reshape(Electrodes,[1 numel(Electrodes)]);
 Electrodes = Electrodes(1:8);

 

  %Electrodes In should be 8
 StimConfig.Electrodes = Electrodes ;
 
 %Properties
 StimConfig.PatternInterval = PatternInterval ;
 StimConfig.PulseInterval   = PulseInterval   ;

 r = 8 ; 
 p = 40 ;
 StimConfig.Patterns = zeros(r,p);
 StimConfig.PatternDelay  = zeros(size(StimConfig.Patterns)); 
 
 
 
for j=1:p/2
     x = randperm(8)';
     StimConfig.Patterns(:,2*j-1) = x ;
     StimConfig.Patterns(:,2*j  ) = x(end:-1:1) ;
     StimConfig.PatternDelay(:,2*j-1) = StimConfig.PulseInterval ;
     StimConfig.PatternDelay(:,2*j  ) = StimConfig.PulseInterval ;
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
