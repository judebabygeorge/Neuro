function Config = GenerateExpConfigs
%GENERATEEXPCONFIGS Summary of this function goes here
%   Detailed explanation goes here

%a = load('ChannelMap.mat') ;
a = load('ChannelMapMEA60.mat') ;
ChannelMapping = a.ChannelMapping;

% Config{1} = GetConfig('F7','D1',ChannelMapping);
% Config{2} = GetConfig('F6','D2',ChannelMapping);

% Config{1} = GetConfig('E12','Electrode_1',ChannelMapping);
% Config{2} = GetConfig('H12','Electrode_2',ChannelMapping);
% Config{3} = GetConfig('L8','Electrode_3',ChannelMapping);
% Config{4} = GetConfig('J6','Electrode_4',ChannelMapping);
% Config{5} = GetConfig('D6','Electrode_5',ChannelMapping);
% Config{6} = GetConfig('C8','Electrode_6',ChannelMapping);
% 
% Config{7} = GetConfig('M5','Ground',ChannelMapping);

Config{1} = GetConfig('47','D1',ChannelMapping);
Config{2} = GetConfig('48','D2',ChannelMapping);

end

function C = GetConfig(ChannelName,Descriptor,ChannelMapping)

C.ChannelName = ChannelName;
C.Descriptor=Descriptor;
C.ChannelId = GetElectrodeNumber(ChannelName,ChannelMapping);

end
