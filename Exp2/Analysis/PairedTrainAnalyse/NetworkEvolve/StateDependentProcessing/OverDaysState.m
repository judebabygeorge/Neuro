%close all
%Culture = 'G09102014C';
%dDIV = {'DIV36','DIV37','DIV38','DIV39'} ;
Culture = 'G05012015A';
dDIV = {'DIV25', 'DIV28','DIV29','DIV30','DIV31','DIV37','DIV38'} ;

%d = [2 3 4 5];
d = [6];
y = zeros(24*numel(d),120);

rm_El = randperm(120);
rm_El = rm_El(1:60);

ElectrodeWithChanges = [4 7 5 8 9 10 15 17 22 25 35 38 48 50 51 52 53 65 68 79 81 86 91 94 101 102 108 109 110 114 115 117];
rm_El = randperm(numel(ElectrodeWithChanges));
rm_El = ElectrodeWithChanges(1:30);

for k=1:numel(d)
    DIV = dDIV{d(k)};
    a = load(sprintf('%s_%s_statechange.mat',Culture,DIV));
    Y = a.Y;
    for i=1:24
        for j=1:120
            y((k-1)*24+i,j) = numel(Y{i}.T{j});
        end
    end
end

%y(:,rm_El) = [];

s = 1./max(y);
y = bsxfun(@times,y,s);


[COEFF,SCORE,latent] = princomp(y);

SCORE1 = bsxfun(@plus,SCORE,-min(SCORE));
SCORE1 = bsxfun(@rdivide,SCORE1,max(SCORE1));


figure;hold on;
c = ['bgrcymkb'];
for k=1:numel(d)    
    plot3(SCORE1((1+(k-1)*24):(k*24-12),1),SCORE1((1+(k-1)*24):(k*24-12),2),SCORE1((1+(k-1)*24):(k*24-12),3),c(k));    
    plot3(SCORE1((1+(k-1)*24+12):(k*24),1),SCORE1((1+(k-1)*24+12):(k*24),2),SCORE1((1+(k-1)*24+12):(k*24),3),c(k),'Linewidth',2,'LineStyle','-.'); 
end

if(1)
yyy = mean(yyy);
for i=1:12
    origin = [SCORE1(i,1) SCORE1(i,2) 0];
    sz     = [.05 .05 yyy(i)];
    drawCube ( origin,  sz,'b')
end
for i=13:24
    origin = [SCORE1(i,1) SCORE1(i,2) 0];
    sz     = [.05 .05 yyy(i)];
    drawCube ( origin,  sz,'g')
end
end
axis square