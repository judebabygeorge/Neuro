
%Y = uint16(zeros(size(X)));
pre_width = 50;
post_width = 50;

display('Calculating Image...')
f = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Analysis\Imaging\InitialSetup\data_04082016\mean_6_crop.tif';
imwrite(uint16(zeros(size(X,1),size(X,2))),f);

for i= pre_width+1:(size(X,3)-post_width+1)
    %Z = double(mean(X(:,:,i:(i+post_width-1)),3) - mean(X(:,:,(i-pre_width):(i-1)),3));
    i
    Z = double(mean(X(:,:,(i-pre_width):(i-1)),3));
    Z(Z<0) = 0;
    Z = (Z./max(Z(:)))*65000;
    Y=uint16(Z);  
    imwrite (Y,f,'WriteMode','append'); 
end

% f = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Analysis\Imaging\InitialSetup\data_04082016\mean_8.tif';
% imwrite(Y(:,:,pre_width+1),f);
% for i=pre_width+2:(size(X,3)-post_width+1)
%     i
%     imwrite (Y(:,:,i),f,'WriteMode','append');
% end