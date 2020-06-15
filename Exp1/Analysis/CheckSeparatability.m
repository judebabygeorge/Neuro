
function [ClassifyEfficiency1 nSeparable]  =  CheckSeparatability(Pattern)
nIter    = 10                         ;  
nSamples = size(Pattern,3);
nTrain   = floor(nSamples*0.5) ;

nSeparable = zeros(nIter,2);
ClassifyEfficiency1 = zeros(nIter , size(Pattern,2));
ClassifyEfficiency2 = zeros(nIter , size(Pattern,2));
for i=1:nIter    
    sel = randperm(nSamples) ;

    Features = CreatePatternFeatures(Pattern(:,:,sel(1:nTrain)));
    [Class Match] =  DecodePatterns(Features,Pattern(:,:,sel((nTrain+1):end)),'weight_inh');
    
    
    I = 1:1:size(Class,2);
    Correctness = bsxfun(@eq,Class,I);
    ClassifyEfficiency1(i,:) = sum(Correctness)./size(Correctness,1);
    nSeparable(i,1) = sum(ClassifyEfficiency1(i,:)>0.7);
    
    [Class Match] =  DecodePatterns(Features,Pattern(:,:,sel((nTrain+1):end)),'weight_del_inh');
    I = 1:1:size(Class,2);
    Correctness = bsxfun(@eq,Class,I);
    ClassifyEfficiency2(i,:) = sum(Correctness)./size(Correctness,1);
    nSeparable(i,2) = sum(ClassifyEfficiency2(i,:)>0.8);
    
    %mean(ClassifyEfficiency)
end
a=round(mean(nSeparable));
display(['Separable Classes : '  num2str(a(1)) '/' num2str(a(2)) ]);
%mean(ClassifyEfficiency)


%     Features = CreatePatternFeatures(PatternData.Pattern(:,:,:));
%     [Class Match] =  DecodePatterns(Features,PatternData.Pattern(:,:,:),'weight_delinh');
% 
%     I = 1:1:size(Class,2);
%     Correctness = bsxfun(@eq,Class,I);
%     ClassifyEfficiency = sum(Correctness)./size(Correctness,1);
% 
%     sum(ClassifyEfficiency>0.7)
%     mean(ClassifyEfficiency)
end