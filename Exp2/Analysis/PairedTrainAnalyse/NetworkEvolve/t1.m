
% save_path = 'C:\Users\45c\Desktop\train_LTP\G28082014A\ev\';
% B = network_change_analyse('E:\Data\Data\G28082014A\',{'DIV36','DIV37','DIV39','DIV40','DIV47','DIV48','DIV49'},28,6);

% save_path = 'C:\Users\45c\Desktop\train_LTP\G28082014B_T\ev\';
% B = network_change_analyse('E:\Data\Data\G28082014B_T',{'DIV55','DIV56','DIV57'},3,4);

save_path = 'C:\Users\45c\Desktop\train_LTP\G09102014A\ev\';
B = network_change_analyse('E:\Data\Data\G09102014A',{'DIV20','DIV21','DIV22'},4,10);

probes = 1:1:20;

for i=1:numel(probes)
    B.CurrentProbe = probes(i);
    B.UpdateDisplay(B);
    F = getframe(B.h);
    imwrite(F.cdata,[save_path   sprintf('probe_%02d',i) '.png']);
end