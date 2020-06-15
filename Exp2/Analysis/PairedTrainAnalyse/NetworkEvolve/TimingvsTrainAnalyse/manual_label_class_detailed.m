close all;
path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\';
Culture = 'G05012015A';
DIV = 'DIV24' ;
PatternTrain = 1/2;

X = GetElectrodeEvolve( [path Culture] ,DIV);
Y = GetElectrodeTimeEvolve( [path Culture] ,DIV );


path = './temp/';
a = load([path Culture '_' DIV '_T.mat']);
tr = a.tr;

h1 =  figure('Position',[100 400 1200 600]);

label = 1;
single_switch=0;

if label==1
   tr_d = zeros(120,20);
else
    a = load([path Culture '_' DIV '_TD.mat']);
    tr_d = a.tr_d;
end
Col = [0 1 0; 1 0 0];

interval = [9 12 21 24];

for i=1:120            
    if(tr(i)==1) 
     if(label==1)
         for j=1:20
                for k=1:20            
                    y=X(i,k,:);
                    y = y(:);                        
                    plot (y,'Color',[1 1 1]*0.8,'LineWidth',2);hold on;             
                end
                    y=X(i,j,:);
                    y = y(:);                        
                    plot (y,'g','LineWidth',3);hold on;  
                ylim([-0.1 1.1])
                hold off;
                ch = getkey;
                tr_d(i,j)=ch;
         end
     else
            p1 = [];p2 = [];p3 = [];p4 = [];
            for k=1:20 
                lbl = [0 0 0 0];
                if(tr_d(i,k)>0)
                    y=X(i,k,:);
                    y = y(:);                     
                    plot (y,'Color',Col(tr_d(i,k),:),'LineWidth',2);hold on;
                        
                    y = Y(i,k,interval(1):interval(2))-Y(i,2*PatternTrain,interval(1):interval(2));
                    y = y(~isnan(y));y=y(:);y = mean(y);
                    
                    y1 =  Y(i,2*PatternTrain,interval(1):interval(2));y1 = y1(~isnan(y1));y1=mean(y1(:));
                    y2 =  Y(i,2*PatternTrain,interval(3):interval(4));y2 = y2(~isnan(y2));y2=mean(y2(:));
                    lbl(1:2) = [y1 y2];
                    
                    y1 =  Y(i,k,interval(1):interval(2));y1 = y1(~isnan(y1));y1=mean(y1(:));
                    y2 =  Y(i,k,interval(3):interval(4));y2 = y2(~isnan(y2));y2=mean(y2(:));
                    lbl(3:4) = [y1 y2];
                    
                    if(tr_d(i,k)==1)
                        p1 = [p1 y];
                        p3 = [p3 (y1-y2)];
                    end
                    if(tr_d(i,k)==2)
                        p2 = [p2 y];
                        p4 = [p4 (y1-y2)];
                    end  
                    if (single_switch==1)
                       y=X(i,2*PatternTrain,:);
                       y = y(:); 
                       plot (y,'Color','m','LineWidth',2);
                       lbl = round(lbl/50);
                       title(sprintf('Train : [%d %d] Probe [%d %d] InitialDiff %d',lbl(1),lbl(2),lbl(3),lbl(4),lbl(3)-lbl(1)));                       
                       hold off;
                       getkey;
                    end  
                end
                
                y=X(i,2*PatternTrain,:);
                y = y(:);  
                plot (y,'Color','m','LineWidth',2);hold on;
                
                
            end
            hold off;
            %p1/50
            %p2/50
            
            display('Next')
            %[mean(p1) mean(p2)]/50
            
            %p3/50
            %p4/50
            [mean(p3) mean(p4)]/50 
            ch = getkey;            
     end

    end
end

if label==1
    tr_d(tr_d==48)=0;
    tr_d(tr_d==49)=1;
    tr_d(tr_d==50)=2;


    path = './temp/';
    save([path Culture '_' DIV '_TD.mat'],'tr_d');
end
