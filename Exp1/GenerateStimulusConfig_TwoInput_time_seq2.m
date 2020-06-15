function StimConfig = GenerateStimulusConfig_TwoInput_time_seq2 (Electrodes,max,PatternInterval,PulseInterval)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time

 maxPatterns = max ; 
 if(maxPatterns>127)
  maxPatterns = 127 ;
 end
 
 Electrodes = reshape(Electrodes,[1 numel(Electrodes)]);
 
 %ElectrodeSets = reshape(randperm(8),[2 4]);
 ElectrodeSets = reshape(1:1:8,[2 4]);
 
 nElectrodeConfig = 8 + 4*3 ;
 
 E = zeros(2,nElectrodeConfig) ;
 
 E(1,1:8) = Electrodes(reshape(ElectrodeSets,[1 8]));
 
 PreSel = zeros(4,3);
 for i=1:size(PreSel,1)
   x = randperm(4);
   PreSel(i,:) =  x(1:3);
 end
 for i=1:4
     for j=1:3
         E(1,8 + (i-1)*3 + j) = Electrodes(ElectrodeSets(1,PreSel(i,j)));
         E(2,8 + (i-1)*3 + j) = Electrodes(ElectrodeSets(2,i));         
     end
 end
 
 
 
 r = 2 ; 

  %Electrodes In should be 8
 StimConfig.Electrodes = E ;
 
 %Properties
 StimConfig.PatternInterval = PatternInterval ;
 StimConfig.PulseInterval   = PulseInterval   ;
 StimConfig.PulseInterval_x = [10  3]         ; 

    
 %Two sets of all sequences 
 n = numel(StimConfig.Electrodes);

 
 
 %1st row = probe electrodes 
 %2nd row = pre   electrodes
 
 %Iteration 1
 
 %Pair each pre with each post x 2delays
 %4X3X2
 

 p = 4*3*3 ;
 StimConfig.Patterns = zeros(r,p);
 StimConfig.PatternDelay  = zeros(size(StimConfig.Patterns)); 
 
 D1 = 2*StimConfig.PulseInterval - StimConfig.PulseInterval_x ;
 D2 = StimConfig.PulseInterval_x;
 for i=1:4    
     for j=1:3
       for k = 1:2
         StimConfig.Patterns(1,(i-1)*9 + (j-1)*3 + k )= ElectrodeSets(1,PreSel(i,j));
         StimConfig.Patterns(2,(i-1)*9 + (j-1)*3 + k )= ElectrodeSets(2,i); 
                    
         StimConfig.PatternDelay(1,(i-1)*9 + (j-1)*3 + k ) = D1(k);
         StimConfig.PatternDelay(2,(i-1)*9 + (j-1)*3 + k ) = D2(k);      
       end
       
         StimConfig.Patterns(1,(i-1)*9 + (j-1)*3 + 3 )= 8 + (i-1)*3 + j;
         StimConfig.Patterns(2,(i-1)*9 + (j-1)*3 + 3 )= 0; %Null Config
                    
         StimConfig.PatternDelay(1,(i-1)*9 + (j-1)*3 + 3 ) = D1(k);
         StimConfig.PatternDelay(2,(i-1)*9 + (j-1)*3 + 3 ) = D2(k);    
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

