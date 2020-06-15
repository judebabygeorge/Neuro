
setup_paths

global Select_Headstage
Select_Headstage = 1;


fr = create_datastream('C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\Z02022016B\DIV21\data_CheckAllElectrodes.dat');


Frame_stop = fr.Frames ;
%Frame_stop = 17;


DS = DAQSysPlayBack([],0,'',1);

Frame = 1;
for Frame=1:Frame_stop
    [Data, SpikeEncoded, StimTrigger, Output] = get_stream(fr,Frame);
    DS.DataAvailable(Data, StimTrigger)
    pause(0.3)
    drawnow
end