function Y = GetElectrodeTimeEvolve( path ,DIV )

path0 = [path '\' DIV '\'];
paired_probes = dir([path0 '\data_PatternCheck_2_250_paired_train_probe_*.mat']);

Y = zeros(120,20,numel(paired_probes));
for i = 1:numel(paired_probes)
    f = sprintf('\\data_PatternCheck_2_250_paired_train_probe_%d.mat',i);
    f = [path0  f];
    a=load(f); 
    P = CreatemeanFireTimeMatrix( a.PatternData );
    Y(:,:,i) = P; 
end

end
