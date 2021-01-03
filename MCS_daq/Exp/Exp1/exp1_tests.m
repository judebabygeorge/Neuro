

t1.TestConfigGlobal.Culture = 'K17042013A';
t1.TestConfigGlobal.DIV     = 'DIV32';
t1.TestConfigGlobal.RunDir  = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp1\Data\';

TotalTests  = 14 ;
t1.Tests{TotalTests} = [];

t1.Tests{1} = test_CheckAllElectrodes(t1.TestConfigGlobal);

% t1.Tests{2} = test_PatternCheck(t1.TestConfigGlobal,'random' , 2,500);
% t1.Tests{3} = test_PatternCheck(t1.TestConfigGlobal,'random' , 3,500);
t1.Tests{2} = test_PatternCheck(t1.TestConfigGlobal,'train',2,500);
t1.Tests{3} = test_PatternCheck(t1.TestConfigGlobal,'train',2,250);
% t1.Tests{4} = test_PatternCheck(t1.TestConfigGlobal,'random' , 2,250);
% t1.Tests{5} = test_PatternCheck(t1.TestConfigGlobal,'random' , 3,250);

t1.Tests{4} = test_PatternCheck(t1.TestConfigGlobal,'Random8' , 8,250);
t1.Tests{5} = test_PatternCheck(t1.TestConfigGlobal,'Random8' , 8,500);

t1.Tests{6} = test_PatternCheck(t1.TestConfigGlobal,'sequence',2,500);
t1.Tests{7} = test_PatternCheck(t1.TestConfigGlobal,'sequence',2,250);
t1.Tests{8} = test_PatternCheck(t1.TestConfigGlobal,'sequence',3,250);

t1.Tests{9} = test_PatternCheck(t1.TestConfigGlobal,'two_time',2,250);
t1.Tests{10} = test_PatternCheck(t1.TestConfigGlobal,'two_time',2,500);

t1.Tests{11} = test_PatternCheck(t1.TestConfigGlobal,'two_time_seq',2,250);
t1.Tests{12} = test_PatternCheck(t1.TestConfigGlobal,'two_time_seq',2,500);
t1.Tests{13} = test_PatternCheck(t1.TestConfigGlobal,'two_time_seq3',2,250);
t1.Tests{14} = test_PatternCheck(t1.TestConfigGlobal,'two_time_seq3',2,500);

% t1.Tests{8} = test_PatternCheck(t1.TestConfigGlobal,'single', 1,250);
% t1.Tests{9} = test_PatternCheck(t1.TestConfigGlobal,'single', 1,500);
% t1.Tests{10} = test_PatternCheck(t1.TestConfigGlobal,'single', 1,1000);
% t1.Tests{11} = test_PatternCheck(t1.TestConfigGlobal,'single', 1,2000);
% t1.Tests{12} = test_PatternCheck(t1.TestConfigGlobal,'single', 1,4000);
% t1.Tests{13} = test_PatternCheck(t1.TestConfigGlobal,'single', 1,8000);

% t1.Tests{12} = test_PatternCheck(t1.TestConfigGlobal,'interleaved', 1,250);
% t1.Tests{13} = test_PatternCheck(t1.TestConfigGlobal,'interleaved', 1,500);
% t1.Tests{14} = test_PatternCheck(t1.TestConfigGlobal,'interleaved', 1,1000);
% t1.Tests{17} = test_PatternCheck(t1.TestConfigGlobal,'interleaved', 1,2000);
% t1.Tests{18} = test_PatternCheck(t1.TestConfigGlobal,'interleaved', 1,4000);

