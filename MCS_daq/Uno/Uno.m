classdef Uno < handle
    %MPC200PAD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        PortID
        dev
    end
    
    methods
        function PAD   =  Uno(Port)
           PAD.PortID = Port;      
           PAD.dev = [];            
        end
    
       
        function Stat = OpenUno(PAD)
            Stat = false;
           try
            PAD.dev = serial(PAD.PortID);
            set(PAD.dev, 'BaudRate', 9600); %set to 9600 
            set(PAD.dev, 'DataBits', 8);
            set(PAD.dev, 'DataTerminalReady', 'on');
            set(PAD.dev, 'FlowControl', 'none');
            set(PAD.dev, 'Parity', 'none');
            set(PAD.dev, 'ReadAsyncMode', 'continuous');
            set(PAD.dev, 'RequestToSend', 'on');
            set(PAD.dev, 'StopBits', 1);
            set(PAD.dev, 'Terminator', 'LF');
            set(PAD.dev, 'Timeout',10); % long timeout allows large move commands to complete
            set(PAD.dev, 'Tag','LaunchPad');  
            %set(PAD.dev, 'InputBufferSize ',8192);  
            
            fopen(PAD.dev);
            V = PAD.getVersion();
            
            if(strcmp(V,'NeuroElController:1.0..'))
              display('Connected to Uno');  
            else
              display('PAD Communication failed'  );
              fclose(PAD.dev);
            end
            catch exception
                fclose(PAD.dev);
                display('Could Not Open PAD')
            end
        end
        function delete(PAD)
           ClosePAD(PAD);
        end 
        function ClosePAD(PAD)
             if ~isempty(PAD.dev)
                fclose(PAD.dev);
            end
        end
        function V = getVersion(PAD)
            PAD.FlushPort();
            fprintf(PAD.dev,'V');
            pause(0.1);
            V = fscanf(PAD.dev,'%s\n');
            display(V);
        end
        function RelaySetStat(PAD,RelayNumber,mode)
            try
                PAD.FlushPort();
                s=sprintf('Rm%d%d\n',RelayNumber,mode);
                fprintf(PAD.dev,s);
                pause(0.1);
                S = fscanf(PAD.dev,'%s\n');
                display(S);
            catch e
                display('PAD Error')
            end
        end
        function SwitchPWM(PAD,stat)
            try
                PAD.FlushPort();
                if(stat==true)
                  s=sprintf('PP\n');
                else
                  s=sprintf('Pp\n');  
                end
                fprintf(PAD.dev,s);
                pause(0.1);
                S = fscanf(PAD.dev,'%s\n');
                display(S);
            catch e
                display('PAD Error')
            end
                end
        function SwitchPWMFq(PAD,speed)
            try
                PAD.FlushPort();               
                s=sprintf('P%c\n',speed);               
                fprintf(PAD.dev,s);
                pause(0.1);
                S = fscanf(PAD.dev,'%s\n');
                display(S);
            catch e
                display('PAD Error')
            end
                end        
        function StepperSetStepDelay(PAD,delay)
            PAD.FlushPort();
            fprintf(PAD.dev,'Ss%d\n',delay);
            pause(0.1);
            S = fscanf(PAD.dev,'%s\n');
            display(S);
        end
        function StepperMove(PAD,steps)
            PAD.FlushPort();
            fprintf(PAD.dev,'Sm%d\n',steps);
            pause(0.1);
            S = fscanf(PAD.dev,'%s\n');
            display(S);
        end
        function FlushPort(PAD)
            while (PAD.dev.BytesAvailable > 0)
                    %d = fread(ROE.dev,ROE.dev.BytesAvailable,'uint8');
                    fread(ROE.dev,PAD.dev.BytesAvailable);
                    pause(0.05)
            end
        end
    end
    
end

