
%% Show Frames of activity on stimulation

stream = create_datastream(PatternData.src_filename);

PFiring = ones(size(PatternData.Pattern));
PFiring(isnan(PatternData.Pattern)) = 0;
Probability = 0;
a = mean(PFiring,3);
a(a<Probability) = 0;
a = sum(a) ;
[~,I] = sort(a,'descend');

nSamples = size(PatternData.Pattern,3) ;
Samples = randperm(nSamples);



% figure ;
% for i=1:5
%     for j=1:3
%       clf;
%       [i j]
%       FrameId = PatternData.FrameNumber(1,I(i),Samples(j)) ;
%       ShowFrame(stream,FrameId,PFiring(:,I(i),Samples(j)),PatternData.Pattern(:,I(i),Samples(j)),2000);
%       while(1)
%         w = waitforbuttonpress;
%         if(w~=0)
%             break;
%         end
%       end
%     end
% end
% i=3;j=1;
% FrameId = PatternData.FrameNumber(1,I(i),Samples(j)) ;
% ShowFrame(stream,FrameId,PFiring(:,I(i),Samples(j)),PatternData.Pattern(:,I(i),Samples(j)),2000);

%I = 1:1:size(PatternData.Pattern,2);
%i = 3 ;

figure;
for i=1:numel(I)
for j=1:nSamples
    clf;
    FrameId = PatternData.FrameNumber(1,I(i),Samples(j)) ;
    ShowFrame(stream,FrameId,PFiring(:,I(i),Samples(j)),PatternData.Pattern(:,I(i),Samples(j)),2000);
      while(1)
        w = waitforbuttonpress;
        if(w~=0)
            break;
        end
      end
end
end