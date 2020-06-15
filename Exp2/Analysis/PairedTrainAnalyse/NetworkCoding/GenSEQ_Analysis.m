C = {};
C{1}.Culture = 'Z23042015A';
C{1}.DIV     = [13 14 15 20 21 40 41];
C{1}.DIV     = [13 14 15 20 21];

C{2}.Culture = 'Z23042015B';
C{2}.DIV     = [16 17 18 19];

C{3}.Culture = 'Z23042015C';
C{3}.DIV     = [17 18];

n = 0;
for j=1:numel(C)
 n = n  + numel(C{j}.DIV);
end

E = zeros(8,7,n);


k = 1;
label={};
Cl = zeros(11,3);
Cb= [247 150 70 ;155 187 89;79 129 189]/255;
DIVL = [];
for j=1:numel(C)
     for i=1:numel(C{j}.DIV)
        path = sprintf('C:\\Users\\45c\\Documents\\MATLAB\\MCS_daq\\Exp\\Exp2\\Data\\%s\\DIV%d',C{j}.Culture,C{j}.DIV(i));
        a = load(sprintf('%s/GenResults_R.mat',path));
        E(:,:,k) = a.erra;
                
        label{k} = sprintf('C%d : DIV%d',j,C{j}.DIV(i));
        
        Cl(k,:) = Cb(j,:)*(0.7 + 0.3*i/numel(C{j}.DIV));
        
        k = k + 1;    
        
     end
     DIVL = [DIVL C{j}.DIV];
end

E = 8-E;
X = mean(mean(E));
X = X(:);
p = 1:1:numel(X);
close all
opengl software
figure;
set(gcf,'Renderer','OpenGL');
h = bar(p,diag(X),1,'stacked');
hold on;
pbase = [0 0 ; 0 1 ; 1 1 ; 1 0]*0.9;
faces  = [1 2 3 4];
for i = 1:numel(h)
    set(h(i),'facecolor',Cl(i,:))
    p = patch('Faces',faces,'Vertices',bsxfun(@plus,pbase,[i-0.45 9]),'FaceColor',Cl(i,:),'EdgeColor','w');
    p = patch('Faces',faces,'Vertices',bsxfun(@plus,pbase,[i-0.45 10]),'FaceColor',Cl(i,:),'EdgeColor','w');
    p = patch('Faces',faces,'Vertices',bsxfun(@plus,pbase,[i-0.45 11]),'FaceColor',Cl(i,:),'EdgeColor','w');
    text(i-0.25 , 11.5,sprintf('%d',DIVL(i)),'FontName','Calibri','FontSize',10,'FontWeight','bold','Color','k')
    text(i-0.25 , 10.5,sprintf('%d',Y(1,i)),'FontAngle', 'italic','FontName','Calibri','FontSize',10,'FontWeight','bold','Color','k')
    text(i-0.25 , 9.5,sprintf('%d',Y(2,i)),'FontAngle', 'italic','FontName','Calibri','FontSize',10,'FontWeight','bold','Color','k')
end

xlabel('Culture')
ylabel('Mean Number of Correct Classes (of 8)')
ax = gca;
set(gca,'XTickLabel',{});
set(gca,'YTick',1:1:8)
set(gca,'YTickLabel',{'1','2','3','4','5','6','7','8',''});
% for i=1:numel(label)
%     text(i,-2,label{i},'Rotation',90,'FontName','Cambria','FontSize',10,'FontWeight','demi')
% end
ylim([0 12])
