function test_f
path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\Z12062015A\DIV22';
files = dir([path '\data_PatternCheck_2_250_probe_scan*.mat']);
nProbeSeq=numel(files);
if(nProbeSeq>0)
   a = load(sprintf('%s/StimConfigTrain.mat',path));
   W = a.StimConfigTrain.DecodeWeights(1:120,1);
   
   Y=zeros(nProbeSeq,sum(W));   
   for i=1:nProbeSeq
       P = get_p(path,i);
       Y(i,:)=P(W>0,1)';
   end
end
plot(Y(1:end,:))
end

function P = get_p(path,probeid)
    a = load(sprintf('%s/data_PatternCheck_2_250_probe_scan_%d.mat',path,probeid));
    PatternData = a.PatternData;
    P=ones(size(PatternData.Pattern));
    P(isnan(PatternData.Pattern))=0;
    P=mean(P,3);
end