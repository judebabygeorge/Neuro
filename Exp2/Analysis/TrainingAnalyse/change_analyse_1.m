

%Create the average pattern

nTrials = numel(ChangeCheck);
a = size(ChangeCheck{1}.Pattern);

X = zeros(a(1),a(2),nTrials) ;

for i=1:nTrials
    Y = ones(size(ChangeCheck{i}.Pattern));
    Y(isnan(ChangeCheck{i}.Pattern)) = 0 ;
    X(:,:,i) = mean(Y,3);
end

