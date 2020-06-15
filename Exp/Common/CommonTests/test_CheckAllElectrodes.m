classdef test_CheckAllElectrodes < handle

    
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
        function test = test_CheckAllElectrodes(Config,mode,nPulses)
            
            %'CheckAllElectrodes','CheckElectrodesHF'
            test.TAG = mode;            
            %%Config will have save diectory , culture id , DIV
            test.TestConfig = Config ;
            test.TestConfig.mode = mode;
            test.TestConfig.nPulses=nPulses;
            test.TestConfig.RepeatCount    = 0;
            test.TestConfig.RepeatInterval = 1;
            
            test.TestConfig.mode = mode;
            test.TestConfig.StimulusMode = 1;
            test.TestConfig.nE = 120  ;
            test.TestConfig.PatternDelay = 1000;
            test.ConfigOptions ={' '};
            
            test.DoACQ      = 1      ;
            
            test.TotalFrames = 0 ;
            test.StimConfig  = [] ;
        end
        
        %% PRE RUN FUNCTION
        %  Any Test propeties that need to be update
        %  Config structure must have any inputs that are
        %  required to create the test
        function pre_run(test,RunConfig)
            %Create and/or Load the corresponding StimConfig file 
            global Select_Headstage
            display([test.TAG 'Pre run setup']); 
            
            switch(test.TestConfig.mode)
                case 'CheckAllElectrodes'
                    
                    if Select_Headstage==1
                        fConfig = 'StimConfig_CheckAllElectrodes_HS1' ;     
                    else
                        fConfig = 'StimConfig_CheckAllElectrodes_HS2' ; 
                    end
                    a = load(['C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Tests\' fConfig '.mat']);
                    test.StimConfig  = a.StimConfig;
                    nSamples   = 3            ;
                case 'CheckElectrodesHF'
                    nSamples   = 3;
                    test.StimConfig = GenerateStimulusConfig_CheckElectrodeHF (1:1:120,127,3,1000,3); 
            end
            test.StimConfig.nLoop = ceil(nSamples/test.StimConfig.nSeq)   ;
            test.TotalFrames = round(((test.StimConfig.PatternInterval)*(test.StimConfig.p)*(test.StimConfig.nSeq)*(test.StimConfig.nLoop))/1000) + 12;               
            
            
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
            
            Config = tConfig;
            display([test.TAG 'Post run wrap up']);
            %% Save the Stimulus Config file
            %stim_filename = [test.TestConfig.RunDir test.TestConfig.Culture '\' test.TestConfig.DIV '\StimConfig_' test.TAG '.mat'];
            %StimConfig = test.StimConfig;
            %save(stim_filename,'StimConfig');
            
            %% Do any post analysis and return relevant data
            
            %%Find the most relevant electrodes
            if(1)
            display('Extracting Pattern Data...')
             PatternData = Extract_PatternData(test.data_filename,test.StimConfig,test.TestConfig.StimulusMode);
            
             display('Checking Electrodes...')
             PFiring = ones(size(PatternData.Pattern));
             PFiring(isnan(PatternData.Pattern)) = 0;
             P = mean(PFiring,3) ;
             
             Probability  = 0.8 ;
             P(P<Probability) = 0 ;
             P = sum(P) ;            
             display(['Number of Good Stimulation Electrodes(nEX>=5) : ' num2str(sum(P>=5))]);
             [~,E] = sort(P,'descend');
             
             display('--------------')
             display('Average Activity');
             display(P(E(1:8)))
             display('--------------')
                          
             Config.ElectrodePreference = E ;
             %Save Electrode Order
             file_name = [test.TestConfig.RunDir test.TestConfig.Culture '\' test.TestConfig.DIV '\ElectrodeOrder.mat'];
             save(file_name,'E');
             %%% Calculate the mean firing time
             P = PatternData.Pattern ;
             P = reshape(P,[1,numel(P)]);
             P = P(~isnan(P));             
             [~,I] =sort(P);
             %Mean firing time : 80%of all
             mT = mean(P(I(1:floor(0.8*numel(I)))));
             
             display(['Mean time to first spike : ' num2str(mT/50) ' ms'])
             
             Config.MeanFiringTime = mT;
            end
        end
    end
end