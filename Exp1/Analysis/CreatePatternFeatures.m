function Features = CreatePatternFeatures(Pattern)

    PatternSize = size(Pattern,1) ;
    nPatterns   = size(Pattern,2) ;
    nSamples    = size(Pattern,3) ;

    Features.Classes    = nPatterns   ;
    Features.nFeatures  = 2           ; %Two Features : F1 = weight , F2 = delay , F3 delay weight
    Features.FeatureSet = zeros(PatternSize,Features.Classes,Features.nFeatures);


    %Weight is proportional to proability of firing of a pattern

    %Find the probaility of firing of an electrode 


    pFiring = zeros(size(Pattern)) ;
    pFiring(~isnan(Pattern)) = 1 ; 

    pFiring = mean(pFiring,3);
%     scale   = sum(pFiring);
%     scale   = 1./scale      ;
%     scale(isnan(scale)) = 0 ;
%     w = bsxfun(@times,pFiring,scale);
    w = pFiring;
    Features.FeatureSet(:,:,1) = w ; 
    
    
    %Delay would be the mean dealy of the first spike time

    Pf    = ones(size(Pattern));
    Pf(isnan(Pattern)) = 0 ;
    
    Pt    = Pattern  ;
    Pt(isnan(Pt)) = 0;    
    Ps = sum(Pt,3) ;
    Pc = sum(Pf,3);
    Ps = Ps./Pc        ;
    Ps(Ps==0) = NaN ;
    
    Delay = Ps;
    Features.FeatureSet(:,:,2) = Delay ; 
    

end