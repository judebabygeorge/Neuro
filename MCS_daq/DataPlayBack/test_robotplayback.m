addpath 'C:\Program Files (x86)\Multi Channel Systems\MC_Rack\MCStreamSupport\Matlab\meatools\mcintfac'
addpath 'C:\Users\45c\Documents\MATLAB\Prelim\'
addpath 'C:\Users\45c\Documents\MATLAB\MCS_daq\'
addpath 'C:\Users\45c\Documents\MATLAB\MCS_daq\SpikeExtraction\'
addpath 'C:\Users\45c\Documents\MATLAB\MCS_daq\FileRead\'
addpath 'C:\Users\45c\Documents\MATLAB\MCS_daq\StimulusGen\'

addpath(genpath('C:\Users\45c\Documents\MATLAB\MCS_daq\GUI\'))
addpath 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp1\'
addpath 'C:\Users\45c\Documents\MATLAB\MCS_daq\OutputExtraction'

%Load Data
%file = datastrm('D:\MC_Rack Data\Set1\24.mcd')


t_start = 0  ;
t_stop  = 60 ;
t_step  = 1  ;

t = 0 ;

close all;
%a = load('Thresholds.mat') ;
%Thresholds = a.Thresholds;


filename = '' ;
uPlay = DAQPlay(0,filename) ;  
% uPlay.ProcessInfo.Thresholds =  Thresholds ;
% uPlay.ProcessInfo.State      =  2;

%uExp = exp1(uPlay);
%uExp.configure_stimulation();
%uExp.start_session();

fr = create_datastream('C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\G08052014A\DIV20\data_PatternCheck_2_200_RobotCheck_1.dat');
Frame = 10 ;
Frame_stop = fr.Frames ;
%Frame_stop = 40;

uPlay.Mode = fr.type ;
uPlay.StartPlay()
while(Frame <= Frame_stop)
    

%Acquire Data
%     startend = [t (t+t_step)];
%     Data = nextdata(file,'streamname','Electrode Raw Data 1','startend',startend*1e3) ;
%     Data = Data.data ;
%     Data = reshape(Data,120,numel(Data)/120);
%     Data = Data - (2^15);
    
    [Data SpikeEncoded StimTrigger Output] = get_stream(fr,Frame);    
    display(['Frame Number : ' num2str(Frame)]);
    %SpikeDecode(uPlay.ProcessInfo.spike_times,uPlay.ProcessInfo.spikeCounts,SpikeEncoded);
    
    

    tic
     uPlay.DataAvailable(Data,StimTrigger,Output)
    tt = toc ;
    display(['Time Spent : ' num2str((tt/1)*100) ' %']);
    pause(0.1);
%     if(tt<1)
%      pause(1-tt);
%     end
    Frame = Frame + 1 ;
end

uPlay.StopPlay();

%fclose(uPlay.save_fid);
