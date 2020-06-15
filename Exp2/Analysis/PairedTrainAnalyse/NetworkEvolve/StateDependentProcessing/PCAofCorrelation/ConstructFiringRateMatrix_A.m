
X = zeros(24,120);

%Create Spontaneous Activity Evolve Matrix
for i = 1:24
    a = load(sprintf('./temp/%s_%s/%s_%s_%d.mat',Culture,DIV,Culture,DIV,i));
    for j=1:120
        X(i,j) = numel(a.T{j});
    end
end

Q = bsxfun(@rdivide,bsxfun(@minus,X , mean(X)),std(X));

C = (1/size(Q,1))*(Q*Q');

[COEFF,SCORE,latent] = princomp(C);

SCORE1 = bsxfun(@plus,SCORE,-min(SCORE));
SCORE1 = bsxfun(@rdivide,SCORE1,max(SCORE1));


figure;hold on;
c = ['bgrcymk'];
  
plot3(SCORE1(1:12,1),SCORE1(1:12,2),SCORE1(1:12,3),'b');    
plot3(SCORE1(13:24,1),SCORE1(13:24,2),SCORE1(13:24,3),'b','Linewidth',2,'LineStyle','-.'); 
