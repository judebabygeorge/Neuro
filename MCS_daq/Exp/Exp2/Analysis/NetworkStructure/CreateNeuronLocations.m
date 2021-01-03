%Randomize Locations in a circle of radius 1
r  = rand(nTotal,1);
th = 2*pi*rand(nTotal,1);

x  = r.*cos(th);
y  = r.*sin(th);

dx = bsxfun(@minus,repmat(x,[1,nTotal]),x');
dy = bsxfun(@minus,repmat(y,[1,nTotal]),y');

d  = (dx.^2 + dy.^2).^0.5;
d  = d./max(d(:));


Exciatory = rand(nTotal,1) < 0.8;
Inhibitory = logical(1-Exciatory);