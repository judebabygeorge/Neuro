function ExecuteTestSeries(uExp,Tests)

Udata.uExp=uExp;
Udata.Tests = Tests;
Udata.NextTest = 1 ;
global ExecuteTestSeries_Timer
ExecuteTestSeries_Timer = timer('ExecutionMode','singleShot','StartDelay',Udata.Tests(Udata.NextTest,2)*60,'TimerFcn',@ExecuteNextTest,'StopFcn',@ExecuteComplete,'UserData',Udata);
tic
start(ExecuteTestSeries_Timer)

%ExecuteTest(uExp,11)
end
function ExecuteNextTest(obj, event, string_arg)
global ExecuteTestSeries_Timer
stop(ExecuteTestSeries_Timer);
toc
Udata = get(ExecuteTestSeries_Timer,'UserData');
display(['Running Test '  num2str(Udata.Tests(Udata.NextTest))])
ExecuteTest(Udata.uExp,Udata.Tests(Udata.NextTest,1))



end
function ExecuteTest(uExp,TestID)


display(['Timer Starting test ' num2str(TestID)]);

uExp.TestSelectionChange(TestID)
switchon_MEA2100
pause(10)
uExp.RunTests('test',TestID,1)



end
function ExecuteComplete(obj, event, string_arg)
global ExecuteTestSeries_Timer
Udata = get(ExecuteTestSeries_Timer,'UserData');
Udata.NextTest = Udata.NextTest + 1;
if Udata.NextTest <= size(Udata.Tests,1)
    set(ExecuteTestSeries_Timer,'UserData',Udata);
    set(ExecuteTestSeries_Timer,'StartDelay',Udata.Tests(Udata.NextTest,2)*60);    
    start(ExecuteTestSeries_Timer)
end

end
