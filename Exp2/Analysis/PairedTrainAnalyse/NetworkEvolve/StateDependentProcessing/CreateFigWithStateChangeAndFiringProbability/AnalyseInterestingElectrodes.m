

El = [9 15 17 25 38 48 51 52 53 65 67 68 79  84 91 94 101 102 109 110 114];

%Z has firing probabilities for 120 electrodes for 20 probes

if(0)
%First select Good probes
h1 =  figure('Position',[100 100 1600 800],'color','w');

for i=1:20
    y=X{1}.X(El,i,:);
    y = reshape(y,[size(y,1), 24])';

    figure(h1);
    plot(y);
    getkey;
end
end

Culture = 'G05012015A';
dDIV = 'DIV37' ;

a = load(sprintf('../%s_%s_statechange.mat',Culture,dDIV));
Y = a.Y;
for i=1:24
    for j=1:120
        y((k-1)*24+i,j) = numel(Y{i}.T{j});
    end
end


s = 1./max(y);
y = bsxfun(@times,y,s);


[COEFF,SCORE,latent] = princomp(y);

SCORE1 = bsxfun(@plus,SCORE,-min(SCORE));
SCORE1 = bsxfun(@rdivide,SCORE1,max(SCORE1));


figure;hold on;
c = ['bgrcymk'];
  
plot3(SCORE1(1:12,1),SCORE1(1:12,2),SCORE1(1:12,3),'b');    
plot3(SCORE1(13:24,1),SCORE1(13:24,2),SCORE1(13:24,3),'b','Linewidth',2,'LineStyle','-.'); 

El1 = El([1 4]);

if(0)
    probe = 2;
    for j=1:2
        y=X{1}.X(El1(j),probe,:);
        y = reshape(y,[size(y,1), 24])';

        yyy = y;
        for i=1:12
        %     origin = [SCORE1(i,1) SCORE1(i,2) 0];
        %     sz     = [.05 .05 ];    
            %drawCube ( origin,  sz,'b')    
            scatter3(SCORE1(i,1), SCORE1(i,2), yyy(i),100,c(j));
        end
        for i=13:24
        %     origin = [SCORE1(i,1) SCORE1(i,2) 0];
        %     sz     = [.05 .05 yyy(i)];
            %drawCube ( origin,  sz,'g')
            scatter3(SCORE1(i,1), SCORE1(i,2), yyy(i),100,c(j),'filled');
        end
    end
end
axis square


El2 = randperm(numel(El));
El2 = El(El2(1:15));

El2 = El;
y(:,El2)=[];
[COEFF,SCORE,latent] = princomp(y);
SCORE1 = bsxfun(@plus,SCORE,-min(SCORE));
SCORE1 = bsxfun(@rdivide,SCORE1,max(SCORE1));
plot3(SCORE1(1:12,1),SCORE1(1:12,2),SCORE1(1:12,3),'g');    
plot3(SCORE1(13:24,1),SCORE1(13:24,2),SCORE1(13:24,3),'g','Linewidth',2,'LineStyle','-.'); 

