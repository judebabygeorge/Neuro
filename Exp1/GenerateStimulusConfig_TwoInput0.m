function StimConfig = GenerateStimulusConfig_TwoInput (Electrodes,max,PatternInterval,PulseInterval)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time

 maxPatterns = max ; 
 if(maxPatterns>127)
  maxPatterns = 127 ;
 end
 
 
 %number of electrode groups for check
 nG = floor(numel(Electrodes)/3); % 2 stim + 1 probe 
 Electrodes = reshape(Electrodes,[1 numel(Electrodes)]);
 StimConfig.Electrodes = Electrodes(1:(nG*3)) ;
 
 %Properties
 StimConfig.PatternInterval = PatternInterval ;
 StimConfig.PulseInterval   = PulseInterval   ;
 StimConfig.PulseInterval_2 = 10              ; 
    
 %Two sets of all sequences 
 n = numel(StimConfig.Electrodes);
 ElectrodeSets = reshape(randperm(n),[3,nG]);
 
 %Each electrode set would have 4 patterns
 
 %Total patterns = nG*4
 r = 3 ;
 p = nG*4;
 StimConfig.Patterns = zeros(r,p);
 StimConfig.PatternDelay  = zeros(size(StimConfig.Patterns)); 
 
 for i=1:nG
     %Stim Electrode 1
     StimConfig.Patterns(1,((i-1)*4+1):i*4) = [ElectrodeSets(1,i) ElectrodeSets(1,i) ElectrodeSets(2,i) ElectrodeSets(2,i)];
     StimConfig.PatternDelay(1,((i-1)*4+1):i*4) = [StimConfig.PulseInterval (2*StimConfig.PulseInterval - StimConfig.PulseInterval_2)  StimConfig.PulseInterval (2*StimConfig.PulseInterval - StimConfig.PulseInterval_2)];
     %Stim Electrode 2
     StimConfig.Patterns(2,((i-1)*4+1):i*4) = [ElectrodeSets(2,i) ElectrodeSets(2,i) ElectrodeSets(1,i) ElectrodeSets(1,i)];
     StimConfig.PatternDelay(2,((i-1)*4+1):i*4) = [StimConfig.PulseInterval (StimConfig.PulseInterval_2)  StimConfig.PulseInterval (StimConfig.PulseInterval_2)];
     
     %Probe Electrode
     StimConfig.Patterns(3,((i-1)*4+1):i*4) = ones(1,4)*ElectrodeSets(3,i) ;
     StimConfig.PatternDelay(3,((i-1)*4+1):i*4) = ones(1,4)*StimConfig.PulseInterval ;
     
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

