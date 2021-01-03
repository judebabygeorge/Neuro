classdef test_PatternCheck < handle

    
    properties
        
        TAG    
        TestConfig
        DoACQ
        
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
            test.TestConfig.nE = nE  ;
            test.TestConfig.PatternDelay = PatternDelay;
            test.TestConfig.RepeatCount    = 0;
            test.TestConfig.RepeatInterval = 1;
            
            test.DoACQ      = 1      ;
            
            test.TotalFrames = 0 ;
            test.StimConfig  = [] ;
        end
        
        %% PRE RUN FUNCTION
        %  Any Test propeties that need to be update
        %  Config structure must have any inputs that are
        %  required to create the test
        function pre_run(test,RunConfig)
            
            display([test.TAG 'Pre run setup']);
            if(isempty(test.StimConfig) || strcmp(test.TestConfig.mode(1:5) ,'train') ) % For every rerun use the same StimConfig except in training
                %Create and/or Load the corresponding StimConfig file 
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
                        case 'train_0'
                           nSamples   = 2400;
                           %nSamples = 127;
                           
                           test.StimConfig = RunConfig.DecodeTask.StimConfig; 
                           %test.StimConfig.PatternInterval = 250;
                           %test.StimConfig.PatternInterval = 30 ;
                        case 'test_0'
                           nSamples   = 45;
                           test.StimConfig = RunConfig.DecodeTask.StimConfig_Test; 
                        otherwise
                            error(['Unknown Test mode ' mode])
                    end
                end                            
                
                test.StimConfig.nLoop = ceil(nSamples/test.StimConfig.nSeq)   ; 

                test.TotalFrames = round(((test.StimConfig.PatternInterval)*(test.StimConfig.p)*(test.StimConfig.nSeq)*(test.StimConfig.nLoop))/1000) + 12;
            end
            
            file_id = 0 ;
            file_name = [test.TestConfig.RunDir test.TestConfig.Culture '\' test.TestConfig.DIV '\data_' test.TAG '.dat'];
            
            while(1)
                if(exist(file_name,'file'))
                  file_id = file_id + 1 ;            
                  file_name = [test.TestConfig.RunDir test.TestConfig.Culture '\' test.TestConfig.DIV '\data_' test.TAG '_' num2str(file_id) '.dat'];
                else
                  break ;
                end 
            end
            
            test.data_filename = file_name ;   
            
        end
        
        %% POST RUN Analysis
        % This must do any post run analysis on the data and 
        % Return the results
        function Config = post_run(test,tConfig)
            
            display([test.TAG 'Post run wrap up']);
            Config = tConfig;    
            %% Save the Stimulus Config file
            %stim_filename = [test.TestConfig.RunDir test.TestConfig.Culture '\' test.TestConfig.DIV '\StimConfig_' test.TAG '.mat'];
            %StimConfig = test.StimConfig;
            %save(stim_filename,'StimConfig');
            
            %% Do any post analysis and return relevant data
    
            display('Extracting Pattern Data...')
            PatternData = Extract_PatternData(test.data_filename,test.StimConfig);
            
            
            
        end
    end
end