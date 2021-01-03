README
======

This source code contains the files used for data acquisition and post processing neuronal data from MEA2100 system.
It works in the following steps

1. Define Stimulus Config
2. Upload the Stimulus Config to DSP processor
3. Run Stimulus and Acquisition using DSP
4. Acquire data in Matlab
5. Post processing and analysis.

A custom DSP code is used  to coordinate patterned stimulus and data acquisition.
This code is provided in the folder RealTimeSystem. The final compiled binary
is also provided : 'RealTimeSystem.bin'

The main interface to the MEA2100 hardware is provided by  a DLL provided by the
MultiChannelSystems. This is called McsUsbNet.dll . We have created a wrapper over
this dll called McsDAQ_Wrapper to simplify usage from matlab. The C# code is provided
in the folder McsDAQ_Wrapper.

This wrapper provides the interface to download a binary for the DSP and exchange data with
the code running on the DSP.

Thus an interface is created between the DSP and MATLAB. Using this interface, we download the
DSP binary. Then we download some configuration and patterns for the DAC stimulator. After this
we run the acquisition loop for the programmed number of samples. These functions are implemented
and exposed by the class DAQSys.m 

The functions (and the m-files) GenerateStimConfig_* generate different configurations of stimulus patterns. These are then loaded into the DSP. Some helper modules for doing this using GUI are created. The files exp2.m implement this. The file start_exp2.m starts the experiment by brining up the hardware and the UI. The file setup_uno connects to an Arduino board to control the power switch to the acquisition hardware. This allows us to shut off and turn on the Acquisition system when running long automated experiments without which warming up of the equipment prevents running long experiments.

Processing of the acquired data is done in multiple steps.
1.	Raw data is filtered, spike detection done and spike timing information is extracted and stored in a specific mat structure format along with the stimulus config. This format allows storing spike pattern for different stimulus patterns.
2.	Further analysis like calculating probabilities, classification etc is done on the data stored in these files.
The initial processing is done in the file ProcessData.m and then after complete acquisition, results stored in a matfile. The data structure for the same is described at the end of this file. Spike detection based on threshold along with back-off is implemented in a C -mex function  to allow for Online processing.

Once the experiment is completed, other analysis can be done on this data.
The core algorithm for classification tasks is implemented in get_best_patterns().  This function is then used extensively for custom analysis as described in the thesis. Some sample analysis scripts can be seen in 	test_spike_probability, test_spike_Delay etc.



Data structure stored
------------------------------
The Data is stored in matFile in a structure called PatternData.
The main fields of this Structure are
1. Pattern [n_electrodes  x maxSpikes x n_patterns x n_Trials]

Each element is a time of occurrence of spike at the electrode post stimulus in a 100ms window (maxSpikes recorded is 5 i.e. upto 5 spikes post stimulus is recorded for each electrode). This matrix contains the spike data for n_patterns used in the experiment and ntrials repeated.

2. StimConfig
This contains the details of the Stimulus pulses applied. The fields are

2.1 Electrodes :   
The electrodes used for stimulation. This can either be single electrodes or a set of electrodes 

2.2 Patterns :  
Stimulation Pattern with a matrix containing sequence of electrodes used for stimulation

2.3  PatternDelay :   
This contains the delay between firing of each electrode in the Pattern described by previous structure

2.4  PatternInterval :    
 Delay between application of different patterns	   
 
2.5  PatternSequence :   
Patterns in the previous array are presented in a random order to the culture. 
This structure captures the actual order in which patterns were presented

