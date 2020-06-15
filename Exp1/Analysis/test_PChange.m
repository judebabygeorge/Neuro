
PFiring = ones(size(PatternData.Pattern));
PFiring(isnan(PatternData.Pattern))=0 ;
Pf = mean(PFiring,3);


i1 = 1:2:size(Pf,2);
i2 = 2:2:size(Pf,2);

S1 = Pf(:,i1);
S2 = Pf(:,i2);

SA = S1./S2 ;
SB = S2./S1 ;

SA(isnan(SA))=nan;
SB(isnan(SB))=nan;
SA(isinf(SA))=nan;
SB(isinf(SB))=nan;

S  = max(SA,SB);

hist(reshape(S,[1 numel(S)]),0:0.1:5);
