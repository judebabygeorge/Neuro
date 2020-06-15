function StimConfig = GenerateStimulusConfig_AllSequence (Electrodes,s,r,max,PatternInterval,PulseInterval)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time

 maxPatterns = max ; 
 if(maxPatterns>127)
  maxPatterns = 127 ;
 end
 
 assert(rem(numel(Electrodes),s)==0,'Number of electrodes must be a multiple of number of sets');
 
 Electrodes = reshape(Electrodes,[1 numel(Electrodes)]);
 StimConfig.Electrodes = Electrodes ;
 
 %Properties
 StimConfig.PatternInterval = PatternInterval ;
 StimConfig.PulseInterval   = PulseInterval ;
 
   

 
 %Two sets of all sequences 
 n = numel(Electrodes);
 ElectrodeSets = reshape(randperm(n),[s,n/s]);
 
 n2=  n/s ;
 
 %Generate all permutations taking 
 np =  (factorial(n2)/factorial(n2-r));
 p = s*np;
 StimConfig.Patterns = zeros(r,p);
 
 O = gen_perm(n2,r);
 
 for i=1:s
     for j=1:np
       StimConfig.Patterns(:,(i-1)*np+j) = ElectrodeSets(i,O(j,:))';     
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
 StimConfig.PatternDelay  = ones(size(StimConfig.Patterns))* StimConfig.PulseInterval;
end


