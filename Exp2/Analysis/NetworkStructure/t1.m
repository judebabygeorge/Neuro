
N = 45;
P = zeros(N,1);

for x=1:N
    P(x) = (factorial(N)/(factorial(x)*factorial(N-x)))*(0.5^x)*(0.5^(N-x));
end

