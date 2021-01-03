

E=GetElectrodeNumber(PatternData.ImageData.ElectrodeUnderView,ChannelMapping);
ROI = MIJ.getRoi(0);
data_window = 900*50 ; 
for i=1:16
  close all;
  Data  = get_stream(file,PatternData.FrameNumber(i));
  figure;
  y = Data(E,PatternData.MarkTime(i):PatternData.MarkTime(i)+data_window);
  y = 5*(y/100);
  plot((1:numel(y))*20e-3,y);hold on;
  [m , n] =  ind2sub([4 4],i);
  z = PatternData.ImageData.Cam1((ROI(2,1):ROI(2,3))+(m-1)*128,(ROI(1,1):ROI(1,2))+(n-1)*128,:);
  z = mean(mean(z));
  z = z(:);
  l = round(numel(z)/2);
  baseline = mean(z((l-10):(l+10)));
  z = 100*(z - baseline)/baseline ;
  z(z>5)=0;z(z<-5)=-0;
  plot((1:numel(z))*10,z,'g','LineWidth',3);
  getkey;
end