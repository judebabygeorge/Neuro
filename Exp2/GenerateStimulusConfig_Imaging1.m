function StimConfig = GenerateStimulusConfig_Imaging1(Electrodes)

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
 StimConfig.PatternInterval = 30000-47 ;
 StimConfig.PulseInterval   = 2    ;
 StimConfig.PulseInterval_x = 2    ; 
 

%P_Probe = [1 1 1 1 ; 2 2 2 2; 3 3 3 3; 4 4 4 4];
%P_Probe = [1 2 3 4 ; 3 4 1 2; 1 2 3 4; 3 4 1 2];
P_Probe = [1 2 ; 3 4 ; 1 2 ; 3 4 ];
%P_Probe = zeros(4,0);
p         = size(P_Probe,1);
r = size(P_Probe,2) + 1;

 StimConfig.Patterns = zeros(r,p);
 StimConfig.PatternDelay  = zeros(size(StimConfig.Patterns)); 
 
for j=1:p
    StimConfig.Patterns(:, j)   = [254 P_Probe(j,:)]'; 
end
 
 StimConfig.PatternDelay(:,:) = StimConfig.PulseInterval;
 StimConfig.PatternDelay(2,:) = 50;
 StimConfig.PatternDelay(1,:) = 1;
 

 nSeq     = floor(4*4/p) ;

 
 StimConfig.PatternSequence = zeros(1,p*nSeq) ;  
 for i=1:nSeq
     StimConfig.PatternSequence(((i-1)*p +1):i*p) = 1:1:p ;
 end
 
 
 StimConfig.r              = r    ;
 StimConfig.p              = p    ;
 StimConfig.nSeq           = nSeq ;
 StimConfig.DecodeWeights  = []   ;
 StimConfig.nLoop          = 1    ;
 
end

