function [StimConfigProbe,StimConfigTrain] = GenerateStimulusConfig_CLTrain (path)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time

filename = sprintf('%s//data_PatternCheck_2_250_two_time_seq4_1.mat',path);
if(exist(filename,'file'))
    a = load(filename);
    PatternData = a.PatternData;
    StimConfigProbe = PatternData.StimConfig;
    StimConfigTrain = PatternData.StimConfig;
else
    filename = sprintf('%s//StimConfig_4.mat',path);
    a = load(filename);
    StimConfig=a.StimConfig;
    StimConfigProbe = StimConfig;
    StimConfigTrain = StimConfig;
end

maxPatterns = 127 ; 

% 
% [Patterns , PatternConfig ]= EditPatterns(PatternData);
% 
% pid = 1:2:112;
% StimPatterns = PatternConfig.Patterns;
% 
% E = reshape(randperm(8),[2 4]);
% probe_patterns=zeros(1,4);
% for i=1:4
%      probe_patterns(i)=pid(((StimPatterns(1,:)==E(1,i))&&(StimPatterns(2,:)==E(2,i))));     
% end
% 
% P = ones(size(Patterns));
% P(isnan(Patterns))=0;
% P = mean(P,3);
% P = P(:,probe_patterns);
% 
% 
% train_patterns = probe_patterns;
% 
% 




%train_patterns   = [1 53 89 109];% 2ms AB CD EF GH
train_patterns0   = [1 53];% 2ms AB CD EF GH
probe_patterns   = 1:1:112;
I=randperm(numel(89:112));
probe_patterns = probe_patterns(I(1:20));
probe_patterns = reshape(probe_patterns,[5 4]);
train_patterns = probe_patterns;

probe_patterns(1,1)=train_patterns0(1);
probe_patterns(3,2)=train_patterns0(2);

train_patterns(1,:)=train_patterns0(1);
train_patterns(3,:)=train_patterns0(2);

probe_patterns = probe_patterns(:);
train_patterns = train_patterns(:);

StimConfigProbe.Patterns = StimConfig.Patterns(:,probe_patterns);
StimConfigProbe.PatternDelay = StimConfig.PatternDelay(:,probe_patterns);
%StimConfigProbe.PatternDelay(1,:) = 1;
StimConfigProbe.DecodeCheckWindow = 40;

p = numel(probe_patterns);
nSeq      = floor(maxPatterns/p) ;   
StimConfigProbe.PatternSequence = zeros(1,p*nSeq) ;  
for i=1:nSeq
 StimConfigProbe.PatternSequence(((i-1)*p +1):i*p) = 1:1:p ;
end

StimConfigProbe.p              = p    ;
StimConfigProbe.nSeq           = nSeq ;
StimConfigProbe.nLoop          = 1    ;

StimConfigTrain.Patterns = StimConfig.Patterns(:,train_patterns);
StimConfigTrain.PatternDelay =StimConfig.PatternDelay(:,train_patterns);
StimConfigTrain.PatternDelay(1,:) = 1;
StimConfigTrain.DecodeCheckWindow = 40;

%Create a decoder to test


p         =  numel(train_patterns);
nSeq      = floor(maxPatterns/p) ;   
StimConfigTrain.PatternSequence = zeros(1,p*nSeq) ;  
for i=1:nSeq
 StimConfigTrain.PatternSequence(((i-1)*p +1):i*p) = 1:1:p ;
end
 

 StimConfigTrain.p              = p    ;
 StimConfigTrain.nSeq           = nSeq ;
 StimConfigTrain.nLoop          = 1    ;

files = dir([path '\data_PatternCheck_2_250_probe_scan_*.mat']);
if(numel(files)>0)
    a = load(sprintf('%s/data_PatternCheck_2_250_probe_scan_%d.mat',path,numel(files)));
    %a = load(sprintf('%s/data_PatternCheck_2_250_probe_scan_%d.mat',path,1));
    PatternData = a.PatternData;
    P=ones(size(PatternData.Pattern));
    P(isnan(PatternData.Pattern))=0;
    P = mean(P,3);
    P1 = P(:,1);
    P2 = P(:,8);
    
    [~,I]= sort((1-abs(P1-0.6)).*(1-0*abs(P1-P2)),'descend');
    [I(1:5) P1(I(1:5)) P2(I(1:5))]
    
    DecodeWeights = zeros(121,1);    
    DecodeWeights(I(1))=1;
    
    StimConfigTrain.DecodeWeights=DecodeWeights;
end

end

