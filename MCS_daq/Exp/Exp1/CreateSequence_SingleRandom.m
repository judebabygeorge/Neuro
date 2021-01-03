function StimConfig = CreateSequence_SingleRandom(Electrodes,max,PatternInterval)
%CREATESEQUENCE Summary of this function goes here
%   Detailed explanation goes here

 maxPatterns = max ; 
 if(maxPatterns>127)
  maxPatterns = 127 ;
 end
 
%Create Configuration
 
 StimConfig.Electrodes = Electrodes ;
 
 %Properties
 StimConfig.PatternInterval = PatternInterval ;
 StimConfig.PulseInterval   = 0 ;
              
 
 p         = numel(Electrodes)    ;
 nSeq      = floor(maxPatterns/p) ;
            
 I        = randperm(p) ;
 StimConfig.Patterns = I    ;
 
 StimConfig.PatternSequence = zeros(p*nSeq,1) ;
 
 for i=1:nSeq
     StimConfig.PatternSequence(((i-1)*p +1):i*p) = randperm(p) ;
 end
 
 StimConfig.r             = 1;
 StimConfig.p             = p;
 StimConfig.nSeq          = nSeq; 
 StimConfig.nLoop         = 1   ;
 
 StimConfig.PatternDelay  = ones(size(StimConfig.Patterns))* StimConfig.PulseInterval;
end
