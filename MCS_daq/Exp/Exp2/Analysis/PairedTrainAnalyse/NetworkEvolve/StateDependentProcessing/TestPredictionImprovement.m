P = PredictProbability(X,Y);
Z = zeros(size(X));
Z(:,:,2:end)=X(:,:,1:end-1);
close all
for i=1:1
    for j=1:1
        pp = P(i,j,:);
        xx = X(i,j,:);
        zz = Z(i,j,:);
        yy = y(:,i);
        plot([pp(:) xx(:) zz(:) yy(:)]);
    end
    getkey;
end