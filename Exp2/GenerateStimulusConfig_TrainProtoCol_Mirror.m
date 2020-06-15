function [StimConfigProbe,StimConfigTrain] = GenerateStimulusConfig_TrainProtoCol_Mirror(path)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time

a = load(sprintf('%s/data_PatternCheck_2_250_two_time_seq4_1.mat',path));
PatternData = a.PatternData;


StimConfigProbe = PatternData.StimConfig;
StimConfigTrain = PatternData.StimConfig;

maxPatterns = 127 ; 



probe_patterns = [113:120 15 43 67 87] ;%(EA FB GC HD)
train_patterns = [probe_patterns([9 11])];

x = 1:1:120;
x(probe_patterns)=[];
x = x(randperm(numel(x)));
probe_patterns = [probe_patterns x(1:8)];
x = randperm(numel(probe_patterns));
StimConfigProbe.PatternDetails.probe_patterns=x;
probe_patterns=probe_patterns(x);



StimConfigProbe.Patterns = PatternData.StimConfig.Patterns(:,probe_patterns);
StimConfigProbe.PatternDelay = PatternData.StimConfig.PatternDelay(:,probe_patterns);

p = numel(probe_patterns);
nSeq      = floor(maxPatterns/p) ;   
StimConfigProbe.PatternSequence = zeros(1,p*nSeq) ;  
for i=1:nSeq
 StimConfigProbe.PatternSequence(((i-1)*p +1):i*p) = 1:1:p ;
end
d = sum(StimConfigProbe.PatternDelay);
StimConfigProbe.PatternDelay(1,:) = StimConfigProbe.PatternDelay(1,:) - (d-250);
 

StimConfigProbe.p              = p    ;
StimConfigProbe.nSeq           = nSeq ;
StimConfigProbe.nLoop          = 1    ;

nPulses=3;
PulseDelay=5;
x= repmat(PatternData.StimConfig.Patterns(:,train_patterns),[nPulses 1]);
StimConfigTrain.Patterns  = x;
       
y = PatternData.StimConfig.PatternDelay(:,train_patterns);
for i=size(y,2)
    if(x(2,i)==0)
       y(2,i) = 0;
    end
end
y = repmat(y,[nPulses 1]);
y(3:2:end) = PulseDelay;
StimConfigTrain.PatternDelay = y;
       
       
% StimConfigTrain.Patterns = PatternData.StimConfig.Patterns(:,train_patterns);
% StimConfigTrain.PatternDelay = PatternData.StimConfig.PatternDelay(:,train_patterns);

d = sum(StimConfigTrain.PatternDelay);
StimConfigTrain.PatternDelay(1,:) = StimConfigTrain.PatternDelay(1,:) - (d-250);
p         =  numel(train_patterns);
nSeq      = floor(maxPatterns/p) ;   
StimConfigTrain.PatternSequence = zeros(1,p*nSeq) ;  
for i=1:nSeq
 StimConfigTrain.PatternSequence(((i-1)*p +1):i*p) = 1:1:p ;
end
 

 StimConfigTrain.p              = p    ;
 StimConfigTrain.nSeq           = nSeq ;
 StimConfigTrain.nLoop          = 1    ;
 
end
