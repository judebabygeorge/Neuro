function t1_compress_data_files

path = 'E:\Data\Data' ;

display([ 'Scanning ' path])
cultures = dir(path);
cultures = cultures(3:end);
for i=1:numel(cultures)
   CompressDataForCulture([path '\' cultures(i).name])
end

% cultures = {'G28082014A'};
% divs     = {'DIV36'};
% 
% for i=1:numel(divs)
%   p = [path '\' cultures{1} '\' divs{i}]    ;
%   CompressDataForDIV(p);
% end

% cultures = {'G14082014A','G21072014A'};
% for i=1:numel(cultures)
%     p = [path '\' cultures{i}];
%     CompressDataForCulture(p)
% end

end

function CompressDataForCulture(CulturePath)    
   divs = dir(CulturePath);
   divs = divs(3:end);
   for j=1:numel(divs);
       p = [CulturePath '\' divs(j).name];
       CompressDataForDIV(p)
   end
   
end
function CompressDataForDIV(DIVPath)
    CompressDataInFolder(DIVPath);
end