
ROI = MIJ.getRoi(0);
ROIList{numel(ROIList)+1}=ROI;

figure(roi_view)
rectangle('Position',[ROI(1,1),ROI(2,1),ROI(1,2)-ROI(1,1),ROI(2,3)-ROI(2,1)],...
           'Curvature',[0,0],'EdgeColor','b','LineWidth', 1,'LineStyle','-');
text(double(ROI(1,1)),double(ROI(2,1)),num2str(numel(ROIList)),'Color','g')