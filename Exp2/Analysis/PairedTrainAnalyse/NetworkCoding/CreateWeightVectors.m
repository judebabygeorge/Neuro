
path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\Z23042015A\';
DIV  = [13 14 15];

base_file = 'data_PatternCheck_2_250_probe_scan';

W = zeros(121,20,24);
E = zeros(20,24);
n=60;
for j=1:numel(DIV)
    for i=1:24
        i
        p = sprintf('%s\\DIV%d\\%s_%d.mat',path,DIV(j),base_file,i);
        a = load(p);
        PatternData = a.PatternData;
        SelectedPatterns = 1:1:20;
        
        C = zeros(121,numel(SelectedPatterns));
        C(121,:)=1;
        for k=1:numel(SelectedPatterns)
          el = randperm(120);
          C(el(1:n),k)=1; 
        end
        
        [emin, Wm] = CheckClassifiability(PatternData,SelectedPatterns,C);
        W(:,:,i)=Wm;
        E(:,i)=emin;
    end
    save(sprintf('%s\\DIV%d\\WeightVectors_2.mat',path,DIV(j)),'W','E');
end