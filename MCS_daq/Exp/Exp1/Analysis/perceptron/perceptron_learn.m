function [o w] = perceptron_learn(x,d)
%PERCEPTRON_LEARN Summary of this function goes here
%   Detailed explanation goes here

d(d==0) = -1 ;

%Normalize all inputs
m = mean(x,2);
s = std(x,0,2);
s(s==0)=1;

x = bsxfun(@minus,x,m);
x = bsxfun(@rdivide,x,s);

%Append bias

X = ones([size(x,1)+1 size(x,2)]);
X(1:end-1,:)= x ;

%Calculate the optimum weight

w = zeros(size(X,1),size(d,1));

for i=1:size(d,1)
 w(:,i) = sum(bsxfun(@times,X,d(i,:)),2);
end
w = normc(w);

o = zeros(size(d));

for i=1:size(d,1)
o(i,:) = sum(bsxfun(@times,X,w(:,i)));
end
o(o>0) = 1 ;
o(o<=0) = -1;

end

