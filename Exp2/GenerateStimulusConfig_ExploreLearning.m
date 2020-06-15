function StimConfigProbe = GenerateStimulusConfig_ExploreLearning(PatternData)
   %X = GenerateStimulusConfig_ExploreLearning_Task(PatternData);
   maxPatterns=125;
   [TrainProbesSelected,ProbesSelected] = GenerateStimulusConfig_ExploreLearning_Timing(PatternData);
   
   p = numel(TrainProbesSelected) + numel(ProbesSelected) ;
 
   nSeq      = floor(maxPatterns/p) ; 
   StimConfigProbe.PatternSequence = zeros(1,p*nSeq) ; 
 
   nT = numel(TrainProbesSelected);
   ivecs = [TrainProbesSelected';ProbesSelected(1:nT)'];
   ivecs = [ivecs(:)' ProbesSelected(nT+1:end)'];
   pp = zeros(1,p);
   vecs = 1:1:p;
   pp(vecs) = ivecs ;
 
 
   StimConfigProbe = PatternData.StimConfig;
   StimConfigProbe.Patterns     =  StimConfigProbe.Patterns(:,pp);
   StimConfigProbe.PatternDelay =  StimConfigProbe.PatternDelay(:,pp);

 
 for i=1:nSeq
     StimConfigProbe.PatternSequence(((i-1)*p +1):i*p) = 1:p ;
 end
 
 StimConfigProbe.PatternDetails.vecs = vecs;
 StimConfigProbe.PatternDetails.electrodes  = ones(size(vecs));

 
 StimConfigProbe.p              = p    ;
 StimConfigProbe.nSeq           = nSeq ;
 
 
end
function Y = GenerateStimulusConfig_ExploreLearning_Task(PatternData)

    TrainProbesSelected = 0;ProbesSelected=0;
    
    
    [Patterns , ~ ]= EditPatterns(PatternData);
    %Find Significant Electrodes
     
    %Calculate The firing probabilities at each electrode 
    P = ones(size(Patterns)) ;
    P(isnan(Patterns)) = 0   ;
    N = sum(P,3);
        
    %Calculate Mean Fire Time at each electrode
    T = Patterns;
    T(isnan(Patterns)) = 0;
    T = sum(T,3);
    
    P = mean(P,3);
    T = T./N;
    
    th = 0.5;
    w  = 10*50;
    nP = size(P,2); 
    
   
   
    Y  = zeros([nP nP 2]);
    
    for i=1:nP
        for j=1:nP
            p  = (P(:,i)>th)&(P(:,j)>th);
            td = T(:,i) - T(:,j);
            Y(i,j,1) = sum((td >  w)&p);
            Y(i,j,2) = sum((td < -w)&p);
        end
    end
    
    
end
function [TrainProbesSelected,ProbesSelected] = GenerateStimulusConfig_ExploreLearning_Timing(PatternData)
    [Patterns , ~ ]= EditPatterns(PatternData);
    %Find Significant Electrodes
     
    %Calculate The firing probabilities at each electrode 
    P = ones(size(Patterns)) ;
    P(isnan(Patterns)) = 0   ;
    N = sum(P,3);
        
    %Calculate Mean Fire Time at each electrode
    T = Patterns;
    T(isnan(Patterns)) = 0;
    T = sum(T,3);
    
    P = mean(P,3);
    T = T./N;
    
    th = 0.5;
    w = 10*50;
    
    y = T(P>th);
    c = median(y);
    %hist(y/50)
    
    X = zeros(size(P));
    
    X((T<(c-w))&(P>th)) = -1;
    X((T>(c+w))&(P>th)) =  1;
    X((T>(c-w))&(T<(c+w))&(P>th)) =  2;
    
    nP = 112;
    Y = zeros(nP,nP);
    for i=1:nP
        for j=i+1:nP
            p  = (P(:,i)>th)&(P(:,j)>th);
            td = T(:,i) - T(:,j);
            Y(i,j) = sum((td >  w)&p);
            Y(j,i) = sum((td < -w)&p);            
        end
    end
    
    %Selecting Train Patterns
    TrainingEffect = zeros(nP,2);
    for i=1:nP
        TrainingEffect(i,:) = [sum(Y(i,:)) sum(Y(:,i))];
    end
    
    ElectrodesInvolved = zeros(nP,2);
    for i=1:120
        if PatternData.StimConfig.Patterns(2,i) == 0
            ElectrodesInvolved(i,1) = PatternData.StimConfig.Electrodes(1,PatternData.StimConfig.Patterns(1,i));
            ElectrodesInvolved(i,2) = PatternData.StimConfig.Electrodes(2,PatternData.StimConfig.Patterns(1,i));
        else
            ElectrodesInvolved(i,1) = PatternData.StimConfig.Electrodes(1,PatternData.StimConfig.Patterns(1,i));
            ElectrodesInvolved(i,2) = PatternData.StimConfig.Electrodes(1,PatternData.StimConfig.Patterns(2,i));
        end
    end
    [~,TrainProbes] = sort(sum(TrainingEffect,2),'descend');
    %TrainProbes = TrainProbes(1:5)
    
    nT = 0;
    id = 1;
    ElectrodesUsed = zeros(120,1);
    TrainProbesToSelect = 5;
    TrainProbesSelected = zeros(TrainProbesToSelect,1);
    sid = zeros(TrainProbesToSelect,1);
    while (nT < TrainProbesToSelect) && (id<=3*TrainProbesToSelect)
        x = ElectrodesUsed(ElectrodesInvolved(TrainProbes(id),1)) + ElectrodesUsed(ElectrodesInvolved(TrainProbes(id),2)) ;
        if x < 2
            nT = nT + 1;
            sid(nT) = id;
            TrainProbesSelected(nT) = TrainProbes(id);            
            ElectrodesUsed(ElectrodesInvolved(TrainProbes(id),1)) =1;
            ElectrodesUsed(ElectrodesInvolved(TrainProbes(id),2)) =1;
        end
        id = id + 1;
    end
    TrainProbesSelected = TrainProbesSelected(1:nT);
    if(nT < TrainProbesToSelect)
        sid = sid(1:nT);
        TrainProbes(sid) = [];
        TrainProbesSelected = [TrainProbesSelected;TrainProbes(1:TrainProbesToSelect-nT)];
    end
    
    TrainProbesSelected
    id
    
    %% Pick Probe patterns
    
    %Creating Scores
    TrainProbeEffect = zeros(nP,2);
    probes = 1:nP;
    probes(TrainProbesSelected)=[];
           
    for i=probes
        TrainProbeEffect(i,:) = [sum(Y(i,TrainProbesSelected)) sum(Y(TrainProbesSelected,i))];
    end
    
    [~,ProbesEffect] = sort(sum(TrainProbeEffect,2),'descend');
 
    nPr = 0;
    id = 1;
    ElectrodesUsed = zeros(120,1);
    ProbesToSelect = 15;
    ProbesSelected = zeros(ProbesToSelect,1);
    sid = zeros(ProbesToSelect,1);
    while (nPr < ProbesToSelect) && (id<=3*ProbesToSelect)
        x = ElectrodesUsed(ElectrodesInvolved(ProbesEffect(id),1)) + ElectrodesUsed(ElectrodesInvolved(ProbesEffect(id),2)) ;
        if x < 2
            nPr = nPr + 1;
            sid(nPr) = id;
            ProbesSelected(nPr) = ProbesEffect(id);            
            ElectrodesUsed(ElectrodesInvolved(ProbesEffect(id),1)) =1;
            ElectrodesUsed(ElectrodesInvolved(ProbesEffect(id),2)) =1;
        end
        id = id + 1;
    end
    ProbesSelected = ProbesSelected(1:nPr);
    if(nPr < ProbesToSelect)
        sid = sid(1:nPr);
        ProbesEffect(sid) = [];
        ProbesSelected = [ProbesSelected;ProbesEffect(1:ProbesToSelect-nPr)];
    end
    
    
    ProbesSelected
    id
    
    [sum(sum(Y(TrainProbesSelected,ProbesSelected))) sum(sum(Y(ProbesSelected,TrainProbesSelected)))]
end