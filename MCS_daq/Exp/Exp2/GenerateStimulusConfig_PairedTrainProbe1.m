function StimConfigProbe = GenerateStimulusConfig_PairedTrainProbe(PatternData)

    %Number of Configs required = Number of Electrodes
    %p different patterns , r electrodes at a time

     maxPatterns = 127 ; 
 
    [Patterns , ~ ]= EditPatterns(PatternData);
    %Find Significant Electrodes
     
    %Calculate The firing probabilities at each electrode 
    P = ones(size(Patterns)) ;
    P(isnan(Patterns)) = 0   ;
    P = mean(P,3);
    
    P = reshape(P(:,1:112),[120 4 28]);    
    
    QQ = zeros(120,6,28);
    th1 = 0.3;
    
    id = 1;
    xx =zeros(6,2);
    for i=1:3
        for j=(i+1):4
            QQ(:,id,:) = abs(P(:,i,:) - P(:,j,:));            
            xx(id,:) = [i j];
            id = id + 1;
        end
    end
    
    Q = QQ>th1;
    
    T = reshape(sum(sum(Q,2),1),[1 28]);   
    [TT,II] = sort(T,'descend');
    I = II(TT>0);
    T(I)
    nProbe= min(5,numel(I));
    I = I(1:nProbe);
    
    R = QQ(:,:,I).*Q(:,:,I);
    S = reshape(sum(R,1),[6 size(R,3)])
    
    [~,J] = max(S);
    
    
    ivecs = zeros(1,2*nProbe);
    el   = zeros(1,2*nProbe);
    els = zeros(1,nProbe);
    
    gElScore = sum(sum(QQ.*Q,3),2);
    ElScore  = sum(R,2);
    nProbe = numel(J);
    
    for i=1:nProbe
        ivecs(i)          = (I(i)-1)*4 + xx(J(i),1);
        ivecs(i+nProbe) = (I(i)-1)*4 + xx(J(i),2);
        
        es = ElScore(:,1,i).*gElScore;
        
        %make scores of existing ones zero
        e1 = el(el>0);
        ess = es;
        ess(e1) = 0;
        
        if(sum(ess)>0)
            es = ess;
        end
        
        [s,es] = max(es);
        els(i) = s;
        el(i) = es;        
        el(i+nProbe) = es;
    end
    
    ivecs
    el
    els
    

  
 StimConfigProbe = PatternData.StimConfig;

 p = 2*2*nProbe ;
 
 nSeq      = floor(maxPatterns/p) ; 
 StimConfigProbe.PatternSequence = zeros(1,p*nSeq) ; 
 
 
 pp = zeros(1,p);
 vecs = 2*(1:1:(2*nProbe));
 pp(vecs) = ivecs ;
 
 
 %To Select filler random data from rest
 q = 1:1:PatternData.StimConfig.p;
 q(ivecs) = [];
 q = q(randperm(numel(q)));
 
 a = 1:p;
 a(vecs) = [];
 
 pp(a) =q(1:numel(a));
 StimConfigProbe.Patterns     =  StimConfigProbe.Patterns(:,pp);
 StimConfigProbe.PatternDelay =  StimConfigProbe.PatternDelay(:,pp);

 
 for i=1:nSeq
     StimConfigProbe.PatternSequence(((i-1)*p +1):i*p) = 1:p ;
 end
 
 StimConfigProbe.PatternDetails.vecs = vecs;
 StimConfigProbe.PatternDetails.electrodes  = el;

 
 StimConfigProbe.p              = p    ;
 StimConfigProbe.nSeq           = nSeq ;
end
function [Patterns , PatternConfig ]= EditPatterns(PatternData)
    %Extract The relevent patterns
    Patterns = PatternData.Pattern;
    PatternConfig = PatternData.StimConfig;
    %Patterns = Patterns(:,V,:);

    E = PatternData.StimConfig.Electrodes(1,1:8) ;
    E = reshape(E,[1 numel(E)]);
    E = E(E~=0);
    Patterns(E,:,:)=nan;
    DecodeCheckWindow= 100;
    Patterns(Patterns<5*50) = nan;
    Patterns(Patterns>DecodeCheckWindow*50) = nan;
end