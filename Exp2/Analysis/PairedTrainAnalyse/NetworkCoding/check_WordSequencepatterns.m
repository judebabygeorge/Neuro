path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\G28122015A\';
DIV  = [31];


a = load(sprintf('%s//DIV%d//data_PatternCheck_2_250_WordSequence_1.mat',path,DIV(1)));
PatternData = a.PatternData;
[Patterns , PatternConfig ]= EditPatterns(PatternData);
P = ones(size(Patterns));
P(isnan(Patterns)) = 0;

P = mean(P,3);

h = PatternView ;
hO  = guidata(h);

nW=1;
for i=1:3
       Vis  = P(:,2*(i-1)+1);   
       Act  = ones(size(Vis))*0;
       Mark = zeros(size(Act));
       id = (i-1)*8+1;
       hO.ShowElectrodeActivity(hO,id,[Act Vis], Mark);
       
       for j=2:(nW+1)
           Vis  = P(:,2*(i-1)+j);   
           Act  = ones(size(Vis))*0;
           Mark = zeros(size(Act));
           id = (i-1)*8+j;
           hO.ShowElectrodeActivity(hO,id,[Act Vis], Mark);
       end
end