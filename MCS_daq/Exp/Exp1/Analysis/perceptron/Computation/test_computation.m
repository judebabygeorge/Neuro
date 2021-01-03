
%SelectedPatterns = [1 3 4 5 7 8 9 10 11 12 14 18 19 20 23]+24*0;
SelectedPatterns  = [2 3 4 7 8 10 12 15 16 17 18 19 20 21 22 23];
%SelectedPatterns = 1:1:size(PatternData.Pattern,2);
Y= PatternData.Pattern(:,SelectedPatterns,:);
E = PatternData.StimConfig.Electrodes(1,1:8) ;
E = reshape(E,[1 numel(E)]);
E = E(E~=0);
Y(E,:,:)=nan;
Y((Y<(5*50)))=nan;

P = ones(size(Y));
P(isnan(Y))=0;
P = mean(P,3);


h = PatternView ;
hO  = guidata(h); 
% for i=1:min(32,size(P,2))       
%     Vis = P(:,i);
%     Act = ones(size(Vis));
%     Mark = zeros(size(Act));
%     hO.ShowElectrodeActivity(hO,i,[Act Vis], Mark);
% end

for i=1:2
  for j=1:4
    Vis = P(:,i*4 + j -1);
    Act = ones(size(Vis));
    Mark = zeros(size(Act));
    hO.ShowElectrodeActivity(hO,(i-1)*8+j,[Act Vis], Mark);
  end
end

% for i=1:(size(P,2)/2)
%     a = abs(P(:,2*i-1)-P(:,2*i));
%     a = a./max(a);
%     Vis = a;
%     Act = ones(size(Vis));
%     Mark = zeros(size(Act));
%     hO.ShowElectrodeActivity(hO,8+2*i-1,[Act Vis], Mark);
% end

%For first pair
p = 2;
a = abs(P(:,2*p)-P(:,2*p-1));
[~,I] = sort(a,'descend');

y = 1:1:size(Y,3);
figure;
for i=1:10
    %x = Y(I(numel(I)+1-i),:);    
    clf;hold on;
    I(i)
    a(I(i))
    x = Y(I(i),2*p,:);
    scatter(x,y,10,'filled','r');
    x = Y(I(i),2*p-1,:);
    scatter(x,y,10,'filled','b');
    xlim([0 5000])
    waitforbuttonpress;    
end