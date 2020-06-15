function T = find_mean_firing_time(P)

X = ones(size(P));
X(isnan(P)) = 0 ;
P(isnan(P)) = 0 ;

P  = sum(P,3);
X  = sum(X,3);

T  = P./X ;

T(isnan(T)) = 0;


end
