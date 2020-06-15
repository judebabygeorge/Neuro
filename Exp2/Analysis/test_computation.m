
Y= PatternData.Pattern(:,(1:1:8)*2,:);
E = PatternData.StimConfig.Electrodes(1,1:8) ;
E = reshape(E,[1 numel(E)]);
E = E(E~=0);
Y(E,:,:)=nan;

Y((Y<(5*50)))=nan;

X = Y;

P = ones(size(Y));
P(isnan(Y))=0;
P = mean(P,3);


% h = PatternView ;
% hO  = guidata(h); 
% for i=1:min(32,size(P,2))       
%     Vis = P(:,i);
%     Act = ones(size(Vis));
%     Mark = zeros(size(Act));
%     hO.ShowElectrodeActivity(hO,i,[Act Vis], Mark);
% end
% 
% for i=1:(size(P,2)/2)
%     a = abs(P(:,2*i-1)-P(:,2*i));
%     a = a./max(a);
%     Vis = a;
%     Act = ones(size(Vis));
%     Mark = zeros(size(Act));
%     hO.ShowElectrodeActivity(hO,8+2*i-1,[Act Vis], Mark);
% end

%For first pair
i = 4;
a = abs(P(:,2*i)-P(:,2*i-1));
[~,I] = sort(a,'descend');

y = 1:1:size(Y,3);
figure;
for i=1:5
    %x = Y(I(numel(I)+1-i),:);    
    clf;hold on;
    I(i)
    x = Y(I(i),1,:);
    scatter(x,y,10,'filled','r');
    x = Y(I(i),2,:);
    scatter(x,y,10,'filled','b');
    xlim([0 1000])
    waitforbuttonpress;    
end