function StimConfig = GenerateStimulusConfig_PairedTrain(PatternData)

    %Number of Configs required = Number of Electrodes
    %p different patterns , r electrodes at a time

    
    [Patterns , StimConfigProbe ]= EditPatterns(PatternData);
    StimConfig = StimConfigProbe;
    
    maxPatterns = 127 ; 
 
   
   vecs = StimConfigProbe.PatternDetails.vecs;
   electrodes = StimConfigProbe.PatternDetails.electrodes;
 
   nStimOut = numel(vecs)/2;
 
   nProbe = nStimOut;
   
   for i=1:nProbe       
       [FireTime_Probe,pr1] = GetMeanFireTime(Patterns,electrodes(i),vecs(i));
       [FireTime_Stim,pr2]  = GetMeanFireTime(Patterns,electrodes(i),vecs(i+nStimOut)) ;
       display(['Probe : ' num2str(i) ' ' num2str([FireTime_Probe pr1 FireTime_Stim pr2])]);
   end
   
  TrainPattern = input('Enter Patterns to be used for training: ');
  TrainOrder   = input('Enter Direction for training: ');

  nTrain = numel(TrainPattern);
  if(nTrain > 1)
      nTrain =1;
  end
  
  
 %Properties
   p = 50*nTrain;
   r = 4 ;  
   StimConfig.Patterns = zeros(r,p);
   StimConfig.PatternDelay  = ones(size(StimConfig.Patterns))*50; 
   FireDelay = 5;
   
   for j=1:nTrain
       %Find the electrodes involved in firing       
%        Electrodes = PatternData.StimConfig.Patterns(:,ToStimOut(2,i));
%        if(Electrodes(2)==0);
%            E= PatternData.StimConfig.Electrodes(:,Electrodes(1));
%            Electrodes(1) =find(PatternData.StimConfig.Electrodes(1,1:8)==E(1));
%            Electrodes(2) =find(PatternData.StimConfig.Electrodes(1,1:8)==E(2));
%        end
%        
%        StimConfig.Patterns(1,(i-1)*50 + 1) = Electrodes(1); %Electrode 1       
%        StimConfig.Patterns(1,(i-1)*50 + 2) = Electrodes(2); %Electrode 2       
%        StimConfig.Patterns(1:2,(i-1)*50 + 3) = PatternData.StimConfig.Patterns(:,ToStimOut(2,i)); %Probe Input
%        StimConfig.PatternDelay(1:2,(i-1)*50 + 3) = PatternData.StimConfig.PatternDelay(:,ToStimOut(2,i)); %Probe Input       
%        StimConfig.Patterns(1:2,(i-1)*50 + 4) = PatternData.StimConfig.Patterns(:,ToFireOut(i)); %Fire Input
%        StimConfig.PatternDelay(1:2,(i-1)*50 + 4) = PatternData.StimConfig.PatternDelay(:,ToFireOut(i)); %Fire Input
%        
%        StimConfig.Patterns(:,(i-1)*50 + 5:(i-1)*50 + 8) = StimConfig.Patterns(:,(i-1)*50 + 1:(i-1)*50 + 4);
%        StimConfig.PatternDelay(:,(i-1)*50 + 5:(i-1)*50 + 8) = StimConfig.PatternDelay(:,(i-1)*50 + 1:(i-1)*50 + 4);
%        
%        StimConfig.Patterns(:,(i-1)*50 + 9:(i-1)*50 + 12) = StimConfig.Patterns(:,(i-1)*50 + 1:(i-1)*50 + 4);
%        StimConfig.PatternDelay(:,(i-1)*50 + 9:(i-1)*50 + 12) = StimConfig.PatternDelay(:,(i-1)*50 + 1:(i-1)*50 + 4);


       i = TrainPattern(j);
       
       StimConfig.PatternDetails.Train{i}.ElectrodesToObserve = electrodes(i);
       StimConfig.PatternDetails.Train{i}.Patterns            = [vecs(i) vecs(i+nStimOut)]; 
       StimConfig.PatternDetails.Train{i}.TrainOrder          = TrainOrder;
       
       if(TrainOrder> 0)
        vec_t = [vecs(i) vecs(i+nStimOut)];
       else
        vec_t = [vecs(i+nStimOut) vecs(i)];
       end
       
       [FireTime_1,pr] = GetMeanFireTime(Patterns,electrodes(i),vec_t(1));
       [FireTime_2,pr]  = GetMeanFireTime(Patterns,electrodes(i),vec_t(2));    
       FireTime_1= min(100,FireTime_1);
       FireTime_2= min(100,FireTime_2);
       DelayTrainFiring = ceil(FireTime_1 - FireTime_2 + FireDelay)
       
       if(DelayTrainFiring < 0)
           vec_t = [vec_t(2) vec_t(1)];
           DelayTrainFiring = -DelayTrainFiring;       
       end
       
       %DelayTrainFiring = max(DelayTrainFiring,2);
       vec_t
       x=[PatternData.StimConfig.Patterns(:,vec_t(1));PatternData.StimConfig.Patterns(:,vec_t(2))]
       %x=[PatternData.StimConfig.Patterns(:,ToStimOut(2,i));[0 0]'];
       StimConfig.Patterns(:,((j-1)*50 + 1):j*50)  = repmat(x,1,50); %Train = Probe+fire

       y = [PatternData.StimConfig.PatternDelay(:,vec_t(1)); PatternData.StimConfig.PatternDelay(:,vec_t(2))] ;
       if(x(2) ~=0)
        DelayTrainFiring = DelayTrainFiring - y(2)        ;
       else
        y(2) = 2;
       end
       DelayTrainFiring
       y(3) = max(2,DelayTrainFiring);
       %x = PatternData.StimConfig.PatternDelay(:,vecs(i+nStimOut));
       %x(1) = 0 + DelayTrainFiring;
       %x=[PatternData.StimConfig.PatternDelay(:,vecs(i));x];
       StimConfig.PatternDelay(:,((j-1)*50 + 1):j*50)  = repmat(y,1,50); %Train = Probe+fire
              
      
   end
 
 x = sum(StimConfig.PatternDelay);
 StimConfig.PatternDelay(1,:) = StimConfig.PatternDelay(1,:) - (x-200);

 nSeq      = floor(maxPatterns/p) ;   
 StimConfig.PatternSequence = zeros(1,p*nSeq) ;  
 for i=1:nSeq
     StimConfig.PatternSequence(((i-1)*p +1):i*p) = 1:1:p ;
 end
 
 StimConfig.r              = r    ;
 StimConfig.p              = p    ;
 StimConfig.nSeq           = nSeq ;
 StimConfig.DecodeWeights  = []   ;
 StimConfig.nLoop          = 1    ; 

end

function [tm,p] =  GetMeanFireTime(Patterns,El,Pid)
    tm = Patterns(El,Pid,:);
    N = numel(tm);
    tm=  tm(~isnan(tm));
    f = numel(tm);
    tm = mean(tm)/50;
    p=f/N;
end

