function P = find_mean_pattern( Pattern )
%FIND_MEAN_PATTERN Summary of this function goes here
%   Detailed explanation goes here


% Pattern = Pattern(:,:,SelectedSamples);
% P = ones(size(Pattern)) ;
% P(isnan(Pattern)) = 0 ;
P = mean(Pattern,3);

end

