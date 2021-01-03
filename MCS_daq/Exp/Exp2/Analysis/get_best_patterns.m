function [ PatternId W e] = get_best_patterns(P)
%GET_BEST_PATTERNS Summary of this function goes here
%   Detailed explanation goes here

%Sorted according to the best possible for classification

Y = ones(size(P)) ;


Y(isnan(P)) = 0 ;

nClasses = size(Y,2) ;

x  = ones([size(Y,1)+1 size(Y,2)*size(Y,3)]);
x(1:size(Y,1),:,:)  = reshape(Y,[size(Y,1) size(Y,2)*size(Y,3)]);

%xn = normc(x) ;
xn = x ;

t = zeros(size(Y,2),(size(Y,2)*size(Y,3)));

for i=1:nClasses
t(i,i:size(Y,2):end) = 1;
end

W = zeros(size(Y,1)+1,size(Y,2));
Wmin = W;



nIter = 1000;

err = zeros(nClasses,nIter);
emin = ones(nClasses,1)*size(x,2);

for i=1:nIter
  W2 = W ;
  [nE,W] = perceptron_train(x,xn,t,W);
  err(:,i) = nE ; 
  for j=1:nClasses
      if(nE(j) < emin(j))
          Wmin(:,j) = W2(:,j);
          emin(j) = nE(j);
      end
  end  
  if(rem(i,100) == 0)
      e = emin./size(Y,3) ;
      c =sum(e < 0.3);
      display([num2str(100*i/nIter) ' % done ' num2str(c) ' Classes' ]);
  end
end
      
[~,PatternId] = sort(emin,'ascend');
W = Wmin(:,PatternId) ;
% PatternId = 1:1:numel(emin);
%W  = Wmin;

a = max(abs(W)) + 1e-9;
a = (1./a)*16383;
W = round(bsxfun(@times,W,a));

%Adjust weights to scale for DSP


 %figure ; hist(emin) ;
 e = emin./size(Y,3) ;
 sum(e < 0.3);
 PatternId=reshape(PatternId,[1 numel(PatternId)]);
end

