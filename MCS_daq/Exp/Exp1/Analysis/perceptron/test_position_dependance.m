

P = PatternData.Pattern ;


h = PatternView ;
hO  = guidata(h); 


Electrode = 8   ;


Id = zeros(1,32);
for i=1:32
%   pos = find(PatternData.StimConfig.Patterns(:,i)==Electrode);
%   Id(i) = pos;
%   pos = [(pos - 1) pos]*5*50 ;
  pos = [0 25]*50;
  X = P(:,i,:) ;
  X(X<pos(1)) = nan ;
  X(X>pos(2)) = nan ;
  x = ones(size(X)) ;
  x(isnan(X)) = 0   ;
  x = mean(x,3);
  
  Vis  = x;
  Act  = ones(size(Vis));
  Mark = zeros(120,1);
  hO.ShowElectrodeActivity(hO,i,[Act Vis], Mark);
end





