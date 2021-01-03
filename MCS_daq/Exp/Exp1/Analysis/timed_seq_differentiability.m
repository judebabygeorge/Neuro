
P = PatternData.Pattern;
E = PatternData.StimConfig.Electrodes ;
E = reshape(E,[1 numel(E)]);
E = E(E~=0);
P(E,:,:)=nan;

X = ones(size(P)) ;
X(isnan(P)) = 0 ;

W = mean(X,3);
%W(W<0.5)=0;
%Take top 10 contributors
for i=1:size(W,2)
    [~,I] = sort(W(:,i));
    W(I(1:end-10),i) = 0;
end

%W = bsxfun(@rdivide,W,sum(W));


%Select patterns

SelectedPatterns = 2:2:size(PatternData.Pattern,2);

%Select patterns based on differentiability
% SelectedPatterns = zeros(1,floor(size(PatternData.Pattern,2)/2));
% for i=1:floor(size(PatternData.Pattern,2)/4)
%     p = SelectBestDifferentiablePair(W(:,((i-1)*4+1):i*4));
%     SelectedPatterns(((i-1)*2+1):i*2) = p + (i-1)*4 ;
% end


W = W(:,SelectedPatterns) ;



Y = X(:,SelectedPatterns,:) ;
Y(Y==0)=-1;

O = zeros(size(W,2));
for i=1:size(Y,2)
    
%   Z = bsxfun(@times,Y,W(:,i));
%   Z = sum(Z,1);
%   Z = mean(Z,3);
  
%   [a,I] = max(Z) ;
%   Z(Z<a)=0;
%   Z(I) = 1;
%   
%  O(i,:)=Z;

 I = Y(:,i,:) ;
 I = reshape(I,[size(I,1) size(I,3)]);

 Z = I'*W ;
 
 
 O(i,:) = O(i,:) + mean(Z) ;
%  for j=1:size(Z,1)
%      [~,I] = max(Z(j,:));
%      O(i,I) = O(i,I) + 1;
%  end
  
end

figure;
bar3(O');

% A = zeros(size(O,1),1);
% 
% for i=1:size(O,1)
%     [~,I] = sort(O(i,:),'descend');
%     if(I(1) ~=i)
%         A(i) = O(i,i) - O(i,I(1));
%     else
%         A(i) = O(i,i)- O(i,I(2));
%     end
% end
% 
% [~,I] = sort(A,'descend');
% bar3(O(I,:)');

% Q = zeros(size(O));
% for i=1:size(O,1)
%     [~,I] = max(O(i,:));
%     Q(i,I) = 1;
% end
% imshow(Q)



h = PatternView ;
hO  = guidata(h);

W = mean(X(:,SelectedPatterns,:),3);

I = 1:1:32;
for i=1:numel(I)
        Vis  = W(:,I(i));
        Act  = ones(size(Vis))*0;
        Mark = zeros(size(Act));
        hO.ShowElectrodeActivity(hO,i,[Act Vis], Mark);
end