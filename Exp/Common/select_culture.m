function varargout = select_culture(varargin)
% SELECT_CULTURE MATLAB code for select_culture.fig
%      SELECT_CULTURE, by itself, creates a new SELECT_CULTURE or raises the existing
%      singleton*.
%
%      H = SELECT_CULTURE returns the handle to a new SELECT_CULTURE or the handle to
%      the existing singleton*.
%
%      SELECT_CULTURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECT_CULTURE.M with the given input arguments.
%
%      SELECT_CULTURE('Property','Value',...) creates a new SELECT_CULTURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before select_culture_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to select_culture_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help select_culture

% Last Modified by GUIDE v2.5 22-May-2013 10:33:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @select_culture_OpeningFcn, ...
                   'gui_OutputFcn',  @select_culture_OutputFcn, ...
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


% --- Executes just before select_culture is made visible.
function select_culture_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to select_culture (see VARARGIN)

% Choose default command line output for select_culture
handles.output = hObject;
handles.UpdateCultureList = @UpdateCultureList;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes select_culture wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = select_culture_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in lst_Cultures.
function lst_Cultures_Callback(hObject, eventdata, handles)
% hObject    handle to lst_Cultures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lst_Cultures contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lst_Cultures


% --- Executes during object creation, after setting all properties.
function lst_Cultures_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lst_Cultures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function UpdateCultureList(h,path)

a = dir(path) ;
a = a(3:end) ;

lst = findobj(h,'Tag','lst_Cultures');

items{numel(a)} = [];
for i=1:numel(a)
    items{i} = a(i).name ;    
end
set(lst,'String',items);

% --- Executes on button press in cmd_Select.
function cmd_Select_Callback(hObject, eventdata, handles)
% hObject    handle to cmd_Select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global SelectedCulture;

lst = findobj(handles.output,'Tag','lst_Cultures');
SelectedCulture = get(lst,'Value');
a =  get(lst,'String');
SelectedCulture = a{SelectedCulture};
close(handles.output)
