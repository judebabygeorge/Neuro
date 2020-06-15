Culture = 'G09102014C';
dDIV = {'DIV36','DIV37','DIV38','DIV39'} ;

j     = 3;
DIV   = dDIV{j};

path = 'E:\Data\Data\';
probe_file_tag = 'data_PatternCheck_2_250_paired_train_probe';

path0 = [[path Culture] '\' DIV '\'];
SelectedPatterns = 1:1:4;
C = ones(121,numel(SelectedPatterns));
    
i = 1;
f = sprintf('\\%s_%d.mat',probe_file_tag,i);
f = [path0  f];        
a = load(f); 
[emin, Wmin] = CheckClassifiability(a.PatternData,SelectedPatterns,C); %Accuracy Based On Current Weight
Wmin = bsxfun(@times,Wmin,1./abs(Wmin(121,:)));

Emin(:,2,i)=emin;
[X1,t1 ,e] = GetClassificationAccuracy(path0,probe_file_tag,i,Wmin); %Accuracy Based On Current Weight

e

i = 2;
[X2,t2 ,e] = GetClassificationAccuracy(path0,probe_file_tag,i,Wmin); %Accuracy Based On Current Weight

e