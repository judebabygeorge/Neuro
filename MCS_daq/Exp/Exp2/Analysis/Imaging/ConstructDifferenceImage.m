
close all;

X = Y{1};
n=40;
for i=0:(floor(192/n)-2)
    
    Xm = mean(X(:,:,i*n + (1:n)),3);

    Z  = mean(X(:,:,(i+1)*n + (1:n)),3)- Xm;

    I = Z;
    I = I - min(min(I));
    I = I/(max(max(I)));
    imshow(I,'InitialMagnification',400);
    
    getkey;
end