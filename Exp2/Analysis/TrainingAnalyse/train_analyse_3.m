
h = PatternView ;
hO  = guidata(h); 

a = randperm(60);
I{1}.P =  do_ttest(PatternsProbe{1}.Pattern(:,:,a(1:30)),PatternsProbe{1}.Pattern(:,:,a(31:60)));
I{2}.P =  do_ttest(PatternsProbe{2}.Pattern(:,:,a(1:30)),PatternsProbe{2}.Pattern(:,:,a(31:60)));
I{3}.P =  do_ttest(PatternsProbe{3}.Pattern(:,:,a(1:30)),PatternsProbe{3}.Pattern(:,:,a(31:60)));
%I{2}.P =  do_ttest(PatternsProbe{2}.Pattern,PatternsProbe{3}.Pattern);

for i=1:3
    for j=1:4
     
     Vis  = zeros(120,1);
     Vis(I{i}.P(:,j)<0.05) = 1; 
     
     Act  = ones(size(Vis))*0; 
     Mark = zeros(size(Act));
     idx = (i-1)*8 + j ;
     hO.ShowElectrodeActivity(hO,idx,[Act Vis], Mark);
     
     Vis  = 1- I{i}.P(:,j);
     idx = (i-1)*8 + j+4 ;
     hO.ShowElectrodeActivity(hO,idx,[Act Vis], Mark);
    end
end
% for i=1:3
%     P = find_mean_time( PatternsProbe{i}.Pattern , 1:62 );
%     for j=1:size(P,2)        
%       Vis = ~isnan(P(:,j));      
%       K = P(:,j);
%       K(isnan(K)) = 0;      
%       Act = K;      
%       Mark = zeros(size(Act));
%       idx = (i-1)*8 + j ;
%       hO.ShowElectrodeActivity(hO,idx,[Act Vis], Mark);
%     end
% end
