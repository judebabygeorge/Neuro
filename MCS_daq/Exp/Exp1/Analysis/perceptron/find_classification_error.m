function O=  find_classification_error(X,t,W)


O  = find_neuron_response(X,W);
%Winner Take All
size(O)
% [~,I] = max(O) ;
% 
% O2 = zeros(size(O));
% for i=1:size(O,2)
%     for j=1:size(O,3)
%         O2(I(1,i,j),i,j)=1;
%     end
% end

O2 = O>0;

size(O2)

t  = reshape(t,size(t,1),size(t,2)*size(t,3));
O2  = reshape(O2,size(t));
O2  = O2>0;

a1 = (O2==1)&(t==1); %Correct detection of sample
%a2 = (O==1)&&(t==0);
size(a1)
a1 = sum(a1,1);
size(a1)
a1 = reshape(a1,[size(X,2) size(X,3)]);
a1 = mean(a1,2)

figure;hist(a1,0.05:0.1:1.05);

sum(a1>0.7)
sum(a1>0.8)
sum(a1>0.9)
%[~,I] = max(O);
%I = reshape(I,size(t));
%I = (I~=t) ;

% 
% nE = sum(I,2) ;
% nE = nE/size(I,2);
% 
% display([num2str(sum(nE<0.3)) '/' num2str(numel(nE))]);

end