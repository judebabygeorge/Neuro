function StimConfig = GenerateStimulusConfig_Interleaved (ElectrodeSet1,ElectrodeSet2,q,max,PatternInterval,PulseInterval)

 %Electrode Set 1 : Once in every q sets
 

 maxPatterns = max ; 
 if(maxPatterns>127)
  maxPatterns = 127 ;
 end
 
 Electrodes = [ElectrodeSet1 ; ElectrodeSet2];
 Electrodes = reshape(Electrodes,[1 numel(Electrodes)]);
 StimConfig.Electrodes = Electrodes ;
 
 %Properties
 StimConfig.PatternInterval = PatternInterval ;
 StimConfig.PulseInterval   = PulseInterval ;
 
   
 r = 1 ;
 p = q*numel(ElectrodeSet1);
 
 StimConfig.Patterns = zeros(1,p) ;
 
 x = randperm(numel(ElectrodeSet1));
 for i=1:numel(ElectrodeSet1)
    StimConfig.Patterns(1 + (i-1)*q) =  x(i) ;
    y = randperm(numel(ElectrodeSet2));
    StimConfig.Patterns((2 + (i-1)*q):i*q) = y(1:q-1) + numel(ElectrodeSet1);
 end
 
 nSeq      = floor(maxPatterns/p) ;
   
 StimConfig.PatternSequence = zeros(1,p*nSeq) ; 
 
 x = 1:1:p ;
 x = reshape(x,[numel(ElectrodeSet1) q]);
 
 for i=1:nSeq
     y = randperm(numel(ElectrodeSet1)) ;
     z = x(y,:);
     y = randperm(q);
     z = z(:,y);
     StimConfig.PatternSequence(((i-1)*p +1):i*p) =  reshape(z,[1 p]) ;
 end
 
 StimConfig.r              = r    ;
 StimConfig.p              = p    ;
 StimConfig.nSeq           = nSeq ;
 StimConfig.nLoop          = 1    ;
 
 StimConfig.PatternDelay  = ones(size(StimConfig.Patterns))* StimConfig.PulseInterval;
end

