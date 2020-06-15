function  plot_Evolve( X, C , D )
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

xlabel('time(hr)','FontWeight','bold')
ylabel('P','FontWeight','bold');
ylim([-0.1 1.1]);


title(['Network Evolve : ' C ' ' D] ,'FontWeight','bold');

end

