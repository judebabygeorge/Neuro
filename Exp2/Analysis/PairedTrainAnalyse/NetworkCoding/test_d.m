
path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\Z23042015B\';
DIV  = [16 17];

a = load(sprintf('%s//DIV%d//data_PatternCheck_2_250_two_time_seq4_1.mat',path,DIV(2)));
PatternData = a.PatternData;
[Patterns , PatternConfig ]= EditPatterns(PatternData);
P = ones(size(Patterns));
P(isnan(Patterns)) = 0;

s = size(P);
Q = reshape(P,[s(1) s(2)*s(3)]);

Z = zeros(120,112);
for i=1:112
    Z(:,i) = mean(Q(:,Q(i,:)==1),2);
end
Z(isnan(Z))=0;
Y = sum(Z,2);
Y = Y./max(Y);


[~,I]=sort(Y,'descend');
n=30;


        
base_file = 'data_PatternCheck_2_250_probe_scan';

W = zeros(121,20,24);
E = zeros(20,24);

for j=1:numel(DIV)
    for i=1:24
        i
        p = sprintf('%s\\DIV%d\\%s_%d.mat',path,DIV(j),base_file,i);
        a = load(p);
        PatternData = a.PatternData;
        SelectedPatterns = 1:1:20;
        C = zeros(121,numel(SelectedPatterns));
        C(121,:)=1;
        C(I(1:n),:)=1;
        
        
%         for k=1:numel(SelectedPatterns)
%           el = randperm(120);
%           C(el(1:n),k)=1; 
%         end
        
        [emin, Wm] = CheckClassifiability(PatternData,SelectedPatterns,C);
        W(:,:,i)=Wm;
        E(:,i)=emin;
    end
    save(sprintf('%s\\DIV%d\\WeightVectors_2.mat',path,DIV(j)),'W','E');
end