
C{1}.Culture = 'Z23042015A';
C{1}.DIV     = [13 14 15 20 21 40 41];
C{1}.DIV     = [13 14 15 20 21];

C{2}.Culture = 'Z23042015B';
C{2}.DIV     = [16 17 18 19];

C{3}.Culture = 'Z23042015C';
C{3}.DIV     = [17 18];

n=[15 30 60 90 120];

% for i=1:numel(C)
%     for j=1:numel(C{i}.DIV)
%         E = zeros(112,numel(n));
%         for k=1:numel(n)
%              sprintf('%s  %d [%d]',C{i}.Culture,C{i}.DIV(j),n(k))
%              emin = CheckSubNetwork_Coding(C{i}.Culture,C{i}.DIV(j),n(k));
%              E(:,k)=emin;
%         end
%         path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\';
%         save(sprintf('%s\\%s\\DIV%d\\ClassSubNet.mat',path,C{i}.Culture,C{i}.DIV(j)),'E');
%     end
% end
path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\';
E = zeros(5,0);
for i=1:numel(C)
    for j=1:numel(C{i}.DIV)
        a = load(sprintf('%s\\%s\\DIV%d\\ClassSubNet.mat',path,C{i}.Culture,C{i}.DIV(j)));
        X = a.E;
        X = sum(X/45 < 0.2);
        X = X./X(end);
        E = [E X'];
    end
end
E = mean(E,2);
plot(n,E);
ylim([0 1.2])
set(gca,'XTick',0:15:120)
set(gca,'XDir','reverse')
xlabel('Number of Electrodes')
ylabel('Classification Efficiency')