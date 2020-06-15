function StimConfig = GenerateStimulusConfig_ContextDependenceCheck(PatternData)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time

StimConfig = PatternData.StimConfig;
maxPatterns = 127 ; 
 
 r = 2 ; 
  
 O = GetClassifiabilityOfTimedPairs(PatternData);

 
 p = 8+(4 + 8*4)*3;
  
 StimConfig.Patterns = zeros(r,p);
 StimConfig.PatternDelay  = zeros(size(StimConfig.Patterns)); 
 
 [~,I] =sort(O,'ascend');

 probe_pid = I(1);
 %probe_pid = [1 2 3 4 0 0] + (probe_pid-1)*4;
 %patt = PatternData.StimConfig.Patterns(:,id);
 I=I(2:end);
 
%  %Insert Probe Sequence in 3 contexts
%  for i=1:3
%      StimConfig.Patterns(:,((i-1)*36+33):i*36) = PatternData.StimConfig.Patterns(:,((probe_pid-1)*4+1):probe_pid*4);
%      StimConfig.PatternDelay(:,((i-1)*36+33):i*36)      = PatternData.StimConfig.PatternDelay(:,((probe_pid-1)*4+1):probe_pid*4); 
%  end
 %insert random context in first two
 for i=1:2
    I=I(randperm(numel(I)));
    context =I(1:9);
    I=I(10:end);
    id = repmat([1 2 3 4], [1 9]); 
    for ii=1:9
        id((ii-1)*4+1:ii*4) =  id((ii-1)*4+1:ii*4) + (context(ii)-1)*4;
    end
    id = id(randperm(numel(id)));
    id([9 18 27 36]) = [1 2 3 4] + (probe_pid-1)*4;
    StimConfig.Patterns(:,((i-1)*36+1):((i)*36))     = PatternData.StimConfig.Patterns(:,id);
    StimConfig.PatternDelay(:,((i-1)*36+1):((i)*36)) = PatternData.StimConfig.PatternDelay(:,id); 
 end
 
%insert repeated stim in third
id = repmat([1 2 3 4], [1 9])+(probe_pid-1)*4;
id = id(randperm(numel(id)));
id([9 18 27 36]) = [1 2 3 4] + (probe_pid-1)*4;
i=3;
StimConfig.Patterns(:,((i-1)*36+1):((i)*36))     = PatternData.StimConfig.Patterns(:,id);
StimConfig.PatternDelay(:,((i-1)*36+1):((i)*36)) = PatternData.StimConfig.PatternDelay(:,id); 
    
 % Single Electrode Stim 
 StimConfig.Patterns(:,p-8+1:p) = PatternData.StimConfig.Patterns(:,113:120);
 StimConfig.PatternDelay(:,p-8+1:p) = PatternData.StimConfig.PatternDelay(:,113:120);
 
 nSeq      = floor(maxPatterns/p) ;   
 StimConfig.PatternSequence = zeros(1,p*nSeq) ;  
 for i=1:nSeq
     StimConfig.PatternSequence(((i-1)*p +1):i*p) = 1:1:p;
 end
 
 StimConfig.r              = r    ;
 StimConfig.p              = p    ;
 StimConfig.nSeq           = nSeq ;
 StimConfig.DecodeWeights  = []   ;
 StimConfig.nLoop          = 1    ;
end
