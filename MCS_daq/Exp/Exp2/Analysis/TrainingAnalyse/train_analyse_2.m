

%X has the cumulative patterns

n = size(X,3)-1;
%ChA = zeros(n,64);
ChA = zeros(120,n);
for i=1:n
    Ch = X(:,:,(i+1)) - X(:,:,1) ; 
    
    %Ch(Ch<0) = 0;
    
    Ch = abs(Ch) ;
    Ch(Ch<0.5) = 0 ;
    Ch(Ch>0.1) = 1 ;
    
    Ch = sum(Ch,2) ;
    %Ch = sum(Ch,1) ;
    Ch(Ch>0) = 1 ;
    %ChA(i,:) = Ch;
    ChA(:,i) = Ch;

%     Ch(Ch<1) = [];
%     Ch = reshape(Ch,[1 numel(Ch)]);
%     numel(Ch)
    %hist(Ch);
    %waitforbuttonpress;
end