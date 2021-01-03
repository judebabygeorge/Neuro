close all
%Culture = 'G09102014C';
%dDIV = {'DIV36','DIV37','DIV38','DIV39'} ;
Culture = 'G05012015A';
dDIV = {'DIV25', 'DIV28','DIV29','DIV30','DIV31','DIV37','DIV38'} ;

d = 7;
DIV = dDIV{d};

a = load(sprintf('%s_%s_statechange.mat',Culture,DIV));
X = a.X;
Y = a.Y;


P = mean(X,3);

y = zeros(24,120);
for i=1:24
    for j=1:120
        y(i,j) = numel(Y{i}.T{j});
    end
end
s = 1./max(y);
y = bsxfun(@times,y,s);



[COEFF,SCORE,latent] = princomp(y);

SCORE1 = bsxfun(@plus,SCORE,-min(SCORE));
SCORE1 = bsxfun(@rdivide,SCORE1,max(SCORE1));

if(0)

    t = zeros(120,1);
    h1 = figure('Position',[100 100 600 600]) ;
    h2 = figure('Position',[800 100 600 600]) ;

    for i=1:120
        
        figure(h1)
        clf
        hold on ;
        x = reshape(X(i,:,:),[20 24])';
        plot(x,'b');
        plot(y(:,i),'g','LineWidth',2);   
        plot(mean(y,2),'r','LineWidth',2);   
        plot(SCORE1(:,1:2),'k','LineWidth',2);
        
        text(0.1,0.9,sprintf('Electrode %d',i))
        hold off;
        
        if(0)
            figure(h2)
            clf;hold on;
            z1 = zeros(23,20);
            z2 = zeros(23,20);
            for j=1:20
                z1(:,j) = xcorr(y(1:12,i),x(1:12,j),'unbiased');           
                z2(:,j) = xcorr(y(13:24,i),x(13:24,j),'unbiased');            
            end
             plot(mean(z1,2),'b');
             plot(mean(z2,2),'g');
            hold off;
            ylim([-0.1 1])
        end
        
        ch = getkey;
        t(i)= ch-48;
    end
    %save(sprintf('%s_%s_Emarked.mat',Culture,DIV),'t');
end

if(0)
Z1 = zeros(120,20);
Z2 = zeros(120,20);
for i=1:120
    x = reshape(X(i,:,:),[20 24])';
    for j=1:20
        Z1(i,j) = max(xcorr(y(1:12,i),x(1:12,j),'unbiased'));           
        Z2(i,j) = max(xcorr(y(13:24,i),x(13:24,j),'unbiased'));  
    end
end    

figure(h1);imshow(Z1,'InitialMagnification',300);
figure(h2);imshow(Z2,'InitialMagnification',300);
end
% [COEFF,SCORE,latent] = princomp(y(:,t==1));
% figure;
% plot3(SCORE(1:12,1),SCORE(1:12,2),SCORE(1:12,3),'b');hold on;plot3(SCORE(12:24,1),SCORE(12:24,2),SCORE(12:24,3),'g');
% figure;
% plot(SCORE(1:12,1),SCORE(1:12,2),'b');hold on;plot(SCORE(12:24,1),SCORE(12:24,2),'g');
% figure;
% plot(1:1:12,SCORE(1:12,1),'b');hold on;plot(12:24,SCORE(12:24,1),'g');

