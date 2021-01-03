function PatternId = get_pattern_to_train(Pattern)

Pattern(Pattern > 50*50) = nan ;
P = ones(size(Pattern)) ;

P(isnan(Pattern)) = 0   ;

P = mean(P,3);
p = sum(P) ;

[~,I] = sort(p,'descend');

h = PatternView ;
hO  = guidata(h);  

%Plot all the outputs in row 1
for i=1:32    
    Vis = P(:,I(i));    
    Act  = ones(size(Vis))*0;   
    Mark = zeros(size(Act));
    hO.ShowElectrodeActivity(hO,i,[Act Vis], Mark);
end

PatternId = I;
end