
%Load BurstData


RecordingId = 12;

SpontaneousActivity = BurstData{RecordingId};

%plot(SpontaneousActivity.y)

Bursts = DetectBursts(SpontaneousActivity.y);
nBursts = size(Bursts,1);
BurstProperties = zeros(nBursts,3);

%Find the length of BurstActivity
BurstProperties(:,1) = Bursts(:,2)-Bursts(:,1) + 1;


for i=1:nBursts
  % Number of spikes
  BurstProperties(i,2) = sum(SpontaneousActivity.y(Bursts(i,1):Bursts(i,2))); 
  
  % Number of Active Electrodes
  e  = SpontaneousActivity.e(Bursts(i,1):Bursts(i,2),:);  
  BurstProperties(i,3) = sum(sum(e,1) > 0);
end

% Create burst profiles
BurstLength = 700/5;
BurstProfiles = zeros(BurstLength,nBursts);
h = ones(10,1)/10;
z = filtfilt(h,1,SpontaneousActivity.y);
for i=1:nBursts
    BurstProfiles(1:min(BurstLength,BurstProperties(i,1)),i) = z(Bursts(i,1):(Bursts(i,1) + min(BurstLength,BurstProperties(i,1))-1));
end

b=cumsum(BurstProfiles);
b = bsxfun(@rdivide,b,b(end,:));
%plot(b,'b')

F = zeros(nBursts,2);

for i=1:nBursts
    F(i,1) = find(b(:,i)>0.5,1);
    F(i,2) = find(b(:,i)>0.6,1);    
end

F = abs(F-30);
[~,I] = sort(F,'ascend');
plot(BurstProfiles(:,I(1:40)),'b')

t_w = [150 200]/5;
nSamples = 40;

P = zeros(120,nSamples);

%Activity of burst in a window
for i=1:nSamples
    e =  SpontaneousActivity.e((Bursts(I(i),1)+t_w(1)):(Bursts(I(i),2)+t_w(2)),:)'; 
    P(:,i) = (sum(e,2) > 0);
end

h = PatternView ;
hO  = guidata(h);  

P = mean(P,2);
Vis  = P;
Act  = ones(size(Vis))*0;   
Mark = zeros(size(Act));
hO.ShowElectrodeActivity(hO,1,[Act Vis], Mark);


%Activity of burst in a window
for i=1:nBursts
    e =  SpontaneousActivity.e((Bursts(I(i),1)+t_w(1)):(Bursts(I(i),2)+t_w(2)),:)'; 
    P(:,i) = (sum(e,2) > 0);
end
P = mean(P,2);
Vis  = P;
Act  = ones(size(Vis))*0;   
Mark = zeros(size(Act));
hO.ShowElectrodeActivity(hO,2,[Act Vis], Mark);