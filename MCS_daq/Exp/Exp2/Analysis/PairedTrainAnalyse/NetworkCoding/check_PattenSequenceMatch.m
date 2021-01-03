path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\Z06112015A\';
DIV  = [14];


a = load(sprintf('%s//DIV%d//data_PatternCheck_2_250_PatternMatch_1.mat',path,DIV(1)));
PatternData = a.PatternData;
[Patterns , PatternConfig ]= EditPatterns(PatternData);
P = ones(size(Patterns));
P(isnan(Patterns)) = 0;

P = mean(P,3);

h = PatternView ;
hO  = guidata(h);

remove = 1+[ 0 8 9];

SelectedPatterns = 1:2:20;
SelectedPatterns(remove)=[];

for i=1:7
       Vis  = P(:,SelectedPatterns(i));   
       Act  = ones(size(Vis))*0;
       Mark = zeros(size(Act));
       id = i;
       hO.ShowElectrodeActivity(hO,id,[Act Vis], Mark);  
end
SelectedPatterns = 2:2:20;
SelectedPatterns(remove)=[];
for i=1:7
       Vis  = P(:,SelectedPatterns(i));   
       Act  = ones(size(Vis))*0;
       Mark = zeros(size(Act));
       id = 8+i;
       hO.ShowElectrodeActivity(hO,id,[Act Vis], Mark);  
end