
C{1}.Culture = 'Z23042015A';
C{1}.DIV     = [13 14 15 20 21];

C{2}.Culture = 'Z23042015B';
C{2}.DIV     = [16 17 18 19];

C{3}.Culture = 'Z23042015C';
C{3}.DIV     = [17 18];



path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\';

if(0)
    for i=1:numel(C)
        for j=1:numel(C{i}.DIV)
            a = load(sprintf('%s\\%s\\DIV%d\\data_PatternCheck_2_250_two_time_seq4_1.mat',path,C{i}.Culture,C{i}.DIV(j)));        
            PatternData = a.PatternData;
            ClassificationAccuracyRes = zeros(56,2);
            for k=1:2
                SelectedPatterns = k:2:112;
                ESel = ones(121,numel(SelectedPatterns));
                [emin, Wmin] = CheckClassifiability(PatternData,SelectedPatterns,ESel);    
                ClassificationAccuracyRes(:,k)=emin;            
            end
            save(sprintf('%s\\%s\\DIV%d\\ClassificationAccuracyRes.mat',path,C{i}.Culture,C{i}.DIV(j)),'ClassificationAccuracyRes');
        end
    end

end

x = 0;
for i=1:numel(C)
    x = x + numel(C{i}.DIV);
end
Y = zeros(2,x);
x=0;
for i=1:numel(C)
    for j=1:numel(C{i}.DIV)
         a = load(sprintf('%s\\%s\\DIV%d\\ClassificationAccuracyRes.mat',path,C{i}.Culture,C{i}.DIV(j)));   
         ClassificationAccuracyRes = a.ClassificationAccuracyRes;
         x = x+1;
         ClassificationAccuracyRes = sum(ClassificationAccuracyRes/45 < 0.2) ;
         
         Y(:,x) = ClassificationAccuracyRes';
    end
end
