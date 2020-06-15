function FDR = FischerDiscriminatRatio(Patterns)
    
Pc   = mean(Patterns,3);
Pch  = mean(Pc,2);

n = (bsxfun(@minus,Pc,Pch)).^2;
d = mean((bsxfun(@minus,Patterns,Pc)).^2,3);

FDR = mean(n,2)./mean(d,2);
FDR(isnan(FDR))=0;
end