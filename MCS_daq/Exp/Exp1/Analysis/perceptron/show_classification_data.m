

h = PatternView ;
hO  = guidata(h);

Perceptron = 2 ;

Vis = mean(Y(:,Perceptron,TrainSamples),3);
Act  = ones(size(Vis))*0;
Mark = zeros(size(Act));
hO.ShowElectrodeActivity(hO,1,[Act Vis], Mark);

Vis = mean(Y(:,Perceptron,CheckSamples),3);
Act  = ones(size(Vis))*0;
Mark = zeros(size(Act));
hO.ShowElectrodeActivity(hO,2,[Act Vis], Mark);

for i=3:24
   Vis  = Y(:,Perceptron,TrainSamples(i));
   
   Act  = ones(size(Vis))*0;
   Mark = zeros(size(Act));
    
   id = i;
   hO.ShowElectrodeActivity(hO,id,[Act Vis], Mark);
end

for i=1:8
   Vis  = Y(:,Perceptron,CheckSamples(i));
   
   Act  = ones(size(Vis))*0;
   Mark = zeros(size(Act));
    
   id = 24+i;
   hO.ShowElectrodeActivity(hO,id,[Act Vis], Mark);
end