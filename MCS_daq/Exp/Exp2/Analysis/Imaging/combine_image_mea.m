E = {'L8','L8','L8','L8'};
for i=2:4
    load(sprintf('C:\\Users\\45c\\Documents\\MATLAB\\MCS_daq\\Exp\\Exp2\\Data\\G29022016B\\DIV15\\data_PatternCheck_2_250_Imaging1_%d.mat',i));
    load(sprintf('C:\\Users\\45c\\Documents\\MATLAB\\MCS_daq\\Exp\\Exp2\\Analysis\\Imaging\\InitialSetup\\ImageData_G29022016B_DIV15\\data_Camera-1_I%d.mat',i))
    PatternData_Spikes = Extract_PatternData(PatternData.src_filename,PatternData.StimConfig,4);

    ImagingData.PatternData = PatternData;
    ImagingData.PatternData_Spikes = PatternData_Spikes;
    ImagingData.Cam1 = Y;
    ImagingData.Electrode = E{i};
    save(sprintf('C:\\Users\\45c\\Documents\\MATLAB\\MCS_daq\\Exp\\Exp2\\Data\\G29022016B\\DIV15\\ImagingData_%d.mat',i),'ImagingData');
end