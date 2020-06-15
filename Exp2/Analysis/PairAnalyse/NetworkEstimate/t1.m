
%M = [0.5 5 0 0 ; .49 4.5 0 0];
%M = [1 8; -.95 5];   %14
%M = [0.5 5; 0.5 4.5]; %2
%M = [0.72 5; 0.72 5]; %10

M = [0.4 5; 0.5 4.4]; %2

d = [0.5 3];
I = [1 2;2 1];
[P,t] = CalculateModelOutput(M,I,d);
%plot(fO')



D.nInputs = 2;
D.nCombs  = 2;
D.nDelays = 2;
D.d = d;
D.I = I;
D.P = P;
D.t = t;

estM = estimate_model(D);
%estM = estimate_model_stdp(D);

Target = [P t]
[P,t] = CalculateModelOutput(estM,I,d);
Eval   = [P t]




