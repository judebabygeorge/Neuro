addpath 'C:\Program Files (x86)\Multi Channel Systems\MC_Rack\MCStreamSupport\Matlab\meatools\mcintfac'
addpath 'C:\Users\45c\Documents\MATLAB\Prelim\'
addpath 'C:\Users\45c\Documents\MATLAB\MCS_daq\'
addpath 'C:\Users\45c\Documents\MATLAB\MCS_daq\SpikeExtraction\'
addpath 'C:\Users\45c\Documents\MATLAB\MCS_daq\FileRead\'
addpath 'C:\Users\45c\Documents\MATLAB\MCS_daq\StimulusGen\'

addpath(genpath('C:\Users\45c\Documents\MATLAB\MCS_daq\GUI\'))
addpath 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp1\'

%Load Data
%file = datastrm('D:\MC_Rack Data\Set1\24.mcd')


t_start = 0  ;
t_stop  = 10 ;
t_step  = 1  ;

t = 0 ;

close all;
% a = load('Thresholds.mat') ;
% Thresholds = a.Thresholds;


filename = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\Z26022016X\DIV109\data_PatternCheck_2_250_Dummy_1.dat' ;
uPlay = DAQPlay(0,filename) ;  
% % uPlay.ProcessInfo.Thresholds =  Thresholds ;
% % uPlay.ProcessInfo.State      =  2;
% 
% uExp = exp2(uPlay);
% uExp.configure_stimulation();
% uExp.start_session();

fr = create_datastream(filename);
Frame = 1 ;
Frame_stop = fr.Frames ;
Frame_stop = 17;

uPlay.Mode = fr.type ;
uPlay.StartPlay()
while(Frame <= Frame_stop)
    

%Acquire Data
%     startend = [t (t+t_step)];
%     Data = nextdata(file,'streamname','Electrode Raw Data 1','startend',startend*1e3) ;
%     Data = Data.data ;
%     Data = reshape(Data,120,numel(Data)/120);
%     Data = Data - (2^15);
    
    [Data SpikeEncoded StimTrigger] = get_stream(fr,Frame);    
    display(['Frame Number : ' num2str(Frame)]);
    %SpikeDecode(uPlay.ProcessInfo.spike_times,uPlay.ProcessInfo.spikeCounts,SpikeEncoded);
    
    

    tic
     uPlay.DataAvailable(Data,StimTrigger)
    tt = toc ;
    display(['Time Spent : ' num2str((tt/1)*100) ' %']);
    if(tt<1)
     pause(1-tt);
    end
    Frame = Frame + 1 ;
end

uPlay.StopPlay();

%fclose(uPlay.save_fid);
