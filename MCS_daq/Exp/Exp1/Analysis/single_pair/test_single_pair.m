
h = PatternView ;
hO  = guidata(h);


%Plot all the single responses
E = PatternData_pair.StimConfig.Electrodes(1,1:8) ;

X = ones(size(PatternData_single.Pattern));
X(isnan(PatternData_single.Pattern)) = 0 ;
X = mean(X,3);
X(X<0.7) = 0;
T = find_mean_firing_time(PatternData_single.Pattern);

lim = 2500;
T(T>lim)= lim;
T = T./lim ;

for i=1:8
      Vis  = X(:,E(i));
      %Act  = ones(size(Vis))*0;
      Act  = T(:,E(i));
      Mark = zeros(size(Act));
      Mark(E(i)) = 1;
      hO.ShowElectrodeActivity(hO,i,[Act Vis], Mark);  
end
   
X = ones(size(PatternData_pair.Pattern));
X(isnan(PatternData_pair.Pattern)) = 0 ;
X = mean(X,3);


for i=1:4
    a = bsxfun(@eq,PatternData_pair.StimConfig.Patterns,[2*i-1;2*i]);
    I = find(sum(a)==2);
    
    id = [I+1 I+3];
      
    Act  = ones(size(Vis))*0;
    Mark = zeros(size(Act));
    
    hO.ShowElectrodeActivity(hO,8 + i*2-1,[Act X(:,id(1))], Mark); 
    hO.ShowElectrodeActivity(hO,8 + i*2  ,[Act X(:,id(2))], Mark); 
end