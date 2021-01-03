
if(0)
    Patterns = PatternData.Pattern;
    Patterns = Patterns(:,2:2:112,:);

    E = PatternData.StimConfig.Electrodes(1,1:8) ;
    E = reshape(E,[1 numel(E)]);
    E = E(E~=0);
    Patterns(E,:,:)=nan;
    DecodeCheckWindow= 100;
    Patterns(Patterns<5*50) = nan;
    Patterns(Patterns>DecodeCheckWindow*50) = nan;

    [PairId Wo PairError] = get_pairs( Patterns );
end

if(1)
    P = ones(size(Patterns)) ;
    P(isnan(Patterns)) = 0   ;
    P = mean(P,3);
    h = PatternView ;
    hO  = guidata(h);  
    
    %I = PairId';
    %I = I(1:numel(I));
    %Plot all the outputs in row 1
    for i=1:min(32,size(P,2))    
        Vis = P(:,i);    
        Act  = ones(size(Vis))*0;   
        Mark = zeros(size(Act));
        hO.ShowElectrodeActivity(hO,i,[Act Vis], Mark);
    end
end