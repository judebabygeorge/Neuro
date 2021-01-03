
SelectedPatterns = (1:1:56)*2 ;



X = ones(size(PatternData.Pattern));
X(isnan(PatternData.Pattern))=0;
Pf = mean(X,3);

SelectedPatterns = reshape(SelectedPatterns,[2 28]) ;

P1 = Pf(:,SelectedPatterns(1,:)) - Pf(:,SelectedPatterns(2,:)) ;
P1 = reshape(P1,[1 numel(P1)]);
P1(abs(P1)<0.2) = [];
hist(P1,-0.95:0.1:0.95);

xlabel('Change in Probability of firing due to timing');
set(gca,'YTick',[])
set(gcf,'Color',[1 1 1]);
axis square
axis tight


% SelectedPatterns = (1:1:56)*2 ;
% 
% a = SelectedPatterns - 1 ;
% 
% X = ones(size(PatternData.Pattern));
% X(isnan(PatternData.Pattern))=0;
% Pf = mean(X,3);
% 
% 
% Pc = zeros(size(X,1),numel(SelectedPatterns));
% 
% for i=1:numel(SelectedPatterns)
%     E = PatternData.StimConfig.Patterns(:,a(i))';
%     m = sum(Pf(:,E+112),2);
%     m(m>1) = 1 ;
%     Pc(:,i) =Pf(:,SelectedPatterns(i)) - m ;
% end
% Pc = reshape(Pc,[1 numel(Pc)]);
% Pc(abs(Pc)<0.2) = [];
% figure;hist(Pc,-0.95:0.1:0.95);
% 
% xlabel('Change in Probability of firing due to pairing');
% set(gca,'YTick',[])
% set(gcf,'Color',[1 1 1]);
% axis square
% axis tight