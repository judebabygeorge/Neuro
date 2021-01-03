
path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\G03112014A\DIV32';
pid  = 5;

yy = zeros(24,2);
for id = 1:24
  [y, e] = CompareBurstVsInput( path , id ,pid);
  yy(id,:) = [y e];
end

xx = ((1:1:24)*0.37)' ;
xx = [xx (xx+0.25)];
yy(:,1) = yy(:,1)/max(yy(:,1)) ;
figure;plot(xx,yy,'LineWidth',2);

