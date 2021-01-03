classdef DAQPlay < handle
    %DAQSYS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties  
      
       FrameId
       SamplesPerFrame 
       
       Connected
       GUI
       
       
      
       nChannels
 
% 
%        FramesInMemory
%        TotalActivity 
       
       Mode
       
       ProcessInfo
       ProcessMode
       

       save_filename 
       save_fid      
       save_enable
       
       Test
       nDecoders
       Stats
       ViewDecoderStats
    end
    
    methods
        %Initialize Class and objects
        function DS = DAQPlay(save_enable,save_filename)
                    
           DS.save_enable   = save_enable      ;            
           DS.save_filename = save_filename;
           DS.save_fid  = 0 ;
           
           DS.FrameId = 0        ;
           DS.Connected = false  ;
           
%           DS.GUI.DAQ_Control  = DAQ_control ;                   
%           DS.GUI.ChannelView  = ChannelView ;
%            DS.GUI.SpikeSegView  = ChannelView ;
%            DS.GUI.Raster        = Raster      ;
           
%            handles = guidata(DS.GUI.DAQ_Control);
%            handles.SYS = DS ;
%            guidata(DS.GUI.DAQ_Control,handles);          
           
%            DS.nChannels = uDAQ.Channels ;
%            DS.SamplesPerFrame=uDAQ.Samplerate;

            DS.nChannels      = 120      ;
            DS.SamplesPerFrame= 50000    ;

%           DS.FramesInMemory   = 10;           
%           DS.TotalActivity=zeros(1000*DS.FramesInMemory,1); %1ms bins (Frames come per second) 
           DS.Mode = 0;
%           DS.uDAQ.SearchDevice()
           
%          handles = guidata(DS.GUI.Raster);
%          handles.SetupRaster(DS.nChannels,handles) ;
          
           DS.nDecoders =4;
           DS.Stats.Patterns = [];
           DS.Stats.DecodeStats = zeros(DS.nDecoders,DS.nDecoders);
           DS.ViewDecoderStats = DecoderPerformance();
          
        end
        function StartPlay(DS)
          DS.ProcessMode = 1 ;
          DS.ProcessInfo = ProcessInfo_Setup ;
          
          if(DS.save_enable==1)
           DS.save_fid = fopen(DS.save_filename, 'w');
           fwrite(DS.save_fid,0   ,'uint32'); 
           x = uint32(fix(clock))           ;
           fwrite(DS.save_fid,x   ,'uint32');                    
          end
        end
        
        function DataAvailable(DS,Data,StimTrigger,OutEncoded)
            
               DS.FrameId = DS.FrameId + 1 ;
               if(DS.save_enable)                      
                 if(DS.save_fid >0)
                     fwrite(DS.save_fid,1   ,'uint32');
                     fwrite(DS.save_fid,DS.FrameId   ,'uint32');
                     fwrite(DS.save_fid,Data,'int16'); 
                 end
               end 
               
                 
                 Data = double(Data)';
                 [StimConfig StimEvents] = StimDecode(StimTrigger) ;
                 DecoderOut = OutputDecode(OutEncoded);
                  
%                 for i=1:size(StimEvents,2)
%                     Event = StimEvents(2,i);
%                     
%                     if Event > 0
%                         a = typecast(uint32(Event),'uint8');
%                     else
%                         a = typecast(int32(Event),'uint8');
%                     end
%                     
%                     Event  = a(1);
%                     Id     = a(2);
%                     
%                     switch(Event)
%                         case 1 
%                             display(['**Sequence Start : '  num2str(Id) ' @' num2str(typecast(a(3:4),'uint16'))] )
%                             t1.ChannelStimResponse = zeros(120,1);
%                         case 2
%                             display(['**Sequence Start(L)'  num2str(Id)]) 
%                             t1.ChannelStimResponse = zeros(120,1);
%                         case 3
%                             display('**Sequence End')
%                             stop_acq = 1 ;
%                         case 4
%                             display('**Pattern shift')
%                         case 5
%                             display(['**Decoder Enable : '  num2str(typecast(a(3:4),'uint16'))]) 
%                             t1.ChannelStimResponse = zeros(120,1);     
%                         case 6
%                             display(['**Decoder Out : '  num2str(typecast(a(3:4),'uint16'))]) 
%                             t1.ChannelStimResponse = zeros(120,1);  
%                         otherwise
%                             display(['ERROR : Unknown Event ' num2str(Event) ] )
%                     end
%                 end               
%                 for i=1:size(StimConfig,2)
%                     Config = StimConfig(2,i);
%                     a = typecast(uint32(Config),'uint8');
%                     Pattern = a(1);
%                     Element = a(2);                       
%                     display(['** Pattern : '  num2str(Pattern) ' Element : ' num2str(Element) '  Config : ' num2str(a(3:4)) '  @ '  num2str(StimConfig(1,i))]);
%                 end
%                 for i=1:size(DecoderOut,2)
%                     display(['Decoder Output at : ' num2str(DecoderOut(1,i)) ]);
%                     a = typecast(uint32(DecoderOut(2:end,i)),'uint16');
%                     a1 = a(2:2:end);
%                     a2 = typecast(a(1:2:end),'int16');                    
%                     %for j=1:numel(a1)
%                     for j=1:4
%                         display(['Decoder ' num2str(a1(j)) ' : ' num2str(a2(j)) ] );
%                     end
%                 end
                
                if((size(StimConfig,2)>0)&&(size(StimConfig,2) == size(DecoderOut,2)))
                    M = zeros(size(StimConfig,2) , 1 + 2*DS.nDecoders);
                    for i=1:size(StimConfig,2)
                        Config = StimConfig(2,i);
                        a = typecast(uint32(Config),'uint8');
                        a = double(a(1));
                        b = typecast(uint32(DecoderOut(2:DS.nDecoders+1,i)),'uint16');
                        a1 = double(b(2:2:end));
                        a2 = double(typecast(b(1:2:end),'int16'));  
                        M(i,:) =  [a  a1' a2'] ;
                    end
                    DS.DecoderStats(M);
                    display(DS.Stats.DecodeStats)
                    h = guidata(DS.ViewDecoderStats);
                    h.UpdateDecoderPerformance(h.hPerformanceMatix,DS.Stats.DecodeStats);
                end
                
               % pause(1)
if(0)
                 %Show waveform
                 handles  = guidata(DS.GUI.ChannelView);
                 handles.DrawWaveForms(Data,handles,10,DS.ProcessInfo.Thresholds);
                 
                 ProcessData               
                 
                 if(DS.FrameId ==17)
                     Thresholds  = DS.ProcessInfo.Thresholds;
                     SpikeCounts = DS.ProcessInfo.spikeCounts ; 
                     SpikeTimes  = DS.ProcessInfo.spike_times;                    
                       %DS.ProcessInfo.spikeCounts
                 end
                 
                 DS.Test.data_available(DS.ProcessInfo.spike_times,DS.ProcessInfo.spikeCounts,StimConfig,StimEvents)
                 

                 handles.MarkSpikeTimes(handles,DS.ProcessInfo.spike_times,DS.ProcessInfo.spikeCounts);

      
                 SpikeEncoded = (zeros(4,size(Data,1)));
                 SpikeEncode(DS.ProcessInfo.spike_times,DS.ProcessInfo.spikeCounts,SpikeEncoded);                                   
                 %StimTrigger = zeros(2,size(Data,1));


               %Save Additional Data
               if(DS.save_enable)                      
                 if(DS.save_fid >0)                     
                     fwrite(DS.save_fid,SpikeEncoded,'uint32');
                     fwrite(DS.save_fid,StimTrigger,'uint32');
                 end
               end   
end 

        end
        function  DecoderStats(DS,M )
            for i=1:size(M,1)
                Pid = find(DS.Stats.Patterns==M(i,1),1) ;  
                if(isempty(Pid))
                    DS.Stats.Patterns = [DS.Stats.Patterns M(i,1)];
                    Pid = find(DS.Stats.Patterns==M(i,1),1);
                end
                DS.Stats.DecodeStats(Pid,M(i,2)) =DS.Stats.DecodeStats(Pid,M(i,2))+1 ;        
            end
            %DS.Stats.DecodeStats
        end
        function  StopPlay(DS)
            if(DS.save_enable)                
                if(DS.save_fid > 0)
                    fwrite(DS.save_fid,2   ,'uint32');
                    fwrite(DS.save_fid,DS.FrameId   ,'uint32');                
                    fclose(DS.save_fid);
                    display(['Frames in File : ' num2str(DS.FrameId) ]);
                    DS.save_fid = -1 ;
                end
            end
        end  
        function SetTest(DS,Test)
            DS.Test = Test ;
        end
    end    
    
end

