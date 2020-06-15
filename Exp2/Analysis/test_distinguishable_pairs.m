Patterns = PatternData.Pattern ;
DecodeCheckWindow = 100 ;

E = PatternData.StimConfig.Electrodes(1,1:8) ;
E = reshape(E,[1 numel(E)]);
E = E(E~=0);
Patterns(E,:,:)=nan;
            
Patterns(Patterns<5*50) = nan;
Patterns(Patterns>DecodeCheckWindow*50) = nan;

[PairError Wo] = get_distinguishable_pairs( Patterns );