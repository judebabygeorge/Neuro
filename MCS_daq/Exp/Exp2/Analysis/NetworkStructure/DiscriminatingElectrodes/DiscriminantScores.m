

function Scores = DiscriminantScores(P,SelectedPatterns)

Ps = P(:,SelectedPatterns);

nPatterns = size(Ps,2);
Scores = zeros(size(Ps,1),nPatterns*(nPatterns-1));

idx = 0;
for i=1:(nPatterns-1)    
   for j=(i+1):nPatterns
       S = (Ps(:,i)-Ps(:,j)).^2;
       s = numel(S);
       S = (S/sum(S))*s;
       idx=idx + 1; Scores(:,idx)=S;       
   end
end
end