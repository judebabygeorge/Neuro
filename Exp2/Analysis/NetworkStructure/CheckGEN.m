
if(0)
    if(1)
        %load('SimulatedData1.mat')
        %P = rand(120,64,45);P=bsxfun(@lt,P,O);
    else
        load('RealData.mat');
        st = 1;
        P = P(:,[st:4:112 (st+1):4:112 113:120]);
        O = P;
        P = rand(120,64,45);P=bsxfun(@lt,P,O);
    end

    RandomShuffle;
end
%P = rand(120,64,45);P=bsxfun(@lt,P,O);
E = Pair;

erra=zeros(8,7)*nan;


st=1;


for i=1:8

tg1 = 1:1:8;
tg1(i)=[];




    for j=1:numel(tg1)
    %for j=1:7
        
        tg = tg1(j);
        nClasses = 8;
        SelectedPatterns = 1:1:56;
        E1 = E(:,SelectedPatterns);

        pg = zeros(7,1);
        ll =1:8;
        ll(tg)=[];
        for l=1:numel(ll)
        for k=1:numel(SelectedPatterns)
          if ((E1(1,k)==ll(l))&&(E1(2,k)== tg))
              pg(l)=k;
          end
        end
        end
        pg(pg==0)=[];
        pcheck = SelectedPatterns(pg);
        SelectedPatterns(pg)=[];
        E1(:,pg)=[];

        t = zeros(nClasses,numel(SelectedPatterns),size(P,3));

        for k=1:nClasses
          t(k,E1(1,:)==k,:)=1;
        end
        t = reshape(t,[size(t,1) size(t,2)*size(t,3)]);

        C = ones(121,nClasses);
        % n=60;
        % for i=1:size(C,2)
        %   el = randperm(120);
        %   C(el(1:n),i)=0; 
        % end
        [emin, W] = CheckClassifiability_2(P,SelectedPatterns,t,C);
        Y = P(:,pcheck,:) ;
        x  = ones([size(Y,1)+1 size(Y,2)*size(Y,3)]);
        x(1:size(Y,1),:,:)  = reshape(Y,[size(Y,1) size(Y,2)*size(Y,3)]);
        O = W'*x ;
        err = zeros(7,1);
        O = reshape(O,[size(O,1) size(Y,2) size(Y,3)]);
        Sel = zeros(size(Y,2) ,  size(Y,3));
        for l=1:size(O,2)
            for k=1:size(O,3)
                [~,I]=max(O(:,l,k));
                Sel(l,k)=I;
                if(I ~= ll(l))
                    err(l) = err(l) + 1;
                end
            end
        end
        err
        erra(i,j)=sum((err/45)>0.2)
    end
end
