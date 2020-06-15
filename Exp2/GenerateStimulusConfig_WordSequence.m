function StimConfig = GenerateStimulusConfig_WordSequence(Electrodes)

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
 
%AFG 167
%BEH 258
%CDF 346

 nC=4;
 nW=1;
 r = nC  ; 
 p = 3+3*nW;
 
 StimConfig.Patterns = zeros(r,p);
 StimConfig.PatternDelay  = zeros(size(StimConfig.Patterns)); 

% P_Probe = [1 6 7; 2 5 8; 3 4 6];
P_Probe = [1 2 7 8; 3 4 6 8; 2 3 5 6];
 P_Probe
 
 P_Test = repmat(P_Probe,[1 1]);
 P_Test = P_Test(:,[1 2 4 3]);
 
 for j=1:size(P_Probe,1)
         StimConfig.Patterns(:, (j-1)*2 + 1)   = P_Probe(j,:)';
         StimConfig.Patterns(:, (j-1)*2 + 2)   = P_Test (j,:)';
%          for k=1:size(P_Probe,2)
%              StimConfig.Patterns(k, (j-1)*5 + 1) = P_Probe(j,k);
%              StimConfig.Patterns(k, (j-1)*5 + 2) = P_Test(j,k);
%          end   
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

