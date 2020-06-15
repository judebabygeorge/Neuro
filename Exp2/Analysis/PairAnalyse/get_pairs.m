function [PairId Wo PairError] = get_pairs( Patterns )
%GET_DISTINGUISHABLE_PAIRS Summary of this function goes here
%   Detailed explanation goes here

%Find pairs
Pid = 1:size(Patterns,2);
Pid = reshape(Pid,[2 numel(Pid)/2]);

%Train Pairs
PairError= zeros(2,size(Pid,2));
Wo = zeros(121,numel(Pid));
for i= 1:size(Pid,2)
    sprintf('Training pattern %d',i);
    [PatternId W e] = get_best_patterns(Patterns(:,Pid(:,i),:));
    PairError(:,i)=e;
    Wo(:,Pid(PatternId,i))=W;
end
e = PairError(1,:);
[~,I] = sort(e,'ascend');
PairId = Pid(:,I)';
PairError = PairError(:,I)';
end

