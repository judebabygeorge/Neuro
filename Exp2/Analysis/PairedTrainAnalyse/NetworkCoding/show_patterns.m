
path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\Z01062015A\';
DIV  = [16];

%base_file = 'data_PatternCheck_2_250_train_protocol';
base_file = 'data_PatternCheck_2_250_probe_scan';

scans     = [1 8 16 24];
patterns  = [5 9 1 7 11 3 6 10];

a = load(sprintf('%s\\DIV%d\\StimConfigProbe.mat',path,DIV(1)));

p = a.StimConfigProbe.PatternDetails.probe_patterns;
for i=1:numel(patterns)
    [~,I]=find(p==patterns(i));
    patterns(i)=I;
end

h = PatternView ;
hO  = guidata(h);

for scan_id =1:min(numel(scans),4)
    
    a = load(sprintf('%s\\DIV%d\\%s_%d.mat',path,DIV(1),base_file,scans(scan_id)));
    PatternData = a.PatternData;
    [Patterns , PatternConfig ]= EditPatterns(PatternData);
    P = ones(size(Patterns));
    P(isnan(Patterns)) = 0;

    Z = mean(P,3);

    for i=1:min(8,size(Z,2))
       Vis  = Z(:,patterns(i));   
       Act  = ones(size(Vis))*0;
       Mark = zeros(size(Act));

       id = (scan_id-1)*8+i;
       hO.ShowElectrodeActivity(hO,id,[Act Vis], Mark);
    end

    % n = zeros(1,size(P,2));
    % for i=1:size(P,3)-1
    %     for j=i+1:size(P,3)
    %         n = n + sum(abs(P(:,:,i) - P(:,:,j)));
    %     end
    % end
    % n

%     SelectedPatterns = 1:1:size(P,2);
%     [emin, Wmin] = CheckClassifiability(PatternData,SelectedPatterns);
end