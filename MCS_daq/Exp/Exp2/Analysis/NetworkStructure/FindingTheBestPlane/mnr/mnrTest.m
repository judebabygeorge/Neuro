P = mean(PatternsOrig,3);
nSamples = 400;

if(1)
    Patterns = bsxfun(@lt,rand(size(P,1),size(P,2),nSamples),P);
else
    Patterns = PatternsOrig;
    nSamples = size(Patterns,3);
end
SelectedPatterns = 2:2:112;
nTrain = 45;
Ptest  = reshape(Patterns(:,SelectedPatterns,:),[size(Patterns,1) numel(SelectedPatterns)*size(Patterns,3)]);
PTrain = reshape(Patterns(:,SelectedPatterns,1:nTrain),[size(Patterns,1) numel(SelectedPatterns)*nTrain]);

e = zeros(numel(SelectedPatterns),1);
for i=1:numel(SelectedPatterns)
    target = zeros(numel(SelectedPatterns),nTrain);
    target(i,:)=1;  
    target = target(:);    
    B = glmfit(PTrain',target,'binomial');
    yy=glmval(B,double(Ptest)','logit');
    yy =reshape(yy,[numel(SelectedPatterns) nSamples]);
    
    th = 0.05;
    yy(yy<th)=0;
    yy(yy>(th-0.01))=1;
    yy = mean(yy,2);    
    ee = (1-yy(i)) + (sum(yy)-yy(i))/(numel(yy)-1) 
    e(i) = ee;
end

sum(e<0.2)