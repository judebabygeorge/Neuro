function GetSpontaneousEvolve( path,Culture,DIV )

    path0 = [path  '\' Culture  '\' DIV '\'];
    paired_probes = dir([path0 '\data_burst_PatternCheck_2_250_Dummy_*.mat']);

    mkdir(sprintf('./temp/%s_%s',Culture,DIV))

    for i = 1:numel(paired_probes)
        sprintf('Scan %d',i)
        f = sprintf('\\data_burst_PatternCheck_2_250_Dummy_%d.mat',i);
        f = [path0  f];
        a=load(f); 
        T = ExtractTimingRelations(a.PatternData);
        save(sprintf('./temp/%s_%s/%s_%s_%d.mat',Culture,DIV,Culture,DIV,i),'T')
    end

end