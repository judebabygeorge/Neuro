function StimConfig = GenerateStimulusConfig_TwoInput_time_seq3 (Electrodes,max,PatternInterval,PulseInterval)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time

 maxPatterns = max ; 
 if(maxPatterns>127)
  maxPatterns = 127 ;
 end
 
 Electrodes = reshape(Electrodes,[1 numel(Electrodes)]);
 
 %ElectrodeSets = reshape(randperm(8),[2 4]);
 ElectrodeSets = reshape(1:1:8,[2 4]);
 
 nElectrodeConfig = 8 + 12*2  ;
 
 E = zeros(2,nElectrodeConfig) ;
 
 E(1,1:8) = Electrodes(reshape(ElectrodeSets,[1 8]));
 
 O = gen_perm(4,2);
 
 for i=1:2
     for j=1:12
         E(1, 8 + (i-1)*12 + j) = Electrodes(ElectrodeSets(i,O(j,1)));
         E(2, 8 + (i-1)*12 + j) = Electrodes(ElectrodeSets(i,O(j,2)));
     end
 end
 
 
 
 r = 2 ; 

  %Electrodes In should be 8
 StimConfig.Electrodes = E ;
 
 %Properties
 StimConfig.PatternInterval = PatternInterval ;
 StimConfig.PulseInterval   = PulseInterval   ;
 StimConfig.PulseInterval_x = 10              ; 

    
 p = 2*12*2 ;
 StimConfig.Patterns = zeros(r,p);
 StimConfig.PatternDelay  = zeros(size(StimConfig.Patterns)); 
 
 D1 = 2*StimConfig.PulseInterval - StimConfig.PulseInterval_x ;
 D2 = StimConfig.PulseInterval_x;
 
 for i=1:2
     for j=1:12
         StimConfig.Patterns(1, (i-1)*24 + (j-1)*2 + 1) = ElectrodeSets(i,O(j,1));
         StimConfig.Patterns(2, (i-1)*24 + (j-1)*2 + 1) = ElectrodeSets(i,O(j,2));
         StimConfig.PatternDelay(1, (i-1)*24 + (j-1)*2 + 1) = D1(1);
         StimConfig.PatternDelay(2, (i-1)*24 + (j-1)*2 + 1) = D2(1);
         
         StimConfig.Patterns(1, (i-1)*24 + (j-1)*2 + 2) = 8 + (i-1)*12 + j;
         StimConfig.Patterns(2, (i-1)*24 + (j-1)*2 + 2) = 0;
         StimConfig.PatternDelay(1, (i-1)*24 + (j-1)*2 + 2) = StimConfig.PulseInterval;
         StimConfig.PatternDelay(2, (i-1)*24 + (j-1)*2 + 2) = StimConfig.PulseInterval;
     end
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

