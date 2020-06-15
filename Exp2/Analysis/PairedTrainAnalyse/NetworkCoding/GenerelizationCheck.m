
C = {};
C{1}.Culture = 'Z23042015A';
C{1}.DIV     = [13 14 15 20 21 40 41];
C{1}.DIV     = [13 14 15 20 21];

C{2}.Culture = 'Z23042015B';
C{2}.DIV     = [16 17 18 19];

C{3}.Culture = 'Z23042015C';
C{3}.DIV     = [17 18];



if(0)
    for j=1:numel(C)
        for i=1:numel(C{j}.DIV)
            path = sprintf('C:\\Users\\45c\\Documents\\MATLAB\\MCS_daq\\Exp\\Exp2\\Data\\%s\\DIV%d',C{j}.Culture,C{j}.DIV(i));
            erra=CheckGEN(path);
            save(sprintf('%s/GenResults_R.mat',path),'erra');
        end
    end
end
if(0)
    for j=1:numel(C) 

        for i=1:numel(C{j}.DIV)
            path = sprintf('C:\\Users\\45c\\Documents\\MATLAB\\MCS_daq\\Exp\\Exp2\\Data\\%s\\DIV%d',C{j}.Culture,C{j}.DIV(i));
            erra=CheckSEQ(path);
            save(sprintf('%s/SEQResults.mat',path),'erra');
        end
    end
end
if(0)
    for j=1:numel(C) 
        for i=1:numel(C{j}.DIV)
            path = sprintf('C:\\Users\\45c\\Documents\\MATLAB\\MCS_daq\\Exp\\Exp2\\Data\\%s\\DIV%d',C{j}.Culture,C{j}.DIV(i));
            erra=CheckGEN_Alone(path);
            save(sprintf('%s/GenAloneResults.mat',path),'erra');
        end
    end
end

if(1)
    id=1;
    for j=1:numel(C) 
        for i=1:numel(C{j}.DIV)
            path = sprintf('C:\\Users\\45c\\Documents\\MATLAB\\MCS_daq\\Exp\\Exp2\\Data\\%s\\DIV%d',C{j}.Culture,C{j}.DIV(i));            
            x = load(sprintf('%s/GenAloneResults.mat',path));
            y(id) = x.erra;
            id = id+1;
        end
    end
end