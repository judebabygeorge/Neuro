function StimConfig = GenerateStimulusConfig_PairedTrain_Theta1(PatternData)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time

nPulses    = 1 ;
PulseDelay = 30;
TrainPulseDelay=30;

[Patterns , StimConfigProbe ]= EditPatterns(PatternData);
StimConfig = StimConfigProbe;

maxPatterns = 127 ;

P = ones(size(Patterns));
P(isnan(Patterns)) = 0 ;
P = mean(P,3);

P1 = (P>0.9);
Efire = sum((sum(P1,2) > 0))
P2 = (P>0.4)&(P<0.7);

nEff = zeros(20,2);
for i=1:20   %For every definitly firing one 
   Q = sum(bsxfun(@times,P2,P1(:,i)));
   [m,I]=max(Q);
   if(m>nEff(i))
       nEff(i,:) = [m I(1)];
   end
end

[~,I]= sort(nEff(:,1),'descend');
[(1:1:20)' I nEff(I,[2 1])]

vecs = StimConfigProbe.PatternDetails.vecs;
electrodes = StimConfigProbe.PatternDetails.electrodes;

nStimOut = numel(vecs);

nProbe = nStimOut;
TrainPattern = input('Enter Patterns to be used for training: ');


nTrain = numel(TrainPattern);
if(nTrain > 1)
    nTrain =1;
end
TrainPattern = TrainPattern(1:nTrain);
Q = bsxfun(@times,P2,P1(:, I(TrainPattern)));
  
 %Properties
   p = 3*nTrain;
   r = 4*nPulses ;  
   StimConfig.Patterns = zeros(r,p);
   StimConfig.PatternDelay  = ones(size(StimConfig.Patterns))*0; 

   
   for j=1:nTrain
       
       i = TrainPattern(j);
       
       StimConfig.PatternDetails.Train{i}.TrainPattern        = nEff(I(i),2) ;  
       StimConfig.PatternDetails.Train{i}.PulsePattern        = I(i) ;
       StimConfig.PatternDetails.Train{i}.Q                   = Q;
       
       [StimConfig.PatternDetails.Train{i}.TrainPattern StimConfig.PatternDetails.Train{i}.PulsePattern]
       
       x= [PatternData.StimConfig.Patterns(:,nEff(I(i),2));PatternData.StimConfig.Patterns(:,I(i))];
       x= repmat(x,[nPulses 1]);
       StimConfig.Patterns(:,((j-1)*5 + 1):j*5)  = repmat(x,1,5);
       
  
       y= [PatternData.StimConfig.PatternDelay(:,nEff(I(i),2));PatternData.StimConfig.PatternDelay(:,I(i))];
       if(x(2)==0)
           y(2) = 0;
       end
       if(x(4)==0)
           y(4) = 0;
       end
       
       y = repmat(y,[nPulses 1]);
       y(3:2:end) = PulseDelay;
       StimConfig.PatternDelay(:,((j-1)*5 + 1):j*5)  = repmat(y,1,5); %Train = Probe+fire
              
      
   end
 
 x = sum(StimConfig.PatternDelay);
 StimConfig.PatternDelay(1,:) = StimConfig.PatternDelay(1,:) - (x-1000);

 p =5;
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

