

Z = rand(200,2) ;
Z(Z>0.5) = 1 ;
Z(Z<1)   = 0 ;

z = 1.*Z(:,1) + 2.*Z(:,2)  ;
% y = z ;

y = zeros(size(z));
y(z>1) = 1;

%a = rand(size(y)) ;
%y = y.*(a>0.2) ;


% [b,dev,stats]  = glmfit(Z,y,'normal','identity');
% 
% yhat = glmval(b,Z,'identity');
% yhat(yhat>0.5) =1;
% yhat(yhat<1) = 0;
% 
% sum(y~=yhat)
% k = [y yhat];
% b = b./min(b);

%b = regress(y,Z);

inputs  = Z ;
outputs = y ;

              model = svmtrain(outputs, inputs, '-t 0 -c 50');
              w = (model.sv_coef' * full(model.SVs));
              th = -model.rho ;
              scaled_weights = -(th .* w) ./ (norm(w)^2);
             
              
            
  figure ; hold on;
 
  
  m  = -scaled_weights(1) ./ scaled_weights(2);
  m  = max(min(m, 100000), -100000);
  c  = scaled_weights(2) - (scaled_weights(1) .* m);
  b  = 1; 
  edges = [-b (-b * m) + c; (b - c)./m b; b (b * m) + c; -(b + c) ./ m -b];

  boundary = edges(sum(abs(edges), 2) <= 10, :);
      
  plot(boundary(:, 1), boundary(:, 2), '--r')
  
  o  = (inputs * w') + th;
  o = sign(o);
  o(o<0) = 0;
  %output(abs(input) < 0.001) = 0;
  
  y = o;
  scatter(Z((y==0),1),Z((y==0),2),'filled','b');
  scatter(Z((y==1),1),Z((y==1),2),'filled','r');
      