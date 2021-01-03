
#include "mex.h"
#include <math.h>
#include <stdio.h>


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    
    
    //SpikeTimes SpikeCount SpikeData
    
    
    double  *spikeTimes , *spikeCount , *SpikeEncode;            

    int numChannels ;
    int i , j , k  , l;
    unsigned int id1,id2 ;
    unsigned int x ; 
    
    spikeTimes   = mxGetPr(prhs[0]);
    
    spikeCount   = mxGetPr(prhs[1]);
    numChannels  = mxGetM(prhs[1]) ;
    
    SpikeEncode = mxGetPr(prhs[2]);
    
    //mexPrintf("SIZE : %d\n",mxGetM(prhs[2])*mxGetN(prhs[2]));
    k = 0 ; 
    for(i=0;i<numChannels;i++){
        id1 = i/32      ;
        id2 = i%32;
        id2 = (1<<id2) ;
        
        
        for(j=0;j<spikeCount[i];j++){
          l = ((unsigned int)spikeTimes[k])*4+id1;
          //mexPrintf("\nCh%d : %d :  %d %d",i,l,id1,id2);
          //mexPrintf("%d ",l);
          //if(l>=(50000*120)){
          //    mexPrintf("\nERROR !\n");
         // }
          x = (unsigned int)SpikeEncode[l] ; 
          //mexPrintf("%d ",x);
          x  |= id2 ;    
          //mexPrintf("%d \n",x);
          SpikeEncode[l]  = (double)x;
          k++;
        }        
    }   

}
