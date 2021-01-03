function e = ClosestPlaneError(x,Ptest,target)

%nVectors = 4000;

%I = rand(size(Wt,1),nVectors);
%I(I<0.5) = 0;
%I(I>0.4) = 1;

%I(end,:) = 1;

I = Ptest;

%O1 = (Wt'*I>0);

O1 = target';

x(end) = x(end) - 0.5;


O2 =  (x*I>0);



%Absense of firing
a = (O1==1)&(O2==0);
%Incorret firing
b = (O1==0)&(O2==1);

O1 = O1(:);
a = sum(a(:)) ; b = sum(b(:));
sb = sum(O1==1)./sum(O1==0);
nE = a + b.*sb ;

e = nE;
e = e.^2;

%[x e]
end