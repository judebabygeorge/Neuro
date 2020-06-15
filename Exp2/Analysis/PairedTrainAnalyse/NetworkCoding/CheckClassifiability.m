function [emin, Wmin] = CheckClassifiability(PatternData,SelectedPatterns,C)


[Patterns , PatternConfig ]= EditPatterns(PatternData);
P = ones(size(Patterns));
P(isnan(Patterns)) = 0;
mean(mean(mean(P,3),2))
  Y = P(:,SelectedPatterns,:) ;
  %% Taking n at a time
n = 1 ;
a = size(Y,2);
Seq = nchoosek(1:1:a,n);

 nClasses = size(Seq,1) ;
 t = zeros(nClasses,(size(Y,2)*size(Y,3)));
 for i=1:nClasses
   for j = 1:n  
     t(i,Seq(i,j):size(Y,2):end) = 1;
   end
 end


x  = ones([size(Y,1)+1 size(Y,2)*size(Y,3)]);
x(1:size(Y,1),:,:)  = reshape(Y,[size(Y,1) size(Y,2)*size(Y,3)]);
%xn = normc(x) ;
xn = x ;



W = zeros(size(Y,1)+1,nClasses);
Wmin = W;

emin = ones(nClasses,1)*size(x,2);

nIter = 1000;
err = zeros(nClasses,nIter);


for i=1:nIter
  W2 = W ;
  [nE,W] = perceptron_train(x,xn,t,W);
  W = W.*C;
  err(:,i) = nE ; 
  for j=1:nClasses
      if(nE(j) < emin(j))
          Wmin(:,j) = W2(:,j);
          emin(j) = nE(j);
      end
  end  
  if(rem(i,100) == 0)
      display(['done '  num2str(100*i/nIter) ' %'])
  end
end
for i=1:nClasses
  nSamples = sum(t(i,:));
  e = emin./nSamples ;
end

 display([num2str(sum(e < 0.2)) '/' num2str(numel(e))])
 
end