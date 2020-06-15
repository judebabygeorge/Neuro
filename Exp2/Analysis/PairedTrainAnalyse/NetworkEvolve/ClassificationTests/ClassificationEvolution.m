
Y  = X(tr(:,1)==1,:,:);

for i=1:9

    el = [1 2 3]*i;
    pt = 1:20;
    x = Y(el(1),pt,:);x = reshape(x,[numel(pt),24])';
    y = Y(el(2),pt,:);y = reshape(y,[numel(pt),24])';
    z = Y(el(3),pt,:);z = reshape(z,[numel(pt),24])';

    plot3(x,y,z);
    axis square;
    ch = getkey;
    i
end

