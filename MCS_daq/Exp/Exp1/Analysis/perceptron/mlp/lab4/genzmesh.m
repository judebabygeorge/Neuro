function z = genzmesh(xr, yr, f)

% z = genzmesh(xr, yr, f)
% Creates a mesh z-matrix from 2-d vectors taken from the range xr and yr
% xr - vector of x-coordinates
% yr - vector of y-coordinates
% f  - Either a vector of function values or a string of an m-function
%      of the form f(x) where x is an 2d-vector, [xr(i),yr(j)]'
%      For the case of a vector the function values must be in column
%      wise order, eg
%      xr = 1:5, yr = 1:0.5:3
%      f = [ f([1]) f([1  ]) f([1]) f([1  ]) f([1])  f([2])... ] 
%              [1]    [1.5])   [2]    [2.5]    [3]     [1]
% z  - matrix (elems in yr X elems in xr) sizey x sizeto be used with MESH
%      for example

m = max(size(xr));
n = max(size(yr));

v=ones(m,n);

if isstr(f)
   s = 1;
else
   s = 0;
end

for i=1:m,
   for j=1:n,
      if s == 1
         eval(f);
      else
         z(j,i) = f((i-1)*n + j);
      end
   end
end 	
