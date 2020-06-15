function d = dist_SpikeDelay( XI,XJ )
%DIST_FS Summary of this function goes here
%   Detailed explanation goes here


th = 5 ; 
d = bsxfun(@minus,XI,XJ) ;
mask = bsxfun(@or,isnan(d),isinf(d));

a1 = sum(~isinf(XI));
a2 = sum(~isinf(XJ),2);
a  = max(a1,a2);
d(mask) = 2*th;
d = 1 - (sum((abs(d) < th),2)./a);

end

