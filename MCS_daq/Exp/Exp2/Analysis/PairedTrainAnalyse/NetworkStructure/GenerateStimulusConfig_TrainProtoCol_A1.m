function [StimConfigProbe,StimConfigTrain] = GenerateStimulusConfig_TrainProtoCol_A1(path,pid,Eob)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time

a = load(sprintf('%s/StimConfigProbe.mat',path));
StimConfigProbe = a.StimConfigProbe;

a = load(sprintf('%s/StimConfigTrain.mat',path));
StimConfigTrain = a.StimConfigTrain;

patterns = [13 16 25 19 1 4 10 7 22 28];

StimConfigTrain.Patterns = StimConfigProbe.Patterns(:,patterns(pid));
StimConfigTrain.PatternDelay = StimConfigProbe.PatternDelay(:,patterns(pid));
StimConfigTrain.Info.pid = patterns(pid);
StimConfigTrain.Info.Eob = Eob;
end


