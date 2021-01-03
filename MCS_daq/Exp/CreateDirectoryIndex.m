function DirectoryData = CreateDirectoryIndex(root,tag)
%CREATEDIRECTORYINDEX Summary of this function goes here
%   Detailed explanation goes here

DirectoryData.root = root ;
DirectoryData.tag  = tag  ;

cd(root);

C = dir ;
C = C(3:end);
DirectoryData.nCultures = numel(C)  ;


DirectoryData.Cultures{DirectoryData.nCultures,1} = [] ;

for i=1:DirectoryData.nCultures
    
    DirectoryData.Cultures{i}.Culture  = C(i).name;
    DirectoryData.Cultures{i}.Details  = C(i);
    
    cd(C(i).name);
    D = dir ;
    D = D(3:end);
    DirectoryData.Cultures{i}.nDays = numel(D) ;
    if(DirectoryData.Cultures{i}.nDays > 0)
        DirectoryData.Cultures{i}.DIV{DirectoryData.Cultures{i}.nDays,1} = [];
        for j=1:DirectoryData.Cultures{i}.nDays
            d = D(j).name  ;
            DirectoryData.Cultures{i}.DIV{j}.Day = str2double(d(4:end));
            DirectoryData.Cultures{i}.DIV{j}.Details = D(j);
            cd(D(j).name)
            F = dir ;
            F = F(3:end);
            if(numel(F) > 0)
            DirectoryData.Cultures{i}.DIV{j}.Files{numel(F),1} = [];
            DirectoryData.Cultures{i}.DIV{j}.FileDetails = F;
              for k=1:numel(F)
                DirectoryData.Cultures{i}.DIV{j}.Files{k} = F(k).name ;  
              end              
            end
            cd('../');
        end
    end
    cd('../');
end

end

