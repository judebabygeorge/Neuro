function varargout = DecoderPerformance(varargin)
% DECODERPERFORMANCE MATLAB code for DecoderPerformance.fig
%      DECODERPERFORMANCE, by itself, creates a new DECODERPERFORMANCE or raises the existing
%      singleton*.
%
%      H = DECODERPERFORMANCE returns the handle to a new DECODERPERFORMANCE or the handle to
%      the existing singleton*.
%
%      DECODERPERFORMANCE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DECODERPERFORMANCE.M with the given input arguments.
%
%      DECODERPERFORMANCE('Property','Value',...) creates a new DECODERPERFORMANCE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DecoderPerformance_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DecoderPerformance_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DecoderPerformance

% Last Modified by GUIDE v2.5 01-Jun-2014 10:12:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DecoderPerformance_OpeningFcn, ...
                   'gui_OutputFcn',  @DecoderPerformance_OutputFcn, ...
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


% --- Executes just before DecoderPerformance is made visible.
function DecoderPerformance_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DecoderPerformance (see VARARGIN)

% Choose default command line output for DecoderPerformance
handles.output = hObject;

H = SetupPerformanceMatix(handles.output,[10 50*4],[31 32 52 54]);
handles.hPerformanceMatix=H;
H = SetupClassificationAccuracyTracker(handles.output,[20 50*4+40 + 20],[31 32 52 54]);
handles.AccuracyTracker=H;

handles.UpdateDecoderPerformance=@UpdateDecoderPerformance;
handles.SetupClassificationAccuracyTracker=@SetupClassificationAccuracyTracker;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DecoderPerformance wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DecoderPerformance_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function H = SetupPerformanceMatix(h,P,Patterns)

nDecoders = numel(Patterns);
%Create Matrix ForViewingData
w = 40;
H.nDecoders = nDecoders;
H.w = w;

for i=1:nDecoders    
   H.Patterns{i}.h = uicontrol('Parent',h,'Style','text','Units','pixels','Position',[(P(1)) (P(2) - w*(i-1)) w w],'String',num2str(Patterns(i)),...
   'FontWeight','bold','FontSize',12,'BackGroundColor',[0 0.5 0.8]);
   for j=1:nDecoders
    H.Matirx{i,j}.h = uicontrol('Parent',h,'Style','text','Units','pixels','Position',[(P(1)+ (w*j)) (P(2) - w*(i-1)) w w],'String','',...
   'FontWeight','bold','FontSize',12,'BackGroundColor',[1 0.7 0.4]);
   end
   H.Accuracy{i}.h = uicontrol('Parent',h,'Style','text','Units','pixels','Position',[(P(1) + w*(nDecoders+1)) (P(2) - w*(i-1)) w w],'String','',...
   'FontWeight','bold','FontSize',12,'BackGroundColor',[0 1 0]);
end

function H = SetupClassificationAccuracyTracker(h,P,Patterns)
    H.d = [600 120];
    H.ax= axes('Parent',h,'Units','pixels','Position',[P H.d]);    
    nDecoders = numel(Patterns);
    H.nDecoders = nDecoders;
    set(H.ax,'YLimMode','manual','YLim',[-0.1 1.1],'XLimMode','manual','XLim',[0 10]);
    C = 'kbgrymc';
    for i=1:nDecoders  
        H.hl{i} = line([.1 .2],[.2 .1]*i);        
        set(H.hl{i},'Parent',H.ax,'Color',C(rem(i,numel(C))+1));        
    end

function UpdateClassificationAccuracy(h,Stat)
    H=h.AccuracyTracker;
    nAverage = 3;
    X = (1:1:ceil(Stat.TotalFrames/nAverage))*nAverage+0.001;
    Xm = X/60;
    for i=1:numel(StimTrainStats)
        f = Stat.StimTrainStats{i}.Dout(:,1:Stat.StimTrainStats{i}.nStim);
        Y = ones(size(X))*nan;
        for j=1:numel(X)
            d = f(2,(f(1,:)> X(j)- nAverage)&& (f(1,:)<X(j)));
            Y(j) = sum(d==i)/numel(d);
        end
        set(H.hl{i},'XData',Xm,'YData',Y,'XLim',[0 Xm(end)]);
    end
function UpdateDecoderPerformance(H,M)
nDecoders =H.nDecoders;
%Create Matrix ForViewingData

for i=1:nDecoders    
   for j=1:nDecoders
    set(H.Matirx{i,j}.h,'String',num2str(M(i,j))); 
   end
   a= M(i,i)/sum(M(i,:));
   set(H.Accuracy{i}.h,'String',sprintf('%1.2f',a)); 
end