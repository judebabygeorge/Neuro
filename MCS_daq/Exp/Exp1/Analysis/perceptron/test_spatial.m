
P = PatternData.Pattern;
E = PatternData.StimConfig.Electrodes(1,1:8) ;
E = reshape(E,[1 numel(E)]);
E = E(E~=0);
P(E,:,:)=nan;
P(P<5*50) = nan;
%P(P>25*50) = nan; 

%[ 10(14) 15(32) 20(38) 25(40) 30(36) 35(31) 40(6) 45(10) 50(12) 55(7)]
%[25(0) 50(2) 100(3) 150(4) -0]
X = ones(size(P)) ;
X(isnan(P)) = 0 ;

SelectedPatterns = (1:1:56)*2;

Y = X(:,SelectedPatterns,:) ;

% %Now Do some pre-process
% Pf = mean(Y,3) ;
% Pf(Pf<0.5) = 0 ;
% Pf(Pf>0.4) = 1 ;

% for i=1:size(X,3)
%  Y(:,:,i) = Y(:,:,i).*Pf;
% end

nSamples = size(Y,3); 
%nTrain   = round(nSamples*0.5);
nTrain   = nSamples;
%seq      = 1:1:nSamples ; 
seq = randperm(nSamples);

%CrossValidation
%k = 5 ;


TrainSamples = seq(1:nTrain);
%CheckSamples = seq(nTrain+1:end);


%C = 16



%% Creating vectors
x = Y(:,:,TrainSamples);

Pf = mean(x,3);
Pf(Pf<0.7) = 0 ;
Pf(Pf>0.4) = 1 ;

%W   = Pf - 0.5;

% N = norm(W) ;
% N = 1./N    ;
% N(isnan(N)) = 0 ;
% N(isinf(N)) = 0 ;
% W   = bsxfun(@times,W,N);
% W(isnan(W)) = 0 ;
% W(isinf(W)) = 0 ;

W = Pf ; 

%Find the right threshold value
%For each perceptron

x = reshape(x,[size(x,1) size(x,2)*size(x,3)]);
x(x == 0) = -1 ;

% x = x - 0.5 ;
% N = norm(x) ;
% N = 1./N    ;
% N(isnan(N)) = 0 ;
% N(isinf(N)) = 0 ;
% x   = bsxfun(@times,x,N);

O = W'*x ;
O = O'; % now each column for a neuron

%Each 3rd dimension for a neuron
%Each row for response for a particular input class
O = reshape(O , [size(W,2) size(O,1)/size(W,2) size(O,2)]) ;

% for i=1:size(W,2)
%    id = 1:1:size(O,1) ;
%    id(i) = [] ;
%    
%    L1 = O(i,:,i);
%    L2 = O(id,:,i);
%    L2 = reshape(L2,[1 numel(L2)]);
%    
%    
% end




% x  = ones([size(Y,1)+1 size(Y,2),size(Y,3)]);
% x(1:size(Y,1),:,:)  = Y;
% x = x(:,:,CheckSamples);
% tt = t(:,:,CheckSamples);
% 
% x = reshape(x,size(x,1),size(x,2)*size(x,3));
% tt = reshape(tt,size(tt,1),size(tt,2)*size(tt,3));
% %Calculate Classification success
% O = W'*x ;
% y = (O>0);
%  %Absense of firing
% a = (tt==1)&(y==0);
% %Incorret firing
% b = (tt==0)&(y==1);
% 
% a = sum(a,2) ; b = sum(b,2);
% sb = sum(tt==1,2)./sum(tt==0,2);
% nE = a + b.*sb ;
% 
% nX = [a b];
% 
% nSamples = sum(tt,2);
% nE = nE./nSamples;
% display([num2str(sum(nE < 0.3)) '/' num2str(numel(nE))])
