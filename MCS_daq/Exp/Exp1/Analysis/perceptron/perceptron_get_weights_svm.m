function [nE,W] = perceptron_get_weights_svm(X,Ci)

 W = zeros(size(X,1),size(X,2)) ; 
%  Y = 1:1:size(Y,1) ;
%  Y = repmat(Y,[1 size(X,2)/size(Y,2)]);
 
 dn = 0.1 ;
 ds = 0.1 ;
 for i=1:size(X,2)      
     
      %Create Vectors
      C1 = X(:,i,:) ;
      C1 = reshape(C1,[size(C1,1) size(C1,2)*size(C1,3)]);
      
      id = 1:1:size(X,2);
      id(i) = [] ;
      
      C2 = X(:,id,:) ;
      C2 = reshape(C2,[size(C2,1) size(C2,2)*size(C2,3)]);
      
      %Update C1 to C2 elements ;
      Cn = rand(size(C1,1) , size(C2,2)-size(C1,2));
      Cp = mean(C1,2);
      Cn = bsxfun(@le,Cn,Cp);
      
      C1= [C1 Cn];
      
      C = [C1 C2];
      Y = zeros(size(C,2),1);
      Y(1:size(C1,2)) = 1 ;
      
      
      %size(C)
      %size(Y)
      model = svmtrain(Y, C(1:end-1,:)', ['-t 0 -s 0 -h 0 -c ' num2str(Ci) ' ']);      
      
      w = (model.sv_coef' * full(model.SVs));      
      %size(W)
      th = -model.rho ;
      
      
      W(:,i) = [w th]' ;      
      
    
      if((i/size(Y,1))>=dn)
        display(['done '  num2str(dn*100) ' %']);
        dn = dn + ds;
      end
  
 end
 
 nE = zeros(size(W,2),2) ;
 
 Y = zeros(size(X,2) , size(X,2),size(X,3));
 for i=1:size(X,2)
     Y(i,i,:) = 1;
 end
 X = reshape(X , [size(X,1) size(X,2)*size(X,3)]);
 Y = reshape(Y , [size(Y,1) size(Y,2)*size(Y,3)]);
 
 O = W'*X ;
 
 y = (O>0);
 %Absense of firing 
 a = (Y==1)&(y==0);
 %Incorret firing
 b = (Y==0)&(y==1);
 a = sum(a,2) ; b = sum(b,2);
 sb = sum(Y==1,2)./sum(Y==0,2);
 nE(:,1) = a + b.*sb ;

 y = (O<0);
 %Absense of firing 
 a = (Y==1)&(y==0);
 %Incorret firing
 b = (Y==0)&(y==1);
 a = sum(a,2) ; b = sum(b,2);
 sb = sum(Y==1,2)./sum(Y==0,2);
 nE(:,2) = a + b.*sb ;
 
 
 change = (nE(:,1) > nE(:,2))' ; 
 change = change*-1 ;
 change(change>-0.1) = 1 ;
 
 W = bsxfun(@times,W,change);
 
   
 
%Calculate Classification success
O = W'*X ;
y = (O>0);
 %Absense of firing
a = (Y==1)&(y==0);
%Incorret firing
b = (Y==0)&(y==1);

a = sum(a,2) ; b = sum(b,2);
sb = sum(Y==1,2)./sum(Y==0,2);
nE = a + b.*sb ;

%nE = [a b];

nSamples = sum(Y,2);
nE = nE./nSamples;
display([num2str(sum(nE < 0.3)) '/' num2str(numel(nE))])
nE = model;
end