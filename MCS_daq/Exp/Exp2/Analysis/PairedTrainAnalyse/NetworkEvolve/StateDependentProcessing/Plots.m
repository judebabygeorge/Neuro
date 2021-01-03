close all
% figure;hold on;
% plot((1:1:24)*20,SCORE1(:,1),'b','LineWidth',2);
% plot((1:1:24)*20,SCORE1(:,2),'g','LineWidth',2)
% plot((1:1:24)*20,mean(y,2),'r--','LineWidth',2)
% 
% OX = SCORE(:,1:4)*COEFF(1:4,:);
% OX = bsxfun(@plus,OX,-min(OX));
% OX = bsxfun(@rdivide,OX,max(OX));
% 
% legend({'Principle Component 1','Principle Component 2','Average Culture firing rate'})
% xlabel('Time(min)')


figure;hold on;

 i = 10;%10/32 G09102014C DIV37
 x = reshape(X(i,:,:),[20 24])';
 plot(repmat((1:1:24)*20,[size(x,2) 1])', x,'b');
 plot((1:1:24)*20,y(:,i),'g','LineWidth',2);   
 xlabel('Time(min)')
% plot(OX(:,i),'k','LineWidth',2);
% figure;
% 
% t = zeros(20,1);
% for i=1:20
%     plot(x(:,i))
%     ylim([0 1])
%     ch = getkey;
%     t(i) = ch - 48;
% end


%  plot(y(:,[4 5 7 ]),'g','LineWidth',2);  
%  legend({'Spontaneous Activity at Electrode A','Spontaneous Activity at Electrode B','Spontaneous Activity at Electrode C'})