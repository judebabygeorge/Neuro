


sep = round(size(X,3)/2) ;

P = zeros(size(X,1),size(X,2),2);
P(:,:,1) = mean(X(:,:,1:sep),3);
P(:,:,2) = mean(X(:,:,sep+1:end),3);
P = P(:,:,1) - P(:,:,2);
