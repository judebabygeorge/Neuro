classdef DAQSys < handle
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
        function DS = DAQSys(uDAQ,save_enable,save_filename,HSSelected)
                    
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
           
           DS.nChannels = uDAQ.Channels ;
           DS.SamplesPerFrame=uDAQ.Samplerate;

           DS.FramesInMemory   = 10;
           
           DS.TotalActivity=zeros(1000*DS.FramesInMemory,1); %1ms bins (Frames come per second) 
           DS.Mode = 0;
           DS.uDAQ.SearchDevice()
           
%          handles = guidata(DS.GUI.Raster);
%          handles.SetupRaster(DS.nChannels,handles) ;

        
          DS.ProcessMode = 1 ;
          DS.ProcessInfo = ProcessInfo_Setup ;
          
          DS.Test = [] ;
          DS.nDecoders = 0;
          
        end
        
        function  Out = StartACQ(DS,save_enable,filename)
            Out = 0 ;
            if(save_enable == 2)
                save_enable = DS.save_enable;
            end
            
            if(DS.Connected)
                DS.Mode = 1;
                DS.CurrentTime = -1 ;
                display(['Starting  Acquisition... Mode :' num2str(DS.Mode)]);             
                DS.uDAQ.StartDAQ_Port_1(DS.Mode)
                DS.FrameId = 0;
                DS.ProcessInfo.State = 0;
                DS.save_enable = save_enable ;
                %Open File to save data
                if(DS.save_enable)      
                    display('Saving Acquisition')
                    if(isempty(filename))
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
                    end

                    DS.save_fid = fopen(filename, 'w');
                    if(DS.save_fid == -1)
                        display(['ERROR : Could not open file to write : ' DS.save_filename]);
                        DS.save_enable = 0 ;
                    else
                        display(['Logging data to ' filename]);
                       
                        fwrite(DS.save_fid,DS.save_mode   ,'uint32'); 
                      
                        x = uint32(fix(clock))           ;
                        fwrite(DS.save_fid,x   ,'uint32');
                    end
                    Out = 1;
                end

                if(~isempty(DS.Test))
                  DS.nDecoders = size(DS.Test.Tests{DS.Test.CurrentTest}.StimConfig.DecodeWeights,2);
                  display(['Number of Decoders : ' num2str(DS.nDecoders)]);
                  if(DS.nDecoders >0)
                      DS.Stats.Patterns = DS.Test.Tests{DS.Test.CurrentTest}.StimConfig.PatternId;
                      DS.Stats.DecodeStats = zeros(DS.nDecoders,DS.nDecoders);
                      DS.Stats.TotalFrames = 0;
                      for i=1:DS.nDecoders
                          DS.Stats.StimTrainStats{i}.Dout  = zeros(2,1000);%[FrameNumber,DecoderOut]
                          DS.Stats.StimTrainStats{i}.nStim = 0;
                          DS.Stats.StimTrainStats{i}.Y     = ones(1,1000)*nan;  
                      end
                  else
                      DS.Stats.Patterns = [];
                      DS.Stats.DecodeStats = [];
                      DS.Stats.StimTrainStats= [];
                  end
                 DS.Test.start_session();
                end
            else
                display('DAQ Hardware not Connected')
            end
        end
        function  Out = StopACQ(DS)
            Out = 0 ;
            if(DS.Connected)
                display('Stoping  Acquisition... ');
                DS.uDAQ.StopDAQ_Port_1
                
                if(DS.save_enable)                
                    if(DS.save_fid > 0)
                        fwrite(DS.save_fid,2   ,'uint32');
                        fwrite(DS.save_fid,DS.FrameId   ,'uint32');                
                        fclose(DS.save_fid);
                        display(['Frames in File : ' num2str(DS.FrameId) ]);
                        DS.save_fid = -1 ;
                    end
                end
                Out = 1 ;
            else
               display('DAQ Hardware not Connected') 
            end
        end
        function DownLoadCode(DS)
            if(DS.HSSelected==1)
                filename = 'C:\Users\45c\Firmware\RealTimeSystem_HS1.bin';
            else
                filename = 'C:\Users\45c\Firmware\RealTimeSystem_HS2.bin';
            end
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
           
           display(['FrameID : ' num2str(sender.FrameCount) ' NumberofFrames :' num2str(sender.frames_read)  ' Channels :' num2str(sender.Channels)]);
           frame_valid = 1 ;
           tic
           
           samples = sender.frames_read;
           %Y = reshape(int16(sender.data),sender.Channels,samples) ;
           Y = reshape(int32(sender.data),sender.Channels,samples) ;

               x = Y(4,:) ;
               display(['Average Time : ' num2str(mean(x))]) ;
               display(['Max Time     : ' num2str(max(x))]) ;

  
               if(DS.CurrentTime > 0)
                   start_time = DS.CurrentTime + 50000 ;                                     
                   x = Y(3,1);
                   
                   if(x ~= start_time)
                       display('');
                       display('ERROR IN FRAME')
                       display('');
                       frame_valid = 0 ;
                       
                   end
                   if(sum(diff(x))~=0)
                       display('ERROR IN FRAME')                       
                       frame_valid = 0 ;
                   end                   
               end               
               if(frame_valid==0)     
                   DS.CurrentTime = -1;
                   return;
               end
               
              
               
               DS.CurrentTime = Y(3,1);
               DS.FrameId = DS.FrameId + 1 ; 
               Data = Y(5:64,:);
               StimTrigger  = Y(65:66,:); 
               SpikeEncoded = Y(67:70,:);
               OutEncoded   = Y(71:80,:);
               
              
               nC = size(Data,1);
               nS  = size(Data,2);           
               Data = reshape(typecast(reshape(Data,[numel(Data) 1]),'int16'),[2*nC nS]);           
              
                        
               Data = Data(1:DS.ProcessInfo.nC,:);
               
               
               StimTrigger  = double(reshape(typecast(reshape(StimTrigger,[numel(StimTrigger) 1]),'int32'),[2 nS]));
               SpikeEncoded  = double(reshape(typecast(reshape(SpikeEncoded,[numel(SpikeEncoded) 1]),'uint32'),[4 nS]));
               %size(OutEncoded)
               %nS
               OutEncoded  = double(reshape(typecast(reshape(OutEncoded,[numel(OutEncoded) 1]),'uint32'),[10 nS]));
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
               
             
               DecoderOut = OutputDecode(OutEncoded);
             
               
               stop_acq = 0 ;
               
               for i=1:size(StimEvents,2)
                    Event = StimEvents(2,i);
                    
                    if Event > 0
                        a = typecast(uint32(Event),'uint8');
                    else
                        a = typecast(int32(Event),'uint8');
                    end
                    
                    Event  = a(1);
                    Id     = a(2);
                    
                    switch(Event)
                        case 1 
                            display(['**Sequence Start : '  num2str(Id) ' @' num2str(typecast(a(3:4),'uint16'))] )
                            t1.ChannelStimResponse = zeros(120,1);
                        case 9 
                            display(['Pat**Sequence Start : '  num2str(Id) ' @' num2str(typecast(a(3:4),'uint16'))] )
                            t1.ChannelStimResponse = zeros(120,1);
                        case 2
                            display(['**Sequence Start(L)'  num2str(Id)]) 
                            t1.ChannelStimResponse = zeros(120,1);
                        case 3
                            display('**Sequence End')
                            stop_acq = 1 ;
                        case 4
                            display('**Pattern shift')
                        case 5
                            display(['**Decoder Enable : '  num2str(typecast(a(3:4),'uint16'))]) 
                            t1.ChannelStimResponse = zeros(120,1);     
                        case 6
                            display(['**Decoder Out : '  num2str(typecast(a(3:4),'uint16'))]) 
                            t1.ChannelStimResponse = zeros(120,1);  
                           
                        otherwise
                            display(['ERROR : Unknown Event ' num2str(Event) ] )
                    end
                end               
                for i=1:size(StimConfig,2)
                    Config = StimConfig(2,i);
                    a = typecast(uint32(Config),'uint8');
                    Pattern = a(1);
                    Element = a(2);   
                    
                    display(['** Pattern : '  num2str(Pattern) ' Element : ' num2str(Element) '  Config : ' num2str(a(3:4)) '  @ '  num2str(StimConfig(1,i))]);
                end
                if(~isempty(DecoderOut))
                    for i=1:size(DecoderOut,2)
                        display(['Decoder Output at : ' num2str(DecoderOut(1,i)) ]);
                        a = typecast(uint32(DecoderOut(2:(DS.nDecoders+1),i)),'uint16');
                        a1 = a(2:2:end);
                        a2 = typecast(a(1:2:end),'int16');                    
                        for j=1:numel(a1)
                            display(['Decoder ' num2str(a1(j)) ' : ' num2str(a2(j)) ] );
                        end
                    end
                end
                
                %Find the number of unique patterns
                Pid = [];
                if((size(StimConfig,2)>0))
                    Pid = zeros(size(StimConfig,2),1);
                    for i=1:size(StimConfig,2)
                        Config = StimConfig(2,i);
                        a = typecast(uint32(Config),'uint8');
                        a = double(a(1));    
                        Pid(i)=a;
                    end
                end
                
                if(0)
                    [~,m,~]=unique(Pid);
                    Pid =Pid(sort(m,'ascend'));

                    if((numel(Pid)>0)&&(numel(Pid) == size(DecoderOut,2)))                      
                        M = zeros(numel(Pid) , 1 + 2*DS.nDecoders);
                        for i=1:numel(Pid)                                               
                            b = typecast(uint32(DecoderOut(2:DS.nDecoders+1,i)),'uint16');
                            a1 = double(b(2:2:end));
                            a2 = double(typecast(b(1:2:end),'int16'));  
                            M(i,:) =  [Pid(i)  a1' a2'] ;
                        end
                        DS.DecoderStats(M,sender.FrameCount);
                        display(DS.Stats.DecodeStats)
                    end
                end
               
               
               %Show waveform
               handles  = guidata(DS.GUI.ChannelView);
               handles.DrawWaveForms(Data,handles,10,DS.ProcessInfo.Thresholds);  
               
               ProcessData ;                 
               if(DS.ProcessInfo.State==2)
                       display('Loading Threshold Parameters to DSP...')
                       SendCommand(DS,2,DS.ProcessInfo.Thresholds)
               end
               if(DataProcessMode==0)
                   %Decode SpikeTimes
                   DS.ProcessInfo.spikeCounts = zeros(size(DS.ProcessInfo.spikeCounts));
                   SpikeDecode(DS.ProcessInfo.spike_times,DS.ProcessInfo.spikeCounts,SpikeEncoded);
               else
                   SpikeEncoded = zeros(4,size(Data,1));       
                   SpikeEncode(DS.ProcessInfo.spike_times,DS.ProcessInfo.spikeCounts,SpikeEncoded);  
               end
                             
               
               handles.MarkSpikeTimes(handles,DS.ProcessInfo.spike_times,DS.ProcessInfo.spikeCounts);
            
         
               
               %Save Additional Data
          
                   if(DS.save_enable)                      
                     if(DS.save_fid >0)                     
                         fwrite(DS.save_fid,SpikeEncoded,'uint32');
                         fwrite(DS.save_fid,StimTrigger,'int32');
                         if(DS.save_mode ==3 || DS.save_mode == 4)
                           fwrite(DS.save_fid,OutEncoded,'uint32');
                         end
                     end
                   end  
                   
   if(0)
               if(stop_acq==1) 
                    display('');
                    display('ACQUISITION COMPLETE')
                    display('');               
               end
   end       
   
               if(~isempty(DS.Test))
                  Event = 'na' ;
                  if(DS.ProcessInfo.State==2)
                      Event = 'init_complete' ;
                  end
                  if(stop_acq==1)
                      display('Sequence Complete')
                      Event = 'sequence_complete' ;
                  end
                  DS.Test.data_available(Event,DS.ProcessInfo.spike_times,DS.ProcessInfo.spikeCounts,StimConfig,StimEvents);
                  if DS.nDecoders >0
                    DS.Test.UpdateDecodeStats(DS.Stats);
                  end
               end
               
               display(['Time Spent : ' num2str((toc/1)*100) ' %']);         
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
               
                pause(0.1);
                DS.DownLoadCode();
                
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
        function  DecoderStats(DS,M,FrameNumber)
            
            for i=1:size(M,1)
                DS.Stats.TotalFrames = FrameNumber;
                Pid = find(DS.Stats.Patterns==M(i,1),1) ;  
                if(isempty(Pid))
                    sprintf('Warning : Pattern %d not found in list for decoders',M(i,1));
                else
                    DS.Stats.DecodeStats(Pid,M(i,2)) =DS.Stats.DecodeStats(Pid,M(i,2))+1 ; 
                    DS.Stats.StimTrainStats{Pid}.nStim = DS.Stats.StimTrainStats{Pid}.nStim + 1 ;
                    DS.Stats.StimTrainStats{Pid}.Dout(:,DS.Stats.StimTrainStats{Pid}.nStim)  = [FrameNumber M(i,2)]';                    
                end                       
            end
            
            nAverage = 3;
            for i=1:numel(DS.Stats.StimTrainStats)
                d = DS.Stats.StimTrainStats{Pid}.Dout(:,DS.Stats.StimTrainStats{Pid}.nStim) ;
                d = d(2,d(1,:) > (DS.Stats.TotalFrames - nAverage));
                if (numel(d)>=5)
                    DS.Stats.StimTrainStats{i}.Y(DS.Stats.TotalFrames)=sum(d==i)/numel(d);
                else
                    DS.Stats.StimTrainStats{i}.Y(DS.Stats.TotalFrames)=nan;
                end
                
            end
           
        end
    end

    
end

