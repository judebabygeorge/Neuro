    
    N = 4;  % Length of the set.
    K = 3;  % Number of samples taken for each sampling.
    H = nextperm(N,K);
    n = ((prod(1:N)/(prod(1:(N-K)))));
    A = zeros(n,K);
    for ii = 1:n
        A(ii,:) = H();        
    end
