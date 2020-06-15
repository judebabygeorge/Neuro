function E = DelayModelOptimFun(p)

[K1 K2] = DelayModelTest(p);

b = -1.0:0.1:1.0;
n1= hist(K1,b);
n1=n1./max(n1);

n2= hist(K2,b);
n2=n2./max(n2);
y = exp(-30*(b+0.8).^2) +  1*exp(-30*(b+0.05).^2) + exp(-30*(b-0.8).^2);
y = y./max(y);


E = sum((y-n1).^2) + sum((y-n2).^2) ;


end