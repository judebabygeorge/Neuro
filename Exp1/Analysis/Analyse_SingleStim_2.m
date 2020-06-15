
stream = create_datastream(PatternData.src_filename);

%% Show Frames of activity on stimulation

Probability = 0.8;
nEl         = 6  ; 
a = mean(PFiring,3);
a(a<Probability) = 0;
%a = a(a>0.5);
a = sum(a) ;


%Show the mean of electrodes which show significant activity
I = find(a>nEl) ;
%Sort I in decreasing order of acivity
ft = a(I) ;
[~,I2] = sort(ft,'descend');
I = I(I2);

i = 6 ;
j = 3 ;
FrameId = FrameNumber(1,I(i),j) ;
ShowFrame(stream,FrameId,PFiring(:,I(i),j),Pattern(:,I(i),j))

