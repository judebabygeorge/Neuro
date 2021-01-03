
Pattern = PatternData.Pattern ; 
Pattern(Pattern>100*50)= nan;
Pattern(Pattern<5*50)= nan;
P=ones(size(Pattern));
P(isnan(Pattern)) = 0;

P = mean(P,3);

id = [9 18 27 36];
id = [id (id+36) (id+72)];
P = P(:,id);

h = PatternView ;
hO  = guidata(h);  

Vis = zeros(size(P,1),1);
Act  = ones(size(Vis))*0;
Mark = zeros(size(Act));

th = 0.3;
Q = zeros(120,12);
id = 1;
for i=1:2
    for j=(i+1):3
        for k=1:4
            %x(id,k) = sum(abs(P(:,(i-1)*4+k) - P((j-1)*4+k)));
            x(id,k) = sum(abs(P(:,(i-1)*4+k) - P(:,(j-1)*4+k))>th);
            Q(:,(id-1)*4+k) = double((abs(P(:,(i-1)*4+k) - P(:,(j-1)*4+k))>th));
        end
        id = id + 1;
    end
end


for i=1:3
   for j=1:4
    Act  = ones(size(Vis))*0;
    Vis = P(:,(i-1)*4+j);
    hO.ShowElectrodeActivity(hO,(i-1)*8 + j,[Act Vis], Mark);
    
    Vis = Q(:,(i-1)*4+j);
    Act  = ones(size(Vis));
    hO.ShowElectrodeActivity(hO,(i-1)*8 + j + 4,[Act Vis], Mark);
   end
end

h2 = PatternView ;
hO  = guidata(h2) ; 

for i=1:3
    id = 1;
    for j=1:3
        for k=(j+1):4
            Q = P(:,(i-1)*4 + j) - P(:,(i-1)*4 + k);
            Q = double(abs(Q)>0.8);
            
            Vis = Q;
            Act  = ones(size(Vis));
            hO.ShowElectrodeActivity(hO,(i-1)*8 + id,[Act Vis], Mark);
            id=id +1;
        end
    end
end