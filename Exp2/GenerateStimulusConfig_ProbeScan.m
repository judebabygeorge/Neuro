function StimConfig = GenerateStimulusConfig_ProbeScan(StimConfigProbe)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time


    StimConfig = StimConfigProbe;

    maxPatterns = 127 ;


    vecs = StimConfigProbe.PatternDetails.vecs;

    %Find the electrodes involved in the vector
    ProbeElectrodePair = input('Enter Probe Pattern to Scan: ');
    v = vecs(ProbeElectrodePair);
    StimConfigProbe.PatternDetails.electrodes = StimConfigProbe.PatternDetails.electrodes(ProbeElectrodePair);

    if StimConfigProbe.Patterns(2,v) == 0
    Electrodes = StimConfigProbe.Electrodes(:,StimConfigProbe.Patterns(1,v));
    else
    Electrodes = [StimConfigProbe.Electrodes(1,StimConfigProbe.Patterns(1,v)) StimConfigProbe.Electrodes(1,StimConfigProbe.Patterns(2,v))]';
    end

    %0.5ms (AB,BA) 2ms 3ms 4ms
    Patterns = zeros(2,8);

    E1 = find(StimConfigProbe.Electrodes(1,1:8)==Electrodes(1));
    E2 = find(StimConfigProbe.Electrodes(1,1:8)==Electrodes(2));

    Patterns(1,1) = find(StimConfigProbe.Electrodes(1,:)==Electrodes(1) & StimConfigProbe.Electrodes(2,:)==Electrodes(2));
    Patterns(1,2) = find(StimConfigProbe.Electrodes(1,:)==Electrodes(2) & StimConfigProbe.Electrodes(2,:)==Electrodes(1));

    Patterns(:,3:8) = repmat([E1 E2 ; E2 E1],[1 3]);
    PatternDelay_i    = [50 50 ; 98 2 ; 97 3 ; 96 4]';
    PatternDelay = zeros(2,8);
    PatternDelay(:,1:2:end) = PatternDelay_i;
    PatternDelay(:,2:2:end) = PatternDelay_i;



    StimConfig.Patterns     = zeros(2,16);
    StimConfig.PatternDelay = zeros(2,16);

    StimConfig.Patterns(:,2:2:end)  = Patterns;
    StimConfig.PatternDelay(:,2:2:end)  = PatternDelay;
    StimConfig.Patterns(:,1:2:end)  = StimConfigProbe.Patterns(:,1:2:16);
    StimConfig.PatternDelay(:,1:2:end)  = StimConfigProbe.PatternDelay(:,1:2:16);

    p  = size(StimConfig.Patterns,2) ;
    nSeq = floor(maxPatterns/p);
    StimConfig.PatternSequence = repmat(1:1:p,[1 nSeq]);
    StimConfig.r  = size(StimConfig.Patterns,1) ;
    StimConfig.p  = p ;
    StimConfig.nSeq = nSeq;
    StimConfig.DecodeWeights  = []   ;
    StimConfig.nLoop          = 1    ; 

end


