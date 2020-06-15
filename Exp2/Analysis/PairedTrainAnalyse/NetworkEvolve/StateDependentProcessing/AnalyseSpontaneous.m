
close all;

y = zeros(24,120);

for i=1:24
    for j=1:120
        y(i,j) = numel(Y{i}.T{j});
    end
end

s = 1./max(y);
y = bsxfun(@times,y,s);
plot(y); hold on;
plot(mean(y,2),'y','Linewidth',4);

x = reshape(mean(X,2),[120 24])';

figure;
plot(x);hold on;
plot(mean(x,2),'y','Linewidth',4);

figure;
plot(mean(y,2),'y','Linewidth',4);hold on;
plot(mean(x,2),'r','Linewidth',4);


[COEFF,SCORE,latent] = princomp(y);

SCORE1 = bsxfun(@plus,SCORE,-min(SCORE));
SCORE1 = bsxfun(@rdivide,SCORE1,max(SCORE1));

figure;
plot3(SCORE1(1:12,1),SCORE1(1:12,2),SCORE1(1:12,3),'b');
hold on;
plot3(SCORE1(12:24,1),SCORE1(12:24,2),SCORE1(12:24,3),'g');
axis square
%figure;
%plot(SCORE(1:12,1),SCORE(1:12,2),'b');hold on;plot(SCORE(12:24,1),SCORE(12:24,2),'g');