function StimConfig = GenerateStimulusConfig_Selected(StimConfig,SelectedPatterns)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time

 maxPatterns = 127 ; 
 
 p = numel(SelectedPatterns);
 StimConfig.Patterns =StimConfig.Patterns(:,SelectedPatterns);
 StimConfig.PatternDelay  =StimConfig.PatternDelay (:,SelectedPatterns) ;
 

 nSeq      = floor(maxPatterns/p) ;   
 StimConfig.PatternSequence = zeros(1,p*nSeq) ;  
 for i=1:nSeq
     StimConfig.PatternSequence(((i-1)*p +1):i*p) = randperm(p) ;
 end 
 
 StimConfig.p              = p    ;
 StimConfig.nSeq           = nSeq ;
 StimConfig.nLoop          = 1    ;
end

