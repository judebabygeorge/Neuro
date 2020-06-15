function  KalmanEstimate( path , DIV , pid)
%KALMANESTIMATE Summary of this function goes here
%   Detailed explanation goes here

[X,~,~] = AnalyseNetworkEvolve(path,DIV);


l=2;
h  = (1/(2*l+1))*ones(2*l+1,1);

Y = zeros(size(X));

for i=1:size(X,2)
o  = X(:,i);
o2 = filtfilt(h,1,o);
w  = std(o-o2);
y = KalmanEstimateStates(o,w,4);
Y(:,i)=y(:,2);
end

figure;plot_Est(Y,'G1',DIV)
Y = ProjectFromVel(Y);
figure;plot_Est(Y,'G1',DIV)

%plot([o y(:,2)/max(y(:,2))]);
end
function  plot_Est(X,C,D)
%PLOT_EVOLVE Summary of this function goes here
%   Detailed explanation goes here

t = 0:1:(size(X,1)-1);
t = t/4;

c = 'bgrcm';

% l=1;
% h = (1/(2*l+1))*ones(2*l+1,1);
% X = filtfilt(h,1,X);
for i=1:size(X,2)
    plot(t,X(:,i),'Color',c(rem(i-1,5)+1),'LineWidth',2);
    hold on
end
hold off

% xlabel('time(hr)','FontWeight','bold')
% ylabel('P','FontWeight','bold');
% ylim([-0.1 1.1]);
% title(['Network Evolve : ' C ' ' D] ,'FontWeight','bold');

end




