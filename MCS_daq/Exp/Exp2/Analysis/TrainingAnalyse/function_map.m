
F = X(:,:,1) ;

for i=1:size(X,1)
    F(i,:) = sort(F(i,:));
end

s = sum(F,2);
[~,I] = sort(s) ;

F = F(I,:);

