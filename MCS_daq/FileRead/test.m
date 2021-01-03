
%filename = 'F:\G09042013A\DIV38\data_PatternCheck_2_250_two_time_seq3.dat';
%file = create_datastream(filename);

%scale = 0.29802;
%Fstop = 60     ;
%filename = 'D:\MATLAB_Data\data_ch_' ;

% D = zeros(50000*Fstop,1);
% for i=1:120
%     display(['Writing Channel ' num2str(i)])    
%     for j=1:Fstop
%       [Data SpikeEncoded StimTrigger Output] = get_stream(file,j);
%       D(((j-1)*50000+1):j*50000) = (Data(i,:)*scale)' ;
%     end
%      csvwrite( [filename num2str(i) '.txt'] ,D);
% end

fr = PatternData.FrameNumber(1,29,:);
Z = zeros(50000,45);
Eid = 11;
for i=1:45
 [Data SpikeEncoded StimTrigger Output] = get_stream(file,fr(i));
 Z(:,i) = Data(Eid,:)';
end
plot(Z);