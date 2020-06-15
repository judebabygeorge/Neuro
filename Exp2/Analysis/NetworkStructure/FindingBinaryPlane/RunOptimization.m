
function RunOptimization()

C = {};
C{1}.Culture = 'Z23042015A';
C{1}.DIV     = [13 14 15 20 21 40 41];
C{1}.DIV     = [13 14 15 20 21];

C{2}.Culture = 'Z23042015B';
C{2}.DIV     = [16 17 18 19];

C{3}.Culture = 'Z23042015C';
C{3}.DIV     = [17 18];

if(1)
    for j=1:numel(C)
         for i=1:numel(C{j}.DIV)
            path = sprintf('C:\\Users\\45c\\Documents\\MATLAB\\MCS_daq\\Exp\\Exp2\\Data\\%s\\DIV%d',C{j}.Culture,C{j}.DIV(i));    
            [err,Wmin] =RunOptimization0(path); 
            save(sprintf('%s\\BinaryWeightClassification.mat',path),'err','Wmin')
         end
    end
end


if(0)
n = 11;
e = zeros(56,2,n);
id = 0;
    for j=1:numel(C)
         for i=1:numel(C{j}.DIV)
            path = sprintf('C:\\Users\\45c\\Documents\\MATLAB\\MCS_daq\\Exp\\Exp2\\Data\\%s\\DIV%d',C{j}.Culture,C{j}.DIV(i));                
            a = load(sprintf('%s\\BinaryWeightClassification.mat',path));
            id = id + 1;
            e(:,:,id) = a.err;
         end
    end
    e = sum(e/45<0.2,1);
    e = reshape(e,[2 11])
end

end
function [err,Wmin]= RunOptimization0(path)
    a = load(sprintf('%s/data_PatternCheck_2_250_two_time_seq4_1.mat',path));
    PatternData = a.PatternData;
    
    Patterns = PatternData.Pattern;
    E = PatternData.StimConfig.Electrodes(1,1:8) ;
    E = reshape(E,[1 numel(E)]);
    E = E(E~=0);
    Patterns(E,:,:)=nan;
    DecodeCheckWindow= 150;
    Patterns(Patterns<5*50) = nan;
    Patterns(Patterns>DecodeCheckWindow*50) = nan;
    
    P1 = ones(size(Patterns));
    P1(isnan(Patterns)) = 0;
    Patterns = P1;
    %W = [1.1 0.9  0.1  0.8 -1.6]';
    %W = Wmin;
    
    Wmin = zeros(size(Patterns,1)+1,56,2);
    err = zeros(56,2);
    
    for j=1:2
        SelectedPatterns = j:2:112;
        Ptest = [reshape(Patterns(:,SelectedPatterns,:),[size(Patterns,1) numel(SelectedPatterns)*size(Patterns,3)]);ones(1,numel(SelectedPatterns)*size(Patterns,3))];
        opts = gaoptimset();

        tStart = tic;
        nWeights = size(Wmin,2);
        %nWeights = 3;

        for i=1:nWeights;
            %Wt = W(:,i);

            target = zeros(numel(SelectedPatterns),size(Patterns,3));
            target(i,:)=1;        
            target = target(:);
            f  = @(x)ClosestPlaneError(x,Ptest,target);
            x  = ga(f,size(Wmin,1),[],[],[],[],[ones(1,size(Wmin,1)-1)*-1 -(size(Wmin,1)-2)],[ones(1,size(Wmin,1)-1)*1 0],[],1:size(Wmin,1),opts);
            e = ClosestPlaneError(x,Ptest,target)^0.5
            err(i,j) = e;
            Wmin(:,i,j) = x';

            tel = toc(tStart);
            eta = round((tel/i)*(nWeights-i));
            sprintf('Elapsed : %d min , ETA %d min %d sec',round(tel/60),floor(eta/60), rem(eta,60))
        end
    end
end