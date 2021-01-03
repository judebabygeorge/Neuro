
%load('C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\G28012016B\DIV21\data_PatternCheck_2_250_Imaging1_1.mat')

P = PatternData.Pattern;
P(P<55*50)=NaN;
P(P>500*50)=NaN;
Q = zeros(size(P));
Q(~isnan(P))=1;
Q=mean(Q,3);
Q = mean(Q,2);

[~,I] = sort(Q,'descend');

load('ChannelMap.mat')

a = {ChannelMapping.Map.label};
ActiveElectrodes = a(I);