
h = PatternView ;
hO  = guidata(h);

        X = ones(size(I));
        X(isnan(I)) = 0 ;
        Pf = mean(X,3);
        




for i=1:size(Pf,2)
        id = i; 
        if(1)
            Vis  = Pf(:,id);
            Act  = ones(size(Vis))*0;
        else
            Vis  = Pf(:,id);
            Act = ones(size(Vis)) ;
            Act(Act>1) = 1 ;
            Act(Act<0) = 0 ;
            Act  = 1- Act  ;
        end
        Mark = zeros(size(Act));

        id = i ;
        hO.ShowElectrodeActivity(hO,id,[Act Vis], Mark);
end
    

