figure;
Chid = 4 ; 
plot(Data(:,Chid));hold on;
sC= uPlay.ProcessInfo.spikeCounts;
sT= uPlay.ProcessInfo.spike_times;

i1 = sum(sC(1:(Chid-1)))+1;
i2 = sum(sC(1:Chid));
times = sT(i1:i2);
scatter(times,0*ones(size(times)),'r','filled');
