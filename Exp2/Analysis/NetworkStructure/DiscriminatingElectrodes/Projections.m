if(0)
SelectedPatterns = 2:2:112;
FDR = FischerDiscriminatRatio(Patterns(:,SelectedPatterns,:));
[~,I] = sort(FDR,'descend');


Pairs = zeros(2,56);
idx=0;
for i=1:7
    for j=i+1:8
        idx = idx + 1;
        Pairs(1,idx) = i;
        Pairs(2,idx)=j;
        idx = idx + 1;
        Pairs(1,idx) = j;
        Pairs(2,idx)=i;
    end
end

close all


h1 = figure('Position',[100 500 300 300]);
h2 = figure('Position',[700 500 300 300]);
sum(FDR>1)
for j=1:40
    j
    SelectedElectrodes = (3*(j-1)+1):(3*j);
    Q = P(I(SelectedElectrodes),:);




    figure(h1);
    clf(h1);
    hold on;

    cl = ['bgrcymkb'];
    for i=1:7
        SelectedPatterns1 = SelectedPatterns(Pairs(1,:)==i);
        scatter3(Q(1,SelectedPatterns1),Q(2,SelectedPatterns1),Q(3,SelectedPatterns1),50*ones(1,numel(SelectedPatterns1)),cl(i),'filled')
    end
    axis square
    view(45,60)
    
    figure(h2);clf(h2);
    scatter3(Q(1,SelectedPatterns),Q(2,SelectedPatterns),Q(3,SelectedPatterns),'filled')
    view(45,60)
    axis square
    getkey;
end
end
if(1)
    Electrodes = [1 2 3;4 5 6];
   
    c2 =  [1 1 0 ; 1 0 1 ; 0 1 1 ;1 0 0;0 1 0;0 0 1;0 0 0];
    h= zeros(size(Electrodes,1));
    for k=1:size(Electrodes,1)
        h(k) = figure('Position',[100 500 300 300]);
    end
    
    Q=Ps(I(Electrodes(1,:)),:);
    
    Q = (Q(1,:) < 0.5) & (Q(2,:) > 0.5) & (Q(3,:) > 0.5) ;
    y = find(Q==1);
    
    FDR = FischerDiscriminatRatio(Patterns(:,2:2:112,:));
    Ps = mean(Patterns(:,2:2:112,:),3);
    [~,I] = sort(FDR,'descend');
    
    for  k=1:size(Electrodes,1)
        figure(h(k));
        Q=Ps(I(Electrodes(k,:)),:);
        scatter3(Q(1,:),Q(2,:),Q(3,:),100,[0.7 0.7 0.7],'filled');hold on

        for i= 1:min(7,numel(y))
             %text(Q(1,y(i)),Q(2,y(i)),Q(3,y(i)),num2str(i),'FontWeight','bold')
             scatter3(Q(1,y(i)),Q(2,y(i)),Q(3,y(i)),200,c2(i,:),'MarkerFaceColor',c2(i,:));
        end

        grid off

        %axis off
        %view(45,60)
        axis square
        l = 2;
        c = [0.5 0.5 0.5];
        hold on;
        line([0 1]',[0 0]',[0 0]','Color',c,'LineWidth',l);
        line([0 1]',[1 1]',[0 0]','Color',c,'LineWidth',l);
        line([1 1]',[0 1]',[0 0]','Color',c,'LineWidth',l);
        line([0 0]',[0 1]',[0 0]','Color',c,'LineWidth',l);

        line([0 1]',[0 0]',[1 1]','Color',c,'LineWidth',l);
        line([0 1]',[1 1]',[1 1]','Color',c,'LineWidth',l);
        line([1 1]',[0 1]',[1 1]','Color',c,'LineWidth',l);
        line([0 0]',[0 1]',[1 1]','Color',c,'LineWidth',l);

        line([0 0]',[0 0]',[0 1]','Color',c,'LineWidth',l);
        line([0 0]',[1 1]',[0 1]','Color',c,'LineWidth',l);
        line([1 1]',[0 0]',[0 1]','Color',c,'LineWidth',l);
        line([1 1]',[1 1]',[0 1]','Color',c,'LineWidth',l);
        xlabel(['E' num2str(Electrodes(k,1))]);
        ylabel(['E' num2str(Electrodes(k,2))]);
        zlabel(['E' num2str(Electrodes(k,3))]);
        set(gca,'XTick',[0 1],'YTick',[0 1],'ZTick',[0 1],'FontWeight','Bold');
    end
end