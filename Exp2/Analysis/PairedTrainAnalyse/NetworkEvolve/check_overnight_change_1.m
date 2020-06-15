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



h1 =  figure('Position',[100 100 1600 800],'color','w');

%ii = [1 3 15];
ii = 1:120;
for i=ii    
        figure(h1);
        i
        if(1) %Indepedantly
            for j=1:20
                for d=1:numel(DIV)
                    x = (((d-1)*24+1:d*24));                
                    y=X{d}.X(i,j,:);
                    y = y(:);
                    y = y(1:24);                   
                    plot(x,y,'k','LineWidth',2, 'LineSmoothing','on');
                    hold on;  
                end
                xlim([-1 numel(DIV)*24]);ylim([-0.1 1.1]);%hold off; getkey;
            end 
            hold off;
            ch = getkey;
            
            if(ch==49)
                for j=1:20
                    for d=1:numel(DIV)
                        x = (((d-1)*24+1:d*24));                
                        y=X{d}.X(i,j,:);
                        y = y(:);
                        y = y(1:24);                   
                        plot(x,y,'k','LineWidth',2, 'LineSmoothing','on');
                        hold on;  
                    end
                    xlim([-1 numel(DIV)*24]);ylim([-0.1 1.1]);hold off; getkey;
                end 
            end
            
        end
        
        if(0) %In blocks
            s1 = [];
            s2 = [];
            s3=1:1:20;
            s3([s1 s2])=[];
            %s3 = [3 4 9 11 16 18];
            for j=s1 
                for d=1:numel(DIV)
                    x = (((d-1)*25+1:d*25));   x=x(1:1:24);             
                    y=X{d}.X(i,j,:);
                    y = y(:);
                    y = y(1:24);                   
                    plot(x(1:12),y(1:12),'g','LineWidth',2, 'LineSmoothing','on'); hold on;  
                    plot(x(13:end),y(13:end),'g','LineWidth',2, 'LineSmoothing','on'); hold on; 
                end
            end  
            for j=s2 
                for d=1:numel(DIV)
                    x = (((d-1)*25+1:d*25)); x=x(1:1:24);               
                    y=X{d}.X(i,j,:);
                    y = y(:);
                    y = y(1:24);                   
                    plot(x(1:12),y(1:12),'m','LineWidth',2, 'LineSmoothing','on'); hold on;  
                    plot(x(13:end),y(13:end),'m','LineWidth',2, 'LineSmoothing','on'); hold on;  
                end
            end
            for j=s3
                for d=1:numel(DIV)
                    x = (((d-1)*25+1:d*25));  x=x(1:1:24);              
                    y=X{d}.X(i,j,:);
                    y = y(:);
                    y = y(1:24);                   
                    plot(x(1:12),y(1:12),'k','LineWidth',1, 'LineSmoothing','on'); hold on;  
                    plot(x(13:end),y(13:end),'k','LineWidth',1, 'LineSmoothing','on'); hold on;  
                end
            end
            xt = ((1:1:numel(DIV)*25));
            xt = reshape(xt,[25 numel(DIV)]);
            xt = xt(3:3:end,:);
            xt=xt(:);            
            
            xtl =xt(1:1:8)/3;
            %xtl=xtl(1:1:8);
            set(gca,'XTick',xt,'XTickLabel',xtl);

            xlim([0 (numel(DIV)*25+2)]); ylim([-0.1 1.1]);
            xlabel('Time(hr)');ylabel('Probability of Spike');
            
            hold off;
            P = get(gca,'tightinset');
            set(gca,'position',[P(1) P(2) 1-P(1)-P(3) 1-P(2)-P(4)]);
            set(gca,'FontName','Calibiri','FontSize',16, 'FontWeight', 'demi')

           ch = getkey;
           if(ch==(48+9))
             save_path = '';
             display('saving...')
             F = getframe(h1);
             imwrite(F.cdata,[save_path   sprintf('ov_%s_%03d',Culture,i) '.png']);
           end
        end
end


