

path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Analysis\Imaging\InitialSetup\data_MEAStimulated_0703_DIV19\cl_07032017_mea1_5\';
navg = 4;
y = uint16(zeros(nframes/navg,numel(ROIList)));

%load nframes.mat
frames_loaded = 0;
fid=0;
while(frames_loaded<nframes)
    clear S;
    fid=fid+1;S = load(sprintf('%s/S%d.mat',path,fid));
    frames = size(S.S,3);
    frames = min(frames,nframes-frames_loaded);
    for i=1:numel(ROIList)        
     ROI = ROIList{i};
     x = mean(mean(S.S((ROI(2,1):ROI(2,3)),(ROI(1,1):ROI(1,2)),1:frames)));
     x = reshape(x,[navg,frames/navg]);
     y(frames_loaded/navg+1:(frames_loaded+frames)/navg,i) = mean(x);
    end
    frames_loaded = frames_loaded + frames;
    clear S;
end



y = double(y);
y = bsxfun(@minus,y,min(y));
y = bsxfun(@rdivide,y,max(y));

dt = (1/100);
figure('Name','Signals');hold on;
t = dt*(1:navg:nframes);
for i=1:size(y,2)
    plot(t,y(:,i)+i);hold on;
end
if(0)
    for i=1:numel(r)
     plot(t,y(:,II(i))+i);hold on;
    end     
end
if(0)
sdt = 3*(100/navg)*2;
z= (zeros(nframes,1));
z(1:sdt:end)=size(y,2);

%off = min(min(y));
%s   = 0.3*(max(max(y))-off);
plot(t,z,'r')

z = z*0;
z((1+sdt/2):sdt:end)=size(y,2);
plot(t,z,'y')
end