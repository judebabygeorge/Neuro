
function ProcessInfo = ProcessInfo_Setup

           %State Decoding
           % 0 : idle
           % 1 : Estimating Parameters
           % 2 : Spike Detection (Finding Segments for Sorting )
           % 3 : Spike Detection and Sorting based on templates
           
           ProcessInfo.State = 0 ;  
           global Select_Headstage
           if  Select_Headstage==1
               ProcessInfo.nC = 120;                
           else
               ProcessInfo.nC = 60;    
           end
           
           ProcessInfo.ThresholdFrameCounter = 10 ;
           ProcessInfo.ThresholdParameters = zeros(ProcessInfo.ThresholdFrameCounter,ProcessInfo.nC);
        
           [b,a]=ellip(2,0.1,40,[300 3000]*2/50e3);
           ProcessInfo.filterparam.a = a;
           ProcessInfo.filterparam.b = b;
           ProcessInfo.zf = zeros(max(length(a),length(b))-1,ProcessInfo.nC);

           ProcessInfo.Thresholds          = zeros(ProcessInfo.nC,1);
           ProcessInfo.ThresholdBase       = zeros(ProcessInfo.nC,1);
           ProcessInfo.ThresholdVar        = zeros(ProcessInfo.nC,1);
           
           ProcessInfo.t = 0 ;
           ProcessInfo.t_step = 1 ;
           ProcessInfo.dt = 20e-6 ;
           
           pre_spike  = 0.72e-3 ;
           post_spike = 1.52e-3 ;
           
           
           ProcessInfo.pre_spike = uint32(pre_spike/ProcessInfo.dt) ;
           ProcessInfo.post_spike= uint32(post_spike/ProcessInfo.dt);
           ProcessInfo.segment_length = ProcessInfo.pre_spike+ProcessInfo.post_spike;

           %Create Spike Data structure
           
           ProcessInfo.SpikeData.Spikes{ProcessInfo.nC} = [];
           
           ProcessInfo.max_spikes  = 10000 ;
           ProcessInfo.get_segments= 1     ;
           ProcessInfo.last_spike_time = zeros(ProcessInfo.nC,1);
           for i=1:ProcessInfo.nC
               ProcessInfo.SpikeData.Spikes{i}.spike_times   = zeros(1,ProcessInfo.max_spikes);
               ProcessInfo.SpikeData.Spikes{i}.spike_count   = 0 ;
               ProcessInfo.SpikeData.Spikes{i}.Threshold     = 0 ;
               ProcessInfo.SpikeData.Spikes{i}.temp          = 0 ;
               ProcessInfo.SpikeData.Spikes{i}.spike_count_c = 0 ;
               
               if(ProcessInfo.get_segments == 1)
                  ProcessInfo.SpikeData.Spikes{i}.spike_segments = zeros(ProcessInfo.segment_length,ProcessInfo.max_spikes);  
               end  
               
           end
           
           ProcessInfo.spike_times = zeros(10000,1);
           ProcessInfo.spikeCounts = zeros(ProcessInfo.nC,1);
                        
end
