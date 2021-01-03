
function test_e
    path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\Z12062015A\DIV22';
    a = load(sprintf('%s/data_PatternCheck_2_250_CLTrain_1.mat',path));
    PatternData = a.PatternData;
    P=ones(size(PatternData.Pattern));
    P(isnan(PatternData.Pattern))=0;
    
    s=50;
    n = size(P);
    c = floor(n(3)/s);
    e =find(PatternData.StimConfig.DecodeWeights(:,1)==1);
    Q = zeros(n(1),n(2),c);
    S = zeros(1,n(2),c);
    R = zeros(n(1),n(2),c);
    
    size(Q)
    
    for i=1:c
        Q(:,:,i) = mean(P(:,:,1+(i-1)*s:i*s),3);
        S(:,:,i) = mean(sum(P(e,:,1+(i-1)*s:i*s)>0,1),3);
        for j=1:n(1)
            for k=1:n(2)
               t = PatternData.Pattern(j,k,1+(i-1)*s:i*s);
               t = mean(t(~isnan(t)))/50;
               R(j,k,i) = t;
            end
        end
    end
    
    m = mean(Q(e,1:5:20,:),2);m = reshape(m,[size(m,1) size(m,3)])
    m = mean(Q(e,3:5:20,:),2);m = reshape(m,[size(m,1) size(m,3)])
    
    m = mean(S(1,1:5:20,:),2);m(:)
    m = mean(S(1,3:5:20,:),2);m(:)
    
    
    tm = zeros(size(R,3),2,numel(e));
    for i=1:size(R,3)
        for k=1:numel(e)
            t = R(e(k),1:5:20,i);
            t = mean(t(~isnan(t)));
            tm(i,1,k) = t;

            t = R(e(k),3:5:20,i);
            t = mean(t(~isnan(t)));
            tm(i,2,k) = t;
        end
    end
     display(tm)
end
function test_f
    path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\Z12062015A\DIV14';
    files = dir([path '\data_PatternCheck_2_250_CLProbe_*.mat']);
    nProbeSeq=numel(files);
    if(nProbeSeq>0)
       P = get_p(path,1);
       [~,I]= sort(P(:,1),'descend');
       nE=5;
       Y=zeros(nProbeSeq,nE);
       for i=1:nProbeSeq
           P = get_p(path,i);
           Y(i,:)=P(I(1:5),1);
       end
    end
    plot(Y)
end

function P = get_p(path,probeid)
    a = load(sprintf('%s/data_PatternCheck_2_250_CLProbe_%d.mat',path,probeid));
    PatternData = a.PatternData;
    P=ones(size(PatternData.Pattern));
    P(isnan(PatternData.Pattern))=0;
    P=mean(P,3);
end