function CreateNetworkEvolveFigures
%CREATENETWORKEVOLVEFIGURES Summary of this function goes here
%   Detailed explanation goes here

Probes = 1:5;
%%
p = 'E:\Data\Data\G28082014A\';
s = 'C:\Users\45c\Desktop\train_LTP\G28082014A\';
SelectedProbe = 3;
N{1} = {33,1,12};
N{2} = {34,0,20};
N{3} = {36,1,12};
N{4} = {37,0,24};
N{5} = {39,0,12};
N{6} = {40,0,12};
N{7} = {41,0,12};
N{8} = {42,0,12};
N{9} = {47,3,10};
N{10} = {48,1,12};
N{11} = {49,3,12};


%%
% p = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\G28082014B_T\';
% s = 'C:\Users\45c\Desktop\train_LTP\G28082014B_T\';
% SelectedProbe = 2;
% 
% N{1} = {51,1,12};
% N{2} = {52,2,12};
% N{3} = {53,3,12};
% N{4} = {54,1,6};
% N{5} = {55,4,24};
% N{6} = {56,3,12};
% N{7} = {57,2,6};
% N{8} = {58,1,12};

%%
% p = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\G09102014A\';
% s = 'C:\Users\45c\Desktop\train_LTP\G09102014A\';
% SelectedProbe = 5;
% N{1} = {20,1,12};
% N{2} = {21,2,12};
% N{3} = {22,5,12};
% N{4} = {23,3,12};

%%
% p = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\G09102014B\';
% s = 'C:\Users\45c\Desktop\train_LTP\G09102014B\';
% Probes = 1:4;
% SelectedProbe = 2;
% N{1} = {21,2,11};
% N{2} = {22,2,12};
% N{3} = {23,3,12};



% p = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\G09102014A\';
% s = 'C:\Users\45c\Desktop\train_LTP\G09102014A\';
% SelectedProbe = 9;
% N{1} = {25,1,12};
% N{2} = {26,2,12};
% N{3} = {27,3,12};
% N{4} = {28,2,12};
% N{5} = {29,2,12};
% N{6} = {32,4,12};

% p = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\G09102014B\';
% s = 'C:\Users\45c\Desktop\train_LTP\G09102014B\';
% SelectedProbe = 9;
% N{1} = {26,1,10};
% N{2} = {27,2,12};
% N{3} = {28,2,12};
for i=1:numel(N)
    CreateFigure(p,N{i}{1},N{i}{2},N{i}{3},Probes,SelectedProbe,s);
end


end

function CreateFigure(p,DIV,TrainProbe,TrainAfter,Probes,SelectedProbe,save_path)
 f = network_evolve;
 h = guidata(f);
 h.G.AnalyseEvolve(h,p,sprintf('DIV%d',DIV),TrainProbe,TrainAfter,Probes,SelectedProbe);
 F = getframe(f);
 imwrite(F.cdata,[save_path   sprintf('evDIV%d',DIV) '.png']);
 close(f)
end