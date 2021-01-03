

fr  = create_datastream(PatternData.src_filename);
frame = PatternData.FrameNumber(1,1,1);

[Data, ~, ~, ~] = get_stream(fr,frame);

t = PatternData.MarkTime(1,1,3);
y = Data(I(1),t:t+50*200);
figure;plot(y)