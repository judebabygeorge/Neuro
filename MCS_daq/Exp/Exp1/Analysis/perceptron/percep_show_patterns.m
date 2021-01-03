

% 
% %SelectedPatterns = [1 2 3 4 5 6 7 8];
% SelectedPatterns = [1 2 3 4];
% SelectedPatterns = 1 + (SelectedPatterns - 1)*4;
% %SelectedPatterns = [1 9 13 17];
% SelectedPatterns = [SelectedPatterns;(SelectedPatterns+2)];
% SelectedPatterns = [SelectedPatterns;(SelectedPatterns+1)];
% SelectedPatterns = SelectedPatterns([1 2 4 3],:);
% %SelectedPatterns = (1:1:32)*2;
% 
% SelectedPatterns = [SelectedPatterns'; (112 + [1 2 3 4])]';
h = PatternView ;
hO  = guidata(h);


% SelectedPatterns = (1:1:56)*2;
% SelectedPatterns = SelectedPatterns(1:min(32,numel(SelectedPatterns)));
% SelectedPatterns = reshape(SelectedPatterns,[4 8]);

 SelectedPatterns = (1:1:56);
 %SelectedPatterns = (1:1:24);
 SelectedPatterns = SelectedPatterns(1:min(32,numel(SelectedPatterns))); 
 SelectedPatterns = reshape(SelectedPatterns,[4 8]);

%  vidObj = VideoWriter('patterns.avi');
%  vidObj.FrameRate = 3;
%  open(vidObj);
    


% for sample = 1:4
%     for t = 50:50:25*50

        X = ones(size(PatternData.Pattern ));
        X(isnan(PatternData.Pattern)) = 0 ;
        Pf = mean(X,3);
        
%         X = PatternData.Pattern(:,:,sample) ;
%         X(isnan(X)) = 5000 ;
%         X(X>t) = 5000 ;
        %X(X<(t-50)) = 5000;
        
%         Pf = X ;
%         Pf(Pf<5000) = 1 ;
%         Pf(Pf > 1) = 0;
        
        %Pf = mean(X,3);
        %Pf(Pf<.7)=0;



    for i = 1:size(SelectedPatterns,1)  % Pair    
        for j=1:size(SelectedPatterns,2)
        id = SelectedPatterns(i,j);
        if(1)

            Vis  = Pf(:,id);
            Act  = ones(size(Vis))*0;
        else
            Vis  = Pf(:,id);
            Act = ones(size(Vis)) ;
            Act(Act>1) = 1 ;
            Act(Act<0) = 0 ;
            Act  = 1- Act  ;
        end
        Mark = zeros(size(Act));

        id = (i-1)*8 + j ;
        hO.ShowElectrodeActivity(hO,id,[Act Vis], Mark);
        end
    end
    
%     myaa
%     I=getframe(gcf);
%     writeVideo(vidObj,I);
%     close(gcf)
%     
%     pause(0.3)
%     end
% end

%  close(vidObj);