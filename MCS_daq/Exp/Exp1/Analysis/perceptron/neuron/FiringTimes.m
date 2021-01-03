

N = 2;

W = Wmin(1:120,N);

[~,id] = sort(abs(W),'descend');

figure;hold on;

y = 1:1:120 ;

% for i=1:size(I,2)
%     for j=1:size(I,3)
%         x = I(:,i,j);
%         x = x(id);
%         x1 = x(W>0);
%         y1 = y(W>0);
%         scatter(x1,y1+150*i,10,'filled','r');
%         x1 = x(W<0);
%         y1 = y(W<0);
%         scatter(x1,y1+150*i,10,'filled','b');
%     end    
% end

for i=1:10
    a = 1:1:size(I,2) ;
    a(N) = [];
    
    x = I(id(i) , : , : ) ;
    x = reshape(x,[numel(x),1])*20e-3;
    scatter(x,ones(size(x))*50*i,10,'filled','b');
    
    x = I(id(i) , N , : ) ;
    x = reshape(x,[numel(x),1])*20e-3;
    scatter(x,(1:1:size(x)) + 50*i+2,30,'filled','r');
end