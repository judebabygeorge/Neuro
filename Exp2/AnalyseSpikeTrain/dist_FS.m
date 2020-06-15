function d = dist_FS( X1,X2 )
%DIST_FS Summary of this function goes here
%   Detailed explanation goes here


d = bsxfun(@minus,X2,X1) ;

mask = bsxfun(@or,isnan(d),isinf(d));
d(mask) = 0;

d = sum(d.^2,2).^0.5./sum(~mask,2) ;
d(isnan(d))=inf;
end

