function ClassificationUsingDiscrimantScores()

C = {};
C{1}.Culture = 'Z23042015A';
C{1}.DIV     = [13 14 15 20 21 40 41];
C{1}.DIV     = [13 14 15 20 21];

C{2}.Culture = 'Z23042015B';
C{2}.DIV     = [16 17 18 19];

C{3}.Culture = 'Z23042015C';
C{3}.DIV     = [17 18];

if(1)
    for j=1:numel(C)
         for i=1:numel(C{j}.DIV)
            path = sprintf('C:\\Users\\45c\\Documents\\MATLAB\\MCS_daq\\Exp\\Exp2\\Data\\%s\\DIV%d',C{j}.Culture,C{j}.DIV(i));    
            Patterns = LoadPattern(path);
            P = mean(Patterns,3);
            
            err    = zeros(56,2);
            DScores = zeros(120,2);
            for k=1:2
                SelectedPatterns = k:2:112;
                %Scores = DiscriminantScores(P,SelectedPatterns);
                %S = mean(Scores,2);
                
                S = FischerDiscriminatRatio(Patterns(:,SelectedPatterns,:));                
                DScores(:,k)=S;
                
                %S = (S>1);
                S = (S>1);
                sprintf('Discriminating Electrodes : %d' , sum(S)) 
                
                [emin, Wmin] = CheckClassifiability(Patterns(S,:,:),SelectedPatterns,ones(sum(S)+1,numel(SelectedPatterns)));
                err(:,k)= emin;
            end
            save(sprintf('%s\\FDRDiscriminantClassification.mat',path),'err','DScores')            
         end
    end
end
end
