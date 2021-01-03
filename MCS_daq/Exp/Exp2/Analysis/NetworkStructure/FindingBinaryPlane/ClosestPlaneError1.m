function e = ClosestPlaneError1(x,Wt,I)





O1 = (Wt'*I>0);
x(end) = x(end) - 0.5;

O2 =  (x*I>0);


e = sum(O1 ~= O2);
e = e.^2;

end