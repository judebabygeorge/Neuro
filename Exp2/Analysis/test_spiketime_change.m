
Y = PatternData.Pattern;
Y = reshape(Y,[size(Y,1) size(Y,2)*size(Y,3)]);


y = 1:1:size(Y,2);
figure;
for i=1:5
    %x = Y(I(numel(I)+1-i),:);
    x = Y(I(i),:);
    clf;
    scatter(x,y,10,'filled','r');
    xlim([0 1000])
    waitforbuttonpress;
    
end
