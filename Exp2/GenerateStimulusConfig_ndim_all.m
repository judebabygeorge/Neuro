function StimConfig = GenerateStimulusConfig_ndim_all (Electrodes,max,ndim,PatternInterval,PulseInterval)

%Number of Configs required = Number of Electrodes
%p different patterns , r electrodes at a time
Electrodes
display(' Generating GenerateStimulusConfig_ndim all'); 

maxPatterns = max ; 
if(maxPatterns>127)
  maxPatterns = 127 ;
end
 
nElectrodes = floor(numel(Electrodes)/ndim)*ndim;
Electrodes  = reshape(Electrodes,[1 numel(Electrodes)]);
Electrodes  = Electrodes(1:nElectrodes);

%ElectrodeSets = reshape(randperm(numel(Electrodes)),[numel(Electrodes)/ndim ndim]);
ElectrodeSets = reshape(1:1:numel(Electrodes),[ndim numel(Electrodes)/ndim]);
nCombinations = factorial(ndim)/factorial(ndim-2);
nCombinations = nCombinations*floor(numel(Electrodes)/ndim);
nElectrodeConfig = numel(Electrodes) +nCombinations ;
 
 E = zeros(2,nElectrodeConfig) ;
 
 E(1,1: numel(Electrodes)) = Electrodes(reshape(ElectrodeSets,[1 numel(Electrodes)]));
 
 Em = gen_perm(ndim,2)      ; 
 Em = [Em ; (ndim + Em)]    ;
 Em = [Em ones(size(Em,1))'];
 
 for j=1:size(Em,1)
         Em(j,3) = numel(Electrodes) + j;
         E(1,numel(Electrodes) + j) = Electrodes(ElectrodeSets(Em(j,1)));
         E(2,numel(Electrodes) + j) = Electrodes(ElectrodeSets(Em(j,2)));
 end
  
 r = 3 ; 

  %Electrodes In should be 8
 StimConfig.Electrodes = E ;
 
 %Properties
 StimConfig.PatternInterval = PatternInterval ;
 StimConfig.PulseInterval   = PulseInterval   ;

    
 p = (ndim^ndim - ndim);
 StimConfig.Patterns = zeros(r,p*2);
 StimConfig.PatternDelay  = zeros(size(StimConfig.Patterns)); 
 
 
 O = npermutek(1:ndim,ndim);
 
 
 x = zeros(1,ndim);
 %Remove elements where all are same
 for i=1:ndim
     for j=1:size(O,1)
         if(sum(O(j,:) == [i i i])==3)
             x(i) = j;
         end
     end
 end

 O(x,:) = [];
 
 O
 for j=0:1
 for i=1:size(O,1)
     
     done  = 0 ;
     %First two equal
     if(O(i,1) == O(i,2))
         if(abs(O(i,1)-O(i,3))==1)
             pair = find_EconfigPair(Em,[1 2]+j*3);
         else
             pair = find_EconfigPair(Em,[2 1]+j*3);
         end
           
         if(O(i,1)<O(i,3))             
           StimConfig.Patterns(1,i+j*p) = pair;
           StimConfig.Patterns(2,i+j*p) = 3+j*3;
         else
           StimConfig.Patterns(1,i+j*p) = 3+j*3;
           StimConfig.Patterns(2,i+j*p) = pair;
         end
         done = 1;
     end
     
     if(O(i,1) == O(i,3))
         if(abs(O(i,1)-O(i,2))==1)
             pair = find_EconfigPair(Em,[1 3]+j*3);
         else
             pair = find_EconfigPair(Em,[3 1]+j*3);
         end
         if(O(i,1)<O(i,2))
           StimConfig.Patterns(1,i+j*p) = pair;
           StimConfig.Patterns(2,i+j*p) = 2+j*3;
         else
           StimConfig.Patterns(1,i+j*p) = 2+j*3;
           StimConfig.Patterns(2,i+j*p) = pair;
         end
         done = 1;
     end 
     
     %last two equal
     if(O(i,2) == O(i,3))
         if(abs(O(i,3)-O(i,1))==1)
             pair = find_EconfigPair(Em,[2 3]+j*3);
         else
             pair = find_EconfigPair(Em,[3 2]+j*3);
         end
         if(O(i,2)<O(i,1))
           StimConfig.Patterns(1,i+j*p) = pair;
           StimConfig.Patterns(2,i+j*p) = 1+j*3;
         else
           StimConfig.Patterns(1,i+j*p) = 1+j*3;
           StimConfig.Patterns(2,i+j*p) = pair;
         end
         done = 1;
     end     
     %None are equal
     if(done == 0)
        StimConfig.Patterns(:,i+j*p) = O(i,:)'+j*3;
     end
     
     StimConfig.PatternDelay(1,i+j*p)=StimConfig.PulseInterval;
     StimConfig.PatternDelay(2,i+j*p)=StimConfig.PulseInterval;
     StimConfig.PatternDelay(3,i+j*p)=StimConfig.PulseInterval;
 end
 end
 p= p*2;
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

function ConfigId = find_EconfigPair(Em,Pair)
   ConfigId = 0;
   for i=1:size(Em,1)
       if(sum(Em(i,1:2)==Pair)==2)
           ConfigId = Em(i,3);
           break;
       end
   end
end