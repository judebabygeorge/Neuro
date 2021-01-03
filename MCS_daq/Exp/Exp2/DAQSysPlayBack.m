classdef DAQSysPlayBack < handle
    %DAQSYS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties  
       FrameId
       SamplesPerFrame 
       CurrentTime 
       
       Connected
       GUI
       uDAQ
      
       nChannels
       
       FramesInMemory
       
       maxSpikes

       TotalActivity 
       
       Mode
       
       ProcessInfo
       ProcessMode
       
       save_filename 
       save_fid      
       save_enable
       save_mode 
       
       Test
       nDecoders
       Stats
        
       HSSelected
    end
    
    methods
        %Initialize Class and objects
        function DS = DAQSysPlayBack(uDAQ,save_enable,save_filename,HSSelected)
                    
           DS.uDAQ   = uDAQ      ; 
           DS.HSSelected = HSSelected;
           
           DS.save_filename = save_filename;
           DS.save_fid  = 0 ;
           DS.save_enable = save_enable ;
           
           if(DS.HSSelected==1)
            DS.save_mode = 3;
           else
            DS.save_mode = 4;
           end
           
           DS.FrameId = 0        ;
           DS.Connected = false  ;
           DS.CurrentTime = 0 ;
           DS.GUI.DAQ_Control  = DAQ_control;                   
           DS.GUI.ChannelView  = ChannelView ;
           %DS.GUI.SpikeSegView  = ChannelView ;
           %DS.GUI.Raster        = Raster      ;
           
           handles = guidata(DS.GUI.DAQ_Control);
           handles.SYS = DS ;
           guidata(DS.GUI.DAQ_Control,handles);  
           
           DS.nChannels = 120 ;
           DS.SamplesPerFrame=50000;

           DS.FramesInMemory   = 10;
           
           DS.TotalActivity=zeros(1000*DS.FramesInMemory,1); %1ms bins (Frames come per second) 
           DS.Mode = 0;
 
           
%          handles = guidata(DS.GUI.Raster);
%          handles.SetupRaster(DS.nChannels,handles) ;

        
          DS.ProcessMode = 1 ;
          DS.ProcessInfo = ProcessInfo_Setup ;
          
          DS.Test = [] ;
          DS.nDecoders = 0;
          
        end
        
 


            
        function DataAvailable(DS,Data,StimTrigger)
            
           DataProcessMode = 1 ; % 1 Matlab processing 0 : DSP Processing
           
          
           frame_valid = 1 ;
           tic
           
           
               

              
               nC = size(Data,1);
               nS  = size(Data,2);           
              
               [StimConfig StimEvents] = StimDecode(StimTrigger) ;
               Data = Data(1:DS.ProcessInfo.nC,:);
               

               
                
               Data = double(Data)';     
            

 
               
               
               %Show waveform
               handles  = guidata(DS.GUI.ChannelView);
               handles.DrawWaveForms(Data,handles,10,DS.ProcessInfo.Thresholds);  
               
               ProcessData ;                 
    
               if(DataProcessMode==0)
                   %Decode SpikeTimes
                   DS.ProcessInfo.spikeCounts = zeros(size(DS.ProcessInfo.spikeCounts));
                   SpikeDecode(DS.ProcessInfo.spike_times,DS.ProcessInfo.spikeCounts,SpikeEncoded);
               else
                   SpikeEncoded = zeros(4,size(Data,1));       
                   SpikeEncode(DS.ProcessInfo.spike_times,DS.ProcessInfo.spikeCounts,SpikeEncoded);  
               end
                             
               
               handles.MarkSpikeTimes(handles,DS.ProcessInfo.spike_times,DS.ProcessInfo.spikeCounts);
            
   
        end



    end

    
end

