
[Patterns , PatternConfig ]= EditPatterns(PatternData);
P = ones(size(Patterns));
P(isnan(Patterns)) = 0;
P = mean(P,3);


E = PatternData.StimConfig.Patterns;
Ex= PatternData.StimConfig.Electrodes(1,1:8);
Eid =zeros(120,1);
for i=1:numel(Ex)
    Eid(Ex(i))=i;
end
for i=2:2:112
    p = E(1,i);
    E(1,i)=Eid(PatternData.StimConfig.Electrodes(1,p));
    E(2,i)=Eid(PatternData.StimConfig.Electrodes(2,p));
end

if (1)
    Stat = zeros(3,28);
    k = 1;
    for A  =1:7;
        for B = (A+1):8;

            y = find( (E(1,:)==A) & (E(2,:)==B));

            SelectedPatterns = ((y(1)-1)) + [1 2 4 3] ;
            SelectedPatterns = [SelectedPatterns (112 + [A B])];

            Q = P(:,SelectedPatterns);

            if(1)
                y =  (Q(:,5) + Q(:,6));
                y(y>1)=1;        
                R = bsxfun(@minus,Q(:, [1 2 3 4]) ,y);
                Z = (abs(R) > 0.5);
                Z = (R > 0.5);
            end
            if(0)
                y =  min([Q(:,5)' ; Q(:,6)'])';
                R = bsxfun(@minus,Q(:, [1 2 3 4]) ,y);
                Z = (R < -0.5);
            end 

            Stat(:,k) = [A B sum(sum(Z))]';
            k = k + 1;
        end
    end

    [~,I] = max(Stat(3,:));
    A = Stat(1,I);B=Stat(2,I);

    y = find( (E(1,:)==A) & (E(2,:)==B));
    SelectedPatterns = ((y(1)-1)) + [1 2 4 3] ;
    SelectedPatterns = [SelectedPatterns (112 + [A B])];
    Q = P(:,SelectedPatterns);
    if(1)
        y =  (Q(:,5) + Q(:,6));
        y(y>1)=1;        
        R = bsxfun(@minus,Q(:, [1 2 3 4]) ,y);
        Z = (abs(R) > 0.5);
        %Z = (R > -0.5);
    end
    if(0)
        y =  min([Q(:,5)' ; Q(:,6)'])';
        R = bsxfun(@minus,Q(:, [1 2 3 4]) ,y);
        Z = (R < -0.5);
    end

    I = find(sum(Z,2)>0);


    close all
    figure('Position',[100 100 1600 400])
    txt = {'A B 3ms' , 'A B 0.5ms' , 'B A 0.5ms' , 'B A 3ms' , 'A' , 'B' };
    %for j=1:numel(I)
    %for j=[12]
    for j=[12 25]
        j
    
        for i=1:6
            h = subplot(1,6,i);
            p = get(h, 'pos');
            p(1) = 0.1 + (0.8/6)*(i-1);
            p(3) = (0.8/6);
            set(h,'pos',p);

            yy = Patterns(I(j),SelectedPatterns(i),:);
            yy = yy(:)/50;
            hist(yy,0:5:50);
            xlim([0 55])
            ylim([0 40])
            text(15,30,sprintf('%s , P = %1.1f',txt{i},Q(I(j),i)),'FontName','Cambria','FontSize',14,'FontWeight','bold');
            if(i ~= 1)
                set(gca,'YTickLabel',[]);
            else
                ylabel('n','FontName','Cambria','FontSize',14,'FontWeight','bold');
            end
             set(gca,'XTick',0:10:50);
             xlabel('time(ms)','FontName','Cambria','FontSize',14,'FontWeight','bold')
             set(gca,'FontName','Cambria','FontSize',14,'FontWeight','bold');
        end
%         key = getkey;
%         if key == uint8('q')
%             break;
%         end
    end
end

if(0)
    
    Ec = E(:,1:2:112);
    Es = 4;
    Et = 1:1:8; Et(Es) = [];
    
    SelectedPatterns = zeros(1,Et*2);
    for i=1:numel(Et)
        SelectedPatterns(2*i-1) = find(Ec(1,:)==Es & Ec(2,:)==Et(i));
        SelectedPatterns(2*i)   = find(Ec(2,:)==Es & Ec(1,:)==Et(i));
    end
    SelectedPatterns = SelectedPatterns*2-1;
    SelectedPatterns = reshape(SelectedPatterns,[2,numel(SelectedPatterns)/2]) ; 
    SelectedPatterns = [SelectedPatterns;SelectedPatterns+1];
    SelectedPatterns = SelectedPatterns([1 3 4 2],:);
    
    h = PatternView ;
    hO  = guidata(h);

    for i=1:size(E1,2)
      if(E1(2,i)==0)
          E1(2,i)=E1(1,i);
      end
    end

    for i=1:6    
        for j=1:4
        Vis = P(:,SelectedPatterns(j,i));    
        Act  = ones(size(Vis))*0;   
        Mark = zeros(size(Act));
        %Mark(E1(:,i)) = 1;
        hO.ShowElectrodeActivity(hO,(j-1)*8+i,[Act Vis], Mark);
        end
    end
end