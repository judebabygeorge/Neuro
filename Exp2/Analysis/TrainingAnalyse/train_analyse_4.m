
function train_analyse_4(Pattern)

    
    P = ones(size(Pattern)) ;
    P(isnan(Pattern)) = 0 ;
    P = mean(P,3);

    h = PatternView ;
    hO  = guidata(h);  

    %Run Iterations of all
    len  = min(32,size(P,2)) ;

    for j=1:len
        P1 = P(:,j);

        Vis = P1;
        Act  = ones(size(Vis))*0;   
        Mark = zeros(size(Act));
        hO.ShowElectrodeActivity(hO,j,[Act Vis], Mark);
    end


