close all;
path = 'E:\Data\Data\';
Culture = 'G05012015A';
DIV = 'DIV37' ;


X = GetElectrodeEvolve( [path Culture] ,DIV,'data_PatternCheck_2_250_paired_train_probe');

path = './temp/';
a = load([path Culture '_' DIV '_Z.mat']);
Z = a.Z;

h1 =  figure('Position',[100 100 600 600]);

Z  = sum(Z,3);
tr = zeros(120,2);
%for i=1:120  
for i=[4 7 5 8 9 10 15 17 22 25 35 38 48 50 51 52 53 65 68 79 81 86 91 94 101 102 108 109 110 114 115 117]
    %if sum(tr(i,:))> 0
        %tr(i,:)
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
        text(5,2,sprintf('Electrode %d',i));
        hold off;
        ch = getkey;tr(i,1)=ch;
        %ch = getkey;tr(i,2)=ch;
    %end
end

tr(tr==48)=0;
tr(tr==49)=1;
sum(tr)
%save([path Culture '_' DIV '_T.mat'],'tr');
