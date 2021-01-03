
if(1)    
fname = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Analysis\Imaging\InitialSetup\data_MEAStimulated_0703_DIV19\cl_07032017_mea1_5\cl_07032017_mea1_5_MMStack.ome.tif';
f     = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Analysis\Imaging\InitialSetup\data_MEAStimulated_0703_DIV19\cl_07032017_mea1_5\cl_07032017_mea1_5_MMStack_filtered.tif';

info = imfinfo(fname);
num_images = numel(info);
end

avg_frames = 50;

I = uint16(zeros(128,128,avg_frames));
for k=1:avg_frames:num_images
    k
    for j=1:avg_frames
        I(:,:,j) = imread(fname, k+j-1, 'Info', info);    
    end
    J = mean(I,3);
    J = J./max(max(J));
    J = adapthisteq(J);
    
    if k == 1
        imwrite(uint16(J*65536),f);
    else
        imwrite(uint16(J*65535),f,'WriteMode','append');
    end
end