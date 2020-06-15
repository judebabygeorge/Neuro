

Y = PatternData.Pattern;
P = ones(size(Y));
P(isnan(Y))=0;

P = reshape(P , [size(P,1) 127 size(P,3)/127]);

h = PatternView ;
hO  = guidata(h);  

P = mean(P,2);

for i=1:min(32,size(P,3))
    
    a = (P(:,1,i)-P(:,1,1));
    
    Vis = abs(a);
    Vis = Vis./max(Vis);
    
    a1   = min(a);    
    a    = a - a1;
    a    = a./max(a);
    Act  = a;
    
%  Vis = P(:,1,i);
%  Act = ones(size(Vis));
    Mark = zeros(size(Act));
    hO.ShowElectrodeActivity(hO,i,[Act Vis], Mark);
end

% %Changed Ones
%     a = (P(:,1,end)-P(:,1,1));
%     
%     Vis = abs(a);
%     Vis = Vis./max(Vis);
%     
%     a1   = min(a);    
%     a    = a - a1;
%     a    = a./max(a);
%     Act  = a;
%     
%     Mark = zeros(size(Act));
%     hO.ShowElectrodeActivity(hO,i+1,[Act Vis], Mark);
%     
%     
% % After    Some Time
% P = ones(size(PatternChange));
% P(isnan(PatternChange)) = 0;
% P = mean(P,3);
% 
% for i=1:size(PatternChange,2)
%     Vis = P(:,i);
%     Act = ones(size(Vis)); 
%     hO.ShowElectrodeActivity(hO,24+i,[Act Vis], Mark);
% end