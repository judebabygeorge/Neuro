

P = PatternData.Pattern(:,Config.DecodeTask.StimConfig.PatternId,:);
W = Config.DecodeTask.StimConfig.DecodeWeights;

DecodeCheckWindow = 100;
E = PatternData.StimConfig.Electrodes(1,1:8) ;
E = reshape(E,[1 numel(E)]);
E = E(E~=0);
P(E,:,:)=nan;

P(P<5*50) = nan;
P(P>DecodeCheckWindow*50) = nan;


Y = ones(size(P)) ;
Y(isnan(P)) = 0   ;

nClasses = size(Y,2) ;

x  = ones([size(Y,1)+1 size(Y,2)*size(Y,3)]);
x(1:size(Y,1),:,:)  = reshape(Y,[size(Y,1) size(Y,2)*size(Y,3)]);

O = W'*x ;

[~,I] = max(O);
I = reshape(I,[size(Y,2) size(Y,3)]);
