function output = captureConsole(myMethod)
%Capture the output of Console.Write or Console.WriteLine in MATLAB
% Input: A string to pass it to Console.Write method
% Output: Captured output
import System.*
%create a streamwriter class
writer = IO.StreamWriter(IO.MemoryStream);
%save the old console
oldConsole = Console.Out;
%set the new console output
Console.SetOut(writer);
%set the stream length to 0
stream = writer.BaseStream;
stream.SetLength(0);
% Call a method that prints out a string
evalin('base',myMethod)
%capture the output from the streamwriter
writer.Flush;
output = char(writer.Encoding.GetString(stream.ToArray));
%set the old Console back after done
Console.SetOut(oldConsole);
end 

