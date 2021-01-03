

Responses = zeros(size(Y,2) , size(Y,2));

x = reshape(Y,[size(Y,1) size(Y,2)*size(Y,3)]);
for i=1:size(Y,2)
    
    R = Wb(:,i)'*x - bb(i) ;
    
    R = reshape(R,[1 size(Y,2) size(Y,3)]);
    
    R = mean(R,3);
    %Responses(i,:) = R;
    [~,I] = max(R);
    Responses(i,I) = 1;
end

%bar3(Responses);
imshow(Responses);