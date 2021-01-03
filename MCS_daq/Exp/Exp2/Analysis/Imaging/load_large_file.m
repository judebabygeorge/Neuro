

fname = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Analysis\Imaging\InitialSetup\data_MEAStimulated_0703_DIV19\cl_07032017_mea1_5\cl_07032017_mea1_5_MMStack.ome.tif';
info = imfinfo(fname);
num_images = numel(info);

frames_per_file = 20000;
S=uint16(zeros(128,128,frames_per_file));

fid = 0;



for k = 1:frames_per_file:num_images
    n=min(frames_per_file,num_images - (k-1));    
    for j=1:n
        k+j-1
        S(:,:,j) = imread(fname, k+j-1, 'Info', info); 
    end
    fid=fid+1;save(sprintf('S%d.mat',fid),'S');    
end

nframes = num_images;
save('nframes.mat','nframes')