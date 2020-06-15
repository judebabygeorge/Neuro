classdef test_PatternCheck < handle

    
    properties
        
        TAG    
        TestConfig
        DoACQ
        ConfigOptions
        
        data_filename
        StimConfig 
        
        TotalFrames
    end
    
    methods
        function test = test_PatternCheck(Config,mode,nE,PatternDelay)
            
            test.TAG = ['PatternCheck_' num2str(nE) '_' num2str(PatternDelay) '_' mode] ;            
            %%Config will have save diectory , culture id , DIV
            test.TestConfig = Config ;
            test.TestConfig.mode = mode;
            test.TestConfig.StimulusMode = 1;
            test.TestConfig.nE = nE  ;
            test.TestConfig.PatternDelay = PatternDelay;
            test.TestConfig.RepeatCount    = 0;
            test.TestConfig.RepeatInterval = 1;            
            test.ConfigOptions = {' '};
            
            test.DoACQ      = 1      ;
            
            test.TotalFrames = 0 ;
            test.StimConfig  = [] ;
          
        end
        
        %% PRE RUN FUNCTION
        %  Any Test propeties that need to be update
        %  Config structure must have any inputs that are
        %  required to create the test
        function pre_run(test,RunConfig)     
            
            
            if(isempty(test.StimConfig) || strcmp(test.TestConfig.mode(1:5) ,'train')||strcmp(test.TestConfig.mode ,'RobotCheck')|| ...
                strcmp(test.TestConfig.mode ,'paired_train')||strcmp(test.TestConfig.mode ,'PairedTrain_Theta')|| ...
                strcmp(test.TestConfig.mode ,'paired_train_probe')||strcmp(test.TestConfig.mode ,'TrainHF') ||strcmp(test.TestConfig.mode ,'CLProbe') ||... 
                strcmp(test.TestConfig.mode ,'CLTrain')||strcmp(test.TestConfig.mode ,'Imaging_spont_short')||strcmp(test.TestConfig.mode ,'Imaging_spont')||...
                strcmp(test.TestConfig.mode ,'Imaging_long')||strcmp(test.TestConfig.mode ,'Imaging1'))                
                 % For every rerun use the same StimConfig except in training
                display([test.TAG ' ' ' Pre run setup']);
                %Create and/or Load the corresponding StimConfig file 
                %Load Electrode info if exists
                filename = sprintf('%s%s\\%s\\ElectrodeOrder.mat',test.TestConfig.RunDir,test.TestConfig.Culture,test.TestConfig.DIV);
                if(exist(filename,'file'))
                    a  = load(filename);   
                    display(['Loading Settings from  '  filename]);
                    RunConfig.ElectrodePreference = a.E;
                end
                Electrodes = RunConfig.ElectrodePreference(1:8)';
                nSamples   = 45                                 ;
                if(test.TestConfig.nE == 1)    
                    nSamples = 10 ;
                    switch(test.TestConfig.mode)
                        case 'single'                         
                             test.StimConfig = CreateSequence_SingleRandom(RunConfig.ElectrodePreference(1:4)',120,test.TestConfig.PatternDelay); 
                        case 'interleaved'
                             test.StimConfig = GenerateStimulusConfig_Interleaved (RunConfig.ElectrodePreference(1:4)',RunConfig.ElectrodePreference(5:12)',8,127,test.TestConfig.PatternDelay,0);
                    end
                else
                    switch(test.TestConfig.mode)
					    case 'two_time_seq3'
                           nSamples = 45;
                           test.StimConfig = GenerateStimulusConfig_TwoInput_time_seq3 (Electrodes,127,test.TestConfig.PatternDelay,50);
                        case 'two_time_seq4'
                           nSamples = 45;
                           test.StimConfig = GenerateStimulusConfig_TwoInput_time_seq4 (Electrodes,127,test.TestConfig.PatternDelay,50);
                        case 'two_time_seq5'
                           nSamples = 45;
                           file = 'PatternCheck_2_250_two_time_seq4';
                           PatternData = test.GetRecentPatternData(file);
                           test.StimConfig = GenerateStimulusConfig_TwoInput_time_seq5 (PatternData);
                        case 'ndim_all'
                           test.StimConfig = GenerateStimulusConfig_ndim_all (Electrodes,127,3,test.TestConfig.PatternDelay,3);
                        case 'ndim_all_2'
                           test.StimConfig = GenerateStimulusConfig_ndim_all_2 (Electrodes,127,3,test.TestConfig.PatternDelay,3);  
                        case 'Random8'
                           nSamples   = 45;
                           test.StimConfig = GenerateStimulusConfig_Random8 (Electrodes,127,test.TestConfig.PatternDelay,5); 
                        case 'Random8_selected'
                           nSamples   = 20;
                           test.StimConfig = RunConfig.DecodeTask.StimConfig;                        
                        case 'RobotCheck'
                            
                           nSamples   = 200;
                           
                           Config = LoadLatestConfig(test,'DecodeConfig');
                            if(isempty(Config))
                               display('Warning : File not found to load from. Loading from test...');
                               Config = RunConfig;
                            end

                           test.StimConfig = Config.DecodeTask.StimConfig;
                           test.StimConfig.PatternSequence = Config.DecodeTask.StimConfig.PatternId;
                           test.StimConfig.p = numel(Config.DecodeTask.StimConfig.PatternId); 
                           
                           test.StimConfig.nSeq=1;
                           test.StimConfig.nLoop=1;
                           test.StimConfig.PatternInterval=test.TestConfig.PatternDelay;
                           test.TestConfig.StimulusMode = 2;
                        case 'train_0'
                           nSamples   = 2400;
                           %nSamples = 127;
                           
                           test.StimConfig = RunConfig.DecodeTask.StimConfig; 
                           %test.StimConfig.PatternInterval = 250;
                           %test.StimConfig.PatternInterval = 30 ;
                        case 'test_0'
                           nSamples   = 45;
                           test.StimConfig = RunConfig.DecodeTask.StimConfig_Test; 
                           
                        case 'training_1'
                            nSamples   = 20000;
                           Config = LoadLatestConfig(test,'TrainConfig');
                           test.StimConfig = Config.DecodeTask.StimConfig;
                           test.StimConfig.PatternSequence = Config.DecodeTask.StimConfig.PatternId;
                           test.StimConfig.p = numel(Config.DecodeTask.StimConfig.PatternId); 

                           test.StimConfig.nSeq=1;
                           test.StimConfig.nLoop=1;
                           test.StimConfig.PatternInterval=test.TestConfig.PatternDelay;
                           test.TestConfig.StimulusMode = 2;
                           
                           test.ConfigOptions={'BaseLine','Train_1','Train_2','Train_None'};
                        case 'RobotEncodingTest'
                            nSamples = 45;
                            file = 'PatternCheck_2_250_two_time_seq4';
                            PatternData = test.GetRecentPatternData(file);
                            test.StimConfig = GenerateStimulusConfig_RobotEncodingTest(PatternData);    
                        case 'ContextDependenceCheck'
                            nSamples = 45;
                            file = 'PatternCheck_2_250_two_time_seq4';
                            PatternData = test.GetRecentPatternData(file);
                            test.StimConfig = GenerateStimulusConfig_ContextDependenceCheck(PatternData);  
                        case 'paired_train'
                           nSamples = 45*10*3;
                           %filename = sprintf('%s%s\\%s\\StimConfigTrain.mat',test.TestConfig.RunDir,test.TestConfig.Culture,test.TestConfig.DIV);
%                            if(exist(filename,'file'))
%                                a  = load(filename,'StimConfigProbe');
%                                test.StimConfig = a.StimConfigProbe;
%                            else
                                file = 'PatternCheck_2_250_paired_train_probe';
                                PatternData = test.GetRecentPatternData(file);
                                StimConfigTrain = GenerateStimulusConfig_PairedTrain(PatternData);    
                                %save(filename,'StimConfigTrain');
                                test.StimConfig = StimConfigTrain;
%                            end                                                                         
                        case 'PairedTrain_Theta'
                                                   
                            file = 'PatternCheck_2_250_paired_train_probe';
                            PatternData = test.GetRecentPatternData(file);
                            
                            nSamples = 45*10*3; 
                            %StimConfigTrain = GenerateStimulusConfig_PairedTrain_Theta(PatternData);
                            
                            nSamples = 45*10*3;   
                            StimConfigTrain = GenerateStimulusConfig_PairedTrain_Theta1(PatternData); 
                            %save(filename,'StimConfigTrain');
                            test.StimConfig = StimConfigTrain;
%                            end      
                        case 'paired_train_probe'
                            nSamples = 45;
                            filename = sprintf('%s%s\\%s\\StimConfigProbe.mat',test.TestConfig.RunDir,test.TestConfig.Culture,test.TestConfig.DIV);
                            if(exist(filename,'file'))
                               a  = load(filename,'StimConfigProbe');
                               test.StimConfig = a.StimConfigProbe;
                            else
                                file = 'PatternCheck_2_250_two_time_seq4';
                                PatternData = test.GetRecentPatternData(file);
                                %StimConfigProbe = GenerateStimulusConfig_PairedTrainProbe(PatternData);
                                StimConfigProbe = GenerateStimulusConfig_PairedTrainProbe1(PatternData);
                                %StimConfigProbe = GenerateStimulusConfig_ExploreLearning(PatternData);
                                save(filename,'StimConfigProbe');
                                test.StimConfig = StimConfigProbe;
                            end
                        case 'ProbeHF'
                            filename = sprintf('%s%s\\%s\\ElectrodeOrder.mat',test.TestConfig.RunDir,test.TestConfig.Culture,test.TestConfig.DIV);
                            if(exist(filename,'file'))
                                a  = load(filename);   
                                display(['Loading Settings from  '  filename]);
                                RunConfig.ElectrodePreference = a.E;
                            end
                            Electrodes = RunConfig.ElectrodePreference(1:8)';
                            test.StimConfig=GenerateStimulusConfig_ProbeHF (Electrodes,120,250,5);
                            nSamples = 45;
                        case 'TrainHF'
                            filename = sprintf('%s%s\\%s\\ElectrodeOrder.mat',test.TestConfig.RunDir,test.TestConfig.Culture,test.TestConfig.DIV);
                            if(exist(filename,'file'))
                                a  = load(filename);   
                                display(['Loading Settings from  '  filename]);
                                RunConfig.ElectrodePreference = a.E;
                            end
                            Electrodes = RunConfig.ElectrodePreference(1:8)';
                            test.StimConfig=GenerateStimulusConfig_TrainHF (Electrodes,120,5,250,5);
                            nSamples = 2400 ;
                        case 'Dummy'
                           nSamples   = 45*3;
                           test.StimConfig = GenerateStimulusConfig_Dummy (Electrodes,127,test.TestConfig.PatternDelay,5); 
                           test.TestConfig.StimulusMode = 4;
                           
                         case 'probe_scan'
                            nSamples = 45;
                            filename = sprintf('%s%s\\%s\\StimConfigProbe.mat',test.TestConfig.RunDir,test.TestConfig.Culture,test.TestConfig.DIV);
                            if(exist(filename,'file'))
                               a  = load(filename,'StimConfigProbe');
                               test.StimConfig =a.StimConfigProbe;
                            else
                               error('Probe Sequence does not exist')
                            end
                         case 'train_protocol'
                            nSamples = 45*25;
                            filename = sprintf('%s%s\\%s\\StimConfigTrain.mat',test.TestConfig.RunDir,test.TestConfig.Culture,test.TestConfig.DIV);
                            if(exist(filename,'file'))
                               a  = load(filename,'StimConfigTrain');
                               test.StimConfig =a.StimConfigTrain;
                            else
                               error('Train Sequence does not exist')
                            end
                         case 'CLProbe'
                            nSamples = 45*10;
                            filename = sprintf('%s%s\\%s\\StimConfigProbe.mat',test.TestConfig.RunDir,test.TestConfig.Culture,test.TestConfig.DIV);
                            if(exist(filename,'file'))
                               a  = load(filename,'StimConfigProbe');
                               test.StimConfig =a.StimConfigProbe;
                            else
                               error('Probe Sequence does not exist')
                            end   
                            test.TestConfig.StimulusMode = 5;
                         case 'CLTrain'
                            %nSamples = 45*16;
                            nSamples = 45*6;
                            filename = sprintf('%s%s\\%s\\StimConfigTrain.mat',test.TestConfig.RunDir,test.TestConfig.Culture,test.TestConfig.DIV);
                            if(exist(filename,'file'))
                               a  = load(filename,'StimConfigTrain');
                               test.StimConfig =a.StimConfigTrain;
                            else
                               error('Train Sequence does not exist')
                            end   
                            test.TestConfig.StimulusMode = 5;
                        case 'PatternMatch'
                           nSamples = 90;
                           filename = sprintf('%s%s\\%s\\StimConfig_PatternMatch.mat',test.TestConfig.RunDir,test.TestConfig.Culture,test.TestConfig.DIV);
                           if(exist(filename,'file'))
                               a  = load(filename,'StimConfig_PatternMatch');
                               test.StimConfig =a.StimConfig_PatternMatch;
                           else
                               StimConfig_PatternMatch = GenerateStimulusConfig_PatternMatch (Electrodes);
                               save(filename,'StimConfig_PatternMatch');
                               test.StimConfig =StimConfig_PatternMatch;
                           end     
                        case 'WordSequence'
                           nSamples = 91;
                           filename = sprintf('%s%s\\%s\\StimConfig_WordSequence.mat',test.TestConfig.RunDir,test.TestConfig.Culture,test.TestConfig.DIV);
                           if(exist(filename,'file'))
                               a  = load(filename,'StimConfig_WordSequence');
                               test.StimConfig =a.StimConfig_WordSequence;
                           else
                               StimConfig_WordSequence = GenerateStimulusConfig_WordSequence(Electrodes);
                               save(filename,'StimConfig_WordSequence');
                               test.StimConfig =StimConfig_WordSequence;
                           end 
                        case 'Imaging1'
                           nSamples = 4;
                           filename = sprintf('%s%s\\%s\\StimConfig_Imaging1.mat',test.TestConfig.RunDir,test.TestConfig.Culture,test.TestConfig.DIV);
                           if(exist(filename,'file'))
                               a  = load(filename,'StimConfig_Imaging1');
                               test.StimConfig =a.StimConfig_Imaging1;
                           else
                               StimConfig_Imaging1 = GenerateStimulusConfig_Imaging1(Electrodes);
                               save(filename,'StimConfig_Imaging1');
                               test.StimConfig =StimConfig_Imaging1;
                           end    
                         case 'Imaging_long'
                           nSamples = 2*5;
                           filename = sprintf('%s%s\\%s\\StimConfig_Imaging_long.mat',test.TestConfig.RunDir,test.TestConfig.Culture,test.TestConfig.DIV);
                           if(exist(filename,'file'))
                               a  = load(filename,'StimConfig_Imaging1');
                               test.StimConfig =a.StimConfig_Imaging1;
                           else
                               StimConfig_Imaging1 = GenerateStimulusConfig_Imaging_long(Electrodes);
                               save(filename,'StimConfig_Imaging1');
                               test.StimConfig =StimConfig_Imaging1;
                           end
                         case 'Imaging_spont'
                           nSamples = 2*5;
                           filename = sprintf('%s%s\\%s\\StimConfig_Imaging_spont.mat',test.TestConfig.RunDir,test.TestConfig.Culture,test.TestConfig.DIV);
                           if(exist(filename,'file'))
                               a  = load(filename,'StimConfig_Imaging1');
                               test.StimConfig =a.StimConfig_Imaging1;
                           else
                               StimConfig_Imaging1 = GenerateStimulusConfig_Imaging_spont(Electrodes);
                               save(filename,'StimConfig_Imaging1');
                               test.StimConfig =StimConfig_Imaging1;
                           end   
                         case 'Imaging_spont_short'
                           nSamples = 4;
                           filename = sprintf('%s%s\\%s\\StimConfig_Imaging_spont_short.mat',test.TestConfig.RunDir,test.TestConfig.Culture,test.TestConfig.DIV);
                           if(exist(filename,'file'))
                               a  = load(filename,'StimConfig_Imaging1');
                               test.StimConfig =a.StimConfig_Imaging1;
                           else
                               StimConfig_Imaging1 = GenerateStimulusConfig_Imaging_spont_short(Electrodes);
                               save(filename,'StimConfig_Imaging1');
                               test.StimConfig =StimConfig_Imaging1;
                           end  
                        otherwise
                            error(['Unknown Test mode ' mode])
                    end
                end                            
                
                test.StimConfig.nLoop = ceil(nSamples/test.StimConfig.nSeq)    ;
%                 nSamples
%                 test.StimConfig.p
%                 test.StimConfig.nSeq
%                 test.StimConfig.nLoop
%                 test.StimConfig.PatternInterval
                test.TotalFrames = round(((test.StimConfig.PatternInterval)*(test.StimConfig.p)*(test.StimConfig.nSeq)*(test.StimConfig.nLoop))/1000) + 12;
            end
            
            file_id = 1 ;            
            while(1)
                file_name = [test.TestConfig.RunDir test.TestConfig.Culture '\' test.TestConfig.DIV '\data_' test.TAG '_' num2str(file_id) '.dat'];
                
                if(exist(file_name,'file'))
                  file_id = file_id + 1 ;  
                else
                  break ;
                end 
            end
            
            test.data_filename = file_name ;   
            
        end
        function Config = LoadLatestConfig(test,basename)
            Config = [];
            %Find a file to load Config from
            %Find a filename to save DecoderConfig
            file_part = sprintf('%s%s\\%s\\%s',test.TestConfig.RunDir,test.TestConfig.Culture,test.TestConfig.DIV,basename);
            i=1;
            fname = [];
            while(1)
                ftry = sprintf('%s_%d.mat',file_part,i);
                if(exist(ftry,'file'))                    
                    fname=ftry;
                    i = i+1;                                   
                else                                    
                    break;
                end
            end
             if(~isempty(fname))
               display(['Loading DecodeConfig from file  '  fname]);
               a = load(fname);
               Config = a.Config;
             end
        end
        function PatternData = GetRecentPatternData(test,file_TAG)
            %Loading Pattern Data file  
            %Get The most recent patternCheck file
            file_part = sprintf('%s%s\\%s\\data_%s',test.TestConfig.RunDir,test.TestConfig.Culture,test.TestConfig.DIV ,file_TAG);
            fname=[];
            %Check if indexed files exist
            i=1;
            while(1)
                ftry = sprintf('%s_%d.mat',file_part,i);
                if(exist(ftry,'file'))
                    fname = ftry;
                    i = i+1;
                else
                    break;
                end
            end
            if ~isempty(fname)
                filename=fname;
            else
                filename = sprintf('%s.mat',file_part);
            end
            
            display(['Loading file : '  filename]);                       
            
            a = load(filename);
            PatternData = a.PatternData;   
        end        
        
        %% POST RUN Analysis
        % This must do any post run analysis on the data and 
        % Return the results
        function Config = post_run(test,tConfig)
            
            pause(2)                
            switchoff_MEA2100
            pause(2)        
            display([test.TAG 'Post run wrap up']);
            Config = tConfig;            
            
            %% Do any post analysis and return relevant data
    
            display('Extracting Pattern Data...') 
            PatternData = Extract_PatternData(test.data_filename,test.StimConfig,test.TestConfig.StimulusMode);
            
        end
    end
end