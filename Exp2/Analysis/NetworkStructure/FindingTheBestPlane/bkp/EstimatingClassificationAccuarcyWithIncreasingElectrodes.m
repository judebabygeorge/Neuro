
function [a,W,II] = EstimatingClassificationAccuarcyWithIncreasingElectrodes(P,SelectedPatterns)


a = zeros(size(P(:,SelectedPatterns)));
W = zeros(size(P,1)+1,numel(SelectedPatterns));
II = zeros(size(P,1),numel(SelectedPatterns));

%for PatternToDetect = 1:size(a,2)
for PatternToDetect = 8
    p = P(:,SelectedPatterns);

    %PatternToDetect = 1;

    PatternOrder = 1:1:size(p,2);
    PatternOrder(PatternToDetect) = [];
    PatternOrder = [PatternToDetect PatternOrder];
    p = p(:,PatternOrder);

    if(1)
        [~,I] = sort(abs(p(:,1) - 0.5), 'descend');
    else
        code = GetMostLikelyBinaryCode(p(:,1:numel(PatternToDetect)));        
        code = repmat(code,[1 numel(PatternOrder)]);
        code(:,2:end) = 1-code(:,2:end);
        Score = code.*p + (1-code).*(1-p);
        Score = sum(Score,2);        
        [~,I] = sort(Score,'descend');
        n = 60;
        [~,J] = sort(abs(p(I(1:n),1) - 0.5), 'descend');
        I = [I(J) ; I(n+1:end)];
    end
    II(:,PatternToDetect)=I;
    p = p(I,:);

    code = GetMostLikelyBinaryCode(p);



    e = zeros(size(p,1),1);
    for nEl = 1:size(p,1)
        r = GetProbabilityOfOccuranceofCode(p(1:nEl,:),code(1:nEl,1));        
        r = [r(1) 1-sum(r(2:end))/(numel(r)-1)];
        e(nEl) = mean(r(:));
    end
    a(:,PatternToDetect) = e;
    [~,J] = max(e);
    
    
    w = ones(size(p,1),1);
    w(code(:,1) == 0)= -1;
    w((J+1):end)=0;
    
    [w I]
    w =  [w;-sum(code(1:J,1))];
    
    
    
    K = zeros(121,1);
    K([I ; 121])=w;
    W(:,PatternToDetect) =K;
end
end

function b = GetMostLikelyBinaryCode(p)
    b = zeros(size(p));
    b(p>0.5) = 1;
end
function e = GetProbabilityOfOccuranceofCode(p,code)
    
    e = nan*zeros(size(p));
    for i=1:size(p,2)
        e(code==1,i) = p(code==1,i);
        e(code==0,i) = 1-p(code==0,i);
    end
    
    e = prod(e,1);
    
end
