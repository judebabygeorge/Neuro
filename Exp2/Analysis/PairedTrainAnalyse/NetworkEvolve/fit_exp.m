function [a,b,e]= fit_exp(y)
  x  = (0:1:numel(y)-1)';
  %ly = log(y+1e-10);
  %plot(x,ly)
  
  fit_type = fittype('c + a*exp(-b*x)');
  f = fit(x,y,fit_type);
  %p  = polyfit(x,ly,1);
  
  a = NaN;
  b = NaN;
  e = NaN;
  
  v = coeffvalues(f);
  if(v(2)>0)
      y0= feval(f,x);
      e = sum((y-y0).^2);
      b = v(2);
      a = v(1);
  end
  %plot([x x],[y y0])
  

end    
  