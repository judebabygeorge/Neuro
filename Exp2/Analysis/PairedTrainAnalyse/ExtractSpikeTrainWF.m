%path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\G14082014A\DIV27\';
path0 = [path '\' DIV '\'];
paired_probes = dir([path0 '\data_spiketrain_PatternCheck_2_250_paired_train_probe_*.mat']);

for i=1:numel(paired_probes)
    a=load([path0 '\' paired_probes(i).name]);
    PatternData =a.PatternData;
    
    n = min(6,numel(PatternData.StimConfig.PatternDetails.vecs));
    Patterns = PatternData.StimConfig.PatternDetails.vecs(1:n);
    electrodes=PatternData.StimConfig.PatternDetails.electrodes(1:n);
    [SpikeIndex SpikeData] = ExtractSpikeShapes_SpikeTrain( PatternData ,  PatternData.src_filename , Patterns , electrodes);
    
    SpikeWF.SpikeIndex = SpikeIndex;
    SpikeWF.SpikeData = SpikeData;
    
    save_filename = [path0 '\spiketrain_wf_paired_train_probe_' num2str(i) '.mat'];
    save( save_filename , 'SpikeWF');
end