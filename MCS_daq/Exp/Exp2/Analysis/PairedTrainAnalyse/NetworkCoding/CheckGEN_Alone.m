
function erra = CheckGEN_Alone(path)
%path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\Z23042015A\DIV21';
a = load(sprintf('%s/data_PatternCheck_2_250_two_time_seq4_1.mat',path));
PatternData = a.PatternData;
%RandomShuffle;
if(1)
%load('RealData.mat');
%st = 1;

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



[Patterns , PatternConfig ]= EditPatterns(PatternData);
P = ones(size(Patterns));
P(isnan(Patterns)) = 0;


st = 1;
SelectedPatterns = st:2:112;
     
        nClasses = 8;
        %SelectedPatterns = 1:1:56;
        E1 = E(:,SelectedPatterns);

     
        t = zeros(nClasses,numel(SelectedPatterns),size(P,3));

        for k=1:nClasses
          t(k,E1(1,:)==k,:)=1;
        end
        
        t = reshape(t,[size(t,1) size(t,2)*size(t,3)]);

        C = ones(121,nClasses);
        [emin, W] = CheckClassifiability_2(PatternData,SelectedPatterns,t,C);
end
if(1)
        Y = P(:,113:120,:) ;
        x  = ones([size(Y,1)+1 size(Y,2)*size(Y,3)]);
        x(1:size(Y,1),:,:)  = reshape(Y,[size(Y,1) size(Y,2)*size(Y,3)]);
        O = W'*x ;
        err = zeros(8,1);
        O = reshape(O,[size(O,1) size(Y,2) size(Y,3)]);
        Sel = zeros(size(Y,2) ,  size(Y,3));
        for l=1:size(O,2)
            for k=1:size(O,3)
                [~,I]=max(O(:,l,k));
                Sel(l,k)=I;
                if(I ~= l)
                    err(l) = err(l) + 1;
                end
            end
        end
        err
        erra=sum((err/45)>0.2)
 end
    
