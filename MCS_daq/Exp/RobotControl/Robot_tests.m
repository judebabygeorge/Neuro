
t1.TestConfigGlobal.RunDir = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\RobotControl\Data\';

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

TotalTests  = 2 ;
t1.Tests{TotalTests} = [];

t1.Tests{1} = test_CheckAllElectrodes(t1.TestConfigGlobal);
t1.Tests{2} = test_PatternCheck(t1.TestConfigGlobal,'two_time_seq3',2,250);
