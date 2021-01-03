

switch (3)
    case 1 
        SelectedPatterns = [1:2:32 2:2:32];
        SelectedPatterns = SelectedPatterns([1:8 17:24 9:16 25:32]);
    case 2
        SelectedPatterns = [1:1:32];      
    case 3
        SelectedPatterns = 1:1:32;
        SelectedPatterns = reshape(SelectedPatterns,[4,8]);
        SelectedPatterns = SelectedPatterns([1 2 4 3],:)';
        SelectedPatterns = SelectedPatterns(:);
end

%SelectedPatterns = [1:2:32 2:2:32];

E = PatternData.StimConfig.Patterns;
Ex= PatternData.StimConfig.Electrodes(1,1:8);
Eid =zeros(120,1);
for i=1:numel(Ex)
    Eid(Ex(i))=i;
end
for i=2:2:112
    p = E(1,i);
    E(1,i)=Eid(PatternData.StimConfig.Electrodes(1,p));
    E(2,i)=Eid(PatternData.StimConfig.Electrodes(2,p));
end


Y = PatternData.Pattern(:,SelectedPatterns,:);
P = ones(size(Y));
P(isnan(Y))=0;
P = mean(P,3);

h = PatternView ;
hO  = guidata(h);  

%Plot all the outputs in row 1
E1 = E(:,SelectedPatterns);
for i=1:32    
    Vis = P(:,SelectedPatterns(i));    
    Act  = ones(size(Vis))*0;   
    Mark = zeros(size(Act));
    Mark(E1(:,i)) = 1;
    hO.ShowElectrodeActivity(hO,i,[Act Vis], Mark);
end

if(0)

    SelectedPatterns = SelectedPatterns + 32 ;

    Y = PatternData.Pattern(:,SelectedPatterns,:);
    P = ones(size(Y));
    P(isnan(Y))=0;
    P = mean(P,3);

    h = PatternView ;
    hO  = guidata(h);  

    %Plot all the outputs in row 1
    E1 = E(:,SelectedPatterns);
    for i=1:32    
        Vis = P(:,SelectedPatterns(i));    
        Act  = ones(size(Vis))*0;   
        Mark = zeros(size(Act));
        Mark(E1(:,i)) = 1;
        hO.ShowElectrodeActivity(hO,i,[Act Vis], Mark);
    end
end

