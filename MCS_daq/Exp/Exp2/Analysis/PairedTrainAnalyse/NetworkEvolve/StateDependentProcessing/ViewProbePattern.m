

if(~exist('h','var'))
    h = PatternView ;
    hO  = guidata(h);  
end

for i = 0:3:23
    for j=1:4
        [j,i]
        Q = X(:,j+4,i+1);
        
        %Vis = zeros(size(Q));
        Vis = Q;            
        Act  = ones(size(Vis))*0;   
        Mark = zeros(size(Act));
        hO.ShowElectrodeActivity(hO,(j-1)*8+i/3 + 1,[Act Vis], Mark);            
    end
end