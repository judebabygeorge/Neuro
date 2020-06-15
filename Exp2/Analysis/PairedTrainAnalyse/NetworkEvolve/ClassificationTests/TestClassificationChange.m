
path = 'E:\Data\Data\';

% Culture = 'G09102014C';
% dDIV = {'DIV36','DIV37','DIV38','DIV39'} ;
% Culture = 'G05012015A';
% dDIV = {'DIV28','DIV29','DIV30','DIV31','DIV37','DIV38'} ;
% Culture = 'G28082014A';
% dDIV = {'DIV36','DIV37','DIV48','DIV49','DIV50'} ;
Culture = 'G09102014B';
dDIV = {'DIV33','DIV34','DIV35'} ;
Stats = {};
for j=1:numel(dDIV)
    DIV = dDIV{j};
    probe_file_tag = 'data_PatternCheck_2_250_paired_train_probe';

    path0 = [[path Culture] '\' DIV '\'];
    paired_probes = dir([path0 '\' probe_file_tag '*.mat']);



    Err = zeros(20,numel(paired_probes));
    tim = tic;
    for i=1:numel(paired_probes)    
        f = sprintf('\\%s_%d.mat',probe_file_tag,i);
        f = [path0  f];
        a = load(f); 

        [Patterns , ~ ]= EditPatterns(a.PatternData);

        P = ones(size(Patterns));
        P(isnan(Patterns)) = 0;
        P = mean(P,3);
        SelectedPatterns = 1:1:size(Patterns,2);
        C = ones(121,numel(SelectedPatterns));
        [emin, Wmin] = CheckClassifiability(a.PatternData,SelectedPatterns,C);

        Err(:,i)=emin;
        z = toc(tim);
        eta = (z/i)*(numel(paired_probes) -i);
        if(i<numel(paired_probes))
            s = sprintf('(%d/%d) Elasped  %d s. ETA : %d min %d s',i,numel(paired_probes),z, floor(eta/60) ,round(eta - floor(eta/60)*60));
            display(s);
        end
    end

    ea = sum(Err/48 < 0.2);

    id = numel(Stats)+1;
    Stats{id}.Culture = Culture;
    Stats{id}.DIV = DIV;
    Stats{id}.Err = Err;
    save(sprintf('Status_%s.mat',Culture),'Stats')
end

K = zeros(numel(Stats),24);
for i=1:numel(Stats)
    K(i,:) = sum(Stats{i}.Err/48 < 0.2);
end
