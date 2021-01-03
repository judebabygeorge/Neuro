classdef exp2 < handle

    
    properties
        DS
        GUI
        
        %Variables
        ChannelSpikeCount 
        ChannelStimResponse
        
        StimElectrodeBlank
        
        save_enable 
        TestConfigGlobal
        TestData 
        Tests
        CurrentTest    
        TestRunning
        EnableAutoStop
        
    end
    
    methods
        function t1 = exp2(DS)
            t1.DS = DS ;            
             
            
            t1.ChannelSpikeCount   = zeros(120,1);
            t1.ChannelStimResponse = zeros(120,120);
            
            t1.StimElectrodeBlank.nS   = 3 ;
            t1.StimElectrodeBlank.Id   = 1 ;
            t1.StimElectrodeBlank.Mask = zeros(120,t1.StimElectrodeBlank.nS);            
            
            DS.SetTest(t1);         
            
            %Load The test Sequence information
            exp2_tests;
           
            t1.CurrentTest = 0 ;
            t1.TestData = [];
            t1.TestRunning = 0 ;
            t1.save_enable=0;
            t1.EnableAutoStop = 1;
            t1.GUI.test1_gui = exp2_gui ;
            handles = guidata(t1.GUI.test1_gui);
            
            cl = findobj(handles.output,'Tag','lbl_Culture') ;
            set(cl,'String',[t1.TestConfigGlobal.Culture ' : ' t1.TestConfigGlobal.DIV]);
          
            
            handles.Test = t1 ;
            TestSelector = handles.CreateTestSelector(handles,t1.Tests);
            handles.TestSelector=TestSelector;
            
            guidata(t1.GUI.test1_gui,handles);      
            
            t1.TestSelectionChange(1);
        end
        
        function Mask = StimElectrodeBlanking(t1,E)
           t1.StimElectrodeBlank.Mask(:,t1.StimElectrodeBlank.Id) =  E ;
           t1.StimElectrodeBlank.Id =t1.StimElectrodeBlank.Id  + 1 ;
           if(t1.StimElectrodeBlank.Id >t1.StimElectrodeBlank.nS)
               t1.StimElectrodeBlank.Id  = 1;
           end
            Mask = (sum(t1.StimElectrodeBlank.Mask,2) > 0);
        end
  
        function start_session(t1)
            t1.ChannelSpikeCount = zeros(120,1);
            t1.StimElectrodeBlank.Mask = zeros(120,t1.StimElectrodeBlank.nS);
            t1.ChannelStimResponse = zeros(120,120);
        end      
        
        
        function setup_stimulation(t1)
            
            display('Setting up Stimulation ')
            display('---------------------- ')        
          
            display('Pulse Pattern Load')
            [Array ~] = Stim_GenStimulusPattern(0,0.5);
            SendCommand(t1.DS,4,Array);            
 
           
            LoadStimulusPatternConfig(t1.DS,t1.Tests{t1.CurrentTest}.StimConfig)  ;  
            if(~isempty(t1.Tests{t1.CurrentTest}.StimConfig.DecodeWeights))
              display('Loading Weights')
              LoadDecoderWeights(t1.DS,t1.Tests{t1.CurrentTest}.StimConfig.DecodeWeights,t1.Tests{t1.CurrentTest}.StimConfig.DecodeCheckWindow)
            end
            if(strcmp(t1.Tests{t1.CurrentTest}.TestConfig.mode,'training_1'))
                h=guidata(t1.GUI.test1_gui); 
                hl = findobj(h.output,'Tag','lstTestMode');
            
                SelectedTrain = get(hl,'Value');
                s = get(hl,'String');
                display(['Loading StimTrain Patterns : ' s{SelectedTrain}]);
                
                LoadStimTrainSequence(t1.DS,t1.Tests{t1.CurrentTest}.StimConfig.StimTrain{SelectedTrain});
            end         
            
        end

        function start_stimulation(t1)
            display('Starting Stimulation ')
            display('-------------------- ')
            
            Start     = 0   ;
            End       = 2*numel(t1.Tests{t1.CurrentTest}.StimConfig.PatternSequence) -1;
            nLoop     = t1.Tests{t1.CurrentTest}.StimConfig.nLoop ;
            Trigger   = 9   ;            
            CurrentTime     = t1.DS.CurrentTime + 2000  ; %Align to Sample Number 2000
            
            Start_StimPatternSequence(t1.DS,Start,End,nLoop,Trigger,CurrentTime);            
        end
        
        function out = RunTests(t1,status,id,save_enable)
            out = 'na' ;
            
            if(t1.DS.Connected)
                switch status
                    case 'next'
                        if(t1.CurrentTest < numel(t1.Tests))                             
                             id = t1.CurrentTest + 1 ;  
                             t1.Start_TestRun(id,save_enable) ;
                        else
                            out = 'test_seq_complete' ; 
                        end
                    case 'test'                        
                        if(id <= numel(t1.Tests))
                            t1.Start_TestRun(id,save_enable) ;
                        end
                    case 'init_complete'  
                        if(t1.TestRunning)
                           switch(t1.Tests{t1.CurrentTest}.TestConfig.mode)
                               case 'RobotCheck'
                                  display('Robot Loop Triggered Stimulation Started');
                                  SendCommand(t1.DS,17,[(t1.DS.CurrentTime + 100) 1]);
                                  t1.EnableAutoStop = 0;
                               case 'training_1'
                                  display('Stimulus Train Started...');
                                  SendCommand(t1.DS,17,[(t1.DS.CurrentTime + 100) 2]);
                                  t1.EnableAutoStop = 0;
                               case 'CLProbe'
                                  display('Closed Loop Protocol Started');
                                  SendCommand(t1.DS,17,[(t1.DS.CurrentTime + 100) 3]);
                                  t1.EnableAutoStop = 0;
                               case 'CLTrain'
                                  display('Closed Loop Train Protocol Started');
                                  SendCommand(t1.DS,17,[(t1.DS.CurrentTime + 100) 4]);
                                  t1.EnableAutoStop = 0;
                               otherwise
                                  t1.start_stimulation() ;
                           end                          
                        end
                    case 'sequence_complete'
                        if ((t1.EnableAutoStop==1)||((t1.Tests{t1.CurrentTest}.TotalFrames - t1.DS.FrameId)<15) )
                            t1.DS.StopACQ();
                            pause(0.1);
                            t1.TestData = t1.Tests{t1.CurrentTest}.post_run(t1.TestData) ;
                            out = 'callback';
                            display(['Test Complete :' t1.Tests{t1.CurrentTest}.TAG]);
                            t1.TestRunning  = 0;
                            if(t1.CurrentTest == numel(t1.Tests))
                                display('!!! PROTOCOLS  COMPLETE !!!');
                            end
                        end
                end
            else
                display('DAQ Hardware not Connected')
            end
        end
        function Start_TestRun(t1,id,save_enable)   
            
               t1.CurrentTest = id ;
               display(['Running Test > ' t1.Tests{t1.CurrentTest}.TAG]);   
               
               if(t1.Tests{t1.CurrentTest}.DoACQ == 1)
                   %t1.Tests{t1.CurrentTest}.pre_run(t1.TestData) ;
                   filename = t1.Tests{t1.CurrentTest}.data_filename;
                   t1.setup_stimulation();
                   t1.save_enable=save_enable;
                   t1.TestRunning = 1;

                   handles  = guidata(t1.GUI.test1_gui);   
                   set(handles.lblCurrentTest,'String',[t1.Tests{t1.CurrentTest}.TAG ' : ' num2str(t1.Tests{t1.CurrentTest}.TotalFrames)]);
                   t1.Tests{t1.CurrentTest}.TAG 
                   if strcmp(t1.Tests{t1.CurrentTest}.TestConfig.mode , 'RobotCheck') || strcmp(t1.Tests{t1.CurrentTest}.TestConfig.mode , 'training_1') 
                        t1.EnableAutoStop = 0;                        
                        display('Set up Performance Matrix');
                        h=guidata(t1.GUI.test1_gui);                        
                        h.hPerformanceMatix = h.SetupPerformanceMatix(h,[600 250],t1.Tests{t1.CurrentTest}.StimConfig.PatternId);
                        h.hAccuracyTracker = h.SetupClassificationAccuracyTracker(h,[600 320],t1.Tests{t1.CurrentTest}.StimConfig.PatternId);
                        guidata(t1.GUI.test1_gui,h);                                                 
                   else
                       t1.EnableAutoStop = 1;
                   end
                   t1.DS.StartACQ(save_enable,filename);
               else
                   t1.TestData = t1.Tests{t1.CurrentTest}.ExecuteTask(t1.TestData);
               end
               
        end
        function data_available(t1,Event,spike_times,spike_count,StimConfig,StimEvents)
           
            if((t1.Tests{t1.CurrentTest}.TotalFrames - t1.DS.FrameId)<0)   
                t1.Tests{t1.CurrentTest}.TotalFrames
                t1.DS.FrameId
                display 'Data 2!'
                if(t1.CurrentTest ~=0)
                    out = t1.RunTests('sequence_complete',0,t1.save_enable);
                end
            else
                out = t1.RunTests(Event,0,t1.save_enable);
            end
            
            if(t1.CurrentTest ~=0)
                handles  = guidata(t1.GUI.test1_gui);   
                set(handles.lblCurrentTest,'String',[t1.Tests{t1.CurrentTest}.TAG ' : ' num2str(t1.Tests{t1.CurrentTest}.TotalFrames - t1.DS.FrameId)]);
            end
            
            switch out
                case 'callback'
                case 'test_seq_complete'
                    display('!!! PROTOCOLS  COMPLETE !!!')
            end
            
            %%Update Graphics 
            E = zeros(120,1);  
            for i=1:size(StimConfig,2)
                    sConfig = StimConfig(2,i);
                    a = typecast(uint32(sConfig),'uint8');                                          
                    Ei = t1.Tests{t1.CurrentTest}.StimConfig.Electrodes(:,a(4));   
                    Ei = Ei(Ei~=0);
                    E(Ei) = E(Ei) + 1 ;                    
            end   
            A = (E>0);
            handles  = guidata(t1.GUI.test1_gui);   
            handles.ShowElectrodeActivity(handles,1,A,zeros(size(E)));  
        end
        function ForceStopAcq(t1)
            t1.DS.StopACQ();
            pause(2);
            display('Stopping...')
            pause(2);
            
            if (t1.Tests{t1.CurrentTest}.TestConfig.StimulusMode == 2) 
                display('Auto Stimulation Stop');
                SendCommand(t1.DS,17,[(t1.DS.CurrentTime + 100) 0]);
            end
            t1.TestRunning  = 0;
            display(['Test Complete :' t1.Tests{t1.CurrentTest}.TAG]);
            t1.TestData = t1.Tests{t1.CurrentTest}.post_run(t1.TestData) ;                        
            
        end
        function LoadSettings(t1,filename)
            display(['Loading Settings from ' filename]);
            a = load(filename);
            t1.TestData.ElectrodePreference= a.E ;
        end
        function UpdateDecodeStats(t1,Stats)
             if (strcmp(t1.Tests{t1.CurrentTest}.TestConfig.mode , 'RobotCheck') || strcmp(t1.Tests{t1.CurrentTest}.TestConfig.mode , 'training_1'))                    
                h=guidata(t1.GUI.test1_gui); 
                h.UpdateDecoderPerformance(h.hPerformanceMatix,Stats.DecodeStats);
                h.UpdateClassificationAccuracy(h.hAccuracyTracker,Stats);
             end
        end
        function TestSelectionChange(t1,SelectedTest)
            if(t1.Tests{SelectedTest}.DoACQ == 1)
                   t1.Tests{SelectedTest}.pre_run(t1.TestData) ;
            end
            h=guidata(t1.GUI.test1_gui); 
            set(findobj(h.output,'Tag','lstTestMode'),'String',t1.Tests{SelectedTest}.ConfigOptions);
        end
    end
    
end

