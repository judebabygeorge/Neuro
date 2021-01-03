classdef test_DSP_Decode < handle

    
    properties
        
        TAG    
        TestConfig
        DoACQ
        ConfigOptions
        
        data_filename
        StimConfig 
        
        TotalFrames
        nDecoders
    end
    
    methods
        function test = test_DSP_Decode(Config,mode,PatternFile,nDecoders)
            
            test.TAG = ['dsp_decode_'  mode] ;            
            %%Config will have save diectory , culture id , DIV
            test.TestConfig = Config ;
            test.TestConfig.mode = mode;
            test.TestConfig.PatternDelay = 0;
            test.TestConfig.PatternFile = PatternFile;
            test.TestConfig.RepeatCount    = 0;
            test.TestConfig.RepeatInterval = 1;
            test.ConfigOptions = {' '};
            
            test.TotalFrames = 0 ;
            test.StimConfig  = [] ;
            test.DoACQ       = 0 ;
            test.nDecoders=nDecoders;
            
        end
        
        %% PRE RUN FUNCTION
        %  Any Test propeties that need to be update
        %  Config structure must have any inputs that are
        %  required to create the test
        
        function Config = ExecuteTask(test,tConfig)
            display([test.TAG '  :  Executing Task']);
            switch(test.TestConfig.mode)
                case 'robot_decode'
                    Config = test.ExecuteTask_robot_decode(tConfig);
                case 'training_1'
                     Config = test.ExecuteTask_training_1(tConfig);
            end            
        end
        function Config = ExecuteTask_training_1(test,tConfig)
            Config = tConfig ;
            PatternData = test.GetRecentPatternData();
            DecodeCheckWindow = 100 ;
            Patterns = test.EditPatterns(PatternData,DecodeCheckWindow);
            
            [PairId Wo] = get_distinguishable_pairs( Patterns );
            PatternId = PairId(1,:);
            W = Wo(:,PatternId);
            
            Config.DecodeTask.StimConfig = PatternData.StimConfig ;        
            Config.DecodeTask.StimConfig.DecodeWeights=W          ;
            Config.DecodeTask.StimConfig.PatternId = PatternId    ; 
            Config.DecodeTask.StimConfig.DecodeCheckWindow = DecodeCheckWindow;
            
            %%Create Sequence  
            TotalSingleFrameStims =4*60;
            ProbeStims            =4*3;
            
            Config.DecodeTask.StimConfig.StimTrain{1} = test.CreateStimTrain([1 2],[],TotalSingleFrameStims,[],1);
            Config.DecodeTask.StimConfig.StimTrain{2} = test.CreateStimTrain([1 2],1,ProbeStims,TotalSingleFrameStims-ProbeStims*2,10);
            Config.DecodeTask.StimConfig.StimTrain{3} = test.CreateStimTrain([1 2],2,ProbeStims,TotalSingleFrameStims-ProbeStims*2,10);
            Config.DecodeTask.StimConfig.StimTrain{4} = test.CreateStimTrain([1 2],0,ProbeStims,TotalSingleFrameStims-ProbeStims*2,10);
            
            SaveDecoderConfig(test,Config,'TrainConfig');
        end
        function StimTrain=CreateStimTrain(test,PatternPair,TrainPattern,ProbeRepeat,TrainRepeat,SequenceRepeat)
            nP=1;
            if(~isempty(TrainPattern))
                nP=2;
            end
            StimTrain.Elements = zeros(nP,2+4); %[nRepeat nPatterns Patterns[4]]
            StimTrain.Elements(1,1) = ProbeRepeat;
            StimTrain.Elements(1,2) = 2;
            StimTrain.Elements(1,3:4) = PatternPair(1:2);
            if(nP==2)
                StimTrain.Elements(2,1) = TrainRepeat;
                StimTrain.Elements(2,2) = 1;
                StimTrain.Elements(2,3) = TrainPattern;            
            end
            StimTrain.nSequenceRepeat = SequenceRepeat;
        end
        
        function Config = ExecuteTask_robot_decode(test,tConfig)
            Config = tConfig ;
            
            PatternData = test.GetRecentPatternData();   
            display(['Patterns Loaded From file  ' PatternData.TAG]);
            
            
            
            switch (PatternData.TAG)
                case 'two_time_seq3'
                   test.CreateDecoderConfig_two_time_seq3(Patterns) 
                case 'two_time_seq4'
                   test.CreateDecoderConfig_two_time_seq4(PatternData) 
                case 'RobotEncodingTest'
                   test.CreateDecoderConfig_RobotEncodingTest(Patterns) 
            end
           
        end
        function CreateDecoderConfig_two_time_seq3(test,Patterns)
             %Check if a decoder file already exists 
            iConfig = test.LoadDecoderConfig('DecodeConfig');
            if(isempty(iConfig))            
                display('Finding Patterns ...');
                [ PatternId ~ ] = get_best_patterns(Patterns)         ;
                PatternId(1:10)
                PatternsToLoad=test.nDecoders;
                Pid = PatternId(1:PatternsToLoad);                
            else
                 Pid= iConfig.DecodeTask.StimConfig.PatternId; 
            end
                
            [ nPid W ] = get_best_patterns(Patterns(:,Pid,:));
            PatternId= Pid(nPid);
            
            %W = rand(121,4);
            %Update the patterns to be used for DSP test
            test.CreateDecoderConfig(PatternData,PatternId,W)  ;
        end
        function CreateDecoderConfig_two_time_seq4(test,PatternData)
             %Check if a decoder file already exists
            DecodeCheckWindow = 100 ;
            PatternData.Patterns = test.EditPatterns(PatternData,DecodeCheckWindow);
            Patterns = PatternData.Patterns;
           
            if(0) %Create Based on time delay
                O = zeros(28,1);
                for i=1:28
                    [~, ~ ,e] = get_best_patterns(Patterns(:,(i-1)*4+1:i*4,:));
                    O(i) = max(e)*sum(e);
                end
                [~,I] = sort(O,'ascend');
                Pid = I(1);
                [PatternId,W,~] = get_best_patterns(Patterns(:,(Pid-1)*4+1:Pid*4,:));

                PatternId = (Pid-1)*4 + PatternId ;
            end
            if(1) %Create based on random picking
                V = 1:2:112;
                [ PatternId ~ ] = get_best_patterns(Patterns(:,V,:))         ;
                PatternId(1:10)
                [ nPid W ] = get_best_patterns(Patterns(:,PatternId(1:4),:));
                PatternId  = PatternId(nPid);
            end
            %W = rand(121,4);
            %Update the patterns to be used for DSP test
            test.CreateDecoderConfig(PatternData,PatternId,W)  ;
        end
        function CreateDecoderConfig_RobotEncodingTest(test,Patterns)
            %Check if a decoder file already exists             
            O = zeros(28,1);           
            for i=1:10
                s1 = [1 2 3 6]+ (i-1)*6;
                [~, ~ ,e1] = get_best_patterns(Patterns(:,s1,:));
                s2 = [1 2 4 5]+ (i-1)*6;
                [~, ~ ,e2] = get_best_patterns(Patterns(:,s2,:));
                O(i) = min([max(e1) max(e2)]);
            end
            [~,I] = sort(O,'ascend');
            Pid = I(1);
            s1 = [1 2 3 6]+ (Pid-1)*6;
            [P1, W1 ,e1] = get_best_patterns(Patterns(:,s1,:));
            s2 = [1 2 4 5]+ (Pid-1)*6;
            [P2, W2 ,e2] = get_best_patterns(Patterns(:,s2,:));
            
            if max(e1)<max(e2)
                PatternId = s1(P1);
                W = W1;
            else
                PatternId = s2(P2);
                W = W2;
            end
                        
            %W = rand(121,4);
            %Update the patterns to be used for DSP test
            test.CreateDecoderConfig(PatternData,PatternId,W)  ;
        end
        function CreateDecoderConfig(test,PatternData,PatternId,W)     
            DecodeCheckWindow=100;
            %W = rand(121,4);
            %Update the patterns to be used for DSP test
            Config.DecodeTask.StimConfig = PatternData.StimConfig ;        
            Config.DecodeTask.StimConfig.DecodeWeights=W          ;
            Config.DecodeTask.StimConfig.PatternId = PatternId    ; 
            Config.DecodeTask.StimConfig.DecodeCheckWindow = DecodeCheckWindow;            
            test.SaveDecoderConfig(Config,'DecodeConfig');
        end
        function Patterns = EditPatterns(test,PatternData,DecodeCheckWindow)
            
            Patterns = PatternData.Pattern ;            
            %Blank Stimulated Electrodes,these spikes would not be counted
            %The Corresponding weights would not adapt and will be 0 hence
            %takes care although this blanking is not done in dsp
            E = PatternData.StimConfig.Electrodes(1,1:8) ;
            E = reshape(E,[1 numel(E)]);
            E = E(E~=0);
            Patterns(E,:,:)=nan;
            
            Patterns(Patterns<5*50) = nan;
            Patterns(Patterns>DecodeCheckWindow*50) = nan;
        end
        function Config = LoadDecoderConfig(test,filename)
            Config = [];
            file_part = sprintf('%s%s\\%s\\%s',test.TestConfig.RunDir,test.TestConfig.Culture,test.TestConfig.DIV,filename);
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
            if ~isempty(fname)
                display('Finding Patterns from neuronal cultures');
                a = load(fname);
                Config= a.Config;
            end
        end
        function SaveDecoderConfig(test,Config,filename)
            %Find a filename to save DecoderConfig
            file_part = sprintf('%s%s\\%s\\%s',test.TestConfig.RunDir,test.TestConfig.Culture,test.TestConfig.DIV,filename);
            i=1;
            fname = '';
            while(1)
                ftry = sprintf('%s_%d.mat',file_part,i);
                if(exist(ftry,'file'))                    
                    i = i+1;
                else
                    fname=ftry;
                    break;
                end
            end
            save(fname,'Config');
        end
        function PatternData = GetRecentPatternData(test)            
            PatternData = test.GetRecentPatternData0('PatternCheck_2_250_RobotEncodingTest');
            if ~isempty(PatternData)
                PatternData.TAG = 'RobotEncodingTest';
                return;                
            end
%             PatternData = test.GetRecentPatternData0('PatternCheck_2_250_two_time_seq5');
%             if ~isempty(PatternData)
%                 PatternData.TAG = 'two_time_seq5';
%                 return;                
%             end
            PatternData = test.GetRecentPatternData0('PatternCheck_2_250_two_time_seq4');
            if ~isempty(PatternData)
                PatternData.TAG = 'two_time_seq4';
                return;                
            end
            PatternData = test.GetRecentPatternData0('PatternCheck_2_250_two_time_seq3');
            if ~isempty(PatternData)
                PatternData.TAG = 'two_time_seq3';
                return;                
            end
            
        end
        function PatternData = GetRecentPatternData0(test,filename)
            %Loading Pattern Data file
            
            %filename = [test.TestConfig.RunDir test.TestConfig.Culture '\' test.TestConfig.DIV '\data_PatternCheck_' test.TestConfig.PatternFile '.mat'];            
            %filename ='C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\G22012014C\DIV42\data_PatternCheck_2_250_two_time_seq3.mat';
            
            %Get The most recent patternCheck file
            file_part = sprintf('%s%s\\%s\\data_',test.TestConfig.RunDir,test.TestConfig.Culture,test.TestConfig.DIV,filename );
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
            display(filename)
            if(exist(filename,'file'))                
                display(['Loading file : '  filename]);            
                %filename = [test.TestConfig.RunDir test.TestConfig.Culture '\' test.TestConfig.DIV '\data_PatternCheck_' '2_250_two_time_seq3' '.mat'];   


                a = load(filename);
                PatternData = a.PatternData;   
            else
                PatternData = []
            end
        end
        
    end
end