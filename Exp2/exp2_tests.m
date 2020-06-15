
t1.TestConfigGlobal.RunDir = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\';

global SelectedCulture
SelectedCulture = 1;
hsel = select_culture;
a = guidata(hsel);
a.UpdateCultureList(hsel,t1.TestConfigGlobal.RunDir);

waitfor(hsel)

day  =  str2double(SelectedCulture(2:3));
month = str2double(SelectedCulture(4:5));
year  = str2double(SelectedCulture(6:9));

div = abs(datenum(date) - datenum(year,month,day));

t1.TestConfigGlobal.Culture = SelectedCulture;
t1.TestConfigGlobal.DIV     = ['DIV' num2str(div)];

rundir = [t1.TestConfigGlobal.RunDir '\' t1.TestConfigGlobal.Culture '\' t1.TestConfigGlobal.DIV ];
if(~isdir(rundir))
  mkdir(rundir);
end

%TotalTests  =  ;
t1.Tests = [];

t1.Tests{1} = test_CheckAllElectrodes(t1.TestConfigGlobal,'CheckAllElectrodes',1);
t1.Tests{2} = test_PatternCheck(t1.TestConfigGlobal,'Dummy',2,250);
%t1.Tests{2} = test_PatternCheck(t1.TestConfigGlobal,'two_time_seq3',2,250);
%t1.Tests{3} = test_PatternCheck(t1.TestConfigGlobal,'Random8',8,250);
t1.Tests{3} = test_DSP_Decode(t1.TestConfigGlobal,'robot_decode','2_250_two_time_seq3',4);
%t1.Tests{5} = test_PatternCheck(t1.TestConfigGlobal,'Random8_selected',8,250);

%t1.Tests{6} = test_PatternCheck(t1.TestConfigGlobal,'ndim_all',8,250);
%t1.Tests{7} = test_PatternCheck(t1.TestConfigGlobal,'ndim_all_2',8,250);
%t1.Tests{7} = test_PatternCheck(t1.TestConfigGlobal,'test_0',2,250);
%t1.Tests{8} = test_AnalysePattern(t1.TestConfigGlobal,'train_select','2_250_two_time_seq3');
%t1.Tests{9} = test_PatternCheck(t1.TestConfigGlobal,'train_0',2,250);
%t1.Tests{4} = test_PatternCheck(t1.TestConfigGlobal,'RobotCheck',2,200);
%t1.Tests{5} = test_DSP_Decode(t1.TestConfigGlobal  ,'training_1','2_250_two_time_seq3',2);
% t1.Tests{4} = test_PatternCheck(t1.TestConfigGlobal,'ProbeHF',2,250);

t1.Tests{4} = test_PatternCheck(t1.TestConfigGlobal,'CLTrain',2,250);
t1.Tests{5} = test_PatternCheck(t1.TestConfigGlobal,'CLProbe',2,250);

%t1.Tests{6} = test_PatternCheck(t1.TestConfigGlobal,'training_1',2,200);
t1.Tests{6} = test_PatternCheck(t1.TestConfigGlobal,'paired_train',2,250);
t1.Tests{7} = test_PatternCheck(t1.TestConfigGlobal,'PairedTrain_Theta',2,250);
%t1.Tests{7} = test_CheckAllElectrodes(t1.TestConfigGlobal,'CheckElectrodesHF',3);
%t1.Tests{7} = test_PatternCheck(t1.TestConfigGlobal,'ContextDependenceCheck',2,250);
t1.Tests{8} = test_PatternCheck(t1.TestConfigGlobal,'two_time_seq4',2,250);
%t1.Tests{9} = test_PatternCheck(t1.TestConfigGlobal,'two_time_seq5',2,250);
%t1.Tests{10} = test_PatternCheck(t1.TestConfigGlobal,'train_protocol',2,250);
%t1.Tests{11} = test_PatternCheck(t1.TestConfigGlobal,'paired_train_probe',2,250);
%t1.Tests{12} = test_PatternCheck(t1.TestConfigGlobal,'probe_scan',2,250);
t1.Tests{9} = test_PatternCheck(t1.TestConfigGlobal,'Imaging_spont_short',2,250);
t1.Tests{10} = test_PatternCheck(t1.TestConfigGlobal,'Imaging1',2,250);
t1.Tests{11} = test_PatternCheck(t1.TestConfigGlobal,'Imaging_long',2,250);
t1.Tests{12} = test_PatternCheck(t1.TestConfigGlobal,'Imaging_spont',2,250);
% t1.Tests{11} = test_PatternCheck(t1.TestConfigGlobal,'PatternMatch',2,250);
% t1.Tests{12} = test_PatternCheck(t1.TestConfigGlobal,'WordSequence',2,250);