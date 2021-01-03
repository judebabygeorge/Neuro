
P = PatternData.Pattern;
E = PatternData.StimConfig.Electrodes ;
E = reshape(E,[1 numel(E)]);
E = E(E~=0);
P(E,:,:)=nan;

P(P>25*50) = nan; 

%[ 10(14) 15(32) 20(38) 25(40) 30(36) 35(31) 40(6) 45(10) 50(12) 55(7)]
%[25(0) 50(2) 100(3) 150(4) -0]
X = ones(size(P)) ;
X(isnan(P)) = 0 ;

%SelectedPatterns = 2:2:size(PatternData.Pattern,2);
%SelectedPatterns = (1:1:56)*2;
SelectedPatterns = 1:1:size(PatternData.Pattern,2);
% subset = 16 ;
% SelectedPatterns = randperm(size(X,2));
% SelectedPatterns = SelectedPatterns(1:subset);

Y = X(:,SelectedPatterns,:) ;

%% Taking One at a time
% nClasses = size(Y,2) ;
% t = zeros(nClasses,(size(Y,2)*size(Y,3)));
% for i=1:nClasses
%  t(i,i:size(Y,2):end) = 1;
% end

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

nFeatureUpdates = zeros(size(x,1),nIter);

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
      display(['done '  num2str(100*i/nIter) ' %'])
  end
end

%find_classification_error(Y,tg,Wmin)

hist(emin) ;

for i=1:nClasses
  nSamples = sum(t(i,:));
  e = emin./nSamples ;
end

 display([num2str(sum(e < 0.3)) '/' num2str(numel(e))])

% plot(err)
% min(err)
% err(end)