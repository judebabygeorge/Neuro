function Th = calculate_threshold_sd (D)

%Split the std determination into smaller bins


nC = size(D,2);
nS = size(D,1);


nSplit = ceil(nS/10);
n = 1:nSplit:nS ;

sd = zeros(numel(n)-1,nC);
for i=1:numel(n)-1
 sd(i,:) = median(abs(D(n(i):n(i+1),:)))/0.6745;   
end
sd = sort(sd);
Th = 5*mean(sd(1:5,:));

end