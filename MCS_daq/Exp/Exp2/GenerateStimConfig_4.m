
function StimConfig = GenerateStimConfig_4(path)

filename = sprintf('%s\\ElectrodeOrder.mat',path);
if(exist(filename,'file'))
                    a  = load(filename);   
                    display(['Loading Settings from  '  filename]);
                    ElectrodePreference = a.E;
end
Electrodes = ElectrodePreference(1:8)';
                
StimConfig = GenerateStimulusConfig_TwoInput_time_seq4 (Electrodes,127,250,50);
save(sprintf('%s\\StimConfig_4.mat',path),'StimConfig')

end