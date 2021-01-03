
path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Analysis\Imaging\InitialSetup\data_MEAStimulated_0703_DIV19\cl_07032017_mea1_5\';

ROIList = {};

I = zeros(128,128);

load(sprintf('%s/nframes.mat',path))
%nframes = nframes;

frames = 0;
fid = 0;
while(frames<nframes)
    clear S;
    fid=fid+1;
    S = load(sprintf('%s/S%d.mat',path,fid));
    n = min(size(S.S,3),nframes-frames);
    I = I + double(mean(S.S(:,:,1:n),3));
    frames = frames + size(S.S,3);
end


I = I./max(max(I));
I = adapthisteq(I);

roi_view = figure('Name','ROIView');
imshow(I,'InitialMagnification',300);
