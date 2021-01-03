function Th = calculate_threshold_max (D)

nC = size(D,2);
nS = size(D,1);


nSplit = ceil(nS/10);
n = 1:nSplit:nS ;

maxv = zeros(numel(n)-1,nC);
for i=1:numel(n)-1
 maxv(i,:) = max(abs(D(n(i):n(i+1),:)))   ;
end
maxv = sort(maxv);
Th = 1.5*mean(maxv(1:5,:));


end