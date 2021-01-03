
% display('Extracting Pattern Data...')
% test = uExp.Tests{1}
%             PatternData = Extract_PatternData(test.data_filename,test.StimConfig);
            
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
            