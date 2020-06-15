function t2_delete_data_files

path = 'E:\Data\Data' ;
display([ 'Scanning ' path])
cultures = dir(path);
cultures = cultures(3:end);
for i=1:numel(cultures)
   divs = dir([path '\' cultures(i).name]);
   divs = divs(3:end);
   for j=1:numel(divs);
       p = [path '\' cultures(i).name  '\' divs(j).name];
       files = dir([p '\*.dat']);
       for k=1:numel(files)           
           delete([p '\' files(k).name])
       end
   end
end


end