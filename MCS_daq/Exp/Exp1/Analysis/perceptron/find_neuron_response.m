function O = find_neuron_response(X,W)
%Append the bias
a = size(X);
x = ones((size(X,1)+1),size(X,2)*size(X,3));
x(1:end-1,:,:)=reshape(X,[size(X,1) size(X,2)*size(X,3)]);


O  = zeros(size(W,2),size(x,2));


for i=1:size(W,2)
    O(i,:) = sum(bsxfun(@times,x,W(:,i)));    
end

O = reshape(O,[size(W,2) a(2) a(3)]);
end
