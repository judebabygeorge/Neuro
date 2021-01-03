function [P,c] = CreateBinaryVectors

close all
n=100;
P = rand(n,2);

i = (P(:,1) - P(:,2))>0;

j = 1:1:n;
j(i)=[];

P1 = 2+round(P(i,:)*13);
P2 = 2+round(P(j,:)*13);

scatter(P1(:,1),P1(:,2),'b','filled');hold on
scatter(P2(:,1),P2(:,2),'r','filled');
axis square

c = zeros(1,n);
c(size(P1,1)+1:size(P2,1)+size(P1,1))=1;
P = zeros(16*2,n);

idx = 1;
for i=1:size(P1,1)    
     P(idx+P1(i,1),i) = 1;    
     P(idx+16+P1(i,2),i) = 1; 
end
for i=1:size(P2,1)    
     P(idx+P2(i,1),i+size(P1,1)) = 1;    
     P(idx+16+P2(i,2),i+size(P1,1)) = 1; 
end

Q = [mean(P(:,c==0),2) mean(P(:,c==1),2)];
[a,W] = EstimatingClassificationAccuarcyWithIncreasingElectrodes(Q,1:2);
figure;plot(a)

end

