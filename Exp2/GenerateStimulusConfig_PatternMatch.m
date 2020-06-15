function StimConfig = GenerateStimulusConfig_PatternMatch (Electrodes)

maxPatterns = 127 ;

ElectrodeSets = 1:1:8 ;
nElectrodeConfig = 8 + 8*7  ;
 
 E = zeros(2,nElectrodeConfig) ;
 
 E(1,1:8) = Electrodes(reshape(ElectrodeSets,[1 8]));
 
 O = gen_perm(8,2);
 
 
 for j=1:56
         E(1, 8  + j) = Electrodes(ElectrodeSets(O(j,1)));
         E(2, 8  + j) = Electrodes(ElectrodeSets(O(j,2)));
 end
 
 
 
 

  %Electrodes In should be 8
 StimConfig.Electrodes = E ;
 
 %Properties
 StimConfig.PatternInterval = 500 ;
 StimConfig.PulseInterval   = 2   ;
 StimConfig.PulseInterval_x = 2   ; 
 
 
 r = 7 ; 
 p = 10 + 10;
 
 StimConfig.Patterns = zeros(r,p);
 StimConfig.PatternDelay  = zeros(size(StimConfig.Patterns)); 

 P_Probe = [
              1 6 5 4 3 2 0 ; 
              2 3 0 0 0 0 0 ;
              1 2 7 5 4 0 0 ;
              1 2 7 3 4 0 0 ;
              6 7 2 3 0 0 0 ;
              1 6 7 3 4 0 0 ;
              6 5 3 7 0 0 0 ;
              1 2 3 0 0 0 0 ;
              1 6 7 3 4 5 2 ;
              7 6 1 2 3 4 0 ;
           ];
 P_Test = [
              0 0 0 0 0 0 0 ; 
              2 3 6 0 0 0 0 ;
              1 2 7 5 4 3 0 ;
              1 2 7 3 4 5 0 ;
              6 7 2 3 4 0 0 ;
              1 6 7 3 4 5 0 ;
              1 6 5 3 7 0 0 ;
              1 2 3 7 0 0 0 ;
              0 0 0 0 0 0 0 ;
              0 0 0 0 0 0 0 ;
           ];
 
       
 for j=1:10
         for k=1:7
             StimConfig.Patterns(k, (j-1)*2 + 1) = P_Probe(j,k);
             StimConfig.Patterns(k, (j-1)*2 + 2) = P_Test(j,k);
         end                 
 end
 
 StimConfig.PatternDelay(:,:) = StimConfig.PulseInterval;
 StimConfig.PatternDelay(1,:) = StimConfig.PatternInterval - sum(StimConfig.PatternDelay(2:end,:));
 
 %nSeq      = floor(maxPatterns/p) ;   
 nSeq      = 1 ;   
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