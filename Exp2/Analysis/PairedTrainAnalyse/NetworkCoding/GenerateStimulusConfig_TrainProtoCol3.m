function [StimConfigProbe,StimConfigTrain] = GenerateStimulusConfig_TrainProtoCol3 (path)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time

a = load(sprintf('%s/data_PatternCheck_2_250_two_time_seq4_1.mat',path));
PatternData = a.PatternData;


StimConfigProbe = PatternData.StimConfig;
StimConfigTrain = PatternData.StimConfig;

maxPatterns = 127 ; 



SelectedPatterns = 1:1:112;
%Select Train Patterns
train_patterns = [0 0];
Z = zeros(size(SelectedPatterns));
C = ones(121,numel(SelectedPatterns));
[emin, ~] = CheckClassifiability(PatternData,SelectedPatterns,C);

if(1)
%Most seprable
    [~,I] = sort(emin,'ascend');
else
%Not so separable
    [~,I] = sort(abs(emin-0.3),'ascend');
end


train_patterns(1)= I(1);
for i=1:numel(SelectedPatterns)
    Z(i) = FindNumberofCommonElectrodes(PatternData.StimConfig,train_patterns(1),I(i));
end
%Next best without common 
train_patterns(2)=I(find(Z==0,1,'first'));
display(emin(train_patterns));
%Common with train pattern 2
for i=1:numel(SelectedPatterns)
    Z(i) = Z(i)+FindNumberofCommonElectrodes(PatternData.StimConfig,train_patterns(2),I(i));
end


%Trained pattern and 18 with uncommon electrodes
probe_patterns = [train_patterns I(find(Z==0,18,'first'))'];
display(emin(probe_patterns));

StimConfigProbe.Patterns = PatternData.StimConfig.Patterns(:,probe_patterns);
StimConfigProbe.PatternDelay = PatternData.StimConfig.PatternDelay(:,probe_patterns);

SelectedPatterns = probe_patterns;
C = ones(121,numel(SelectedPatterns));
[emin, ~] = CheckClassifiability(PatternData,SelectedPatterns,C);
display(emin);


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