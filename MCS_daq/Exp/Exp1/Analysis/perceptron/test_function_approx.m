
function [O W] = test_function_approx(X , Y)

%Number of input points = Columns of X
%Number of samples at each point = dim3
%Output = function on number of rows of input

%O should be approximated function
%W the weight vector to achieve this

%Using gradient descend to achieve this



%Adding a bias input 1

X(X==0) = -1;
%Effectivenes
% Pf = mean(X,3);
% X = bsxfun(@times,X,Pf);

s  = size(X);
X2 = -ones([(s(1)+1) s(2) s(3)]);
X2(1:s(1),:,:) = X ;




%Calculate Network output for every input

nIter  = 200;

err =  zeros(nIter,1);


eta   = 0.1;
gamma = 0; 
mu    = 1;
rho   = round(1/(2*eta));
rate  = 0.1;

E_p = 1e100;

nNeuronsInPool = 2*(rho+1) 
 W = rand((s(1)+1),nNeuronsInPool);
 
%  WW = [1 1 1 1 1 0;1 1 1 1 1 -4 ;  0 1 1 1 1 -3 ; 0 0 1 1 1 -2 ; 0 0 0 1 1  -1 ; 0 0 0 0 1 0 ; ]';
%  WW = [WW WW] ;
%  W = WW;

 W = normc(W);
 
[f az] = CalcPopulationOp(X2 , W,rho);

%Examples with error
e = bsxfun(@minus,f,Y);

dW2 = zeros(size(W));

for i=1:nIter  
    
    %Correction for weight vector
    %of each neuron
    gamma_sum = 0;
 
    for j=1:nNeuronsInPool
      %Scale factor from each example
      dW = -double(((e > eta) & (az(j,: ,:) >= 0))) ;
      dW = dW +  double((e < -eta) & (az(j,: ,:) <  0)) ;
      
      a  = double((e > 0  ) & (e < eta) & (az(j,: ,:) >=  0)&(az(j,: ,:) <   gamma));
      gamma_sum= gamma_sum+ sum(sum(a,2),3);
      
      dW = dW +  mu*a ;
      
      a = double((e < 0  ) & (e > -eta) & (az(j,: ,:) <  0)&(az(j,: ,:) >=  -gamma)) ;
      gamma_sum = gamma_sum + sum(sum(a,2),3);
      dW = dW +  -mu*a;
      
      dW = bsxfun(@times,X2,dW);
      dW = mean(mean(dW,2),3)  ;
      
      %p-delta rule
      dW2(:,j) = dW;        
    end
    
      gamma = gamma + rate*(eta*rho - min(4*eta*rho,gamma_sum));      
      
     % n = 2 ;
     % while(n>0)
     %     n= n - 1;
          %normalize
          W2 = W + rate*dW2;
        %  W2 = normc(W2);

         [f az] = CalcPopulationOp(X2 , W2,rho);
         %Examples with error
         e = bsxfun(@minus,f,Y);

         E = sum(sum(abs(e),2),3);

        if(E>E_p)
            rate = rate*0.5 ;
        else        
            rate = rate*1.1;
       %     W = W2 ;
       %     break ;
        end
    %  end
      %if(n==0)
          W = W2;
      %end
%       if(rate <=0.001)
%           display('Stuck !')          
%       end
    
    E_p = E ;
    err(i) = E;
    if(rem(i,100)==0)
      mean(f,3)
      display(['Error : ' num2str(E)]);       
    end
    if(rate < 1e-15)
        mean(f,3)
        display(['Error : ' num2str(E)]);
        err = err(1:i);
        break ;
    end
end

 display(min(err))
 plot(err);
 [O ~] = CalcPopulationOp(X2 , W , rho);
 O = mean(O,3)
end

function [f az] = CalcPopulationOp(X , W , rho)
    %Calculate output of all neurons  
    az = zeros(size(W,2),size(X,2),size(X,3));
    for j=1:size(W,2)
         y = bsxfun(@times,X,W(:,j));    
         y = sum(y);
         az(j,:,:)=y;
    end
    
    %O(:,:,1)
    %Now Calculate Output of the p-parallel
    Op = double(az>0) ;
    
    %Op(:,:,1)
    
    Op(Op==0) = -1;    
    %Op(:,:,1)
    %Squasuhing Function
    Op = sum(Op); %[-n to n]
   
    
   
    f = Op/(2*(rho-1)) ;
%     f(f<-1) = -1;
%     f(f> 1) =  1;
end


%O = number of +ve - number -ve
%input is anything neuron1 = negative check
%
