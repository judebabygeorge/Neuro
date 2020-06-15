

path0 = [path '\' DIV '\'];
paired_probes = dir([path0 '\data_PatternCheck_2_250_paired_train_probe_*.mat']);

for i=1:numel(paired_probes)
    a=load([path0 '\' paired_probes(i).name]);
    PatternData =a.PatternData;
    filename = [path0 paired_probes(i).name];
    filename(end-2)='d';
    Extract_PatternData(filename,PatternData.StimConfig,3)
end