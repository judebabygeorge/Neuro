function [X,Y] = AnalyseNetworkEvolve_Full( path ,DIV )
%ANALYSE Summary of this function goes here
%   Detailed explanation goes here

% Y Has complete data from last div loaded
% X has mean from all data

X = [];
nX = 0;
for j = 1:numel(DIV)
path0 = [path '\' DIV{j} '\'];
paired_probes = dir([path0 '\data_PatternCheck_2_250_paired_train_probe_*.mat']);



Y = [];

for i=1:numel(paired_probes)
    f = sprintf('\\data_PatternCheck_2_250_paired_train_probe_%d.mat',i);
    f = [path0  f];
    a=load(f); 
    [Patterns , ~ ]= EditPatterns(a.PatternData);    
    P = ones(size(Patterns));
    P(isnan(Patterns)) = 0;
    P = mean(P,3);    
    Y(:,:,i)=P;
end

a = size(Y,3);
i=1;
batch = 12;

while i<a
    nX = nX + 1;
    X(:,:,nX)=mean(Y(:,:,i:min(i+batch-1,a)),3);    
    i=i+batch;
end

end

end

