
ROI = MIJ.getRoi(0);
y = X((ROI(2,1):ROI(2,3)),(ROI(1,1):ROI(1,2)),:);
y = mean(mean(y));
y = y(:);
y=y(2:end);
dt=0.025;
t = dt.*(1:1:numel(y));
figure;plot(t,y)
id = id + 1;
z(:,id)=y;
