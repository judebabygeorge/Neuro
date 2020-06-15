function Q = SigElectrode_TestForLearning(PatternData)

 
    %B = CreateBarGraphDisplay(12,1,4,[4 80]);
    [Patterns , PatternConfig ]= EditPatterns(PatternData);
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
                
%                 E = E &  ((P(:,Pid(1)) >th2)|(P(:,Pid(2)) >th2));
%                 E = find(E==1);
%                 
%                 p = numel(E);
%                 id= 0;
%                 while(p>0)
%                     if(p>12)
%                         El = E(id+1:id+16);
%                     else
%                         El = E(id+1:end);
%                     end
%                     ShowSpikeTimes_Pair(B,Patterns,PatternConfig,El,Pid);
%                     waitforbuttonpress;
%                     p = p-12;
%                     id =id+12;
%                 end
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
   nStimOut  = 0     ;
   
   i=1;
   while i<numel(ToStim)           
       El = find(Q(:,ToStim(i))>0,1);
       [~,I] = sort(P(El,:),'descend');
       if (P(El,I(1))>th4)
           P(El,I(1))
           nStimOut=nStimOut + 1;
           ToStimOut(1,nStimOut) = El;
           ToStimOut(2,nStimOut) = ToStim(i);
           ToFireOut(nStimOut) = I(1);
           if(nStimOut==2)
               break;
           end
       end
       i=i+1;
   end
  
   B = CreateBarGraphDisplay(2,1,2,[4 80]);
   nStimOut
   for i=1:nStimOut
       ShowSpikeTimes(B,[i 1 1],Patterns,PatternConfig,ToStimOut(1,i),ToStimOut(2,i));
       ShowSpikeTimes(B,[i 2 1],Patterns,PatternConfig,ToStimOut(1,i),ToFireOut(i));
   end
   
end
function ShowSpikeTimes_Pair(B,Patterns,PatternConfig,E,Pid)
    clear_BarGraphdisplay(B);
    for i=1:numel(E)
        for j=1:numel(Pid)
            ShowSpikeTimes(B,[i j 1],Patterns,PatternConfig,E(i),Pid(j))
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

