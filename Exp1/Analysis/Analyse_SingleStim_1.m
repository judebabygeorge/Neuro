
%Now a histogram of number of responses caused by every electrode


Probability = 0.8   ;
nEl         = 4    ; 
a = mean(PFiring,3) ;
a(a<Probability) = 0;
a = sum(a)          ;
hist(a)             ; %Approximate number of active electrodes

%Show the mean of electrodes which show significant activity
I = find(a>nEl) ;
%Sort I in decreasing order of acivity
ft = a(I) ;
[~,I2] = sort(ft,'descend');
I = I(I2);

