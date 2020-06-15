
d = zeros(120,120);
loc = [ChannelMapping.row ChannelMapping.col];
for i=1:120
    x = bsxfun(@minus,loc,loc(i,:));
    x = sum(x.^2,2).^0.5;
    d(:,i) = 1./x ;
end

P = PatternData.Pattern;
P(P>100*50) = nan;

for i=1:120
    P(:,i,:) = bsxfun(@times , P(:,i,:) , d(:,i));
end

P = P(~isnan(P));
P = P(~isinf(P));
P = reshape(P,[numel(P) 1]);
P = P/50;
hist(P,0.5:1:100);