function v = gen2dv(xr, yr)

% v = gen2dv(xv, yv)
% Creates a matrix of 2-d column vectors corresponding to each point
% in the grid described by xv and yv
% xr - vector of x-coordinates, eg 1:5
% yr - vector of y-coordinates, eg 1:0.5:3
% v  - matrix of column vectors, column wise order according to xv and yc
%      For the examples above: v is of size 2x25 and looks like
%          v = [1  1    1  1    1  2 2   ... ] 
%              [1  1.5  2  2.5  3  1 1.5 ... ]

m = size(xr, 2);	% Number x-values
n = size(yr, 2);  % Number of y-values

v=ones(2,m*n);		% Resulting matrix

for i=1:m,
   for j=1:n,
      v(1,(i-1) * n + j) = xr(i);
      v(2,(i-1) * n + j) = yr(j);
   end
end 	