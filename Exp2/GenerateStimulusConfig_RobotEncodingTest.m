function StimConfig = GenerateStimulusConfig_RobotEncodingTest(PatternData)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time

StimConfig = PatternData.StimConfig;
maxPatterns = 127 ; 
 
 r = 2 ; 
  
 O = GetClassifiabilityOfTimedPairs(PatternData);
 
 nCombsToTest = 10;
 p =6*nCombsToTest;
  
 StimConfig.Patterns = zeros(r,p);
 StimConfig.PatternDelay  = zeros(size(StimConfig.Patterns)); 
 
 [~,I] =sort(O,'ascend');
 I(1:10)
 for i=1:nCombsToTest
    j =I(i);
    P = PatternData.StimConfig.Patterns(:,(j-1)*4+1:j*4);
    Pd= PatternData.StimConfig.PatternDelay(:,(j-1)*4+1:j*4);
    StimConfig.Patterns(:,(i-1)*6+1:i*6) =  [P(:,2) P(:,4) P(:,1) P(:,3) P(:,1) P(:,3)];
    StimConfig.PatternDelay(:,(i-1)*6+1:i*6) =  [Pd(:,2) Pd(:,4) [98 2]' [98 2]' Pd(:,1) Pd(:,3)];    
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
