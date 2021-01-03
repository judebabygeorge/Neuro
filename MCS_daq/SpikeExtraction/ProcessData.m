
%                  zf = DS.ProcessInfo.zf ;
%                  [Data,zf] = filter(DS.ProcessInfo.filterparam.b,DS.ProcessInfo.filterparam.a,Data,zf);
%                  DS.ProcessInfo.zf= zf;          
                 
                 if(DataProcessMode==1)
                                 Data = CubicFitFilter(Data);
                                 DS.ProcessInfo.spikeCounts = zeros(size(DS.ProcessInfo.spikeCounts));
                 end
                 switch(DS.ProcessInfo.State)
    
                    case 0 % Start Threshold Estimation
                        display('Starting Threshold Estimation')
                        % Switch to Threshold Estimate Mode
                        DS.ProcessInfo.State = 1 ;
                        DS.ProcessInfo.ThresholdFrameCounter = size(DS.ProcessInfo.ThresholdParameters,1);
                        
                        %th= calculate_threshold_sd (Data);
                        th= calculate_threshold_max (Data);
                        DS.ProcessInfo.ThresholdParameters(DS.ProcessInfo.ThresholdFrameCounter,:)=th;

                    case 1 % Threshold Estimate Complete

                        DS.ProcessInfo.ThresholdFrameCounter = DS.ProcessInfo.ThresholdFrameCounter - 1;

                        %display(['Threshold Estimation ' num2str(DS.ProcessInfo.ThresholdFrameCounter)]);

                        %th= calculate_threshold_sd (Data);
                        th= calculate_threshold_max (Data);
                        DS.ProcessInfo.ThresholdParameters(DS.ProcessInfo.ThresholdFrameCounter,:)=th;

                        if(DS.ProcessInfo.ThresholdFrameCounter == 1)
                            display('Threshold Estimation Complete');
                            DS.ProcessInfo.ThresholdFrameCounter = 0 ;
                            th = sort(DS.ProcessInfo.ThresholdParameters) ;
                            th = mean(th(1:5,:));
                            th = th';
                            DS.ProcessInfo.ThresholdBase = th;
                            DS.ProcessInfo.ThresholdVar  = 0*DS.ProcessInfo.ThresholdVar;
                            DS.ProcessInfo.Thresholds = DS.ProcessInfo.ThresholdBase + DS.ProcessInfo.ThresholdVar ;
                            DS.ProcessInfo.State = 2 ;  
                        end
                    case 2
                        if(DataProcessMode==1)
                           DS.ProcessInfo.State = 3 ; 
                        else
                           DS.ProcessInfo.State = 4 ; 
                        end
                    case 3 % Spike Detection Mode
                        %Filtered data is available in Data
                        t  = DS.ProcessInfo.t;
                        dt = DS.ProcessInfo.dt;
                        segment_length=DS.ProcessInfo.segment_length;
                        pre_spike=DS.ProcessInfo.pre_spike;
                        get_segments=DS.ProcessInfo.get_segments;
                        DS.ProcessInfo.t = DS.ProcessInfo.t + DS.ProcessInfo.t_step;

                        DS.ProcessInfo.ThresholdVar = DS.ProcessInfo.ThresholdVar.*exp(-1/5) ;
                        DS.ProcessInfo.Thresholds = DS.ProcessInfo.ThresholdBase + DS.ProcessInfo.ThresholdVar ;
                        
                        SpikeDetect(Data,DS.ProcessInfo.Thresholds, DS.ProcessInfo.last_spike_time,DS.ProcessInfo.spike_times,DS.ProcessInfo.spikeCounts,StimConfig(1,:)');

                        
                 end

     
    
    