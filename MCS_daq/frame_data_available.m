
function  frame_data_available(sender,~)    
tic
  display(['FrameID : ' num2str(sender.FrameCount) ' NumberofFrames :' num2str(sender.frames_read)]);
  Y = reshape(int32(sender.data),sender.Channels,sender.frames_read) ;
  size(Y)  
toc
end