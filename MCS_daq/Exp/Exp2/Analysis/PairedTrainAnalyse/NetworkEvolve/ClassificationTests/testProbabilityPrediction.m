
function Err = testProbabilityPrediction
    Culture = 'G09102014C';
    dDIV = {'DIV36','DIV37','DIV38','DIV39'} ;

    j     = 3;
    DIV   = dDIV{j};

%     a = load(sprintf('%s_%s_statechange.mat',Culture,DIV));
%     P = PredictProbability(a.X,a.Y);
%     P(P<0)=0;
%     P(P>1)=1;

    path = 'E:\Data\Data\';
    probe_file_tag = 'data_PatternCheck_2_250_paired_train_probe';

    path0 = [[path Culture] '\' DIV '\'];
    paired_probes = dir([path0 '\' probe_file_tag '*.mat']);

    SelectedPatterns = 1:1:20;
    C = ones(121,numel(SelectedPatterns));
    
    Wmin = zeros(121,20);
    Err  = zeros(24,3);
    Emin = zeros(20,2,24);
    tim = tic;
    f = sprintf('\\%s_%d.mat',probe_file_tag,1);
    f = [path0  f];        
    a = load(f); 
    Px.StimConfig=a.PatternData.StimConfig;        
    for i=1:numel(paired_probes)
            display(sprintf('DIV %s sequence %d',DIV,i));
                            
            
            e = GetClassificationAccuracy(path0,probe_file_tag,i,Wmin); %Accuracy Based On Previous Weight
            Err(i,1) = e;
            %Generate Some Data based on Predicted firing probability
%             Px.Pattern = bsxfun(@lt,rand(120,20,100),(P(:,:,i)))*10*50;
%             
%             [emin, Wmin] = CheckClassifiability(Px,SelectedPatterns,C);           
%             Emin(:,1,i)=emin;
%             e = GetClassificationAccuracy(path0,probe_file_tag,i,Wmin); %Accuracy Based On Estimated Weight
%             Err(i,2) = e;
            
            f = sprintf('\\%s_%d.mat',probe_file_tag,i);
            f = [path0  f];        
            a = load(f); 
            [emin, Wmin] = CheckClassifiability(a.PatternData,SelectedPatterns,C); %Accuracy Based On Current Weight
            Emin(:,2,i)=emin;
            e = GetClassificationAccuracy(path0,probe_file_tag,i,Wmin); %Accuracy Based On Current Weight
            Err(i,3) = e;            
            Err(1:i,:)
            
            PrintETA (tim,i,numel(paired_probes))
     end
        
end

function e = GetClassificationAccuracy(path0,probe_file_tag,i,Wmin)
        f = sprintf('\\%s_%d.mat',probe_file_tag,i);
        f = [path0  f];
        a = load(f); 
        [Patterns , ~ ]= EditPatterns(a.PatternData);
        SelectedPatterns = 1:1:size(Patterns,2);
        P = ones(size(Patterns));
        P(isnan(Patterns)) = 0;
        Y = ones(size(Patterns,1)+1,size(Patterns,2),size(Patterns,3));
        Y(1:120,:,:) = P;
        Y = reshape(Y,[size(Y,1) size(Y,2)*size(Y,3)]);
        
        nClasses = numel(SelectedPatterns);
        t = zeros(nClasses,(size(Y,2)*size(Y,3)));   
        for k=1:nClasses
            t(k,k:size(P,2):end)=1  ;
        end
        O = Wmin'*Y;
        
        
        %% Implement Winner-Take-All
        OO = zeros(size(O));        
        for i=1:size(O,2)
           for k=1:8     
           [~,I] = max(O(:,i));  
           OO(I,i)=1;
           O(I,i)= -Inf;
           end 
        end
        O = OO;

        O = O>0;
        %% Classification Accuracy
        
        O = sum(O.*t) ;
   
        O = reshape(O,[size(Patterns,2) size(Patterns,3)]);
        
        O = sum(O,2)/48;
        
        
        e= sum(O>0.8);
end