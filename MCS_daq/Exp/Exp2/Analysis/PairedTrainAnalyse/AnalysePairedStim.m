function  AnalysePairedStim(PatternData)
%AnalysePairedStim(PatternData_BT,PatternData_AT,PatternData_T);
%ANALYSEPAIREDSTIM Summary of this function goes here
%   Detailed explanation goes here


[Patterns , StimConfigProbe ]= EditPatterns(PatternData);
P = ones(size(Patterns)) ;
P(isnan(Patterns)) = 0   ;
P = mean(P,3);


Q= zeros(2,numel(StimConfigProbe.PatternDetails.vecs));
for i=1:numel(StimConfigProbe.PatternDetails.vecs)
    Q(1,i) = P(StimConfigProbe.PatternDetails.electrodes(i),StimConfigProbe.PatternDetails.vecs(i));
    Q(2,i) =  GetMeanFireTime(Patterns,StimConfigProbe.PatternDetails.electrodes(i),StimConfigProbe.PatternDetails.vecs(i));
end
display(Q)

 

end

function [P ElectrodesToObserve pStim]= GetElectrodesToObserve(PatternData)

    [Patterns , ~ ]= EditPatterns(PatternData);
    %Find Significant Electrodes
     
    %Calculate The firing probabilities at each electrode 
    P = ones(size(Patterns)) ;
    P(isnan(Patterns)) = 0   ;
    P = mean(P,3);
    
    Q = logical(false(size(P)));
    
   n = 0 ;  
   th1 =0.2;
   th2 =0.4;
   th3= 0.6;
   th4= 0.9;
   for l=1:7
       for m=l+1:8
           n=n+1;           
           for o=1:2
                Pid = [(1 + (n-1)*4 + (o-1)*2) (2 + (n-1)*4 + (o-1)*2) (112+l) (112+m)];
                E = (P(:,Pid(3))<th1) & (P(:,Pid(4))<th1);        
                Q(:,Pid(1)) = E & (P(:,Pid(1)) >th2)&(P(:,Pid(1)) <th3);
                Q(:,Pid(2)) = E & (P(:,Pid(2)) >th2)&(P(:,Pid(2)) <th3);                
           end 
           Pid = (1:4) + (n-1)*4;
           x = sum(Q(:,Pid),1);           
           y = find(x>0);          
           if (numel(y) > 1)
               for i=2:numel(y)
                   Q(:,Pid(y(i))) = 0;
               end
           end
       end
   end
 
   ToStim = find(sum(Q,1)>0)   ;
   
   ToStimOut = [0 0;0 0] ;
   ToFireOut = [0 0] ;
   MeanFireTime = [0 0;0 0];
   nStimOut  = 1     ;
   
   i=1;
   FireDelay = 5;
   
   while i<numel(ToStim)           
       El = find(Q(:,ToStim(i))>0,1);
       [~,I] = sort(P(El,:),'descend');
       if (P(El,I(1))>th4)
           pid = P(El,I(1));
           pfire=P(El,ToStim(i));
           
           ToStimOut(1,nStimOut) = El;
           ToStimOut(2,nStimOut) = ToStim(i);
           ToFireOut(nStimOut) = I(1);
           MeanFireTime(1,nStimOut) =GetMeanFireTime(Patterns,El,ToStimOut(2,nStimOut));
           MeanFireTime(2,nStimOut) =GetMeanFireTime(Patterns,El,ToFireOut(nStimOut));
           
           DelayTrainFiring = ceil(MeanFireTime(1,nStimOut) - MeanFireTime(2,nStimOut) + FireDelay);
           
           if(DelayTrainFiring>2)
            nStimOut=nStimOut + 1;
           end
%            if(nStimOut==3)
%                nStimOut = nStimOut - 1;
%                break;
%            end
       end
       i=i+1;
   end
   
   ElectrodesToObserve = ToStimOut(1,:);
   pStim               = ToStimOut(2,:);
end

function [Patterns , PatternConfig ]= EditPatterns(PatternData)
    %Extract The relevent patterns
    Patterns = PatternData.Pattern;
    PatternConfig = PatternData.StimConfig;
    %Patterns = Patterns(:,V,:);

    E = PatternData.StimConfig.Electrodes(1,1:8) ;
    E = reshape(E,[1 numel(E)]);
    E = E(E~=0);
    Patterns(E,:,:)=nan;
    DecodeCheckWindow= 100;
    Patterns(Patterns<5*50) = nan;
    Patterns(Patterns>DecodeCheckWindow*50) = nan;
end
function tm =  GetMeanFireTime(Patterns,El,Pid)
    tm = Patterns(El,Pid,:);
    tm=  tm(~isnan(tm));
    tm = mean(tm)/50;
end