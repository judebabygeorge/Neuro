path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\G14082014A';
save_path = 'C:\Users\45c\Desktop\train_figs\train14082014A';


DIV  = 'DIV37';

ExtractDetailedSpikeInfo;
ExtractSpikeTrainWF;
AnalysePairedStim_4(path,DIV,save_path);
AnalysePairedStim_2(path,DIV,save_path);
AnalysePairedStim_3(path,DIV,save_path);

