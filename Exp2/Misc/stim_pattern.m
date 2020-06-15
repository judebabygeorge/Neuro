

O = npermutek(1:3,3);

figure ;
hold on ;

nP = size(O,1);
nE = size(O,2);
for i=1:nP
    for j=1:nE
        scatter(O(i,j),(nE*4)*i + j,30,'k','filled')
    end
    line([0 16],((nE*4)*i + nE + 1)*[1 1]);
end

xlim([0 16]);