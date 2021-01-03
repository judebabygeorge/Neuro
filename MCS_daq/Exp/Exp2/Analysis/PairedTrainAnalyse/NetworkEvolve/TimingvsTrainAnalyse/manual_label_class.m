close all;
path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\';
Culture = 'G05012015A';
DIV = 'DIV28' ;


X = GetElectrodeEvolve( [path Culture] ,DIV);

path = '../temp/';
a = load([path Culture '_' DIV '_Z.mat']);
Z = a.Z;

h1 =  figure('Position',[500 100 600 600]);

label = 1;

Z  = sum(Z,3);
tr = zeros(120,1);
for i=1:120 
    i
        for j=1:20            
            y=X(i,j,:);
            y = y(:);            
            if abs(Z(i,j))>0.06
                if Z(i,j)>0
                  plot(y+2,'g','LineWidth',2);hold on;
                else
                  plot(y+1,'m','LineWidth',2);hold on;  
                end
            else    
                  plot (y,'k','LineWidth',2);hold on;
            end
        end
        ylim([-0.1 3.1])
        hold off;
        ch = getkey;tr(i,1)=ch;
end

if(label==1)
    tr(tr==48)=0;
    tr(tr==49)=1;
    sum(tr)
    path = './temp/';
    save([path Culture '_' DIV '_T.mat'],'tr');
end
