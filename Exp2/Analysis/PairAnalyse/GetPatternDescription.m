function s = GetPatternDescription(PatternConfig,pid)
    El = PatternConfig.Electrodes(1,1:8);
    P = PatternConfig.Patterns(:,pid);
    s = [];
    for i=1:numel(P)
        if(P(i) ~=0)              
            s = [s GetElectrodeLables(PatternConfig,P(i))];
        end
    end
    
    s = strtrim(s);
    
    function s0 = GetElectrodeLables(PatternConfig,eid)  
        E = PatternConfig.Electrodes(:,eid);        
        s0 = [];
        
        for j=1:numel(E)
            if(E(j) ~= 0)
                s0 = [s0 char(uint8('A')+find(El==E(j),1)-1) ' '];
            end
        end
    end
end