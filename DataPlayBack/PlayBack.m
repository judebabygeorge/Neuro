
%Setup Paths
addpath 'C:\Program Files (x86)\Multi Channel Systems\MC_Rack\MCStreamSupport\Matlab\meatools\mcintfac'
addpath 'C:\Users\45c\Documents\MATLAB\Prelim\'
addpath 'C:\Users\45c\Documents\MATLAB\MCS_daq\'
addpath 'C:\Users\45c\Documents\MATLAB\MCS_daq\SpikeExtraction\'

addpath(genpath('C:\Users\45c\Documents\MATLAB\MCS_daq\GUI\'))

%Load Data
file = datastrm('D:\MC_Rack Data\Set1\24.mcd')


t_start = 0 ;
t_stop  = 20;
t_step  = 1 ;

t = 0 ;

close all;

filename = 'D:\MATLAB_Data\a1' ;
uPlay = DAQPlay(file,filename) ;  

% DS.GUI.ChannelView  = ChannelView ;
% DS.ProcessInfo = ProcessInfo_Setup ;

while(t<t_stop)
    

    %Acquire Data
    startend = [t (t+t_step)];
    Data = nextdata(file,'streamname','Electrode Raw Data 1','startend',startend*1e3) ;
    Data = Data.data ;
    Data = reshape(Data,120,numel(Data)/120);
    Data = Data -(2^15);
    
    tic
     uPlay.DataAvailable(Data)
    tt = toc ;
    display(['Time Spent : ' num2str((tt/1)*100) ' %']);
    if(tt<1)
     pause(1-tt);
    end
    
    t = t + t_step;
end


