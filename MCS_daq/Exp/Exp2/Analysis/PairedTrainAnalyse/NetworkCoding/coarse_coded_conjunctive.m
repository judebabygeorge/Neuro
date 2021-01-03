
if (1)
    SelectedPatterns = 1:1:120;

    Y = PatternData.Pattern(:,SelectedPatterns,:);
    P = ones(size(Y));
    P(isnan(Y))=0;
    P = mean(P,3);


    P1 = PatternData.StimConfig.Patterns(1,1:2:112);

    Selected = zeros(1,8*7);

    K = 1:2:112;
    for i=1:8
     Selected(((i-1)*7+1):i*7) =  K(P1(1,:)==i);
    end

    Q=P;
    Q(PatternData.StimConfig.Electrodes(1,1:8),:)=[];
    Z=Q(:,[Selected+1 113:120]);
    imshow(Z)
end

if(0)
    
xx = [];
yy = [];
    close all    
    Eo = 15;
    d  = Q(Eo,:);
    d1 = reshape(d(1:56),[7 8]);
    d1 = [d1 zeros(7,8)];
    s = [1:8 ; 9:16];
    s= s(:);
    h1=bar3(d1(:,s),0.9);
    for i=2:2:16
        set(h1(i),'facecolor','white');
        set(h1(i),'edgecolor','white');
    end
    str = ['ABCDEFGH']     ;
    idx = 0;
    for i=1:8
        t = 1:1:8;
        t(i)=[];
        for j=1:7
            idx=idx+1;
            xx(idx)=i;
            yy(idx)=t(j);
            txt = [str(i) str(t(j))];
            text(i*2-2.2,j,0.05,txt,'Rotation',10,'FontName','Cambria','FontSize',14,'FontWeight','bold')            
        end
    end
    set(gca,'XTickLabel',{})
    set(gca,'YTickLabel',{})
    xlim([-1 16])
    grid off
    set(gca,'visible','off');
end

figure;
scatter(xx,yy,d2(:)*500+0.001,'filled')
str = ['ABCDEFGH']     ;
idx = 0;
% for i=1:8
%     t = 1:1:8;
%     t(i)=[];
%     for j=1:7        
%         text(i+.2,t(j),str(i),'Rotation',0,'Color',[0.8,0,0],'FontName','Cambria','FontSize',14,'FontWeight','bold')  
%         text(i+.37,t(j),str(t(j)),'Rotation',0,'Color','k','FontName','Cambria','FontSize',14,'FontWeight','bold')  
%     end
% end
for i=1:8
    text(i-0.2,9,str(i),'Rotation',0,'Color',[0,0,0],'FontName','Cambria','FontSize',14,'FontWeight','bold')
    text(0-0.2,i,str(i),'Rotation',0,'Color',[0,0,0],'FontName','Cambria','FontSize',14,'FontWeight','bold')
end
set(gca,'XTickLabel',{'','A','B','C','D','E','F','G','H',''})
set(gca,'YTickLabel',{'','A','B','C','D','E','F','G','H',''})
set(gca,'XTickLabel',{})
set(gca,'YTickLabel',{})
axis square
grid on
set(gca,'YDir','reverse')
set(gca,'YTick',-1.5:1:9.5)
ylim([-1.5 10])
set(gca,'XTick',-1.5:1:9.5)
xlim([-.5 10])

%xlabel('Context')
%ylabel('Stimuli')