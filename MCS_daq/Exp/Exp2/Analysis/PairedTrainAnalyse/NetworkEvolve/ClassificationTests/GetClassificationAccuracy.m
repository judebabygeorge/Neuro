
function [X1,OO, e] = GetClassificationAccuracy(path0,probe_file_tag,i,Wmin,)
        f = sprintf('\\%s_%d.mat',probe_file_tag,i);
        f = [path0  f];
        a = load(f); 
        [Patterns , ~ ]= EditPatterns(a.PatternData);
        SelectedPatterns = 1:1:size(Patterns,2);
        P = ones(size(Patterns));
        P(isnan(Patterns)) = 0;
        Y = ones(size(Patterns,1)+1,size(Patterns,2),size(Patterns,3));
        Y(1:120,:,:) = P;
        Y = reshape(Y,[size(Y,1) size(Y,2)*size(Y,3)]);
        
        nClasses = numel(SelectedPatterns);
        t = zeros(nClasses,(size(Y,2)*size(Y,3)));   
        for k=1:nClasses
            t(k,k:size(P,2):end)=1  ;
        end
        O = Wmin'*Y;
        
        X1 = O;
        %% Implement Winner-Take-All
        OO = zeros(size(O));        
        for i=1:size(O,2)
           for k=1:4     
           [~,I] = max(O(:,i));  
           OO(I,i)=1;
           O(I,i)= -Inf;
           end 
        end
        O = OO;
        
        O = O>0;
        %% Classification Accuracy
        
        O = sum(O.*t) ;
   
        O = reshape(O,[size(Patterns,2) size(Patterns,3)]);
        
        O = sum(O,2)/48
        
        
        e= sum(O>0.8);
end