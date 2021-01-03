
P = PatternData.Pattern;
E = PatternData.StimConfig.Electrodes(1,1:8) ;
E = reshape(E,[1 numel(E)]);
E = E(E~=0);
P(E,:,:)=nan;

PatternToCheck = 2 ;

X = ones(size(P)) ;
X(isnan(P)) = 0 ;

SelectedPatterns = (1:1:16)*2;
Y = X(:,SelectedPatterns,:) ;

nClasses = 1;
t = zeros(nClasses,size(Y,2),size(Y,3));
t(1,PatternToCheck,:) = 1;


W = zeros(size(Y,1)+1,nClasses);
Wmin = W;

emin = ones(nClasses,1)*size(x,2);

nIter = 1000;
err = zeros(nClasses,nIter);


nSamples = size(Y,3); 
nTrain   = round(nSamples/2);
%nTrain   = 30;
seq      = 1:1:nSamples;randperm(nSamples);
TrainSamples = seq(1:nTrain);
%TrainSamples = seq(1:end);
CheckSamples = seq(nTrain+1:end);


%% Creating vectors
x  = ones([size(Y,1)+1 size(Y,2),size(Y,3)]);
x(1:size(Y,1),:,:)  = Y;
x = x(:,:,TrainSamples);
tt = t(:,:,TrainSamples);

x = reshape(x,size(x,1),size(x,2)*size(x,3));
tt = reshape(tt,size(tt,1),size(tt,2)*size(tt,3));
%xn = normc(x) ;

x1 = mean(x,3);
x  = bsxfun(@times,x,x1); 
xn = x ;


for i=1:nIter
  W2 = W ;
  [nE,W] = perceptron_train(x,xn,tt,W);
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

find_classification_error(Y(:,:,CheckSamples),t(:,:,CheckSamples),Wmin);
