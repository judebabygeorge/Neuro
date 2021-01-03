
P = PatternData.Pattern;
E = PatternData.StimConfig.Electrodes(1,1:8) ;
E = reshape(E,[1 numel(E)]);
E = E(E~=0);
P(E,:,:)=nan;
P(P<5*50) = nan;

X = ones(size(P)) ;
X(isnan(P)) = 0 ;

Pf = mean(X,3) ;
Pf = reshape(Pf,[1 numel(Pf)]);
Pf(Pf<0.05) = 0 ;

b = sum(sum(sum(X)));
a = numel(X) - b ;



a= 1/a  ;
b = 1/b ;
y = hist(Pf,0.05:0.1:1.05);

x = (1:1:numel(y)) - 1;
x = a + x.*(b-a)/(numel(y)) ;
y = y.*x ;

bar(y)
