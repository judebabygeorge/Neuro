function [err1 err2]=testClassificationAccuracyLoss
path = 'E:\Data\Data\';
Culture = 'G09102014C';
dDIV = {'DIV36','DIV37','DIV38','DIV39'} ;
probe_file_tag = 'data_PatternCheck_2_250_paired_train_probe';

err1 = zeros(6,numel(dDIV));
err2 = zeros(6,numel(dDIV));

for j=1:numel(dDIV)
    
    DIV   = dDIV{j};
    path0 = [[path Culture] '\' DIV '\'];
    paired_probes = dir([path0 '\' probe_file_tag '*.mat']);

    f = sprintf('\\%s_%d.mat',probe_file_tag,7);
    f = [path0  f];
    a = load(f);     
    [Patterns , ~ ]= EditPatterns(a.PatternData);
    
    SelectedPatterns = 1:1:size(Patterns,2);
    C = ones(121,numel(SelectedPatterns));
   
    %[emin, Wmin] = CheckClassifiability(a.PatternData,SelectedPatterns,C);   
    P = ones(size(Patterns));
    P(isnan(Patterns)) = 0;
    P = mean(P,3);
    [a,Wmin] = EstimatingClassificationAccuarcyWithIncreasingElectrodes(P,SelectedPatterns);
    
    for i=1:6
        e =  GetClassificationAccuracy(path0,probe_file_tag,i+6,Wmin);
        err1(i,j)=e;
    end
    
    f = sprintf('\\%s_%d.mat',probe_file_tag,19);
    f = [path0  f];
    a = load(f);     
    [Patterns , ~ ]= EditPatterns(a.PatternData);


    SelectedPatterns = 1:1:size(Patterns,2);
    C = ones(121,numel(SelectedPatterns));
   
    %[emin, Wmin] = CheckClassifiability(a.PatternData,SelectedPatterns,C);
    P = ones(size(Patterns));
    P(isnan(Patterns)) = 0;
    P = mean(P,3);
    [a,Wmin] = EstimatingClassificationAccuarcyWithIncreasingElectrodes(P,SelectedPatterns);
    
    for i=1:6
        e =  GetClassificationAccuracy(path0,probe_file_tag,i+18,Wmin);
        err2(i,j)=e;
    end
end

end


function e = GetClassificationAccuracy(path0,probe_file_tag,i,Wmin)
        f = sprintf('\\%s_%d.mat',probe_file_tag,i);
        f = [path0  f];
        a = load(f); 
        [Patterns , ~ ]= EditPatterns(a.PatternData);
        SelectedPatterns = 1:1:size(Patterns,2);
        P = ones(size(Patterns));
        P(isnan(Patterns)) = 0;
        Y = ones(size(Patterns,1)+1,size(Patterns,2),size(Patterns,3));
        Y(1:120,:,:) = P;
        Y = reshape(Y,[size(Y,1) size(Y,2)*size(Y,3)]);
        
        nClasses = numel(SelectedPatterns);
        t = zeros(nClasses,(size(Y,2)*size(Y,3)));   
        for k=1:nClasses
            t(k,k:size(P,2):end)=1  ;
        end
        O = Wmin'*Y;
        O = O>=0;
        
        
        
        c1 = (t==1)&(O==0);
        %Incorret firing
        c2 = (t==0)&(O==1);

        c1 = sum(c1,2) ; c2 = sum(c2,2);
        sb = sum(t==1,2)./sum(t==0,2);
        nE = c1 + c2.*sb ;

        e= mean(nE/48)/2;
end