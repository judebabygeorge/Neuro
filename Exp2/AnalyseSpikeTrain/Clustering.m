
P1 = SmoothTrains( P );

P2 = reshape(P1,[1000 120*62]);

K = zeros(62,120);
for k=1:120
    K(:,k) = (k:120:7440);
end
K= reshape(K,[numel(K) 1]);
P2=P2(:,K)';

[COEFF,SCORE,latent,tsquare] = princomp(P2);
Y = pdist(SCORE(:,1:100),'euclid'); 
%Y = pdist(P2,'euclid'); 
Y2 = squareform(Y);

E = sum(P2,2);
Y2 = Y2./(E*E').^.5;


Z = linkage(Y,'single'); 
T = cluster(Z,'maxclust',120); 

