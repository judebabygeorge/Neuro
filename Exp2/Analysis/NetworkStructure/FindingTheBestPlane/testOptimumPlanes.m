P = mean(PatternsOrig,3);
nSamples = 400;
if(1)
    [a,W] = EstimatingClassificationAccuarcyWithIncreasingElectrodes(P,SelectedPatterns);
    sum(max(a)>0.8)
else
    W = Wmin;
end
if(1)
    Patterns = bsxfun(@lt,rand(size(P,1),size(P,2),nSamples),P);
else
    Patterns = PatternsOrig;
    nSamples = size(Patterns,3);
end
%SelectedPatterns = 1:2:112;
Ptest = [reshape(Patterns(:,SelectedPatterns,:),[size(Patterns,1) numel(SelectedPatterns)*size(Patterns,3)]);ones(1,numel(SelectedPatterns)*size(Patterns,3))];

e = zeros(numel(SelectedPatterns),1);
for i=1:numel(SelectedPatterns)
    target = zeros(numel(SelectedPatterns),size(Patterns,3));
    target(i,:)=1;  
    target = target(:);    
    e(i) = ClosestPlaneError(W(:,i)',Ptest,target)^0.5;    
end
sum(e/nSamples < 0.2)
