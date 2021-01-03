
clear uSYS uDAQ dll lh

setup_paths

%Create Data Acquistion System DLL Interface
dll = NET.addAssembly('C:\Users\45c\Documents\MATLAB\MCS_daq\DAQ_Wrapper\DAQ_MATLAB_Wrapper\DAQ_MATLAB_Wrapper\bin\Release\DAQ_MATLAB_Wrapper.dll');
import DAQ_MATLAB_Wrapper.* 
addpath(genpath('C:\Users\45c\Documents\MATLAB\MCS_daq\DAQ_Wrapper\'));
uDAQ = DAQ;




% Basic System for Data Processing
% Filtering and Spike Detection &
% Hardware Control
Culture = 'Others';
filename = ['C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\' Culture '\data'];

uSYS = DAQSys(uDAQ,0,filename) ;        
%Setup Listeners for DAQ Events
lh(1) = addlistener(uDAQ,'Port_1_Data_Event',@uSYS.DataAvailable);
lh(2) = addlistener(uDAQ,'DeviceStateChange',@uSYS.DeviceStateChange);

% Interface for running test
uExp = RobotControl(uSYS);