

% Eactivity : Vector with feature set
% classes : vector with class assignment

h = PatternView ;
hO  = guidata(h);  

nClasses = min(32,max(classes));

for i=1:nClasses
    
 P = mean(Eactivity(:,(classes==i)),2);
 Vis  = P;
 Act  = ones(size(Vis))*0;   
 Mark = zeros(size(Act));
 hO.ShowElectrodeActivity(hO,i,[Act Vis], Mark);
 
end
            