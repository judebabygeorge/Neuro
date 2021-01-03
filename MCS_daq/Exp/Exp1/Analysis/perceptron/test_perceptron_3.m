
P = PatternData.Pattern;
E = PatternData.StimConfig.Electrodes(1,1:8) ;
E = reshape(E,[1 numel(E)]);
E = E(E~=0);
P(E,:,:)=nan;
P(P<5*50) = nan;
P(P>100*50) = nan; 

%[ 10(14) 15(32) 20(38) 25(40) 30(36) 35(31) 40(6) 45(10) 50(12) 55(7)]
%[25(0) 50(2) 100(3) 150(4) -0]
X = ones(size(P)) ;
X(isnan(P)) = 0 ;

%SelectedPatterns = 2:2:size(PatternData.Pattern,2);
%SelectedPatterns = (1:1:56)*2;
SelectedPatterns = (2:2:112);
%SelectedPatterns = (1:1:24);
%SelectedPatterns = [1 3 4 5 7 8 9 10 11 12 14 18 19 20 23]+24*1;

%SelectedPatterns = [SelectedPatterns [1 3 4 5 7 8 9 10 11 12 14 18 19 20 23]];
%SelectedPatterns = [1  4 5 7 8 10 11 12 14 15 18 19 20 21 23]+24*0;
%SelectedPatterns = (1:1:24)+24;
%SelectedPatterns = (1:1:24)*2;
%SelectedPatterns = 1:1:size(PatternData.Pattern,2);
%  subset = 15 ;
%  SelectedPatterns = randperm(size(X,2));
%  SelectedPatterns = SelectedPatterns(1:subset);

Y = X(:,SelectedPatterns,:) ;

%% Find the relevent Electrodes
%  Calculate an electrode score
%  For each pattern
% p  = mean(Y,3);
% pm = 1 - mean(p,2);
% p  = bsxfun(@times,p,pm);
% p(p<0.05) = 0 ;
% p = sum(p,2);
% p(p>0)=1;
% sum(p)
% 
% Y(p==0,:,:) = 0;

%% Taking One at a time
% nClasses = size(Y,2) ;
% t = zeros(nClasses,(size(Y,2)*size(Y,3)));
% for i=1:nClasses
%  t(i,i:size(Y,2):end) = 1;
% end

%% Taking 1 at a time
n = 1 ;
a = size(Y,2);
Seq = nchoosek(1:1:a,n);

 nClasses = size(Y,2);
 t = zeros(nClasses,size(Y,2),size(Y,3));
 for i=1:nClasses
   t(i,i,:) = 1;
 end

% %% Specific conditions
% Combos = PatternData.StimConfig.Patterns(:,1:2:112) ;
% 
% nClasses = 8 ;
% t = zeros(nClasses,(size(Y,2)*size(Y,3)));
% for i=1:nClasses
%     I = find(Combos(2,:)==i) ;
%     for j=1:numel(I)
%         t(i,I(j):size(Y,2):end) = 1;
%     end
% end


W = zeros(size(Y,1)+1,nClasses);
Wmin = W;



nIter = 1000;
err = zeros(nClasses,nIter);


nSamples = size(Y,3); 
%nTrain   = round(nSamples/2);
nTrain   = 40;
%seq      = 1:1:nSamples ; %randperm(nSamples);
seq=randperm(nSamples);
%TrainSamples = seq(1:nTrain);
TrainSamples = seq(1:nTrain);
CheckSamples = seq(nTrain+1:end);

%% Creating vectors
x  = ones([size(Y,1)+1 size(Y,2),size(Y,3)]);
x(1:size(Y,1),:,:)  = Y;
x = x(:,:,TrainSamples);
tt = t(:,:,TrainSamples);

x = reshape(x,size(x,1),size(x,2)*size(x,3));
tt = reshape(tt,size(tt,1),size(tt,2)*size(tt,3));
%xn = normc(x) ;


xn = x ;

emin = ones(nClasses,1)*size(x,2);

% h = PatternView ;
% hO  = guidata(h);  
% % 
%  x1 = mean(Y,3);
% % x2 = mean(Y(:,:,TrainSamples),3);
% % x3 = mean(Y(:,:,CheckSamples),3);
% for i=1:min(32,size(x1,2))
%      Vis  = x1(:,(i));
%      Act  = ones(size(Vis))*0;   
%      Mark = zeros(size(Act));        
%      hO.ShowElectrodeActivity(hO,i,[Act Vis], Mark);
% %      Vis  = x2(:,(i));
% %      hO.ShowElectrodeActivity(hO,i,[Act Vis], Mark);
% %      Vis  = x3(:,(i));
% %      hO.ShowElectrodeActivity(hO,16+i,[Act Vis], Mark);
% end

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
      ee=0;
      for k=1:nClasses
        nSamples = sum(t(k,:));  
        ee =ee + (emin(k)/nSamples <0.3);
      end
      display(['done '  num2str(100*i/nIter) ' % ' num2str(ee)])
  end
end

%hist(emin) ;

%nSamples = size(t,3)*size(t,2);
for i=1:nClasses
  nSamples = sum(t(i,:));  
end
  e = emin./nSamples ;
display([num2str(sum(e < 0.3)) '/' num2str(numel(e))])

 E = find_neuron_response(Y,Wmin);
 E = (E>0);
 E = sum(E,3);
 nSamples = size(Y,3);
 for i=1:size(E,1)
     E(i,i) = nSamples - E(i,i);
 end 
 F = E>ceil(nSamples*.15) ;
 F = sum(F,2);
 sum(F==0)
 
 find_classification_error(Y(:,:,CheckSamples),t(:,:,CheckSamples),Wmin);
% 
% %Responses of different neurons
% O = find_neuron_response(Y(:,:,CheckSamples),Wmin);
% O = mean(O,3);
% 
% h2 = GraphArray ;
% hO2  = guidata(h2);  
% 
% x1 = 1:1:min(32,size(O,2));
% for i=1:numel(x1)
%     hO2.PlotBar(hO2,x1,O(i,1:numel(x1)),i);
% end



% plot(err)
% min(err)
% err(end)

% O = find_neuron_response(Y,Wmin);
% o = mean(O>0,3);
% imagesc(o)
% xlabel('Input Pattern');
% ylabel('Perceptron Number');