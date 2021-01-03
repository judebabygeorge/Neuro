function check_similarity
path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\Z23042015A\';
DIV  = [13 14 15];
% DIV  = [16 17 18];
% DIV  = [27];

%base_file = 'data_PatternCheck_2_250_train_protocol';
base_file = 'data_PatternCheck_2_250_probe_scan';



XX=zeros(120,2,24*numel(DIV));

for j=1:numel(DIV)
    for i=1:24
        p = sprintf('%s\\DIV%d\\%s_%d.mat',path,DIV(j),base_file,i);
        Z = GetProbabilityMatrix(p) ;
        XX(:,:,(j-1)*24+i)=Z(:,[1 2]);
    end
end

Y = zeros(size(XX,3),size(XX,2));
base=60;
th=0.1;
for i=1:size(XX,3)
%     Y(i,1) = sum(CalculateDistance(XX(:,1,base),XX(:,1,i))>th);
%     Y(i,2) = sum(CalculateDistance(XX(:,2,base),XX(:,2,i))>th);
    
%     Y(i,1) = sum(CalculateDistance(XX(:,1,i-1),XX(:,1,i))>th);
%     Y(i,2) = sum(CalculateDistance(XX(:,2,i-1),XX(:,2,i))>th);
    
    Y(i,1) = sum(CalculateDistance(XX(:,1,base),XX(:,1,i)));
    Y(i,2) = sum(CalculateDistance(XX(:,2,base),XX(:,2,i)));
end
%mean(Y)
figure;plot(sum(Y(1:end,:),2));
end

function D=CalculateDistance(P1,P2)
 D = 1 - ((P1.*P2).^0.5 + ((1-P1).*(1-P2)).^0.5);
end
function P=GetProbabilityMatrix(path)
    a = load(path);
    PatternData = a.PatternData;
    [Patterns , ~ ]= EditPatterns(PatternData);
    P = ones(size(Patterns));
    P(isnan(Patterns)) = 0;

    P = mean(P,3);
end