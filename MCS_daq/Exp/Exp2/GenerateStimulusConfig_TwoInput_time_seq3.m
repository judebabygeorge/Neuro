function StimConfig = GenerateStimulusConfig_TwoInput_time_seq3 (Electrodes,max,PatternInterval,PulseInterval)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time

display('Generating GenerateStimulusConfig_TwoInput_time_seq3'); 
 maxPatterns = max ; 
 if(maxPatterns>127)
  maxPatterns = 127 ;
 end
 
 Electrodes = reshape(Electrodes,[1 numel(Electrodes)]);
 
 %ElectrodeSets = reshape(randperm(8),[2 4]);
 %ElectrodeSets = reshape(1:1:8,[2 4]);
 ElectrodeSets = 1:1:8 ;
 
 nElectrodeConfig = 8 + 8*7  ;
 
 E = zeros(2,nElectrodeConfig) ;
 
 E(1,1:8) = Electrodes(reshape(ElectrodeSets,[1 8]));
 
 O = gen_perm(8,2);
 
 
 for j=1:56
         E(1, 8  + j) = Electrodes(ElectrodeSets(O(j,1)));
         E(2, 8  + j) = Electrodes(ElectrodeSets(O(j,2)));
 end
 
 
 
 
 r = 2 ; 

  %Electrodes In should be 8
 StimConfig.Electrodes = E ;
 
 %Properties
 StimConfig.PatternInterval = PatternInterval ;
 StimConfig.PulseInterval   = PulseInterval   ;
 StimConfig.PulseInterval_x = 3               ; 

    
 %p = 8*7*2 + 8 ;
 p = 8*7 + 8 ;
 StimConfig.Patterns = zeros(r,p);
 StimConfig.PatternDelay  = zeros(size(StimConfig.Patterns)); 
 
 D1 = 2*StimConfig.PulseInterval - StimConfig.PulseInterval_x ;
 D2 = StimConfig.PulseInterval_x;
 
 
for j=1:56
%          StimConfig.Patterns(1, (j-1)*2 + 1) = ElectrodeSets(O(j,1));
%          StimConfig.Patterns(2, (j-1)*2 + 1) = ElectrodeSets(O(j,2));
%          
%          StimConfig.PatternDelay(1, (j-1)*2 + 1) = D1(1);
%          StimConfig.PatternDelay(2, (j-1)*2 + 1) = D2(1);
%          
%          StimConfig.Patterns(1, (j-1)*2 + 2) = 8 + j;
%          StimConfig.Patterns(2, (j-1)*2 + 2) = 0;
%          StimConfig.PatternDelay(1, (j-1)*2 + 2) = StimConfig.PulseInterval;
%          StimConfig.PatternDelay(2, (j-1)*2 + 2) = StimConfig.PulseInterval;
         
         StimConfig.Patterns(1, j) = 8 + j;
         StimConfig.Patterns(2, j) = 0;
         StimConfig.PatternDelay(1, j) = StimConfig.PulseInterval;
         StimConfig.PatternDelay(2, j) = StimConfig.PulseInterval;
end
for j=(p-8+1):p
     StimConfig.Patterns(1, j) = j - (p-8);
     StimConfig.Patterns(2, j) = 0;
     StimConfig.PatternDelay(1, j) = StimConfig.PulseInterval;
     StimConfig.PatternDelay(2, j) = StimConfig.PulseInterval;
end
 
 nSeq      = floor(maxPatterns/p) ;   
 StimConfig.PatternSequence = zeros(1,p*nSeq) ;  
 for i=1:nSeq
     StimConfig.PatternSequence(((i-1)*p +1):i*p) = randperm(p) ;
 end
 
 
 StimConfig.r              = r    ;
 StimConfig.p              = p    ;
 StimConfig.nSeq           = nSeq ;
 StimConfig.DecodeWeights  = []   ;
 StimConfig.nLoop          = 1    ;
end

