

path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\G03112014A\';
d = [31];

nd = numel(d);


for i=1:nd    
    DIV  = sprintf('DIV%d',d(i));
    [Y,Z,Yp,Vp] = CalculateEvolveScores(path,DIV);
    C = sum(sum(Vp.^2,1),2);
    C = sum(bsxfun(@times,Y,C),3);        
end

hist(sum(C,2));