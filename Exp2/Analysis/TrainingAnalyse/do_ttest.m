function P = do_ttest( Pattern1 , Pattern2)
%FIND_MEAN_TIME Summary of this function goes here
%   Detailed explanation goes here



P = zeros(size(Pattern1,1),size(Pattern1,2));

for i=1:size(P,2)
    for j=1:size(P,1)
        x = Pattern1(j,i,:);
        x = x(:);
        y = Pattern2(j,i,:);
        y = y(:);
        %[~,p] = ttest2(x,y);
        p = ranksum(x,y);
        P(j,i) = p;
    end
end




end