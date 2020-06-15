
close all
% Culture = 'G09102014C';
% dDIV = {'DIV36','DIV37','DIV38','DIV39'} ;
Culture = 'G05012015A';
dDIV = {'DIV28','DIV29','DIV30','DIV31','DIV37','DIV38'} ;

d = 5;
DIV = dDIV{d};

a = load(sprintf('%s_%s_statechange.mat',Culture,DIV));
X = a.X;
Y = a.Y;



y = zeros(24,120);
for i=1:24
    for j=1:120
        y(i,j) = numel(Y{i}.T{j});
    end
end
s = 1./max(y);
y = bsxfun(@times,y,s);

h1 = figure('Position',[100 300 600 600]) ;
h2 = figure('Position',[800 300 600 600]) ;

for i=1:120
        
        figure(h1)
        clf
        hold on ;
        x = reshape(X(i,:,:),[20 24])';
        plot(x,'b');
        plot(y(:,i),'y','LineWidth',2);   
        
        text(0.1,0.9,sprintf('Electrode %d',i))
        hold off;
        
        ch = getkey;
        
        if(ch == 49)
           display('Predicting...')
           XP = zeros(size(x));
           z = y(:,i);
           for j=1:20
            f  = @(a)CalculatePrediction(a,z(1:12),x(1:12,j));
            a  = fminunc(f,[0.5 0.1]);
            XP(3:12,j) = a(1)*(z(2:11)-z(1:10)) + x(2:11,j) + a(2);
            f  = @(a)CalculatePrediction(a,z(13:24),x(13:24,j));
            a  = fminunc(f,[0.5 0.1]);
            XP(15:24,j) = a(1)*(z(14:23)-z(13:22)) + x(14:23,j)+ a(2);
           end
           
           figure(h2);clf;hold on;
           plot(x,'b');
           
           idx = [3:12];
           plot(idx,XP(idx,:),'g');
           plot(idx,x(idx-1,:),'r');
           
           e1 = sum(sum((XP(idx,:)-x(idx,:).^2)));
           e2 = sum(sum((x(idx-1,:)-x(idx,:).^2)));
           [e1 e2]
           idx = [15:24];
           plot(idx,XP(idx,:),'g');
           plot(idx,x(idx-1,:),'r');
           
           e1 = sum(sum((XP(idx,:)-x(idx,:).^2)));
           e2 = sum(sum((x(idx-1,:)-x(idx,:).^2)));
           [e1 e2]
           ch = getkey;
        end
        
        
        
end