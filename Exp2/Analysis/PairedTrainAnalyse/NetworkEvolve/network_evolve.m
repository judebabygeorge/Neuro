function varargout = network_evolve(varargin)
% NETWORK_EVOLVE MATLAB code for network_evolve.fig
%      NETWORK_EVOLVE, by itself, creates a new NETWORK_EVOLVE or raises the existing
%      singleton*.
%
%      H = NETWORK_EVOLVE returns the handle to a new NETWORK_EVOLVE or the handle to
%      the existing singleton*.
%
%      NETWORK_EVOLVE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NETWORK_EVOLVE.M with the given input arguments.
%
%      NETWORK_EVOLVE('Property','Value',...) creates a new NETWORK_EVOLVE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before network_evolve_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to network_evolve_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help network_evolve

% Last Modified by GUIDE v2.5 21-Nov-2014 09:13:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @network_evolve_OpeningFcn, ...
                   'gui_OutputFcn',  @network_evolve_OutputFcn, ...
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


% --- Executes just before network_evolve is made visible.
function network_evolve_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to network_evolve (see VARARGIN)

% Choose default command line output for network_evolve
handles.output = hObject;
opengl software
handles.G.div = findobj('Tag','txt_DIV');
handles.G.trainprobe = findobj('Tag','txt_trainprobe');
handles.G.selectedprobe = findobj('Tag','txt_selectedprobe');

handles.G.ax_main = findobj('Tag','ax_main');
handles.G.ax_spike = findobj('Tag','ax_spike');
handles.G.ax_psth = findobj('Tag','ax_psth');

handles.G.AnalyseEvolve = @AnalyseEvolve;

%AnalyseEvolve(handles,'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\G28082014B_T\','DIV56',1,12,2);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes network_evolve wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = network_evolve_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function AnalyseEvolve(h,path,DIV,TrainProbe,TrainAfter,Probes,SelectedProbe)

set(h.G.div,'String',DIV);

if TrainProbe > 0
    set(h.G.trainprobe,'String',sprintf('Train Probe : %d',TrainProbe));
else
    set(h.G.trainprobe,'String',sprintf('Train Probe : -'));
end
set(h.G.selectedprobe,'String',sprintf('Selected Probe : %d',SelectedProbe));
c = 'bgrcm';
set(h.G.selectedprobe,'ForegroundColor',c(1+ floor(rem(SelectedProbe-0.1,5))));

[X,C,D] = AnalyseNetworkEvolve(path,DIV);

t = 1:1:TrainAfter;
t = t/4;


for i=1:numel(Probes)    
    %plot(h.G.ax_main,t,X(1:TrainAfter,[Probes(i) (numel(Probes) + Probes(i))]),'Color',c(1+ floor(rem(i-0.1,5))),'LineWidth',2, 'LineSmoothing','on');
    if(i == SelectedProbe)
        plot(h.G.ax_main,t,X(1:TrainAfter,Probes(i)),'Color',c(1+ floor(rem(i-0.1,5))),'LineStyle','-.','LineWidth',2, 'LineSmoothing','on');
    else
        plot(h.G.ax_main,t,X(1:TrainAfter,Probes(i)),'Color',c(1+ floor(rem(i-0.1,5))),'LineWidth',2, 'LineSmoothing','on');
    end
    
    hold(h.G.ax_main,'on')
end


if TrainAfter < size(X,1)
    hold(h.G.ax_main,'on')
    t = TrainAfter+1:1:(size(X,1));
    t = t/4;
    t = t + 0.5;
    for i=1:numel(Probes)
        
      %plot(h.G.ax_main,t,X(TrainAfter+1:end,[Probes(i) (numel(Probes) + Probes(i))]),'Color',c(1+ floor(rem(i-0.1,5))),'LineWidth',2, 'LineSmoothing','on');
      if(i == SelectedProbe)
       plot(h.G.ax_main,t,X(TrainAfter+1:end,Probes(i)),'Color',c(1+ floor(rem(i-0.1,5))),'LineStyle','-.','LineWidth',2, 'LineSmoothing','on');
      else
       plot(h.G.ax_main,t,X(TrainAfter+1:end,Probes(i)),'Color',c(1+ floor(rem(i-0.1,5))),'LineWidth',2, 'LineSmoothing','on');
      end
      hold(h.G.ax_main,'on')
    end
    %plot(h.G.ax_main,t,X(TrainAfter+1:end,Probes),'LineWidth',2, 'LineSmoothing','on');    
end
hold(h.G.ax_main,'off')

set(h.G.ax_main, 'Ylim',[-0 1.1]);
%set(h.G.ax_main, 'Xlim',[-1 9]);
set(h.G.ax_main,'YTick',0:0.2:1,'YColor','k');

[~,I] = max(X(:,SelectedProbe)) ;

a=load([path DIV '\data_spiketrain_PatternCheck_2_250_paired_train_probe_' num2str(I) '.mat']);
PatternData =a.PatternData;
a = load([path DIV '\spiketrain_wf_PatternCheck_2_250_paired_train_probe_' num2str(I) '.mat']);

StimConfigProbe = PatternData.StimConfig;
Patterns = PatternData.Pattern;
%[Patterns , StimConfigProbe ]= EditPatterns(PatternData);
I = a.SpikeWF.SpikeIndex;
T = a.SpikeWF.SpikeData;

ShowSpikeShape(h.G.ax_spike,I,T,StimConfigProbe,StimConfigProbe.PatternDetails.electrodes(SelectedProbe),StimConfigProbe.PatternDetails.vecs(SelectedProbe));
ShowSpikeTimes(h.G.ax_psth,Patterns,StimConfigProbe,StimConfigProbe.PatternDetails.electrodes(SelectedProbe),StimConfigProbe.PatternDetails.vecs(SelectedProbe));

function ShowSpikeTimes(h,Patterns,PatternConfig,E,Pid)

xl = [4 80];
x = xl(1):round((xl(2)-xl(1))/20):xl(2);
t = Patterns(E,:,Pid,:);
t = reshape(t,[numel(t) 1])/50;
t = t(~isnan(t));
hist(h,t,x, 'LineSmoothing','on');
set(h,'XLim',[0 xl(end)+1],'YLim',[0 20],'YLimMode','manual','XLimMode','manual','XTick',[],'YTick',[]); 
set(h,'XTick',[0 xl(end)],'YTick',[]);

function ShowSpikeShape(h,I,T,PatternConfig,E,Pid)
     id  = I(E,:,Pid,:);
     id  = id(:);
     id  = id(id >0);
     X   = repmat((1:1:size(T,1))'-25,[1 numel(id)]);
 
     plot(h,X,T(:,id),'k', 'LineSmoothing','on');
     set(h,'XLim',[-25 75],'YLim',[-100 100],'XTick',[],'YTick',[]); 
     
     %stim  = GetPatternDescription(PatternConfig,Pid);
     %s =sprintf('(%s)',stim);
     %set(S.SpikeAxis{loc(1),loc(2),loc(3)}.hl,'String',s);

     set(h,'XTick',[-25 75],'YTick',[]);
