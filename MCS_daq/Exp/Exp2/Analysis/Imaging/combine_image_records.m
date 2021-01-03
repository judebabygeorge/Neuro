dpath = './data/';
cam = 'Camera-1';
%files = dir([dpath sprintf('data_%s*.mat',cam) ]);
%n = sscanf(files(1).name,sprintf('data_%s_%%d_%%d.mat',cam));


for j=1:16
    Y={};
    for fid=1:5
        a = load(sprintf('%s//data_%s_%d_%d.mat',dpath,cam,j,fid));
        Y{fid}=a.X;
        fid
    end
    f = sprintf('%s//data_%s_%d_all.mat',dpath,cam,j);
    save(f,'Y')
end