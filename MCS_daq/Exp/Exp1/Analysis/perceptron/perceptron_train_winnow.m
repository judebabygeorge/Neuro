function [nE,W,b] = perceptron_train_winnow(X,~,Y,W,~)

%Classes should be labelled as 1/0
%PERCEPTRON_TRAIN Summary of this function goes here
%   Detailed explanation goes here

%First Calculate the output
%CxS =  nXC nxS   Cx1
b = ones(size(W,2),1).*size(W,1);
O = bsxfun(@minus,W'*X , b) ;

y = zeros(size(O));
y(O>0) = 1;

%    CxS
e =  Y - y ;

nE = sum((e~=0),2);


for i=1:size(W,2)
 u = bsxfun(@times,X,e(i,:));
 u = 2.^u ; 
 W(:,i) = W(:,i).*prod(u,2);
%  if(i==1)
%     prod(u,2)
%  end
end

%b = b + sum(e,2);
end

