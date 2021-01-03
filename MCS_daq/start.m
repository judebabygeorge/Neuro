
filename = 'D:\MATLAB_Data\a1';

uSYS = DAQSys(uDAQ,1,filename) ;        
lh(1) = addlistener(uDAQ,'Port_1_Data_Event',@uSYS.DataAvailable);
lh(2) = addlistener(uDAQ,'DeviceStateChange',@uSYS.DeviceStateChange);