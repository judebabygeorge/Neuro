function spike_times = detect_spikes_th(raw_data,Threshold,t,dt,deadTime,last_spike)
%DETECT_SPIKES Detect spikes using a threshold on the raw data
%   Inputs : Raw data , threshold to use direction to check
%   Output : Spike times
   
%     SD_scale = 5;
%     switch polarity
%         case 'negative'        
%             Threshold = m - SD_scale*sd ;
%             temp=raw_data<Threshold;
%         case 'positive'           
%             Threshold = m + SD_scale*sd ;
%             temp=raw_data>Threshold;
%         case 'both'
%             Threshold = SD_scale*sd ;
%             temp=abs(raw_data)>Threshold;
%         case 'th'
%             Threshold = (SD_scale*sd)^4 ;
%             temp=raw_data>Threshold;
%     end
    
    temp = abs(raw_data)>Threshold;
    %temp = (raw_data<(-Threshold));
    
    spike_times = find(diff([0 ; temp])==1)*dt + (t - dt);
  
    %DeadTime
    if (deadTime > 0)
        spike_times = [last_spike;spike_times];
        agap=find(diff(spike_times)>deadTime)+1;
        spike_times = spike_times(agap);
    end
  
end

