function A = trGenerateStimulusWaveFormFromSignal(signal,Ts,min_step,StartDelay,InterPulseDelay,nPulses,InterTrainDelay,nTrains)
%TRGENERATESTIMULUSWAVEFORMFROMSIGNAL units mV,ms
%   Generate the array to be fed into the timulus generator of DAC


%Generate the signal
Sampling_Frequency = 20e-3 ; %20uS

StartDelay = StartDelay/Sampling_Frequency;
InterPulseDelay=InterPulseDelay/Sampling_Frequency;
InterTrainDelay=InterTrainDelay/Sampling_Frequency;

if (Ts > Sampling_Frequency) 
    %Resample Signal at 20e-3mS
    x  = (0:1:(numel(signal)-1))*Ts;
    xi = 0:Sampling_Frequency:(numel(signal)-1)*Ts;
    signal = interp1(x,signal,xi,'spline');   
end
ScaleFactor =0.571 ; %mV/unit
signal = round(signal/ScaleFactor);
A = zeros(numel(signal),2);

id   = 1;
yold = signal(1);
c = 1;
for i=2:numel(signal)      
  if abs(signal(i)-yold) >= min_step
      A(id,:)=[yold c];      
      id = id + 1;
      yold = signal(i);
      c = 1;
  else
      c = c + 1  ;
  end
end
A(id,:)=[yold c];   
A = A(1:id,:);

%Create the array
A(:,1) = A(:,1) + hex2dec('8000') ; %DAC 0
A(:,1) = uint16(A);

B = [];
for i=1:size(A,1)
    B = [B AddDataPoint(A(i,1),A(i,2))];
end

A = [];
vectors_used = 0;

A = [A  AddDataPoint(0+ hex2dec('8000'),StartDelay)]; %Start Delay

A = [A B];%Waveform
vectors_used = vectors_used + numel(B); 

C =  AddDataPoint(0+ hex2dec('8000'),InterPulseDelay);%InterPulse Delay
A = [A C];
vectors_used = vectors_used + numel(C);

C = AddLoop(vectors_used,nPulses,0);%Pulses
A = [A C];
vectors_used = vectors_used + numel(C);

C =  AddDataPoint(0+ hex2dec('8000'),InterTrainDelay);%InterTrainDelay
A = [A C];
vectors_used = vectors_used + numel(C);

C = AddLoop(vectors_used,nTrains,1);%Trains
A = [A C];
%vectors_used = vectors_used + numel(C);
A = [A AddEndVector()];

% Create SBS Vector

end

function A = AddDataPoint(value,duration)
    A = [];
    if duration > 1000
        A(numel(A)+1) = hex2dec('04000000') + uint16(floor(duration/1000))*2^16 + value;
        duration = rem(duration,1000);
    end
    if duration > 0
        A(numel(A)+1) =  uint16(floor(duration/1000))*2^16 + value;
    end
end

function A = AddLoop(vectors,repeats,level)
    A = [];
    if repeats > 1
        A =  hex2dec('10000000') + (level)*2^26 + uint16(repeats)*2^16 + vectors;
    end
end
function A = AddEndVector()
    A =  hex2dec('70000000');
end
