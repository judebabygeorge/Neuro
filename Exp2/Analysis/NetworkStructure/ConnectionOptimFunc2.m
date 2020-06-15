function e = ConnectionOptimFunc2(x,t,Pair) 
 
 O = ConnectionOpCalc(x,Pair);

 
 e = (O(:) - t(:)).^2;
 e = sum(e(1:56))+(14*sum(e(57:64)));
 
end

