#include "mex.h"
#include <math.h>
#include <stdio.h>

//DEAD_TIME = 2.5ms
#define SPIKE_DEAD_TIME (125)
#define STIM_DEAD_TIME  (250)

//PRE_SPIKE 0.72ms
#define PRE_SPIKE  36

//POST_SPIKE 1.52ms
#define POST_SPIKE 76

//MAX SPIKE AMPLITUDE 
#define MAX_SPIKE_AMPLITUDE 2000

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    
    //Find  the arguments
    //Data, Threshold ,  last_spike
    //spikeTimes,Spikecount
    //StimTimes
    
    double  *rawData ,*Threshold,*last_spike,*StimTimes,*param;
    double  *spikeTimes , *spikeCount ;
            
    double val ;
    int numSamples , numChannels ;
    int i , j , counter , nSpikes , counter_max,totalSpikes;
    double max_val ; int max_idx  , max_idx_find ;
    int max_spikes;
    int nStim , StimId ;
    double *ptr ;
    
    
    numSamples = mxGetM(prhs[0]);
    numChannels= mxGetN(prhs[0]);
    rawData    = mxGetPr(prhs[0]); 
    
    Threshold   = mxGetPr(prhs[1]);
    last_spike  = mxGetPr(prhs[2]);
    
    spikeTimes = mxGetPr(prhs[3]);
    max_spikes = mxGetM(prhs[3]) ;
    
    spikeCount = mxGetPr(prhs[4]);
    
    StimTimes  = mxGetPr(prhs[5]);
    nStim      = mxGetM(prhs[5]) ;
    
    totalSpikes = 0 ;
    
    
    for(j = 0 ;j < numChannels;j++){        
        nSpikes      = 0 ;  
        ptr          = &(rawData[j*numSamples]) ;
        
        counter = (int)last_spike[j] ;
        
        /*
        counter = numSamples - counter ;
        
        if(counter > DEAD_TIME){
            counter = 0  ;             
        }else{
            counter = DEAD_TIME - counter ;
        }
        last_spike[j] = 0 ;        
        if(counter > 0){
            if(counter > PRE_SPIKE) counter = counter - PRE_SPIKE;
            else                    counter = 0 ;
        }
        */
        
        max_idx_find=-1;
        
        StimId = 0 ;
        for(i = PRE_SPIKE  ; i < numSamples - 2*POST_SPIKE ; i++){
            
            if(StimId < nStim){
                if(StimTimes[StimId] < i){
                    //if(j==0)    mexPrintf("Detect off @ %d\n",i);
                    counter = STIM_DEAD_TIME;
                    StimId++ ;
                }
            }
            
            val =   (ptr[i] < 0) ? -ptr[i] : ptr[i] ;
            
            if(max_idx_find > 0){
                //mexPrintf("D.");
                if(val > max_val){
                    max_idx = i ;
                    max_val =val;
                }
                max_idx_find-- ;
            }
            if(max_idx_find == 0){
               // mexPrintf("S");
                if(totalSpikes < max_spikes){
                  
                    if(max_val < MAX_SPIKE_AMPLITUDE){
                      //if(j==90)  mexPrintf("SpikeDetected %d(%d) (%f,%f)\n",max_idx,i,max_val,Threshold[j]);                         
                      nSpikes++                 ;  
                      spikeTimes[totalSpikes++]=max_idx ;
                    }
                       
                }
                max_idx_find--;
            }
            
            if(counter > 0){
                counter--  ;
            }
            else{
                if(val > Threshold[j]){
                    counter      = SPIKE_DEAD_TIME  ;
                    //mexPrintf("\nStart Detect !");
                    max_idx_find = POST_SPIKE ; 
                    max_idx      = i          ;
                    max_val      = val        ;
                    
                }                
            }
            
            
        }
        last_spike[j] = (double)counter;
        spikeCount[j] = nSpikes ;
        
        //mexPrintf("\n Channel %d : Spikes %d\n",j,nSpikes);
    }
 
    
    //mexPrintf("\n\n %d Spikes Detected ! (%f)\n", nSpikes,Threshold);

}
