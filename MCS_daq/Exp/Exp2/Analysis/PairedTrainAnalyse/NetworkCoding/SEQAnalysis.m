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

E = zeros(28,n);


k = 1;

for j=1:numel(C)
     for i=1:numel(C{j}.DIV)
        path = sprintf('C:\\Users\\45c\\Documents\\MATLAB\\MCS_daq\\Exp\\Exp2\\Data\\%s\\DIV%d',C{j}.Culture,C{j}.DIV(i));
        a = load(sprintf('%s/SEQResults.mat',path));
        E(:,k) = a.erra;                
        k = k + 1;           
     end
end

label = {};
el = ['ABCDEFGH'];

k=1;
for i=1:7
    for j=i+1:8
        label{k} = sprintf('%c%c-%c%c',el(i),el(j),el(j),el(i));
        k=k+1;
    end
end

if(1)
E = 1-E;
X = mean(E,2);
X = X(:);

close all
opengl software
figure;
set(gcf,'Renderer','OpenGL');
bar(X)
xlabel('Pair')
ylabel('Classification Accuracy for a different input')

set(gca,'XTickLabel','')

ax = axis;    % Current axis limits
axis(axis);    % Set the axis limit modes (e.g. XLimMode) to manual
Xl = [0 29];
Yl = ax(3:4);  % Y-axis limits

% Place the text labels
Xt = 0.75:1:28;
set(gca,'XTick',Xt,'XLim',Xl);

t = text(Xt,Yl(1)*ones(1,length(Xt)),label);
set(t,'HorizontalAlignment','right','VerticalAlignment','top', ...
      'Rotation',90);
for i = 1:length(t)
  ext(i,:) = get(t(i),'Extent');
end

LowYPoint = min(ext(:,2));
% Place the axis label at this point
XMidPoint = Xl(1)+abs(diff(Xl))/2;
tl = text(XMidPoint,LowYPoint,'X-Axis Label', ...
          'VerticalAlignment','top', ...
          'HorizontalAlignment','center');
      
      
  
end