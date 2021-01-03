function E = CheckPatternSimilarity


path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\Z23042015B\';
DIV  = [16 17];

base_file = 'data_PatternCheck_2_250_probe_scan';

E = zeros(24,numel(DIV));
W = load(sprintf('%s\\DIV%d\\WeightVectors_2.mat',path,DIV(1)));
W = W.W;
W = W(:,:,12);
for j=1:numel(DIV)
%     W = load(sprintf('%s\\DIV%d\\WeightVectors.mat',path,DIV(j)));
%     W = W.W;
%     W = W(:,:,1);
    for i=1:24
        %i
        p = sprintf('%s\\DIV%d\\%s_%d.mat',path,DIV(j),base_file,i);
        a = load(p);
        PatternData = a.PatternData;
        [Patterns , PatternConfig ]= EditPatterns(PatternData);
        P = ones(size(Patterns));
        P(isnan(Patterns)) = 0;

        Y = P;
        
        nClasses = size(P,2) ;
        t = zeros(nClasses,(size(Y,2)*size(Y,3)));
        for k=1:nClasses
            t(k,k:size(Y,2):end)=1;
        end
        x  = ones([size(Y,1)+1 size(Y,2)*size(Y,3)]);
        x(1:size(Y,1),:,:)  = reshape(Y,[size(Y,1) size(Y,2)*size(Y,3)]);
        O = W'*x > 0;
        e = zeros(nClasses,1);
        for k=1:nClasses
            e(k) = sum((t(k,:)==1)&(O(k,:)==0))/sum(t(k,:)==1) + sum((t(k,:)==0)&(O(k,:)==1))/sum(t(k,:)==0);                        
            %sum((t(k,:)==1)&(O(k,:)==0))
            %e(k) = sum(t(k,:)~=O(k,:));
        end        
        E(i,j)=sum(e);
    end
end
        
end