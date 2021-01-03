dpath = './17302016/';
cam = 'Camera-1_1';
files = dir([dpath sprintf('data_%s*.mat',cam) ]);

% for j=1:numel(files)
%     n = sscanf(files(j).name,sprintf('data_%s_%%d_%%d.mat',cam));
%     f = sprintf('%s//data_%s_%d_%d.tiff',dpath,cam,n(1),n(2));
%     a = load(sprintf('%s//data_%s_%d_%d.mat',dpath,cam,n(1),n(2)));
%     X = a.X;
%     imwrite (X(:,:,1),f)
%     for i=2:size(X,3)
%         imwrite (X(:,:,i),f,'WriteMode','append')
%         pause(0.1);
%     end
%     nFrames = size(X,3);
% end

nFrames = 134;

%Create Matrix and save
r = 1;
while(r*r <numel(files))
    r = r+ 1;
end

c = r;

n = sscanf(files(1).name,sprintf('data_%s_%%d_%%d.mat',cam));
f = sprintf('%s//data_%s_%d_all.tiff',dpath,cam,n(1));

FrameId = 1;
X = uint16(zeros(128*r,128*r));
Y = uint16(zeros(128*r,128*r,nFrames));
for FrameNo = 1:nFrames
    fid = 1;
    X = uint16(zeros(128*r,128*r));
    for j=1:c
		for i=1:r
            if(fid <= numel(files))
                a = load(sprintf('%s//data_%s_%d_%d.mat',dpath,cam,n(1),fid));
                X(1+(i-1)*128:i*128,1+(j-1)*128:j*128) = a.X(:,:,FrameNo);
                fid = fid + 1 ;
            end
        end
    end
    if FrameNo == 1
        imwrite (X,f);
    else
        imwrite (X,f,'WriteMode','append');
    end
    Y(:,:,FrameNo)=X;
    FrameNo
end
f = sprintf('%s//data_%s_%d_all.mat',dpath,cam,n(1));
save(f,'Y')

        