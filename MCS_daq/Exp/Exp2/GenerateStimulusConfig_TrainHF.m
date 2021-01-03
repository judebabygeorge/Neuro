function StimConfig = GenerateStimulusConfig_TrainHF(Electrodes,max,nPulses,PatternInterval,PulseInterval)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time

 maxPatterns = max ; 
 if(maxPatterns>127)
  maxPatterns = 127 ;
 end
 
 %Electrodes = StimConfig_Probe.Electrodes;

  %Electrodes In should be 8
 Electrodes = reshape(Electrodes,[1 numel(Electrodes)]);
 StimConfig.Electrodes = Electrodes ;
 
 %Properties
 StimConfig.PatternInterval = PatternInterval ;
 StimConfig.PulseInterval   = PulseInterval   ;

 r = nPulses ; 
 p = numel(Electrodes) ;
 StimConfig.Patterns = zeros(r,p);
 StimConfig.PatternDelay  = zeros(size(StimConfig.Patterns)); 
 
  
for i=1:p
     x = i*ones(r,1);
     StimConfig.Patterns(:,i) = x ;
     StimConfig.PatternDelay(:,i) = StimConfig.PulseInterval ;
end

 patterns_to_train = input('Enter Patterns to Train  : ' );
 p = numel(patterns_to_train);
 patterns_to_train = reshape(patterns_to_train,[1 p]);
 
 
 nSeq      = floor(maxPatterns/p) ;   
 StimConfig.PatternSequence = zeros(1,p*nSeq) ;  
 for i=1:nSeq
     StimConfig.PatternSequence(((i-1)*p +1):i*p) = patterns_to_train(randperm(p)) ;
 end
 
 StimConfig.r              = r    ;
 StimConfig.p              = p   ;
 StimConfig.nSeq           = nSeq ;
 StimConfig.nLoop          = 1    ;
 StimConfig.DecodeWeights  = []   ;
 StimConfig.PatternId      = []   ;
end

