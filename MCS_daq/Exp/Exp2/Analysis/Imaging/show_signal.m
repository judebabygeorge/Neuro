
ROI = MIJ.getRoi(0);
Y = ImagingData.Cam1;
z = zeros(size(Y{1},3),5);

for i=1:5
    Z = Y{i};
    y = Z((ROI(2,1):ROI(2,3)),(ROI(1,1):ROI(1,2)),:);
    y = mean(mean(y));
    y = y(:);
    z(:,i)=y;
end


c = floor(size(z,1)/2);
baseline = mean(z(c-5:c+5,:),1);
zz = zeros(size(z));

df = 3;

df = df/100;
for i=1:size(z,2)
  y = z(:,i)     ;
  b = baseline(i);
  y = y/1;
  %y(y>1+df) =1+df;
  %y(y<1-df)=1-df;
  %y = (y-1)*100 ;
  zz(:,i)=y;
end
x = zz(2:end-10,:);


figure;
l=1;
for i=1:16
    y = x(:,i);
    plot((i-1)*5+(1:numel(y))*30/1000,filtfilt(ones(l,1)/l,1,y),'.');hold on;
end
[SpikeTimes SpikeData] = GetSpikeSequence( ImagingData.PatternData_Spikes , 'L8');
%scatter(SpikeTimes-11,8000*ones(numel(SpikeTimes),1),'r','filled');
if(1)
    cd('./sort/')
    test_sort
    cd('../')
    scatter(SpikeTimes(classes==1)-11,7200*ones(numel(SpikeTimes(classes==1)),1),'r','filled');hold on;
    scatter(SpikeTimes(classes==2)-11,7400*ones(numel(SpikeTimes(classes==2)),1),'g','filled');hold on;
    scatter(SpikeTimes(classes==3)-11,7600*ones(numel(SpikeTimes(classes==3)),1),'m','filled');hold on;
end
ylim([7000 9000])
% hold off;
% plot(30*(1:1:size(zz,1)),zz);
% for i=1:16
%  plot(z(:,i)); 
%  getkey;
% end

if(0)
    x = zeros(numel(ImagingData.PatternData_Spikes.Pattern),1);
    for i=1:numel(x)
        x(i) = sum(ImagingData.PatternData_Spikes.Pattern{i}.SpikeCounts)
    end
    
end