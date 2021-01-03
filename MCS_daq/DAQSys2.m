classdef DAQSys2 < handle
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
       
       Test
    end
    
    methods
        %Initialize Class and objects
        function DS = DAQSys2(save_enable,save_filename)
                    
           %DS.uDAQ   = uDAQ      ; 
           
           DS.save_filename = save_filename;
           DS.save_fid  = 0 ;
           DS.save_enable = save_enable ;
           
           DS.FrameId = 0        ;
           DS.Connected = false  ;
           DS.CurrentTime = 0 ;
           DS.GUI.DAQ_Control  = DAQ_control;                   
           DS.GUI.ChannelView  = ChannelView ;
%            DS.GUI.SpikeSegView  = ChannelView ;
%            DS.GUI.Raster        = Raster      ;
           
           handles = guidata(DS.GUI.DAQ_Control);
           handles.SYS = DS ;
           guidata(DS.GUI.DAQ_Control,handles);          
           
           
           
      
           
%            DS.nChannels = uDAQ.Channels ;
%            DS.SamplesPerFrame=uDAQ.Samplerate;
            DS.nChannels = 120;
            DS.SamplesPerFrame=50000;

           DS.FramesInMemory   = 10;
           
           DS.TotalActivity=zeros(1000*DS.FramesInMemory,1); %1ms bins (Frames come per second) 
           DS.Mode = 0;
%           DS.uDAQ.SearchDevice()
           
%          handles = guidata(DS.GUI.Raster);
%          handles.SetupRaster(DS.nChannels,handles) ;

        
          DS.ProcessMode = 1 ;
          DS.ProcessInfo = ProcessInfo_Setup ;
          
          DS.Test = [] ;
        end
        
        function  StartACQ(DS)
            DS.Mode = 1;
            display(['Starting  Acquisition... Mode :' num2str(DS.Mode)]);             
            %DS.uDAQ.StartDAQ_Port_1(DS.Mode)
            DS.FrameId = 0;
            DS.ProcessInfo.State = 0;
            %Open File to save data
            if(DS.save_enable)                
                %save file id search
                id = 1 ;
                while(1)
                    filename = [DS.save_filename '_' num2str(id) '.dat'] ;
                    if(exist(filename,'file'))
                       id = id + 1 ;
                       continue ;
                    else
                        break ; 
                    end                    
                end
                DS.save_fid = fopen(filename, 'w');
                if(DS.save_fid == -1)
                    display(['ERROR : Could not open file to write : ' DS.save_filename]);
                    DS.save_enable = 0 ;
                else
                    fwrite(DS.save_fid,0   ,'uint32'); 
                    x = uint32(fix(clock))           ;
                    fwrite(DS.save_fid,x   ,'uint32');
                end
            end
            if(~isempty(DS.Test))
             DS.Test.start_session();
            end
        end
        function  StopACQ(DS)
            display('Stoping  Acquisition... ');
            %DS.uDAQ.StopDAQ_Port_1
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
        function DownLoadCode(DS)
            filename = 'C:\Users\45c\Firmware\RealTimeSystem\bin\RealTimeSystem.bin';
            %filename = 'C:\Users\45c\Firmware\StimCheck\bin\RealTimeSystem.bin';
            display(['Downloading Code ...' filename]);
            DS.uDAQ.Download_Code(filename);
        end
        function WriteRegister(DS,Address,Data)
            %display(['REG_WRITE : ' dec2hex(Address) '  ' num2str(Data)]);
            if(DS.uDAQ.WriteRegister(Address,Data)==0)
                display('Register Write Failed')
            end
        end
        function Data = ReadRegister(DS,Address)
            Data = DS.uDAQ.ReadRegister(Address) ;
            display(['REG_READ : ' dec2hex(Address) '  ' num2str(Data)]);           
        end
        %function LoadThreshold
            
        function DataAvailable(DS,sender,~)
            
           DataProcessMode = 1 ; % 1 Matlab processing 0 : DSP Processing
           DS.FrameId = DS.FrameId + 1 ;           
           display(['FrameID : ' num2str(sender.FrameCount) ' NumberofFrames :' num2str(sender.frames_read)  ' Channels :' num2str(sender.Channels)]);
           
           tic
           
           samples = sender.frames_read;
           %Y = reshape(int16(sender.data),sender.Channels,samples) ;
           Y = reshape(int32(sender.data),sender.Channels,samples) ;
%            size(Y);
%            
%            if(sender.FrameCount==1)
%                save('a1.mat','Y')
%            end

               
%             ll = 1:5:25;
%             Y(1:5,ll)
%             Y(121:124,ll)
% %            Y(1:10,samples-5:samples)
% %            Y(121:130,samples-5:samples)
           
           run_full=1;
           if(run_full)
               x = Y(4,:) ;
               display(['Average Time : ' num2str(mean(x))]) ;
               display(['Max Time     : ' num2str(max(x))]) ;

               %Data = Y(7:66,:);
               %StimTrigger = Y(69:70,:);    
               DS.CurrentTime = Y(3,1);
               Data = Y(5:64,:);
               StimTrigger  = Y(65:66,:); 
               SpikeEncoded = Y(67:70,:);
               
               %Y(66:70,1:5)
               %Expand Data
               nC = size(Data,1);
               nS  = size(Data,2);           
               Data = reshape(typecast(reshape(Data,[numel(Data) 1]),'int16'),[2*nC nS]);           
               
               StimTrigger  = double(reshape(typecast(reshape(StimTrigger,[numel(StimTrigger) 1]),'int32'),[2 nS]));
               %SpikeEncoded = double(reshape(typecast(reshape(SpikeEncoded,[numel(SpikeEncoded) 1]),'int32'),[4 nS]));
               
               %Save Samples
               if(DS.save_enable)                      
                 if(DS.save_fid >0)
                     fwrite(DS.save_fid,1   ,'uint32');
                     fwrite(DS.save_fid,DS.FrameId   ,'uint32');
                     fwrite(DS.save_fid,Data,'int16'); 
                 end
               end 
               
                
               Data = double(Data)';                         
               [StimConfig StimEvents] = StimDecode(StimTrigger) ;
              
               stop_acq = 0 ;
                for i=1:size(StimConfig,2)
                    Config = StimConfig(2,i);
                    Id     =  bitand(uint32(Config),(uint32(hex2dec('FFFF'))));
                    Mark   = (bitand(uint32(Config),(uint32(hex2dec('FFFF0000'))))/2^16);
              
                        switch(Mark)
                            case 0
                                 a = '  ';
                            case 1
                                 a = '* ';
                            case 2
                                 a = '> ';
                            case 3
                                 a = '*>';
                            otherwise
                                 a = '--';
                                 %num2str(Mark)
                                 %num2str(Config)
                        end
                 
                    display(['Config' a num2str(Id) ' @ '  num2str(StimConfig(1,i)) ]);
                end
                for i=1:size(StimEvents,2)
                    Event = StimEvents(2,i);
                    Id    = (bitand(uint32(Event),(uint32(hex2dec('FFFF0000'))))/2^16);
                    Event = bitand(uint32(Event),(uint32(hex2dec('FFFF'))));
                    
                    switch(Event)
                        case 1 
                            display(['Sequence Start : '  num2str(Id)] )
                            t1.ChannelStimResponse = zeros(120,1);
                        case 2
                            display(['Sequence Start(L)'  num2str(Id)]) 
                            t1.ChannelStimResponse = zeros(120,1);
                        case 3
                            display('Sequence End')
                            stop_acq = 1 ;
                           
                        otherwise
                            display('ERROR : Unknown Event')
                    end
                end
               
               %Show waveform
               handles  = guidata(DS.GUI.ChannelView);
               handles.DrawWaveForms(Data,handles,10,DS.ProcessInfo.Thresholds);  
               
               ProcessData ;  
               if(DataProcessMode==0)
                   
                   if(DS.ProcessInfo.State==2)
                       display('Loading Threshold Parameters to DSP...')
                       SendCommand(DS,2,DS.ProcessInfo.Thresholds)
                   end
                   
                   %Decode SpikeTimes
                   DS.ProcessInfo.spikeCounts = zeros(size(DS.ProcessInfo.spikeCounts));
                   SpikeDecode(DS.ProcessInfo.spike_times,DS.ProcessInfo.spikeCounts,SpikeEncoded);
               else
                   SpikeEncoded = zeros(4,size(Data,1));       
                   SpikeEncode(DS.ProcessInfo.spike_times,DS.ProcessInfo.spikeCounts,SpikeEncoded);  
               end
               
               
               if(~isempty(DS.Test))
                DS.Test.data_available(DS.ProcessInfo.spike_times,DS.ProcessInfo.spikeCounts,StimConfig,StimEvents)
               end
      
               handles.MarkSpikeTimes(handles,DS.ProcessInfo.spike_times,DS.ProcessInfo.spikeCounts);

               SpikeEncoded = zeros(4,size(Data,1));       
               SpikeEncode(DS.ProcessInfo.spike_times,DS.ProcessInfo.spikeCounts,SpikeEncoded);     
               
               %Save Additional Data
               if(DS.save_enable)                      
                 if(DS.save_fid >0)                     
                     fwrite(DS.save_fid,SpikeEncoded,'uint32');
                     fwrite(DS.save_fid,StimTrigger,'int32');
                 end
               end    
%                if(stop_acq==1) 
%                    DS.StopACQ()
%                end    
               display(['Time Spent : ' num2str((toc/1)*100) ' %']);
           end 
        end

        function DeviceStateChange(DS,sender,~)
            
            DS.Connected = logical(sender.DevicesReady);
            handle  = guidata(DS.GUI.DAQ_Control);
            if(sender.DevicesReady == true)
                display('Devices Connected');
                %Enable Acquisition               
                hObject = handle.tglACQ ;
                set(hObject,'Enable','on');
                set(hObject,'String','Start ACQ');
                set(hObject,'Value',false);
                
                hObject = handle.cmdDownloadCode ;
                set(hObject,'Enable','on');
                
                hObject = handle.lblStatus ;
                set(hObject,'String','DAQ Connected');
              
            else
                
                display('Devices DisConnected');
                
                hObject = handle.tglACQ ;
                set(hObject,'Enable','off'); 
                
                hObject = handle.cmdDownloadCode ;
                set(hObject,'Enable','off');
                
                
                hObject = handle.lblStatus ;
                set(hObject,'String','DAQ Not Connected');
            end
            drawnow();
        end  
        function SetTest(DS,Test)
            DS.Test = Test ;
        end
    end

    
end

