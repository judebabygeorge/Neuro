X = zeros(24,120);

maxtime = 8;
binsize = 1;
nBins   = maxtime/binsize;

X = zeros(nBins,120,24);
%Create Spontaneous Activity Evolve Matrix
for i = 1:24
    a = load(sprintf('./temp/%s_%s/%s_%s_%d.mat',Culture,DIV,Culture,DIV,i));
    O = binSpikes(a.T,binsize,maxtime);
    X(:,:,i) = O;
end

A1 = zeros(nBins*12,120);
A2 = zeros(nBins*12,120);
for i=1:12
    A1(((i-1)*nBins+1):i*nBins,:) = X(:,:,i);
    A2(((i-1)*nBins+1):i*nBins,:) = X(:,:,i+12);
end

%A2 = A2(49:end,:);

%Q1 = bsxfun(@rdivide,bsxfun(@minus,A1 , mean(A1)),std(A1));
Q1 = A1;
Q1(isnan(Q1)) = 0;
Q1 = Q1';

%Q2 = bsxfun(@rdivide,bsxfun(@minus,A2 , mean(A2)),std(A2));
Q2 = A2;
Q2(isnan(Q2)) = 0;
Q2 = Q2';

C1 = (1/size(Q1,1))*(Q1*Q1');
C2 = (1/size(Q2,1))*(Q2*Q2');

[COEFF1,SCORE1,latent1] = princomp(C1);
[COEFF2,SCORE2,latent2] = princomp(C2);

COEFF2 = C2*SCORE1;

% SCORE1 = bsxfun(@plus,SCORE1,-min(SCORE1));
% SCORE1 = bsxfun(@rdivide,SCORE1,max(SCORE1));
% SCORE2 = bsxfun(@plus,SCORE2,-min(SCORE2));
% SCORE2 = bsxfun(@rdivide,SCORE2,max(SCORE2));


figure;hold on;
c = ['bgrcymk'];

%plot3(SCORE1(:,1),SCORE1(:,2),SCORE1(:,3),'b');

%plot3(SCORE1(1:96,1),SCORE1(1:96,2),SCORE1(1:96,3),'b','LineWidth',2);    
%plot3(SCORE1(97:192,1),SCORE1(97:192,2),SCORE1(97:192,3),'g','LineWidth',2); 
%scatter3(SCORE1(:,1),SCORE1(:,2),SCORE1(:,3),'b');
%scatter3(SCORE2(:,1),SCORE2(:,2),SCORE2(:,3),'g');

scatter3(COEFF1(:,1),COEFF1(:,2),COEFF1(:,3),'b');
scatter3(COEFF2(:,1),COEFF2(:,2),COEFF2(:,3),'g');

%axis square;
