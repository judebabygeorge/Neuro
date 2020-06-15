function e = ConnectionOptimFunc(x,t,Pair) 
 
 x = [x(1:8).*x(17:24)  x(9:16)];
 O = ConnectionOpCalc(x,Pair);

 
 e = (O(:) - t(:)).^2;
 e = sum(e(1:56))+(14*sum(e(57:64)));
 
end

