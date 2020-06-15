function A = Create_PatternBuffer(Config)

%PatternBuffer [numberofPatterns OffsetsForeachPattern Patternsxnumberofpatterns]
%Pattern [numberofElementsInPattern ([Valid:Trigger:Segment:Config Delay])xNumberOfElements] 

% Find the number of elements

a         = size(Config.Patterns);
nElements =  (a(1)*2 + 1)*(a(2)+1)  + (a(2)+1)    + 1 ; 
          %   pattens x npatterns     offsets   npatterns

A = zeros(nElements,1) ;

id    = 1      ; %nPattens
A(id) = a(2)+1 ;

Offsets = 1 + (a(2)+1) + (0:1:a(2))*(a(1)*2+1);
A(2:((a(2)+1)+1))=Offsets ;
id =  (a(2)+1)+1 + 1 ;

%Add dummy sample
A(id) = 1 ; id = id + 1 ;   % nElements

A(id) = hex2dec('FF000000');id = id + 1;% Config
A(id) = (Config.PatternInterval - Config.PulseInterval*a(1))*50 ; id = id + 1 ;%delay

id    = id + 2*(a(1) - 1);


for i=1:a(2)    
    A(id) = a(1);id = id + 1 ;
    for j=1:a(1)        
        A(id) = Config.Patterns(j,i) ; % Segment is zero 
            Trigger = 0 ;
            p = Config.Patterns(j,i);
            if((p>0)&&(p<=(size(Config.Electrodes,2))))
                for k=1:size(Config.Electrodes,1)
                    if(Config.Electrodes(k,p) ~=0)
                        Trigger = Trigger + 1*(2^(k-1));
                    end
                end
            end
        A(id) = A(id) + Trigger*(2^16) ; %Trigger DAC 1
        id = id + 1;              
        %A(id) = Config.PulseInterval*50 ;id = id + 1;     
        A(id) = (Config.PatternDelay(j,i))*50 ;id = id + 1; 
    end
end

 A = [0;A];
 
 
end
