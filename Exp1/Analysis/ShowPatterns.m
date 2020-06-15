

nPatterns = size(PatternData.Pattern,2) ;

PFiring = ones(size(PatternData.Pattern));
PFiring(isnan(PatternData.Pattern)) = 0;
Probability = 0.6;
a = mean(PFiring,3);
a(a<Probability) = 0;
a = sum(a) ;
[~,I] = sort(a,'descend');

I = 1:1:numel(I);
%I = x ;
for i=1:numel(I)
  close all
  I(i)
  P = PatternData.Pattern(:,I(i),:);  
  %P = P + (PatternData.StimConfig.PatternDelay(1,I(i))  - 50)*50;
  ShowPattern(P);
  waitforbuttonpress;
end
