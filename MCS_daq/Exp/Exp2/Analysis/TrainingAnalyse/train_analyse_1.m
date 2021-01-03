

%Create the average pattern

nTrials = numel(TrainCheck);
a = size(TrainCheck{1}.Pattern);

X = zeros(a(1),a(2),nTrials) ;

for i=1:nTrials
    Y = ones(size(TrainCheck{i}.Pattern));
    Y(isnan(TrainCheck{i}.Pattern)) = 0 ;
    X(:,:,i) = mean(Y,3);
end

