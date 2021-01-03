

P = PatternData.Pattern;

P  = P(:,1:112,:);
% P  = P(:,113:120,:);
% for i=1:8
%     P(E(i),i,:) = 0;
% end
X = reshape(P , [size(P,1) size(P,2)*size(P,3)]);

Y = zeros((size(X,1)+1),size(X,1));


for i=1:size(X,1)
    
    z = bsxfun(@minus,X,X(i,:));
    z(isnan(z)) = 50*50; %Some positive value
    
    Z = zeros(size(z));
    Z(z<0.1) = 1;    
    c = sum(Z(i,:));
    
    if(c>0)
      Y(1:size(Z,1),i) = sum(Z,2)/c ;
    end
    Y(121,i)=c ;
    
    Y(i,i) = 0;
end

