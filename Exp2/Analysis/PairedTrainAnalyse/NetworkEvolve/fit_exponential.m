function f = fit_exponential(y,depth)
  f = zeros(numel(y),3)*nan;
  N = numel(y);
  
  %fit_type = fittype('c + a*exp(-b*x)');
  %fit_type = fittype('b + a*x');
  for i=1:N-depth+1
      y0 = y(i:i+depth-1);
      %[a,b,e]= fit_exp(y0,fit_type);
      [a,b,e]= fit_lin(y0);
      f(i,:) =[a,b,e];
  end
  
  %f = bsxfun(@rdivide,f,max(f));
  %x = 1:1:numel(y);
  %f = c + a*exp(-b*x);
  
end
function [a,b,e]= fit_lin(y)
  x  = (0:1:numel(y)-1)';
  
  
  p  = polyfit(x,y,1);
 

      y0= polyval(p,x);
      e = sum((y-y0).^2);
      b = p(2);
      a = p(1);

  

end    
function [a,b,e]= fit_exp(y,fit_type)
  x  = (0:1:numel(y)-1)';
  
  
  f = fit(x,y,fit_type);
  
%   a = NaN;
%   b = NaN;
%   e = NaN;
%   
  v = coeffvalues(f);
  %if(v(2)>0)
      y0= feval(f,x);
      e = sum((y-y0).^2);
      b = v(2);
      a = v(1);
  %end
  %plot([x x],[y y0])
  

end    
  
  