function varargout = SignalGen(varargin)
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
                   'gui_OpeningFcn', @SignalGen_OpeningFcn, ...
                   'gui_OutputFcn',  @SignalGen_OutputFcn, ...
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
function SignalGen_OpeningFcn(hObject, eventdata, handles, varargin)
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


a = load('ChannelMap.mat') ;
handles.ChannelMapping     = a.ChannelMapping;
handles.ChannelsToDraw = handles.ChannelMapping.nCh ;


handles.SetupSignalSelect = @SetupSignalSelect;
handles.SetupSignalAssign = @SetupSignalAssign;
handles.GetSignalGenParams = @GetSignalGenParams;

handles = SetupSignalSelect(handles,GetInputParamStruct());
handles = SetupSignalAssign(handles,GenerateExpConfigs());

handles.hSetSigSel = uicontrol('Style', 'pushbutton', 'String','Set Signal Gen',...
        'HorizontalAlignment','left','Position', [300 60 100 60],...
        'Callback', @cmdSetSignalGen);
handles.SignalGenSetting = [];

% Update handles structure
guidata(hObject, handles);

function cmdSetSignalGen(hObject, eventdata)
handles = guidata(hObject);
SignalGen=GetSignalGenParams(handles);

handles.SignalGenSetting = SignalGen;
guidata(hObject, handles);

function SignalGen = GetSignalGenParams(handles)

%Parameters for Signal Generators
SignalConfig{3} = [];
for i=1:3
    %Load the default Structure
    SignalConfig{i} = handles.Config{handles.SignalSelected(i)}; 
    %Load parameters
    for j=1:numel(handles.hSigs{i}.hParams)
        fname = get(handles.hSigs{i}.hParams{j}.hValue,'UserData');
        fname = fname{2};
        fval = str2num(get(handles.hSigs{i}.hParams{j}.hValue,'String'));
        SignalConfig{i}.(fname)=fval;
    end
end

%Signals for electrodes
SignalToElectrodeConfig = zeros(numel(handles.SigAssignConfig),1);
for i=1:numel(handles.SigAssignConfig)
     fval = get(handles.hSigAssign{i}.hList.hSigSel,'Value');
     SignalToElectrodeConfig(i)=fval;
end

SignalGen.SignalConfig = SignalConfig;
SignalGen.SignalToElectrodeConfig = SignalToElectrodeConfig;
SignalGen.SigAssignConfig = handles.SigAssignConfig;



function handles = SetupSignalAssign(handles,Config)

handles.SigAssignConfig  = Config;

Signals = {'None' ,  'GND' , 'Signal 1' ,'Signal 2' , 'Signal 3'};

Ps = [300 800 100 20];
for i=1:numel(Config)           
    h.hLabel = uicontrol('Style', 'text', 'String',Config{i}.Descriptor,...
    'HorizontalAlignment','right','Position',Ps);                 
    set(h.hLabel,'Tag',['lblEl' num2str(i)]);
    set(h.hLabel,'UserData',i);          
    
    hSigSel = uicontrol('Style', 'popupmenu', 'String',Signals,...
        'HorizontalAlignment','left','Position',Ps + [110 0 0 0]); 
    h.hSigSel = hSigSel;        
    set(hSigSel,'Tag',['popSigSel' num2str(i)]);
    set(hSigSel,'UserData',i);
    
    Ps(2) = Ps(2) - 30;    
    handles.hSigAssign{i}.hList = h;  
end

function handles = SetupSignalSelect(handles,Config)

hObject = handles.output;
figure(hObject)
handles.Config = Config;


P1 = get(hObject,'Position');
wHeight = 300;

P  = [800 P1(4) - 150 800 wHeight*0.9] ;
P(1:2:3) = P(1:2:3)./P1(3);
P(2:2:4) = P(2:2:4)./P1(4);
wHeight=wHeight/P1(4);

SignalList{numel(Config)} = [];
for i=1:numel(Config)
    SignalList{i} = Config{i}.Type;
end

handles.SignalList=SignalList;

nSignals = 3;
handles.SignalSelected = zeros(nSignals,1);
handles.hSigs{nSignals} = [];

for i=1:nSignals      
    hLabel = uicontrol('Style', 'text', 'String',['Signal ' num2str(i)],...
        'HorizontalAlignment','right','Position',[20 P(2)*P1(4) + 100 70 20]);                 
    set(hLabel,'Tag',['lblSig' num2str(i)]);
    set(hLabel,'UserData',i);    
    handles.hSigs{i}.hLabel = hLabel;   
    
    hSigSel = uicontrol('Style', 'popupmenu', 'String',SignalList,...
        'HorizontalAlignment','left','Position', [20 + 80 P(2)*P1(4) + 100 80 20],...
        'Callback', @cmdSignalSelect); 
    handles.hSigs{i}.hSigSel = hSigSel;    
    set(hSigSel,'Tag',['popSignals' num2str(i)]);
    set(hSigSel,'UserData',i);
     
    handles.hSigs{i}.hParams = [];
    
    handles.SignalSelected(i) = get(handles.hSigs{i}.hSigSel,'Value');
    
    Ps = [20 1150 - i*wHeight*P1(4) 100 20];
    handles = cmdCreateSignalPropertyFields(handles,i,Ps);
    P(2) = P(2) - wHeight ;   
   
end

function handles = cmdCreateSignalPropertyFields(handles,SignalID,Ps)

    if  numel(handles.hSigs{SignalID}.hParams) ~= 0
        for j=1:numel(handles.hSigs{SignalID}.hParams) 
            delete(handles.hSigs{SignalID}.hParams{j}.hLabel);
            delete(handles.hSigs{SignalID}.hParams{j}.hValue);
        end
    end
    handles.hSigs{SignalID}.hParams = [];
    
    S = handles.Config{handles.SignalSelected(SignalID)};
    f = fieldnames(S);
    f = f(2:end);
    hParams{numel(f)}=[];
    
    Ps(2) = Ps(2) - 25;
    for j=1:numel(f)             
        hParams{j}.hLabel = uicontrol('Style', 'text', 'String',[f{j} ' : '],...
        'HorizontalAlignment','right','Position',Ps);                 
        set(hParams{j}.hLabel,'Tag',['params_' num2str(SignalID) '_' num2str(j)]);
        set(hParams{j}.hLabel,'UserData',[SignalID j]); 
        
        hParams{j}.hValue = uicontrol('Style', 'edit', 'String',num2str(S.(f{j})),...
        'HorizontalAlignment','left','Position', Ps + [100 0 -50 0] );  
        set(hParams{j}.hValue,'Tag',['pVal_' num2str(SignalID) '_' num2str(j)]);
        set(hParams{j}.hValue,'UserData',{SignalID,f{j}}); 
        Ps(2) = Ps(2) - 25;
    end    
    handles.hSigs{SignalID}.hParams = hParams;  
    
function cmdSignalSelect(hObject, eventdata)

    A =  get(hObject,'UserData');
    DACID = A(1);
    val = get(hObject,'Value');
    
    handles = guidata(hObject);
    handles.SignalSelected(DACID) = val;
   
    Ps = [20 1150 - DACID*300 100 20];
    handles = cmdCreateSignalPropertyFields(handles,DACID,Ps);
    
    guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = SignalGen_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
       
