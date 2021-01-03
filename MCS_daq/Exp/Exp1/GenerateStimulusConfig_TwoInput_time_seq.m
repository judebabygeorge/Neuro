function StimConfig = GenerateStimulusConfig_TwoInput_time_seq (Electrodes,max,PatternInterval,PulseInterval)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time

 maxPatterns = max ; 
 if(maxPatterns>127)
  maxPatterns = 127 ;
 end
 
 Electrodes = reshape(Electrodes,[1 numel(Electrodes)]);
  
 r = 2 ; 

  %Electrodes In should be 8
 StimConfig.Electrodes = Electrodes(1:8) ;
 
 %Properties
 StimConfig.PatternInterval = PatternInterval ;
 StimConfig.PulseInterval   = PulseInterval   ;
 StimConfig.PulseInterval_x = [10  2]         ; 

    
 %Two sets of all sequences 
 n = numel(StimConfig.Electrodes);

 ElectrodeSets = reshape(randperm(n),[2 4]);
 
 %1st row = probe electrodes 
 %2nd row = pre   electrodes
 
 %Iteration 1
 
 %Pair each pre with each post x 2delays
 %4X3X2
 

 p = 4*3*2 ;
 StimConfig.Patterns = zeros(r,p);
 StimConfig.PatternDelay  = zeros(size(StimConfig.Patterns)); 
 
 D1 = 2*StimConfig.PulseInterval - StimConfig.PulseInterval_x ;
 D2 = StimConfig.PulseInterval_x;
 for i=1:4
     Ep = randperm(4) ;
     for j=1:3
       for k = 1:2
         StimConfig.Patterns(1,(i-1)*6 + (j-1)*2 + k )= ElectrodeSets(1,Ep(j));
         StimConfig.Patterns(2,(i-1)*6 + (j-1)*2 + k )= ElectrodeSets(2,i); 
                    
         StimConfig.PatternDelay(1,(i-1)*6 + (j-1)*2 + k ) = D1(k);
         StimConfig.PatternDelay(2,(i-1)*6 + (j-1)*2 + k ) = D2(k);      
       end
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

