function StimConfig = GenerateStimulusConfig_PairedTrain_Theta(PatternData)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time

nPulses    = 5;
PulseDelay = 5;

[Patterns , StimConfigProbe ]= EditPatterns(PatternData);
StimConfig = StimConfigProbe;

maxPatterns = 127 ;


vecs = StimConfigProbe.PatternDetails.vecs;
electrodes = StimConfigProbe.PatternDetails.electrodes;

nStimOut = numel(vecs);

nProbe = nStimOut;

for i=1:nProbe
    [~,pr1] = GetMeanFireTime(Patterns,electrodes(i),vecs(i));
    display(['Probe : ' num2str(i) ' ' num2str(pr1)]);
end

TrainPattern = input('Enter Patterns to be used for training: ');


nTrain = numel(TrainPattern);
if(nTrain > 1)
    nTrain =1;
end

  
 %Properties
   p = 5*nTrain;
   r = 2*nPulses ;  
   StimConfig.Patterns = zeros(r,p);
   StimConfig.PatternDelay  = ones(size(StimConfig.Patterns))*0; 

   
   for j=1:nTrain
       
       i = TrainPattern(j);
       
       StimConfig.PatternDetails.Train{i}.ElectrodesToObserve = electrodes(i);
       StimConfig.PatternDetails.Train{i}.Patterns            = vecs(i); 
       StimConfig.PatternDetails.Train{i}.TrainOrder          = 1;     
       
       x= repmat(PatternData.StimConfig.Patterns(:,vecs(i)),[nPulses 1]);
       StimConfig.Patterns(:,((j-1)*5 + 1):j*5)  = repmat(x,1,5);
       
       y = PatternData.StimConfig.PatternDelay(:,vecs(i));
       if(x(2)==0)
           y(2) = 0;
       end
       y = repmat(y,[nPulses 1]);
       y(3:2:end) = PulseDelay;
       StimConfig.PatternDelay(:,((j-1)*5 + 1):j*5)  = repmat(y,1,5); %Train = Probe+fire
              
      
   end
 
 x = sum(StimConfig.PatternDelay);
 StimConfig.PatternDelay(1,:) = StimConfig.PatternDelay(1,:) - (x-250);

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

