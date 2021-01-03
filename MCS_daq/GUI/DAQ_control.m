function varargout = DAQ_control(varargin)
% DAQ_Control MATLAB code for DAQ_Control.fig
%      DAQ_Control, by itself, creates a new DAQ_Control or raises the existing
%      singleton*.
%
%      H = DAQ_Control returns the handle to a new DAQ_Control or the handle to
%      the existing singleton*.
%
%      DAQ_Control('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DAQ_Control.M with the given input arguments.
%
%      DAQ_Control('Property','Value',...) creates a new DAQ_Control or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DAQ_Control_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DAQ_Control_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DAQ_Control

% Last Modified by GUIDE v2.5 18-Apr-2013 09:44:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DAQ_Control_OpeningFcn, ...
                   'gui_OutputFcn',  @DAQ_Control_OutputFcn, ...
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


% --- Executes just before DAQ_Control is made visible.
function DAQ_Control_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DAQ_Control (see VARARGIN)

% Choose default command line output for DAQ_Control
handles.output = hObject;
handles.Data   = [1 2 3];

P = get(hObject,'Position');
P(1:2) = [0 100];
set(hObject,'Position',P);
% Update handles structure


guidata(hObject, handles);

% UIWAIT makes DAQ_Control wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DAQ_Control_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in tglACQ.
function tglACQ_Callback(hObject, eventdata, handles)
% hObject    handle to tglACQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tglACQ
if(get(hObject,'Value') == true)  
  set(hObject,'String','Stop ACQ');
  handles.SYS.StartACQ(2,'')
else
  set(hObject,'String','Start ACQ');
  handles.SYS.StopACQ()
end

% --- Executes on button press in cmdDownloadCode.
function cmdDownloadCode_Callback(hObject, eventdata, handles)
% hObject    handle to cmdDownloadCode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  handles.SYS.DownLoadCode()


% --- Executes on button press in cmdDoAction.
function cmdDoAction_Callback(hObject, eventdata, handles)
% hObject    handle to cmdDoAction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






function SendStimTrigger(handles , ConfigId , SegmentId , Trigger )
 
  Array = uint32(zeros(2,1)); 
  Array(1) = combine_halfwords(SegmentId,ConfigId) ;
  Array(2) = Trigger   ;
  SendCommand(handles.SYS,6,Array) ;

 
% --- Executes on button press in cmd_LoadPattern.
function cmd_LoadPattern_Callback(hObject, eventdata, handles)
% hObject    handle to cmd_LoadPattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Writing Stimulus Pattern

%%Load waveform
 display('Pulse Pattern Load')
 [Array ~] = Stim_GenStimulusPattern(0,0);
 SendCommand(handles.SYS,4,Array);  
            
%%Load stimulus Config

Config = GenerateStimulusConfig_test (1,3,1,120,1000,1000);
LoadStimulusPatternConfig(handles.SYS,Config);


% --- Executes on button press in cmd_TriggerStim.
function cmd_TriggerStim_Callback(hObject, eventdata, handles)
% hObject    handle to cmd_TriggerStim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 %Start_StimSequence(handles.SYS,0,2,10,1,1,100)
 Start_StimPatternSequence(handles.SYS,0, 5 , 2 , 9 , handles.SYS.CurrentTime+25000)
 