
C{1}.Culture = 'Z23042015A';
C{1}.DIV     = [13 14 15 20 21 40 41];
C{1}.DIV     = [13 14 15 20 21];

C{2}.Culture = 'Z23042015B';
C{2}.DIV     = [16 17 18 19];

C{3}.Culture = 'Z23042015C';
C{3}.DIV     = [17 18];

x = 0;
for i=1:numel(C)
    x = x + numel(C{i}.DIV);
end

ClRes = zeros(4,x);

k=0;
path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\';
for i=1:numel(C)
    for j=1:numel(C{i}.DIV)
        a = load(sprintf('%s\\%s\\DIV%d\\ClassificationResults.mat',path,C{i}.Culture,C{i}.DIV(j)));
        Cl = a.Cl;
        k=k+1;
        ClRes(:,k)=mean(Cl,2);        
    end
end

ClRes1 = ClRes;

ClRes = bsxfun(@rdivide,ClRes,ClRes(4,:));
ClRes = ClRes(end:-1:1,:);
M = mean(ClRes,2);
plot([120 90 60 30],M, 'LineWidth',2, 'LineSmoothing','on');
ylim([0 1.2])
set(gca,'XDir','reverse')
xlabel('Number of Electrodes')
ylabel('Classification Efficiency')

hold on


x= repmat([120 90 60 30]',[1 11]);
scatter(x(:),ClRes(:),'g','filled');
xlim([25 120])
axis square
set(gca,'XTick',[30 60 90 120])