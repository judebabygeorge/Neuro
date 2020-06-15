
[Patterns , PatternConfig ]= EditPatterns(PatternData);

SelectedPatterns = 1:2:112;

figure;
for i=1:numel(SelectedPatterns)

    P = ones(size(Patterns));
    P(isnan(Patterns)) = 0;

    Q = reshape(P(:,SelectedPatterns(i),:),[size(P,1) size(P,3)]);

 
   

    y = sum(Q,2);

    [~,I]=sort(y,'ascend');
    Q = Q(I,:);
    x = 1:size(Q,2);
    for j=1:size(Q,1)
        I = Q(j,:)==1;
        if(sum(I)>0)
            scatter(x(I),j+Q(j,I),'filled');hold on;            
        end
    end
    hold off;
    getkey();
end
