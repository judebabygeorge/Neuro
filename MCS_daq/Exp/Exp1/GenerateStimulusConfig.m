function StimConfig = GenerateStimulusConfig (Electrodes,p,r,max,PatternInterval,PulseInterval)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time

 maxPatterns = max ; 
 if(maxPatterns>127)
  maxPatterns = 127 ;
 end
 
 Electrodes = reshape(Electrodes,[1 numel(Electrodes)]);
 StimConfig.Electrodes = Electrodes ;
 
 %Properties
 StimConfig.PatternInterval = PatternInterval ;
 StimConfig.PulseInterval   = PulseInterval ;
 
   
 nSeq      = floor(maxPatterns/p) ;
  
 n = numel(Electrodes);
 I = zeros(n,ceil((r*p)/n));
 for i=1:size(I,2)
      I(:,i) = randperm(n)' ;
 end
 I = reshape(I,[numel(I) 1]);
 I = I(1:(r*p));
 StimConfig.Patterns = reshape(I,r,p);
  
 StimConfig.PatternSequence = zeros(1,p*nSeq) ; 
 
 for i=1:nSeq
     StimConfig.PatternSequence(((i-1)*p +1):i*p) = randperm(p) ;
 end
 
 StimConfig.r              = r    ;
 StimConfig.p              = p    ;
 StimConfig.nSeq           = nSeq ;
 StimConfig.nLoop          = 1    ;
 
 StimConfig.PatternDelay  = ones(size(StimConfig.Patterns))* StimConfig.PulseInterval;
end