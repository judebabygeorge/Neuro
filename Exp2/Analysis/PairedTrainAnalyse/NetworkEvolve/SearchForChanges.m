function X = SearchForChanges( path ,DIV )
%ANALYSE Summary of this function goes here
%   Detailed explanation goes here

path0 = [path '\' DIV '\'];
paired_probes = 12;

StimConfigProbe = load([path0 '\' 'StimConfigProbe.mat']);
StimConfigProbe = StimConfigProbe.StimConfigProbe;

nVecs = numel(StimConfigProbe.PatternDetails.vecs);

X = zeros(120,nVecs,paired_probes);
for i = 1:paired_probes
    f = sprintf('\\data_PatternCheck_2_250_paired_train_probe_%d.mat',i);
    f = [path0  f];
    a = load(f); 
    P = CreateFiringProbabilityMatrix( a.PatternData );
    X(:,:,i)=P(:,StimConfigProbe.PatternDetails.vecs);
end
X = mean(X,3);

end

