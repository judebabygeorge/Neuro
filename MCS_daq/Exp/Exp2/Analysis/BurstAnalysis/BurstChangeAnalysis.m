
h = ones(10,1)/10;

Z = zeros([numel(BurstData{1}.y) numel(BurstData)]);


% for i=1:1:numel(BurstData)
%   k = sum(BurstData{i}.e,1);
%   k = find(k>5000);
%   e = BurstData{i}.e;
%   e(:,k)=0;
%   y = sum(e,2);
%   Z(:,i) = filtfilt(h,1,y);
%   plot([y Z(:,i)])
%   waitforbuttonpress;
% end

D = zeros(numel(BurstData),2);

for i=1:numel(BurstData)
    
    k = sum(BurstData{i}.e,1);
    k = find(k>8000);
    e = BurstData{i}.e;
    e(:,k)=0;
    y = sum(e,2);
  
    Bursts     = DetectBursts(y);
    BurstCount = size(Bursts,1);
    Activity   = sum(y);
    D(i,:)=[BurstCount Activity];
end

d = max(D);
plot([D(:,1)/d(1) D(:,2)/d(2)]);