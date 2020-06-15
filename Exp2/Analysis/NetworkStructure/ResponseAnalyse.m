
close all

if(1)
Pair = zeros(2,56+8);
idx = 1;
for i=1:7
    for j=i+1:8
        Pair(:,idx) = [i j]';
        idx = idx + 1;
    end
end
Pair(:,29:56) = Pair([2 1],1:28);
Pair(1,57:64)=1:8;
WW = rand(size(A))<0.5;
W = (randn(size(A))*0.2 + 0.35)+WW.*(randn(size(A))*0.05 + 0.5);

td = 0.5;
tau_ex = 3;

D  = d*0.0;
end


if(1)
W(Inhibitory,:)= -2;
W = W.*A;

Wv = W.*Av;


tau_ex = 1/tau_ex;
O = zeros(size(Wv,2),size(Pair,2));

inh = 0.5;
for i=1:56
    for j=1:120
        tdn = (D(Pair(1,i),j)) - (D(Pair(2,i),j)+td);        
        if(tdn<0)
             m1 =  Wv(Pair(1,i),j);             
             m2 =  Wv(Pair(2,i),j)*inh + Wv(Pair(1,i),j)*exp(-tdn*tau_ex);             
        else
             m1 =  Wv(Pair(2,i),j);
             m2 =  Wv(Pair(1,i),j)*inh + Wv(Pair(2,i),j)*exp(tdn*tau_ex);
        end 
        O(j,i)=max(m1,m2);
    end
end
for i=57:64
    O(:,i) = Wv(i-56,:)';
end


th=0.5;

if(0)
    O(O<th)=0;
    %O=O*0.5;
    O = O + randn(size(O))*0.01 ;
    O(O<0.02)=0;
    O(O>1)=1;
else
    O = (tansig(8*(O + randn(size(O))*0.01 - th))+1)*0.5;
end
Ps = rand(120,64,45);Ps=bsxfun(@lt,Ps,O);

if(0)
    Ch = zeros(120,56);


    for i=1:56
       a = 1 - (1- O(:,Pair(1,i)+56)).*(1-O(:,Pair(2,i)+56)) ;
       Ch(:,i) = O(:,i) - a;      
    end


    K1 = Ch(:);
    K1(abs(K1)<0.2)=[];
    b = -1.0:0.1:1.0;
    figure('Position',[10 400 600 600]);hist(K1,b);


    Ch = O(:,1:28) - O(:,29:56);
    K2 = Ch(:);
    K2(abs(K2)<0.2)=[];
    b = -1.0:0.1:1.0;
    figure('Position',[610 400 600 600]);hist(K2,b);

    Q = O>0.8;

    if(0)
    PP = Pair(1,1:56);

    xout = 0:3;
    x1 = zeros(4,1);
    for i=1:8
       c  = sum(Q(:,PP==i),2) ;
       x1 = x1    + hist(min(c,7-c),xout)';
    end
    %x1 = x1/8;

    figure('Position',[1210 400 600 600]);
    bar(xout,[x1 x2])
    end
end
end


if(0)
    figure;
    for i=1:120
        bar(O(i,:));
        getkey;
    end
end