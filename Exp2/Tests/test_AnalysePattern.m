classdef test_AnalysePattern < handle

    
    properties
        
        TAG    
        TestConfig
        DoACQ
        
        data_filename
        StimConfig 
        
        TotalFrames
    end
    
    methods
        function test = test_AnalysePattern(Config,mode,PatternFile)
            
            test.TAG = ['AnalysePattern_'  mode] ;            
            %%Config will have save diectory , culture id , DIV
            test.TestConfig = Config ;
            test.TestConfig.mode = mode;
            test.TestConfig.PatternDelay = 0;
            test.TestConfig.PatternFile = PatternFile;
            test.TestConfig.RepeatCount    = 0;
            test.TestConfig.RepeatInterval = 1;
            
            test.TotalFrames = 0 ;
            test.StimConfig  = [] ;
            test.DoACQ       = 0 ;
        end
        
        %% PRE RUN FUNCTION
        %  Any Test propeties that need to be update
        %  Config structure must have any inputs that are
        %  required to create the test
        function Config = ExecuteTask(test,tConfig)
            
            Config = tConfig ;
            
            display([test.TAG '  :  Executing Task']);
            
            %Loading Pattern Data file
            
            filename = [test.TestConfig.RunDir test.TestConfig.Culture '\' test.TestConfig.DIV '\data_PatternCheck_' test.TestConfig.PatternFile '.mat'];
            a = load(filename);
            PatternData = a.PatternData;       
            Patterns = PatternData.Pattern ;
                        
            switch(test.TestConfig.mode)
                case 'dsp_decode'
                        x = (1:1:56);
                        [ PatternId W ] = get_best_patterns(Patterns(:,x,:))  ;
                        PatternId = [x(PatternId) 57:64];
                        Config.DecodeTask.StimConfig = GenerateStimulusConfig_Selected(PatternData.StimConfig,PatternId);
                        Config.DecodeTask.StimConfig.DecodeWeights=W          ;
                case 'train_select'
                        x = 1:1:56 ;
                        PatternId = get_pattern_to_train(Patterns(:,x,:));
                        id =  input('Enter the pattern to train : ');
                        PId = PatternId(id);
                        Config.DecodeTask.StimConfig = GenerateStimulusConfig_Selected(PatternData.StimConfig,PId);
                        
                        id =  input('Enter the patters to test [] : ');
                        PId = PatternId(id);
                        Config.DecodeTask.StimConfig_Test = GenerateStimulusConfig_Selected(PatternData.StimConfig,PId);                       
                        
            end
            

            %Update the patterns to be used for DSP test
           
        end
        
        
    end
end