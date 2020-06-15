function [StimConfigProbe,StimConfigTrain] = GenerateStimulusConfig_TrainProtoCol_A(path)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time

a = load(sprintf('%s/data_PatternCheck_2_250_two_time_seq4_1.mat',path));
PatternData = a.PatternData;
[Patterns,~]=EditPatterns(PatternData);
P = ones(size(Patterns));
P(isnan(Patterns))=0;
P= mean(P,3);

StimConfigProbe = PatternData.StimConfig;
StimConfigTrain = PatternData.StimConfig;

maxPatterns = 127 ; 


ProbeID= zeros(8,8);
id=1;
for i=1:7
    for j=i+i:8
        ProbeID(i,j) = id;
        ProbeID(j,i) = id;
        id=id+1;        
    end
end

sum((P(:,113:120)>0).*P(:,113:120))
[~,Etrain] = max(sum((P(:,113:120)>0).*P(:,113:120)));

train_patterns = 112+Etrain 

probes = ProbeID(Etrain,:);
probes = probes(probes>0);

x = zeros(numel(probes),1);
for i=1:numel(probes)
    pid = (probes(i)-1)*4 + [1 2 3 4];
    sum(sum((P(:,pid)>0.1),2)==4)
    x(i)= sum(sum((P(:,pid)>0.1),2)==4);
end

[~,pid] = max(x);
pid = probes(pid)

[r,c]=find(ProbeID==pid)
E2  = r';
E2  = E2(E2~=Etrain)
pid =  (pid-1)*4 + [1 2 3 4] ;

pid
pid = [pid (112 + [Etrain E2])];

probe_patterns = 1:1:8;
probe_patterns = probe_patterns(probe_patterns~=Etrain);
probe_patterns = probe_patterns(probe_patterns~=E2);

probe_patterns = [probe_patterns probe_patterns probe_patterns probe_patterns];
probe_patterns = 112 + probe_patterns(randperm(numel(probe_patterns)));

probe_patterns = [pid pid(1) pid(3) pid(1) pid(3); reshape(probe_patterns(1:20),[2 10])];
probe_patterns = probe_patterns(:);

StimConfigProbe.Patterns = PatternData.StimConfig.Patterns(:,probe_patterns);
StimConfigProbe.PatternDelay = PatternData.StimConfig.PatternDelay(:,probe_patterns);
StimConfigProbe.PatternDelay(1,[19 22])  = 247 ;
StimConfigProbe.PatternDelay(2,[19 22])  =   3 ;
StimConfigProbe.PatternDelay(1,[25 28])  = 246 ;
StimConfigProbe.PatternDelay(2,[25 28])  =   4 ;

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


StimConfigTrain.Patterns = PatternData.StimConfig.Patterns(:,train_patterns);
StimConfigTrain.PatternDelay = PatternData.StimConfig.PatternDelay(:,train_patterns);

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



function n=FindNumberofCommonElectrodes(StimConfig,p1,p2)
    n = 0;
    E1 = FindElectrodesInvolved(StimConfig,p1);
    E2 = FindElectrodesInvolved(StimConfig,p2);
    for i=1:numel(E1)
        n = n + sum(E1(i)==E2);
    end
end
function E = FindElectrodesInvolved(StimConfig,p)
    if StimConfig.Patterns(2,p) ~=0
        E = [StimConfig.Electrodes(1,StimConfig.Patterns(1,p)) StimConfig.Electrodes(1,StimConfig.Patterns(2,p))]';
    else
        E = StimConfig.Electrodes(:,StimConfig.Patterns(1,p));
    end
end