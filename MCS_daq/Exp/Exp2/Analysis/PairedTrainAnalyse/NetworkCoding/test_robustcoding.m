
path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\';
Culture = 'Z23042015A';
DIV     = [13 14 15 20 21];

path = sprintf('%s\\%s\\DIV%d\\',path,Culture,DIV(1));

a = load(sprintf('%s\\data_PatternCheck_2_250_two_time_seq4_1.mat',path));
PatternData = a.PatternData

SelectedPatterns=1:1:112;
CheckSDR_S2