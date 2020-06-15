 close all;
    path = 'E:\Data\Data\';
    Culture = 'G09102014A';
    DIV = 'DIV28' ;
    
if(0)
   
    X = zeros(24,120,119);
    F = zeros(24,120);

    td = 50;

    for i=1:24
        a = load(sprintf('./temp/%s_%s/%s_%s_%d.mat',Culture,DIV,Culture,DIV,i));
        T = a.T;
        i
        for j=1:120
            e =1:120;
            e(j)=[];
            F(i,j) =  numel(T{j,e(1)}.perv);
            for k=1:119
                prev = T{j,e(k)}.perv/50;
                prev = prev(~isnan(prev));
                X(i,j,k)=sum(prev<td);
            end
        end
    end

    FF= bsxfun(@rdivide,F,max(F));
end


s = [1600 800];f1=figure('Position',[100 100 s],'color','w');

Z = GetElectrodeEvolve( [path Culture] ,DIV,'data_PatternCheck_2_250_paired_train_probe' );

opengl('software');
if(0)
    for i=1:120
        if(i==1)
    %         Y = X(:,i,:);
    %         Y = reshape(Y,[24 119]);
    %         YY = sum(Y,1);
    %         [~,I]=sort(YY,'descend');
    %         YY = Y(:,I);
    %         YY= bsxfun(@rdivide,Y,max(Y));
    %         
    %         for j=1:119
    %           plot([FF(:,i) YY(:,j)]);
    %           getkey;
    %         end
            y= Z(i,:,:);
            y = mean(reshape(y,[20 24])',2);
            y = y/max(y);
            plot(y,'m');hold on;
            Y = reshape(X(:,i,:),[24 119]);
            [~,I] = sort(sum(Y),'descend');
            Y = sum(FF(:,I(1:5)),2);
            y = sum(FF,2);y=y/max(y);
            YY= bsxfun(@rdivide,Y,max(Y));

            plot([FF(:,i) YY y],'LineWidth',2, 'LineSmoothing','on');
            hold off;
            getkey;
        end

    end
end

figure(f1)
if(1)    
    ii  = 1:1:120;
    ii  = [1 57 65];
    for i=ii
            x = ((1:1:24));
            YY = reshape(Z(i,:,:),[20 24])';
            
            if(0)%Bunch plot
                for j=1:20 
                    plot (x(1:12),YY(1:12,j),'k','LineWidth',1, 'LineSmoothing','on');hold on;
                    plot (x(13:24),YY(13:24,j),'k','LineWidth',1, 'LineSmoothing','on');hold on;
                end
                plot(x(1:12),FF(1:12,i),'b','LineWidth',4, 'LineSmoothing','on');hold on;
                plot(x(13:24),FF(13:24,i),'b','LineWidth',4, 'LineSmoothing','on');hold off;
            end
            if(0) %Individual plot
                for j=1:20 
                    j
                    plot (x(1:12),YY(1:12,j),'k','LineWidth',1, 'LineSmoothing','on');hold on;
                    plot (x(13:24),YY(13:24,j),'k','LineWidth',1, 'LineSmoothing','on');hold on;
                    plot(x(1:12),FF(1:12,i),'b','LineWidth',4, 'LineSmoothing','on');hold on;
                    plot(x(13:24),FF(13:24,i),'b','LineWidth',4, 'LineSmoothing','on');hold off;
                    getkey;
                end
            end
            
            %clf(f1);
            
            if(1)%in two sets
                s1 = [];
                s2 = 1:1:20;s2(s1)=[];
                for j=s1 
                    plot (x(1:12),YY(1:12,j),'m','LineWidth',2, 'LineSmoothing','on');hold on;
                    plot (x(13:24),YY(13:24,j),'m','LineWidth',2, 'LineSmoothing','on');hold on;
                end
                for j=s2 
                    plot (x(1:12),YY(1:12,j),'k','LineWidth',2, 'LineSmoothing','on');hold on;
                    plot (x(13:24),YY(13:24,j),'k','LineWidth',2, 'LineSmoothing','on');hold on;
                end
                plot(x(1:12),FF(1:12,i),'b','LineWidth',4,'LineStyle','-.', 'LineSmoothing','on');hold on;
                plot(x(13:24),FF(13:24,i),'b','LineWidth',4,'LineStyle','-.', 'LineSmoothing','on');hold off;
            end
            
            set(gca,'FontName','Calibiri','FontSize',16, 'FontWeight', 'demi');
            xlabel('Time(hr)');ylabel('Probability of Spike');
            
            xt=x(3:3:end);
            xtl=xt/3;
            set(gca,'XTick',xt,'XTickLabel',xtl);
            
           
            P = get(gca,'tightinset');
            set(gca,'position',[P(1) P(2) 1-P(1)-P(3) 1-P(2)-P(4)]);
            
            s=getkey;
            if(s==char('s'))
                A = getframe(f1);
                imwrite(A.cdata,sprintf('spont_%s_%s_E%d.png',Culture,DIV,i));                
            end
    end
end