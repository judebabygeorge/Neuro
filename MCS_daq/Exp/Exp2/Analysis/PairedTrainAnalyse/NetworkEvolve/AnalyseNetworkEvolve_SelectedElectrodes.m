function [X,Culture,DIV] = AnalyseNetworkEvolve_SelectedElectrodes( path ,DIV , vecs , electrodes )
%ANALYSE Summary of this function goes here
%   Detailed explanation goes here

path0 = [path '\' DIV '\'];
paired_probes = dir([path0 '\data_PatternCheck_2_250_paired_train_probe_*.mat']);

StimConfigProbe = load([path0 '\' 'StimConfigProbe.mat']);
StimConfigProbe = StimConfigProbe.StimConfigProbe;

nVecs = numel(vecs);
X = zeros(numel(paired_probes),nVecs);

for i = 1:numel(paired_probes)
    f = sprintf('\\data_PatternCheck_2_250_paired_train_probe_%d.mat',i);
    f = [path0  f];
    a=load(f); 
    P = CreateFiringProbabilityMatrix( a.PatternData );
    P = P(:,StimConfigProbe.PatternDetails.vecs);
  
    for j=1:nVecs       
        X(i,j) = P(electrodes(j),j);
    end
    
end

id = find((path=='\'),2,'last');
Culture = path(id(1)+1:id(2)-1);
end

