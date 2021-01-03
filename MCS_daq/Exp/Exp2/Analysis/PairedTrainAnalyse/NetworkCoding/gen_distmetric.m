
load('ChannelMap.mat');
CElectrodes = [44 14 104 74];

D = zeros(120,4);

r = ChannelMapping.row;
c = ChannelMapping.col;

for i=1:4
    r1= r(CElectrodes(i));
    c1= c(CElectrodes(i));
    D(:,i) = ((r1 - r).^2 +(c1-c).^2).^0.5;
end
D=min(D,[],2);
D= 1-D/(1+max(D));

