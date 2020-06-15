
% load('data_burst_PatternCheck_2_250_Dummy_1.mat')
% [y, e] = ExtractBurstProfile(PatternData);
% h = ones(10,1)/10;
% z = filtfilt(h,1,y);


b = zeros(size(z));

Bursts = DetectBursts(y);
BurstCount = size(Bursts,1);
Eactivity = zeros(120,BurstCount);

SegmentLength = 60/5;
for i=1:BurstCount
    b(Bursts(i,1):Bursts(i,2))=1;    
    ea = sum(e(Bursts(i,1):min(SegmentLength+Bursts(i,1),Bursts(i,2)),:));
    Eactivity(:,i) = (ea > 0)';
end
%Eactivity =Eactivity/BurstCount;

%Rate=BurstCount/(size(z,1)*5/1000)

close all;
plot([y z b*th1])
% figure;
% hist(Eactivity,0:0.1:1);

dist = zeros(BurstCount,BurstCount);

for i=1:BurstCount
    for j=1:BurstCount
        dist(i,j) = sum(abs(Eactivity(:,i) - Eactivity(:,j)));
    end
end