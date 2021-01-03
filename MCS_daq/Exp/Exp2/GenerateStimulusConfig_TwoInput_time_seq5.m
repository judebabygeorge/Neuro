function StimConfig = GenerateStimulusConfig_TwoInput_time_seq5 (PatternData)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time

StimConfig = PatternData.StimConfig;
maxPatterns = 127 ; 
 
 r = 3 ; 
 
 %Properties
 StimConfig.PulseInterval_x = [2 3 4]       ; 

 nDelays = numel(StimConfig.PulseInterval_x)  ;   
 
 D1 = bsxfun(@minus,2*StimConfig.PulseInterval , StimConfig.PulseInterval_x) ;
 D2 = StimConfig.PulseInterval_x;
 
 I = FindInterestingStimuliPair(PatternData);
 I = sort(I,2);
 
 StimConfig.Patterns = zeros(r,maxPatterns);
 StimConfig.PatternDelay  = zeros(size(StimConfig.Patterns)); 
 id = 1;
 StimConfigId=zeros(8,8);
 for i=1:7
     for j=i+1:8
          StimConfigId(i,j)= id;
          id = id + 1;
     end
 end

 id = 1;
 perms = [1 2 3; 1 3 2; 2 1 3; 2 3 1 ; 3 1 2; 3 2 1];
 
 %Some logic to see amount of things that can be clubbed together
 nLeft                = maxPatterns-8;
 %CurrentElectrodeList = [];
 Iid = 1;
 ElementsForNew = 6 + (nDelays+1)*6;
 ElementsForExisting1 = 6 + (nDelays+1)*4;
 ElementsForExisting2 = 6 + (nDelays+1)*2;
 ElementsForExisting3 = 6 + 0;
 PatternsInList=0;
 space_required = [ElementsForNew ElementsForExisting1 ElementsForExisting2 ElementsForExisting3];
 
 StimConfig.PatternListDetails =[];
 StimConfig.PatternListDetails.Pairs = zeros(8,8);
 while((nLeft > ElementsForExisting3)&&Iid<=size(I,1))
     nExisting = 0;
     
     for i=1:2
         for j=i+1:3         
             if(StimConfig.PatternListDetails.Pairs(I(Iid,i),I(Iid,j))>0)
                 nExisting = nExisting + 1;
             end
         end
     end
    
     if(space_required(nExisting+1)<=nLeft)
         %CurrentElectrodeList = [CurrentElectrodeList I(Iid,newE(newE>0))];
         nLeft = nLeft - space_required(nExisting+1);
         PatternsInList = PatternsInList + 1;
         StimConfig.PatternListDetails.Tuples(PatternsInList).E  = I(Iid,:);         
         
         P=[];
         %Create Patterns 
         for i=1:2
             for j=(i+1):3
                 if (StimConfig.PatternListDetails.Pairs(I(Iid,i),I(Iid,j))==0)
                     StimConfig.PatternListDetails.Pairs(I(Iid,i),I(Iid,j)) = id;
                     StimConfig.PatternListDetails.Pairs(I(Iid,j),I(Iid,i)) = id;
                     %Create pairs                     
                     %0.5ms 
                     idx = StimConfigId(I(Iid,i),I(Iid,j));
                     for l=1:2             
                        StimConfig.Patterns(:, id) = [8 + (idx-1)*2 + l ; 0;0];
                        StimConfig.PatternDelay(:, id) = [StimConfig.PulseInterval StimConfig.PulseInterval StimConfig.PulseInterval]';
                        id = id+1;
                     end                     
                     % rest of the delays 
                     for l=1:nDelays
                        StimConfig.Patterns(:, id) = [I(Iid,i);I(Iid,j);0];
                        StimConfig.PatternDelay(:, id) = [D1(l) D2(l) D2(l)]';
                        id = id+1;                
                        StimConfig.Patterns(:, id) = [I(Iid,j);I(Iid,i);0];
                        StimConfig.PatternDelay(:, id) = [D1(l) D2(l) D2(l)]';
                        id = id+1;
                     end    
                 end
                 idd = StimConfig.PatternListDetails.Pairs(I(Iid,i),I(Iid,j));
                 P = [P [idd idd+2:2:idd+2+2*(nDelays-1)] [idd+1 idd+2+1:2:idd+2+1+2*(nDelays-1)]]; 
             end                                      
         end
         StimConfig.PatternListDetails.Tuples(PatternsInList).id = id;
         for j=1:size(perms,1)
            StimConfig.Patterns(:, id) = I(Iid,perms(j,:));
            StimConfig.PatternDelay(:, id) = [D1(1) D2(1) D2(1)]';
            id = id+1;
         end    
         idd = StimConfig.PatternListDetails.Tuples(PatternsInList).id;
         P = [P idd:1:idd+5];
         StimConfig.PatternListDetails.Tuples(PatternsInList).P = P;
     end    
     Iid=Iid+1;
 end
 
 Es = id;
 for i=1:8
     StimConfig.Patterns(:,id) = [i;0;0];
     StimConfig.PatternDelay(:, id) = [StimConfig.PulseInterval StimConfig.PulseInterval StimConfig.PulseInterval]';
     id = id+1;
 end
 id = id - 1;
 StimConfig.Patterns=StimConfig.Patterns(:,1:id);
 StimConfig.PatternDelay=StimConfig.PatternDelay(:,1:id);
 p = id;
 Es = Es-1;
 for i = 1:numel(StimConfig.PatternListDetails.Tuples)
     P=StimConfig.PatternListDetails.Tuples(i).P ;
     P=[StimConfig.PatternListDetails.Tuples(i).E+Es P];
     StimConfig.PatternListDetails.Tuples(i).P=P ;
 end
 
 nSeq      = floor(maxPatterns/p) ;   
 StimConfig.PatternSequence = zeros(1,p*nSeq) ;  
 for i=1:nSeq
     StimConfig.PatternSequence(((i-1)*p +1):i*p) = randperm(p) ;
 end
 
 StimConfig.r              = r    ;
 StimConfig.p              = p    ;
 StimConfig.nSeq           = nSeq ;
 StimConfig.DecodeWeights  = []   ;
 StimConfig.nLoop          = 1    ;
end
function I = FindInterestingStimuliPair(PatternData)
    V = 1:1:112;   
    %Extract The relevent patterns
    Patterns = PatternData.Pattern;
    Patterns = Patterns(:,V,:);

    E = PatternData.StimConfig.Electrodes(1,1:8) ;
    E = reshape(E,[1 numel(E)]);
    E = E(E~=0);
    Patterns(E,:,:)=nan;
    DecodeCheckWindow= 100;
    Patterns(Patterns<5*50) = nan;
    Patterns(Patterns>DecodeCheckWindow*50) = nan;
    
    P = ones(size(Patterns));
    P(isnan(Patterns))=0;
    P = mean(P,3);
    Q = reshape(P,[120 4 28]);

if(0)    
    Q(Q>=0.5) = 1;
    Q(Q<0.5) = 0;

    Q = Q(:,1,:) + 2*(Q(:,2,:)) + 4*(Q(:,3,:)) + 8*(Q(:,4,:));
    Q= reshape(Q,[120,28]);

    RR = zeros(size(Q));
    %merit = [0 1 1 0 1 0 1 0 1 0 1 0 0 0 1 0];
    merit = [0 2 2 0 1 0 1 0 2 0 1 0 0 0 2 0];
    for i=1:16
        RR(Q==i-1)=merit(i);
    end
end
if(1)   
    QQ = zeros(size(Q,1),1,size(Q,3));
    for i=1:size(Q,2)-1
        for j=i+1:size(Q,2)
            QQ  = QQ + (abs(Q(:,i,:) - Q(:,j,:)) > 0.4);
        end
    end
     RR = reshape(QQ,[120,28]);
end
    %Interesting electrodes metric in each pair    
    m = sum(RR);
    %[~,I] = sort(m,'descend');
    
    %Now find interesting electrode metric in pairs
    
    M = zeros(8,8);
    id=1;
    for i=1:7
        for j=(i+1):8
            M(i,j) = m(id);
            M(j,i) = m(id);
            id =id + 1;
        end
    end
    M
    I = [];
    id=1;
    for i=1:6
        for j=i+1:7
            for k=j+1:8
                I(id,:) = [i j k M(i,j)*M(i,k)];
                id =id+1;
            end
        end
    end
    [~,i] = sort(I(:,4),'descend');
    I=I(i,:);
    I = I(:,1:3);
    
end

