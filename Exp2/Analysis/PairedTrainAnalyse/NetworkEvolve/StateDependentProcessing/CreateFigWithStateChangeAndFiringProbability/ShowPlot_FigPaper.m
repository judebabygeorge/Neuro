
%G05012015A/DIV_37

%cd('../')
%check_overnight_change

%9 15 17 25 [38] 48 [51] 52 53 65 67 68 79  84 91
%94 101 102 109 110 114

Z1 = Z(25,:); Z1 = Z1>0.06;

y=X{1}.X(25,Z1,:);
y = reshape(y,[4 24]);
plot(mean(y))
yyy =y;


cd('.\StateDependentProcessing')
OverDaysState