
global N W1 W2 Winh WW D

N  = 5000;
WW = rand(N,2)<0.1;
W1 = randn(N,2)*0.05;
W2 = randn(N,2)*0.05;
Winh = rand(N,2)<0.2;
Winh = -Winh*4;

D  =  poissrnd(10,[N,2]);
D  = D./max(D(:));

p0 =  [0.4 1.2 3];

opts = optimset('Algorithm','interior-point','DiffMinChange',0.01);
p = fmincon(@DelayModelOptimFun,p0,[],[],[],[],[0.3 0 0],[0.5 5 2],[],opts);
%p = fminsearch(@DelayModelOptimFun,p0,opts);


p
if(1)
    [K1 K2] = DelayModelTest(p);
    close all;



    close all
    b = -1.0:0.1:1.0;
    figure('Position',[100 400 600 600]);hist(K1,b);
    figure('Position',[800 400 600 600]);hist(K2,b);
end
