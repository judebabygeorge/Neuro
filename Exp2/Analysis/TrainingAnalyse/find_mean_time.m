function P = find_mean_time( Pattern,SelectedSamples )
%FIND_MEAN_TIME Summary of this function goes here
%   Detailed explanation goes here

Pattern = Pattern(:,:,SelectedSamples);

P = zeros(size(Pattern,1),size(Pattern,2))*nan;

for i=1:size(P,2)
    for j=1:size(P,1)
        a = Pattern(j,i,:);
        a = reshape(a,[numel(a) 1]);
        a = a(~isnan(a));
        P(j,i) = mean(a);
    end
end

P = P/10000 ;


end

