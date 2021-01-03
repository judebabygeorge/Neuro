

clear uSYS uDAQ dll lh

dll = NET.addAssembly('C:\Users\45c\Documents\MATLAB\MCS_daq\DAQ_Wrapper\DAQ_MATLAB_Wrapper\DAQ_MATLAB_Wrapper\bin\Release\DAQ_MATLAB_Wrapper.dll');
import DAQ_MATLAB_Wrapper.* 

addpath(genpath('C:\Users\45c\Documents\MATLAB\MCS_daq\'));
addpath 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp1\'

uDAQ = DAQ;



