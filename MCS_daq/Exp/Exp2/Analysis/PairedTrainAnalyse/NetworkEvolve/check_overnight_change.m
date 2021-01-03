close all;
opengl('software');

%path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\';
path = 'E:\Data\Data\'

% Culture = 'G09102014A';
% DIV = {'DIV26','DIV27','DIV28','DIV29'} ;
% Culture = 'G09102014B';
% DIV = {'DIV33','DIV34','DIV35'} ;
% Culture = 'G09102014C';
% DIV = {'DIV36','DIV37','DIV38','DIV39'} ;
% Culture = 'G28082014A';
% DIV = {'DIV36','DIV37','DIV48','DIV49','DIV50'} ;
Culture = 'G05012015A';
%DIV = {'DIV28','DIV29','DIV30','DIV31'} ;
DIV = {'DIV37','DIV38'} ;

X = {};
for i=1:numel(DIV)
  X{i}.X  = GetElectrodeEvolve( [path Culture] ,DIV{i},'data_PatternCheck_2_250_paired_train_probe');
end

path = './temp/';
a = load([path Culture '_' DIV{1} '_Z.mat']);
Z = a.Z;

h1 =  figure('Position',[100 100 1600 800],'color','w');

Z  = sum(Z,3);

label = 1;
if(label==0)
    a = load([path Culture '_OV.mat']);
    ov = a.ov;
else
    ov = zeros(120,1);
end
for i=1:120    
    if (ov(i) > 0 || label==1)
        figure(h1);
        
            for j=1:20            
                for d=1:numel(DIV)
                    x = (d-1)*24+1:d*24;
                    y=X{d}.X(i,j,:);
                    y = y(:);
                    y = y(1:24);
                    if abs(Z(i,j))>0.06
                        if Z(i,j)>0
                          plot(x,y+2,'g','LineWidth',2);hold on;
                        else
                          plot(x,y+1,'m','LineWidth',2);hold on;
                        end
                    else    
                          plot(x,y,'k','LineWidth',2);hold on;  
                    end
                end
            end
            ylim([-0.1 3.1])
          
        
        
        for d=1:numel(DIV)
            x = (d-1)*24+1:d*24;
            y=X{d}.X(i,:,:);
            y = reshape(y,[size(y,2) size(y,3)])';
            %y = bsxfun(@rdivide,y,max(y));
            
            y = mean(y,2);
            y = y(1:24);
            plot(x,y+3,'m','LineWidth',2);hold on;        
        end        
        ylim([-0.1 4.1]);
        hold off;
        
       ch = getkey;
       if(label==1)
         ov(i) = ch; 
       end
       
       if(ch==(48+9))
         save_path = 'C:\Users\45c\Desktop\Eval\';
         display('saving...')
         %F = getframe(h1);
         %imwrite(F.cdata,[save_path   sprintf('ov_%s_%03d',Culture,i) '.png']);
         %print([save_path   sprintf('ov_%s_%03d',Culture,i)],'-dpng' )
       end
    end
end

if (label==1)
    ov(ov==48)=0;
    ov(ov==49)=1;
    sum(ov)
    save([path Culture '_OV.mat'],'ov');
end
