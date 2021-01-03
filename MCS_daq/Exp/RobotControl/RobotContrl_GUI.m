function varargout = RobotContrl_GUI(varargin)
% ROBOTCONTRL_GUI MATLAB code for RobotContrl_GUI.fig
%      ROBOTCONTRL_GUI, by itself, creates a new ROBOTCONTRL_GUI or raises the existing
%      singleton*.
%
%      H = ROBOTCONTRL_GUI returns the handle to a new ROBOTCONTRL_GUI or the handle to
%      the existing singleton*.
%
%      ROBOTCONTRL_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROBOTCONTRL_GUI.M with the given input arguments.
%
%      ROBOTCONTRL_GUI('Property','Value',...) creates a new ROBOTCONTRL_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RobotContrl_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RobotContrl_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RobotContrl_GUI

% Last Modified by GUIDE v2.5 03-Feb-2014 11:41:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RobotContrl_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @RobotContrl_GUI_OutputFcn, ...
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


% --- Executes just before RobotContrl_GUI is made visible.
function RobotContrl_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RobotContrl_GUI (see VARARGIN)

% Choose default command line output for RobotContrl_GUI
handles.output = hObject;
handles.CreateTestSelector=@CreateTestSelector;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RobotContrl_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function TestSelector = CreateTestSelector(handles,Tests)

hObject = handles.output;
nTests = numel(Tests) ;

P1 = get(hObject,'Position')
P  = [50 (560 - (30+10)*(nTests) - 10) 300 (30+10)*(nTests) + 10] ;
P(1:2:3) = P(1:2:3)./P1(3);
P(2:2:4) = P(2:2:4)./P1(4);

TestSelector.h = uibuttongroup(hObject,'visible','off','Position',P);
TestSelector.Control{nTests}=[];

P = [30 ((30+10)*(nTests-1)+10) 250 30] ;
for i=1:nTests
    P
    TestSelector.Control{i}.select = uicontrol(hObject,'Style','radiobutton','String','',...
    'pos',[5 P(2) 30 30],'Value',0,'FontSize',10,'FontWeight','bold','parent',TestSelector.h);
    TestSelector.Control{i}.chkbox = uicontrol(hObject,'Style','checkbox','String',Tests{i}.TAG,...
    'pos',P,'Value',1,'FontSize',10,'FontWeight','bold','parent',TestSelector.h);
    P(2) = P(2) - P(4) - 10 ;
end

set(TestSelector.h,'visible','on');

% --- Outputs from this function are returned to the command line.
function varargout = RobotContrl_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in cmd_Configure.
function cmd_Configure_Callback(hObject, eventdata, handles)
% hObject    handle to cmd_Configure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in cmdStart.
function cmdStart_Callback(hObject, eventdata, handles)
% hObject    handle to cmdStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for i=1:numel(handles.TestSelector.Control)
    if(get(handles.TestSelector.Control{i}.select,'Value')==1)
        display(['Running Test : ' get(handles.TestSelector.Control{i}.chkbox,'String')]);
        handles.Test.RunTests('test',i,1);
        return;
    end
end
