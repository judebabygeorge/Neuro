function O = CubicFitFilter(data)
%CUICFILTERMEX Summary of this function goes here
%   Detailed explanation goes here

N = 100        ;
T = zeros(7,1) ;



for k=0:6
 T(k+1) = sum((-N:N).^k);
end

S = zeros(4,4);
for k = 0:3
    for l = 0:3
        S(k+1,l+1) = T(k+l+1);
    end
end


Sinv = S\eye(size(S));
S = zeros(2,1);
S(1) = Sinv(1,1);
S(2) = Sinv(3,1);

O = CubicFitFiltermex(data,N,S);
end

