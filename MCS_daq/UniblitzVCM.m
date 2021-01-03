classdef UniblitzVCM < handle
    %MPC200VCM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        PortID
        dev
    end
    
    methods
        function VCM   =  UniblitzVCM(Port)
           VCM.PortID = Port;      
           VCM.dev = [];            
        end
    
       
        function Stat = OpenVCM(VCM)
            Stat = false;
           try
            VCM.dev = serial(VCM.PortID);
            set(VCM.dev, 'BaudRate', 9600); %set to 9600 
            set(VCM.dev, 'DataBits', 8);
            set(VCM.dev, 'FlowControl', 'none');
            set(VCM.dev, 'Parity', 'none');
            set(VCM.dev, 'StopBits', 1);
            set(VCM.dev, 'Terminator', []);
            set(VCM.dev, 'Timeout',10); % long timeout allows large move commands to complete
            set(VCM.dev, 'Tag','UniblitzVCM');  
            %set(VCM.dev, 'InputBufferSize ',8192);  
            
            fopen(VCM.dev);

            catch exception
                fclose(VCM.dev);
                display('Could Not Open VCM')
            end
        end
        function delete(VCM)
           CloseVCM(VCM);
        end 
        function CloseVCM(VCM)
             if ~isempty(VCM.dev)
                fclose(VCM.dev);
            end
        end
        function V = Open(VCM)
            fprintf(VCM.dev,'@');
        end
        function V = Close(VCM)
            fprintf(VCM.dev,'A');
        end
		function V = Trigger(VCM)
            fprintf(VCM.dev,'B');
        end
		function V = Reset(VCM)
            fprintf(VCM.dev,'C');
        end
		function V = AUX(VCM,Mode)
			if(Mode==1)
				fprintf(VCM.dev,'D');
			else
				fprintf(VCM.dev,'E');
			end
        end
		function V = Gate(VCM,Mode)
			if(Mode==1)
				fprintf(VCM.dev,'F');
			else
				fprintf(VCM.dev,'G');
			end
        end
    end
    
end

