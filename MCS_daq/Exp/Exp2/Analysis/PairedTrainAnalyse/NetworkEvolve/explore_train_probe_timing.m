close all;
path = 'E:\Data\Data\';
Culture = 'G28082014A';
DIV = 'DIV50' ;
PatternTrain = 2;

X = GetElectrodeEvolve( [path Culture] ,DIV );
Y = GetElectrodeTimeEvolve( [path Culture] ,DIV );


path = './temp/';
a = load([path Culture '_' DIV '_Z.mat']);
Z = a.Z;
a = load([path Culture '_' DIV '_T.mat']);
tr = a.tr;

Z = sum(Z,3);

p1 = [];
p2 = [];
p  = [];
sum(tr)
for i=1:120
    for j=1:20
        if(j ~= 2*PatternTrain)
            y = Y(i,j,1:12)-Y(i,2*PatternTrain,1:12);
            %y = Y(i,j,1:12);
            %y = Y(i,2*PatternTrain,1:12);  
            
            
            %y = X(i,2*PatternTrain,1:12);
            %y = X(i,j,1:12);
            
            y = y(~isnan(y));y=y(:);
            if (abs(Z(i,j)) > 0.04)
                if ~isempty(y)
                    if(tr(i,1)==1)
                        p1 = [p1; mean(y)];
                    end
                    if(tr(i,2)==1)
                        p2 = [p2; mean(y)];
                    end            
                    p = [p;mean(y)];
                end
            end
        end
    end
end

 figure;hist(p1);figure;hist(p2);
 [mean(p1) mean(p2)]/50
 [median(p1) median(p2)]/50