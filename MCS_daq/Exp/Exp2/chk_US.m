
close all
for i=1:120
    
plot([0 1], [Y(i,1) Y(i,1)],'r','LineWidth',2); hold on;
plot([2 3], Y(i,[2 3]),'g','LineWidth',2);
plot([3 4], [Y(i,4) Y(i,4)],'r','LineWidth',2);
plot([5 6], Y(i,[5 6]),'g','LineWidth',2);
plot([6 7], [Y(i,7) Y(i,7)],'r','LineWidth',2);
hold off;
title(sprintf('Electrode %d' , i))
getkey;


end


SpikeCounts = zeros(120,numel(PatternData.Pattern));
for i=1:numel(PatternData.Pattern)
    SpikeCounts(:,i)=PatternData.Pattern{i}.SpikeCounts;    
end

