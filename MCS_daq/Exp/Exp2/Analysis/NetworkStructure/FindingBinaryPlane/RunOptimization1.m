
Wt = [-1.1 0.95  0.1  0.95  1 0.8 -1.2 -5.6]';
%Wt = rand(5,1)*2-1;

nVectors = 4000;

I = rand(size(Wt,1),nVectors);
I(I<0.5) = 0;
I(I>0.4) = 1;

I(end,:) = 1;

opts = gaoptimset();
f  = @(x)ClosestPlaneError1(x,Wt,I);
x  = ga(f,size(Wt,1),[],[],[],[],[ones(1,size(Wt,1)-1)*-1 -(size(Wt,1)-2)],[ones(1,size(Wt,1)-1)*1 0],[],1:size(Wt,1),opts);
e = ClosestPlaneError1(x,Wt,I)^0.5