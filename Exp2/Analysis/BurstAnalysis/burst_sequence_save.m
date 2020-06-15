function burst_sequence_save(src_path)
files = dir([src_path '\data_burst_PatternCheck_*.mat']);
for i=1:numel(files)
    if(files(i).name(end-4)=='e')
        continue
    end
    f = [src_path '\' files(i).name];
    
    f1 = f(1:end-3) ;
    I = find(f1=='_',1,'last');    
    n = eval(f1(I+1:end));
    f1 = sprintf('%s%02d.png',f1(1:I),n);
    
    f2 = [f(1:end-4) '_e.mat'];
    if (~exist(f2,'file'))
        display(['Analysing  ' f]);
        a = load(f);
        B = burst_analyse(a.PatternData ,[] );
        close(B.h);             
        Data = B.Data;
        save(f2,'Data');
    end
    if (exist(f2,'file')&&~exist(f1,'file'))        
        a = load(f2);
        B = burst_analyse( [] ,a.Data );         
        F = getframe(B.h);
        imwrite(F.cdata,f1);
        close(B.h);
    end
end

end