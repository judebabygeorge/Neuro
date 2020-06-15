function [p,x] = fit_best_piecewise_linear(y,n)

idx = 1;
p = zeros(2,n*(n+1)/2);
x = zeros(n,1);

if(n>0)
    p(:,1) = get_best_fit_1(y);
    x(1) = 0;
end

if(n>1)
    [q,idx] = get_best_fit_2(y) ;
    p(:,2:3)=q;
    x(2) = idx;
end

end

function p = get_best_fit_1(y)  
  N = numel(y);
  x  = (1:1:N)';  
  p  = polyfit(x,y,1);
  p = p';
end

function [p,idx] = get_best_fit_2(y)  
  N = numel(y);
  x  = (1:1:N)';  
  
  e = Inf;
  p = zeros(2,2);
  idx = 2;
  for i=2:(N-2)
    p1  = polyfit(x(1:i),y(1:i),1);
    p2  = polyfit(x(i+1:N),y(i+1:N),1);
    ee = sum(polyval(p1,x(1:i))-y(1:i).^2)+sum(polyval(p1,x(i+1:N))-y(i+1:N).^2);
    if(ee<e)
        e = ee;
        p = [p1;p2];
        idx = i;
    end
  end
  p = p';
end