
function ExtractSpontaneousDataFromFolder(path)
%path = 'E:\Data\Data\G09102014A\DIV29';
n    = 24;

BurstData{n} = [];
for i=1:n
    display(sprintf('Loading Data %d',i));
    B = load(sprintf('%s\\data_burst_PatternCheck_2_250_Dummy_%d.mat',path,i));
    [y, e] = ExtractBurstProfile(B.PatternData);
    BurstData{i}.y = y;
    BurstData{i}.e = e;
end

save(sprintf('%s\\ExtractedSpontaneousData.mat',path),'BurstData');
end