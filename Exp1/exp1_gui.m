function varargout = exp1_gui(varargin)
% TEST1_GUI MATLAB code for test1_gui.fig
%      TEST1_GUI, by itself, creates a new TEST1_GUI or raises the existing
%      singleton*.
%
%      H = TEST1_GUI returns the handle to a new TEST1_GUI or the handle to
%      the existing singleton*.
%
%      TEST1_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST1_GUI.M with the given input arguments.
%
%      TEST1_GUI('Property','Value',...) creates a new TEST1_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test1_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test1_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test1_gui

% Last Modified by GUIDE v2.5 27-Apr-2013 21:55:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test1_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @test1_gui_OutputFcn, ...
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


% --- Executes just before test1_gui is made visible.
function test1_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test1_gui (see VARARGIN)

% Choose default command line output for test1_gui
handles.output = hObject;

handles.ShowElectrodeActivity = @ShowElectrodeActivity;
handles.CreateTestSelector=@CreateTestSelector;
%Creare Axes

figure(hObject);
%set(hObject,'Position',[50 50 800 800]);

P1 = get(hObject,'Position');

a = load('ChannelMap.mat') ;
handles.ChannelMapping     = a.ChannelMapping;

P  = [400 450 300 300] ;
P(1:2:3) = P(1:2:3)./P1(3);
P(2:2:4) = P(2:2:4)./P1(4);
h = axes('Position',P);
[hL hPoints hMask] = SetupElectrodeAxis(h,handles.ChannelMapping.row,handles.ChannelMapping.col);
handles.ElectrodeView{1}.hAxis = h ;
handles.ElectrodeView{1}.hPoints=hPoints;
handles.ElectrodeView{1}.hL = hL ;
handles.ElectrodeView{1}.hMask = hMask ;

if(1)
    s = [200 200];
    for j = 1:2
        for k=1:4    
            i = k + (j-1)*4 + 1;
            l = 2-j+1;
            P  = [(400 + (k-1)*s(1)) (0 + (l-1)*s(2)) s(1) s(2)] ;
            P(1:2:3) = P(1:2:3)./P1(3);
            P(2:2:4) = P(2:2:4)./P1(4);
            h = axes('Position',P);
            [hL hPoints hMask] = SetupElectrodeAxis(h,handles.ChannelMapping.row,handles.ChannelMapping.col);
            handles.ElectrodeView{i}.hAxis = h ;
            handles.ElectrodeView{i}.hPoints=hPoints;
            handles.ElectrodeView{i}.hL = hL ;
            handles.ElectrodeView{i}.hMask = hMask ;   
        end
    end
end

if(0)
    %Create The SelectButtonMatrix
    nButtons = numel(handles.ChannelMapping.row);
    handles.ElectrodeSelectButtons{nButtons} = [] ;

    P  = [750 450 300 300] ;
    m  = max(handles.ChannelMapping.row);
    P(3:4) = P(3:4)./m;
    for i=1:nButtons
     bP        = P               ;
     bP(1)     = bP(1) + (handles.ChannelMapping.col(i) - 1)*P(3) ; 
     bP(2)     = bP(2) + ((m-handles.ChannelMapping.row(i)+ 1) - 1)*P(4) ; 

     h = uicontrol( 'Style'   , 'togglebutton',...
                    'String'  ,  handles.ChannelMapping.Map(i).label,...
                    'Position', bP,...
                    'Callback', @cmdButton_Callback); 
      set(h,'UserData',[i 0]);
      handles.ElectrodeSelectButtons{i}.h = h;
    end


    %Create Select Button Group for electrodes
    % Create the button group.
    P  = [1060 450 100 220] ;
    P(1:2:3) = P(1:2:3)./P1(3);
    P(2:2:4) = P(2:2:4)./P1(4);

    h = uibuttongroup('visible','off','Position',P);
    % Create three radio buttons in the button group.
    u = uicontrol('Style','pushbutton','String','Clear All',...
        'pos',[10 160 80 45],'parent',h,'HandleVisibility','off');

    u0 = uicontrol('Style','togglebutton','String','Group 1',...
        'pos',[10 110 80 45],'parent',h,'HandleVisibility','off');
    u1 = uicontrol('Style','togglebutton','String','Group 2',...
        'pos',[10 60 80 45],'parent',h,'HandleVisibility','off');
    u2 = uicontrol('Style','togglebutton','String','Group 3',...
        'pos',[10  10 80 45],'parent',h,'HandleVisibility','off');
    % Initialize some button group properties. 
    set(h,'SelectionChangeFcn',@cmdButtonGroup_selcbk);
    set(h,'SelectedObject',[]);  % No selection
    set(h,'Visible','on');

    handles.ElectrodeSelectControl.h=h;
    handles.ElectrodeSelectControl.u=u;
    handles.ElectrodeSelectControl.u0=u0;
    handles.ElectrodeSelectControl.u1=u1;
    handles.ElectrodeSelectControl.u2=u2;
end

P = [50 600 200 30] ;
handles.lblCurrentTest = uicontrol(hObject,'Style','text','String','Current Test',...
    'pos',P,'FontSize',10,'FontWeight','bold','HorizontalAlignment','left');

% P  = [50 560 200 30] ;
% P(1:2:3) = P(1:2:3)./P1(3);
% P(2:2:4) = P(2:2:4)./P1(4);
% h = axes('Position',P);
% handles.pbarTestStat.ax = h ;
% set(h,'XLimMode' , 'Manual' , 'YLimMode' , 'Manual' , 'ZLimMode' , 'Manual' );
% set(h,'XLim',[0 1],'YLim',[0 1],'YDir','reverse');
% set(h,'XTick', [],'YTick',[], 'ZTick',[]);set(h,'XTickMode', 'Manual', 'YTickMode', 'Manual', 'ZTickMode', 'Manual');
% set(h,'XColor',[1 1 1], 'YColor',[1 1 1], 'ZColor',[1 1 1])

% Update handles structure
guidata(hObject, handles);

function TestSelector = CreateTestSelector(handles,Tests)

hObject = handles.output;
nTests = numel(Tests) ;

P1 = get(hObject,'Position');
P  = [50 (560 - (30+10)*(nTests) - 10) 300 (30+10)*(nTests) + 10] ;
P(1:2:3) = P(1:2:3)./P1(3);
P(2:2:4) = P(2:2:4)./P1(4);

TestSelector.h = uibuttongroup(hObject,'visible','off','Position',P);
TestSelector.Control{nTests}=[];

P = [30 ((30+10)*(nTests-1)+10) 250 30] ;
for i=1:nTests
    TestSelector.Control{i}.select = uicontrol(hObject,'Style','radiobutton','String','',...
    'pos',[5 P(2) 30 30],'Value',0,'FontSize',10,'FontWeight','bold','parent',TestSelector.h);
    TestSelector.Control{i}.chkbox = uicontrol(hObject,'Style','checkbox','String',Tests{i}.TAG,...
    'pos',P,'Value',1,'FontSize',10,'FontWeight','bold','parent',TestSelector.h);
    P(2) = P(2) - P(4) - 10 ;
end

set(TestSelector.h,'visible','on');


% UIWAIT makes test1_gui wait for user response (see UIRESUME)
% uiwait(handles.test_gui_main);
function cmdButtonGroup_selcbk(hObject, eventdata, handles)

function cmdButton_Callback(hObject, eventdata, handles)
   id = get(hObject,'UserData');
   display(num2str(id(1)));
   
   P = get(hObject,'Position');
   CData = zeros(P(3),P(4),3) ; 
   CData(:,:,1) = 1 ;
   set(hObject,'CData',CData)
% --- Outputs from this function are returned to the command line.
function varargout = test1_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function TestId = get_next_test(handles)

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




function ShowElectrodeActivity(handles,DisplayId,Activity, Mark)

 nEL  = size(Activity,1);
 nPad = 3 - size(Activity,2);
 V = [Activity ones(nEL,nPad)] ;  
 lim_in = [0 1] ;
 lim    = [2/3 0] ; %[r to g]
 %lim    = [1/3 0] ; %[r to g]
      
 m      = (lim(2) - lim(1))/(lim_in(2) - lim_in(1)) ;    
 c      = lim(1) - m*lim_in(1)   ;
 V(:,1) = m.*V(:,1)+c ;  
 V = hsv2rgb(V) ;   

 S = ones(size(V,1),1)*100;
 marks = find(Mark==1);
 for i=1:numel(marks)
  V(marks(i),:) = [0 0 1] ; 
  S(marks(i)) = 200;
 end
%  W = ones(120,3);
%  W((Mark==1),:) = 0 ;
%  set(handles.ElectrodeView{DisplayId}.hMask,'CData',W);
 
 set(handles.ElectrodeView{DisplayId}.hPoints,'CData',V);
 set(handles.ElectrodeView{DisplayId}.hPoints,'SizeData',S);
 
function [hL hPoints hMask] = SetupElectrodeAxis(h,row,col)

th = 0:pi/500:2*pi;
r  = 7.5            ;
c  = [6.5 6.5]    ;  
x  = c(1) + r*sin(th)      ;
y  = c(2) + r*cos(th)      ;

axes(h);
hold(h,'on')
hL = plot(x,y,'LineWidth',3);

m = numel(row) ;

cl = [1 1 1] ;
CData = repmat(cl,m,1);
hMask     = scatter(h,col,row,300,CData,'filled');

cl = [44 147 225]/255 ;
CData = repmat(cl,m,1);
hPoints   = scatter(h,col,row,ones(size(col))*100,CData,'filled');

set(h,'XLimMode' , 'Manual' , 'YLimMode' , 'Manual' , 'ZLimMode' , 'Manual' );
set(h,'XLim',[c(1)-r-1 c(1) + r + 1],'YLim',[c(2)-r-1 c(2) + r + 1],'YDir','reverse');
set(h,'XTick', [],'YTick',[], 'ZTick',[]);
set(h,'XTickMode', 'Manual', 'YTickMode', 'Manual', 'ZTickMode', 'Manual');
set(h,'XColor',[1 1 1], 'YColor',[1 1 1], 'ZColor',[1 1 1])
