
% path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\G03112014A\';
% d = [31 32 33 34 35];

path = 'E:\Data\Data\G09102014A\';
d = [25 26 27 28 29];

nd = numel(d);
C2 = zeros(24,nd);

for i=1:nd    
    DIV  = sprintf('DIV%d',d(i));
    [Y,Z,Yp,Vp] = CalculateEvolveScores(path,DIV);

    %[~,I] = sort(Z(:),'descend');
    
    Vp = abs(Vp);
    [~,I] = sort(Vp(:),'descend');
    m = 10;
    m = Vp(I(m));
    Vp(Vp>m) = m;
    C = sum(sum(Vp,1),2);
    C = C(:);
    C2(:,i)=C;
end

C2=bsxfun(@rdivide,C2,max(C2));
C3=bsxfun(@plus,C2,0:(nd-1));
plot(C3,'LineWidth',2);hold on;
% figure;
% for i=1:200
%     [m,n] = ind2sub(size(Z),I(i));
%     y = Yp(m,n,:);
%     [i Z(m,n)]
%     y = y(:);
%     plot(y,'LineWidth',2);
%     waitforbuttonpress;
% end