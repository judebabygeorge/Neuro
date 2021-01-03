function [StimConfigProbe,StimConfigTrain] = GenerateStimulusConfig_TrainProtoCol2 (path)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time

a = load(sprintf('%s/data_PatternCheck_2_250_two_time_seq4_1.mat',path));
PatternData_41 = a.PatternData;
a = load(sprintf('%s/data_PatternCheck_2_250_two_time_seq5_1.mat',path));
PatternData = a.PatternData;

StimConfigProbe = PatternData.StimConfig;
StimConfigTrain = PatternData.StimConfig;
maxPatterns = 127 ; 

[Patterns , PatternConfig ]= EditPatterns(PatternData);
P = ones(size(Patterns));
P(isnan(Patterns)) = 0;
P=mean(P,3);

n = 0;
for i=1:numel(PatternData.StimConfig.PatternListDetails.Tuples)
    display(sprintf('Combination %d',i));
    pid = PatternData.StimConfig.PatternListDetails.Tuples(i).P;
    %PatternData.StimConfig.Patterns(:,pid)

    %Evaluate the electrodes to look at
    Q = P(:,pid);
    E = zeros(120,1);
    %Change in probability of firing on changing 
    %The time of firing from 0.5 to 3ms
    s = [1 3 5 7];
    for j=1:3
        for k=1:numel(s)-1
            for l=k+1:numel(s)
                E = E + (abs(Q(:,3+s(k)+(j-1)*8)-Q(:,3+s(l)+ (j-1)*8))>0.4);
            end
        end
    end
    
    E = find(E>0);
    Score = zeros(1,numel(E));
    CombDetails{i}.E = E;
    for j=1:numel(E)      
        [Escore,Plist] = EvaluateElectrodeScore(P,E(j),pid) ;   
        CombDetails{i}.Details{j}.Escore = Escore;
        CombDetails{i}.Details{j}.Plist  = Plist;
    end
    n = n + numel(E)*3;
    
end
n
D = zeros(n,4);
n = 0;
for i=1:numel(PatternData.StimConfig.PatternListDetails.Tuples)
   for j=1:numel(CombDetails{i}.E)
       S = CombDetails{i}.Details{j}.Escore;
       
       %% Scoring
       
       % Difference + Sufficient + Medium + Excitatory
       S1 = S(:,1).*S(:,2).*S(:,3).*(S(:,4)>0);
       
       % Difference + Sufficient + Medium + Inhibitory
       S2 = S(:,1).*S(:,2).*S(:,3).*(S(:,5)>0);
       
       S  = S1.*S2;
       %% 
       D(n+1:n+3,:)=[ones(3,1)*i ones(3,1)*j [1 2 3]' S];
       n = n +3;
   end
end

sum(D(:,4)>0)

[~,I] = sort(D(:,4),'descend');

B = CreateBarGraphDisplay(6,2,4,[4 80]);
[Patterns , PatternConfig ]= EditPatterns(PatternData);

for idx = 1:numel(I)
    x = D(I(idx),:);
    y = [x(1) CombDetails{x(1)}.E(x(2)) x(3) x(4)];
    display(y);   

    pid  = PatternData.StimConfig.PatternListDetails.Tuples(y(1)).P; 
    ShowSpikeTimes_Sweep(B,Patterns,PatternConfig,y(2),pid);
    
    k = input('Enter 1 to select this Combination 0 otherwise :');
    if k==1
        break;
    end
end


StimConfigProbe.PatternListDetails.CombDetails = CombDetails;
StimConfigProbe.PatternListDetails.SelectedCombDetails = x(1,:);

p_patterns = CombDetails{x(1)}.Details{x(2)}.Plist(x(3),:);

el_involved = StimConfigProbe.Patterns(:,p_patterns(1));
if(el_involved(2)==0)
    el_involved = StimConfigProbe.Electrodes(:,el_involved(1));
    I = find(StimConfigProbe.Electrodes(1,1:8)==el_involved(1));
    el_involved(1)=I(1);
    I = find(StimConfigProbe.Electrodes(1,1:8)==el_involved(2));
    el_involved(2)=I(1);
end
el_involved = el_involved(1:2);
[sPatterns,sPatternDelay] = FindOtherPatterns(el_involved,y(2),PatternData_41)

%% Constructing 16 Patterns
Patterns = zeros(3,16);
PatternDelay = zeros(3,16);

p_all = 1:1:size(PatternData.StimConfig.Patterns,2);
p_all(p_patterns) =[];
i = randperm(numel(p_all));

%Fill Even Numbers with the required ones
Patterns(:,2:2:16)=StimConfigProbe.Patterns(:,p_patterns);
PatternDelay(:,2:2:16)=StimConfigProbe.PatternDelay(:,p_patterns);
%Fill Odd Numbers with other probes
n = size(sPatterns,2);
if(n>=8) %if patterns available from other pool
    Patterns(:,1:2:16)=sPatterns(:,1:8);
    PatternDelay(:,1:2:16)=sPatternDelay(:,1:8);
else
    
    % Fill with available number
    Patterns(:,1:2:2*n)=sPatterns;
    PatternDelay(:,1:2:2*n)=sPatternDelay;
    
    % Rest random (i has index of random patterns
    n = 8-n;
    Patterns(:,(15-2*(n-1)):2:15) = StimConfigProbe.Patterns(:,i(1:n));
    PatternDelay(:,(15-2*(n-1)):2:15) = StimConfigProbe.PatternDelay(:,i(1:n));
end


StimConfigProbe.Patterns = Patterns;
StimConfigProbe.PatternDelay = PatternDelay;

p         =  16;
nSeq      = floor(maxPatterns/p) ;   
StimConfigProbe.PatternSequence = zeros(1,p*nSeq) ;  
for i=1:nSeq
 StimConfigProbe.PatternSequence(((i-1)*p +1):i*p) = 1:1:p ;
end
d = sum(StimConfigProbe.PatternDelay);
StimConfigProbe.PatternDelay(1,:) = StimConfigProbe.PatternDelay(1,:) - (d-250);
 

 StimConfigProbe.p              = p    ;
 StimConfigProbe.nSeq           = nSeq ;
 StimConfigProbe.nLoop          = 1    ;
 
 %TrainProbe
 el         = CombDetails{x(1,1)}.E(x(1,2));
 p_patterns = CombDetails{x(1,1)}.Details{x(1,2)}.Plist(x(1,3),:);
 pr         = P(el, p_patterns);
 
 
 %% Train Pattern Selection
 i = input('Enter 1 for up train, 0 for down train : ');
 
 if(i==1)
  display('Train Up')
  [~,I]      = max(pr(:));
 else
   display('Train Down');
  [~,I]      = min(pr(:));
 end
 
 p_patterns = p_patterns(I(1));
 p_patterns = repmat(p_patterns,[1 20]);
 
 p_patterns = p_patterns(:)';
StimConfigTrain.Patterns = StimConfigTrain.Patterns(:,p_patterns);
StimConfigTrain.PatternDelay = StimConfigTrain.PatternDelay(:,p_patterns);
d = sum(StimConfigTrain.PatternDelay);
StimConfigTrain.PatternDelay(1,:) = StimConfigTrain.PatternDelay(1,:) - (d-250);
    p         =  numel(p_patterns);
    nSeq      = floor(maxPatterns/p) ;   
    StimConfigTrain.PatternSequence = zeros(1,p*nSeq) ;  
    for i=1:nSeq
     StimConfigTrain.PatternSequence(((i-1)*p +1):i*p) = 1:1:p ;
    end
 

 StimConfigTrain.p              = p    ;
 StimConfigTrain.nSeq           = nSeq ;
 StimConfigTrain.nLoop          = 1    ;
 
end



function [Escore,Plist]=EvaluateElectrodeScore(P,E,Pid)       
    %Paired
    Escore = zeros(3,5);
    Plist  = zeros(3,8);
    for i=1:3
        PP = zeros(2,4);
        for k=1:2
           for j=1:4
                    p = Pid(3 + (i-1)*8 + (k-1)*4 + j);  
                    PP(j,k)=P(E,p);
                    Plist(i,(k-1)*4+j)=p;
            end
        end
        PP = PP(:);        
        Escore(i,1) = max(PP) - min(PP);
        Escore(i,2) = sum(PP);
        Escore(i,3) = sum((PP>0.2) & (PP<.5));
        Escore(i,4) = sum((PP>0.75));
        Escore(i,5) = sum((PP<0.05));
    end    
end

function [sPatterns,sPatternDelay] = FindOtherPatterns(ElectrodePair,Eid,PatternData_41)
    [Patterns ,StimConfig ]= EditPatterns(PatternData_41);
    P = ones(size(Patterns));
    P(isnan(Patterns)) = 0;
    P=mean(P,3);
    %P has 112 patterns
    P = P(Eid,1:112);
    
    %Of these remove patterns involving Electrode Pair
    
     StimConfigId=zeros(8,8);
     id = 1;
     for i=1:7
         for j=i+1:8
              StimConfigId(i,j)= id;
              id = id + 1;
         end
     end
     StimConfigId(:,ElectrodePair) = 0;
     StimConfigId(ElectrodePair,:) = 0;
     StimConfigId = StimConfigId(StimConfigId(:)>0);
     StimConfigId = (StimConfigId-1)*4 ;
     StimConfigId = [StimConfigId+1 StimConfigId+2 StimConfigId+3 StimConfigId+4];
     StimConfigId = StimConfigId(:);
     
     p = StimConfigId((P(StimConfigId)>0.1)&(P(StimConfigId)<0.6));
     [~,I] = sort(P(p),'descend');
     P(p(I))
     sPatterns = StimConfig.Patterns(:,p(I));
     sPatterns = [sPatterns;0*sPatterns(2,:)];
     sPatternDelay= StimConfig.PatternDelay(:,p(I));
     sPatternDelay = [sPatternDelay;1*sPatternDelay(2,:)];
end



function ShowSpikeTimes_Sweep(B,Patterns,PatternConfig,E,Pid)
    %Same Electrode for different Patterns
    %Clear display
    
    clear_BarGraphdisplay(B);
    
    %Paired
    for i=1:3
        for k=1:2
           for j=1:4
                    p = Pid(3 + (i-1)*8 + (k-1)*4 + j);
                    ShowSpikeTimes(B,[i j k],Patterns,PatternConfig,E,p);
            end
        end
    end
    
    %Single
    for j=1:3
        p = Pid(j);
        ShowSpikeTimes(B,[4 j 1],Patterns,PatternConfig,E,p);
    end
    
    %3comb
    for k=1:2
        for j=1:3
            p = Pid(3 + 24 + (k-1)*3 + j);
            ShowSpikeTimes(B,[5 j k],Patterns,PatternConfig,E,p);
        end
    end
end

function ShowSpikeTimes(B,loc,Patterns,PatternConfig,E,Pid)
        t = reshape(Patterns(E,Pid,:),[45 1])/50; 
        [n,~] = hist(B.BarAxis{loc(1),loc(2),loc(3)}.ax,t,B.x);                
        set(B.BarAxis{loc(1),loc(2),loc(3)}.bh,'YData',n);

        P=sum(~isnan(t))/numel(t);
        tm = mean(t(~isnan(t)));
        stim  = GetPatternDescription(PatternConfig,Pid);
        s =sprintf('P=%1.1f,T_m = %2.1f ms  (%s)',P,tm,stim);
        set(B.BarAxis{loc(1),loc(2),loc(3)}.hl,'String',s);
end