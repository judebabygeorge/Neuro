
%% Extract the pattern information from the file
setup_paths

%Open a stream file
Culture = 'G13032013A';
data    = 'data_1';
ConfigSelect = 'StimConfig_SingleRand';
%ConfigSelect = 'StimConfig_SingleSelect';
%ConfigSelect = 'StimConfig_DoubleSelect';
%ConfigSelect = 'StimConfig_TripleSelect';
%ConfigSelect = 'StimConfig_SingleSelect_500';
%ConfigSelect = 'StimConfig_SingleSelect_250';
%ConfigSelect = 'StimConfig_SingleSelect_100';

%ConfigSelect = 'StimConfig_DoubleSelect_500';
%ConfigSelect = 'StimConfig_DoubleSelect_250';
%ConfigSelect = 'StimConfig_TripleSelect_500';
%ConfigSelect = 'StimConfig_TripleSelect_250';

src_filename = ['C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp1\Data\' Culture '\' data '.dat'];
%src_filename = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp1\Data\data_1.dat';
%src_filename = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp1\Data\C1\data_2.dat';
%src_filename = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp1\Data\data0_1.dat';
%src_filename = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp1\Data\data_1.dat';
fr = create_datastream(src_filename);

%Load a Configutation
config_filename = ['C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp1\Data\' Culture '\' ConfigSelect '.mat'];
Config = load(config_filename);
Config = Config.StimConfig;

window  = 50e-3*50000;
[Pattern FrameNumber MarkTime]  = ExtractPatterns(fr,Config,window);

x = find(FrameNumber==0);
if(~isempty(x))
    display('WARNING: Stimulus Missing')
end

PFiring = zeros(size(Pattern));
PFiring(~isnan(Pattern)) = 1 ;



%% Create the Data Structure to Store 
PatternData.src_filename = src_filename ;
PatternData.Config=Config;
PatternData.window = window  ;
PatternData.Pattern=Pattern;
PatternData.FrameNumber = FrameNumber;
PatternData.MarkTime=MarkTime;

save_filename = ['C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp1\Data\' Culture '\' data '.mat'];
save( save_filename , 'PatternData')