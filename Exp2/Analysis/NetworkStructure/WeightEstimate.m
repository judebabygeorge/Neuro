

x0 = [ones(1,8)*0.5 ones(1,8)*0];
optsf = optimset('Algorithm','interior-point','DiffMinChange',0.01);
opts = gaoptimset();

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

idx = 1;
W = zeros(8,120);
C = zeros(8,120);
D = zeros(8,120);

Q  = zeros(120,64);
E  = zeros(120,1);
for i=1:120
    i
    t = P(i,:);    
    f = @(x)ConnectionOptimFunc(x,t,Pair);
    %x = fmincon(f,x0,[],[],[],[],[ones(1,8)*0 ones(1,8)*0],[ones(1,8)*1 ones(1,8)*1],[],opts);
    x = ga(f,24,[],[],[],[],[ones(1,8)*0 ones(1,8)*0 ones(1,8)*0],[ones(1,8)*1 ones(1,8)*1 ones(1,8)*1],[],17:24,opts);
    C(:,i)= x(17:24)';
    
    f = @(x)ConnectionOptimFunc2(x,t,Pair);
    x = fmincon(f,x0,[],[],[],[],[ones(1,8)*0 ones(1,8)*0],[ones(1,8).*C(:,i)' ones(1,8)*1],[],opts);
     
    W(:,i)= x(1:8)';
    
    D(:,i)= x(9:16)';
    
    O = ConnectionOpCalc(x,Pair);
    Q(i,:)=O;    
end

e=sum(sum((Q-P).^2))/numel(Q)