
P = PatternData.Pattern;

P  = P(:,1:112,:);
% P  = P(:,113:120,:);
% for i=1:8
%     P(E(i),i,:) = 0;
% end

X = zeros(size(P,1) , size(P,2)*size(P,3) , size(P,1)) ; 

for i=1:size(X,1)
   z = bsxfun(@minus,P ,P(i,:,:));
   z = reshape(z, size(z,1) , size(z,2)*size(z,3));
   z(isnan(z)) = 50*50; %Some positive value
   
   Z = zeros(size(z));
   Z(z<0)   = 1;   
   X(:,:,i) = Z ; 
   
end


