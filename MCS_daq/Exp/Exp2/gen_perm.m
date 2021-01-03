function O = gen_perm(N,K) 
  
    H = nextperm(N,K);
    n = ((prod(1:N)/(prod(1:(N-K)))));
    O = zeros(n, K) ;
    
    for ii = 1:n
        O(ii,:) = H();        
    end  
  
end