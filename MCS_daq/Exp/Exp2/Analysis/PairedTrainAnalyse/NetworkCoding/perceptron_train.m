function [nE,W] = perceptron_train(X,Xn,Y,W)

%Classes should be labelled as 1/0
%PERCEPTRON_TRAIN Summary of this function goes here
%   Detailed explanation goes here

%First Calculate the output
%CxS =  nXC nxS   Cx1

O = W'*X ;
y = (O>0);


% m = mean(Y,2);
% Z = zeros(size(Y));
% 
% for i=1:size(Z,1)
%     id = Y(i,:)==1;
%     Z(i,id)  = m(i);
%     id = Y(i,:)==0;
%     Z(i,id)  = 1-m(i);
% end


%    CxS
e =  Y - y ;
% e = e.*Z ;

%Absense of firing
a = (Y==1)&(y==0);
%Incorret firing
b = (Y==0)&(y==1);

a = sum(a,2) ; b = sum(b,2);
sb = sum(Y==1,2)./sum(Y==0,2);
nE = a + b.*sb ;
%nE = a + b;
%nE = sum((e~=0),2);

for i=1:size(W,2)
 W(:,i) = W(:,i) + sum(bsxfun(@times,Xn,e(i,:)),2);
end


% %Number of times each vector was used 
% %for an update
% e2 = sum(e~=0);
% %Number of times a feature was used 
% %for an update
% e2 = sum(bsxfun(@times,X,e2),2);
% 
% [~,I] = sort(e2) ;
% W(I(1:5)) = 0 ;

end

