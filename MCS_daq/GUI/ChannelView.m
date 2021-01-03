function varargout = ChannelView(varargin)
% CHANNELVIEW MATLAB code for ChannelView.fig
%      CHANNELVIEW, by itself, creates a new CHANNELVIEW or raises the existing
%      singleton*.
%
%      H = CHANNELVIEW returns the handle to a new CHANNELVIEW or the handle to
%      the existing singleton*.
%
%      CHANNELVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHANNELVIEW.M with the given input arguments.
%
%      CHANNELVIEW('Property','Value',...) creates a new CHANNELVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ChannelView_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ChannelView_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ChannelView

% Last Modified by GUIDE v2.5 08-Jan-2013 13:57:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ChannelView_OpeningFcn, ...
                   'gui_OutputFcn',  @ChannelView_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ChannelView is made visible.
function ChannelView_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ChannelView (see VARARGIN)

% Choose default command line output for ChannelView

handles.output = hObject;
P = get(hObject,'Position');
P(1:2) = [175 100];
set(hObject,'Position',P);

handles.DrawWaveForms = @DrawWaveForms;
handles.DrawSpikeSegments = @DrawSpikeSegments;
handles.MarkSpikeTimes    = @MarkSpikeTimes;

global Select_Headstage

if Select_Headstage == 1
    a = load('ChannelMap.mat') ;
else
    a = load('ChannelMapMEA60.mat') ;
end

handles.ChannelMapping     = a.ChannelMapping;
handles.ChannelsToDraw = handles.ChannelMapping.nCh ;

%Setup the initial display

figure(hObject)

handles.Scale = [-1000 1000]*0.25*.25 ; 
for i=1:handles.ChannelMapping.nCh
  ChId = (handles.ChannelMapping.row(i) - 1)*handles.ChannelMapping.nCols + handles.ChannelMapping.col(i);
  h =subaxis(handles.ChannelMapping.nRows,handles.ChannelMapping.nCols,ChId,'Spacing',0,'Margin',0,'Padding',0); 
  handles.ChAxes{i}.ha = h;
  
   
  hl =  line(ones(3,10),ones(3,10),'Visible','off');
  handles.ChAxes{i}.hl = hl ; 
  handles.ChAxes{i}.LineId = 1;
  
  if(1)
   hold(h,'on')
   hS = scatter(0.5,handles.Scale(2)*0.5,10,'filled','r','Visible','off');
   handles.ChAxes{i}.hS = hS ;    
   set(h,'Children',[hS;hl]); 
   hold(h,'off')
  else
   set(h,'Children',hl); 
  end
  
  set(h,'XTick',[]);
  set(h,'YTick',[]);
  set(h,'YLimMode','Manual','XLim',[0 1],'YLim', handles.Scale);
  handles.ChAxes{i}.ht = text(0.05,handles.Scale(2)*0.75,handles.ChannelMapping.Map(i).label,'FontWeight','bold','FontSize',8);
  
  
  %,'Visible','off'
  %set(h,'YLimMode','Manual','XLim',[0 1],'YLim', [-10 240]);
end

uicontrol('Style', 'pushbutton', 'String', 'Up',...
        'Position', [20 100 40 50],...
        'Callback', @cmdScaleUp_Callback); 
uicontrol('Style', 'pushbutton', 'String', 'Down',...
        'Position', [20 50  40 50],...
        'Callback', @cmdScaleDown_Callback); 

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ChannelView wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function cmdScaleUp_Callback(hObject, eventdata)
handles = guidata(hObject);
handles.Scale = handles.Scale*2 ;
 for i=1:handles.ChannelMapping.nCh
  h =handles.ChAxes{i}.ha ;
  set(h,'YLimMode','Manual','XLim',[0 1],'YLim', handles.Scale);  
  set(handles.ChAxes{i}.ht,'Position',[0.05 handles.Scale(2)*0.75]);
 end
guidata(hObject, handles);

function cmdScaleDown_Callback(hObject, eventdata)
handles = guidata(hObject);
handles.Scale = handles.Scale/2 ;
 for i=1:handles.ChannelMapping.nCh
  h =handles.ChAxes{i}.ha ;
  set(h,'YLimMode','Manual','XLim',[0 1],'YLim', handles.Scale);
  set(handles.ChAxes{i}.ht,'Position',[0.05 handles.Scale(2)*0.75]);
 end
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = ChannelView_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function DrawSpikeSegments(Segments,Count,handles)
 nChannels = size(Count,1);
 idx      = 1 ;
 
 SegmentLen = size(Segments,1) ;
 t = (1:1:SegmentLen)./SegmentLen ;
 
 for Chid = 1:nChannels
     %h = handles.ChAxes(Chid);
              
   for j=1:Count(Chid)     
       
     hl = handles.ChAxes{Chid}.hl(handles.ChAxes{Chid}.LineId); 
     handles.ChAxes{Chid}.LineId = handles.ChAxes{Chid}.LineId + 1 ;
     if(handles.ChAxes{Chid}.LineId > numel(handles.ChAxes{Chid}.hl))
         handles.ChAxes{Chid}.LineId = 1 ;
     end
     
     %Possible SpeedUp No need to set this all time
     set(hl,'XData',t,'YData',Segments(:,idx),'Visible','on')
     %plot(h,t,Segments(:,idx));
     idx = idx + 1 ;
   end
    % hold(h, 'off') ;
 end

function MarkSpikeTimes(handles,spike_times,spikeCounts)
    
  Channels = size(spikeCounts,1);
  id = 1 ;
  for i=1:Channels
      x = spike_times(id:(id+spikeCounts(i)-1))/50000;
      y = ones(size(x))*0.5*handles.Scale(2)      ;
      id = id + spikeCounts(i);     
      
      hS = handles.ChAxes{i}.hS;
      set(hS,'XData',x,'YData',y,'Visible','on');     
%     set(h,'XTick',[]);
%     set(h,'YTick',[]);
 
  end
  

       

function DrawWaveForms(Y,handles,dowsample,Thresholds)
  Channels = size(Y,2);
  samples  = size(Y,1);
  
  ChannelsToDraw = handles.ChannelsToDraw ;
  
  idx      = 1:dowsample:samples ;
  t        = idx./samples;
  
  if(Channels > ChannelsToDraw)
      Channels = ChannelsToDraw ;
  end
  
  
  for Chid=1:Channels                
      
      hl = handles.ChAxes{Chid}.hl(1); 
       h = handles.ChAxes{Chid}.ha;
      %Possible SpeedUp No need to set this all time
      set(hl,'XData',t,'YData',Y(idx,Chid),'Visible','on');
      
      hl = handles.ChAxes{Chid}.hl(2); 
      set(hl,'XData',[t(1) t(end)],'YData',Thresholds(Chid)*[1 1],'Visible','on');
      hl = handles.ChAxes{Chid}.hl(3); 
      set(hl,'XData',[t(1) t(end)],'YData',-Thresholds(Chid)*[1 1],'Visible','on');
      
      %plot(h,t,Y(Chid,idx));
      %xlim(h,[0 1]) ;
      %ylim(h,[-1 1]*5000) ;
       set(h,'XTick',[]);
       set(h,'YTick',[]);
  end
