
% Transitivity , Graded Association
function [erra,W] = CheckTransitivity()

path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\Z23042015B\DIV19';
a = load(sprintf('%s/data_PatternCheck_2_250_two_time_seq4_1.mat',path));
PatternData = a.PatternData;

%RandomShuffle;

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



s  = 1:2:112;
Er = [1:7 ; 2:8 ; zeros(1,7)];

E1 = E(:,s);

for i=1:7
    Er(3,i) =  find( E1(1,:) == Er(1,i) &  E1(2,:) == Er(2,i));
end

pcheck = s;
pcheck(Er(3,:)) = [];


        nClasses = 7;
        SelectedPatterns = s(Er(3,:))
        t = zeros(nClasses,numel(SelectedPatterns),size(PatternData.Pattern,3));

        for k=1:nClasses
          t(k,k,:)=1;
        end
        t = reshape(t,[size(t,1) size(t,2)*size(t,3)]);

        C = ones(121,nClasses);

        
        [emin, W] = CheckClassifiability_2(PatternData,SelectedPatterns,t,C);
        
        Y = P(:,pcheck,:) ;
        x  = ones([size(Y,1)+1 size(Y,2)*size(Y,3)]);
        x(1:size(Y,1),:,:)  = reshape(Y,[size(Y,1) size(Y,2)*size(Y,3)]);
        O = W'*x ;
        
        O = reshape(O,[size(O,1) size(Y,2) size(Y,3)]);
        Z = zeros(size(O,2) ,size(O,3));
        
        erra=zeros(size(Z,1),1)*nan;
        
        for l=1:size(O,2)
            for k=1:size(O,3)
                [~,I]=max(O(:,l,k));
                Z(l,k)=I;
            end
        end
        
        for i=1:numel(pcheck)
            erra(i)=sum(Z(i,:) ~= E(1,pcheck(i)));
        end
       
        100*sum(erra/size(Z,2) < 0.2)/size(Z,1)

end