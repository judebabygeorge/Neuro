
#include "mex.h"
#include <math.h>
#include <stdio.h>


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    
    
    //SpikeTimes SpikeCount SpikeData
    
    
    double  *spikeTimes , *spikeCount , *SpikeEncode;            

    int numChannels , numSamples ;
    int i , j , k  , l;
    unsigned int id1,id2 ;
    unsigned int Chid;
    unsigned int x ; 
    
    unsigned int maxSpikes , nCh; 
    unsigned int *Offsets  ;
    spikeTimes   = mxGetPr(prhs[0]);
    maxSpikes    = mxGetM(prhs[0]);
    
    spikeCount   = mxGetPr(prhs[1]);
    numChannels  = mxGetM(prhs[1]) ;
    
    SpikeEncode = mxGetPr(prhs[2]);
    numSamples  =  mxGetN(prhs[2]) ;
    //mexPrintf("SIZE : %d\n",mxGetM(prhs[2])*mxGetN(prhs[2]));
    
     
    
    Offsets = (unsigned int *) mxCalloc(numChannels,sizeof(unsigned int));
    
    
    for(i=0;i<numChannels;i++){
        spikeCount[i] = 0;
    }
    for(i = 0 ; i < numSamples ; i++){
      for(j=0;j<4;j++){
          x = SpikeEncode[i*4 + j] ;           
          if(x !=0){         
             // mexPrintf("Not 0 %d!\n",j);
              for(k=0;k<32;k++){
                  id2 = (1<<k);
                  if((x & id2)!=0){
                    //  mexPrintf("%d:%d %d\n",j,k,j*32+k);
                      Offsets[j*32 + k]++ ;                      
                  }
              }
          }
      }
    }
    
    //for(i=0;i<numChannels;i++)
    //    mexPrintf("S : %d:%d \n",i,Offsets[i]);
    
    j = 0 ; k = 0 ;
    nCh = 0 ;
    for(i=0;i<numChannels;i++){
        k = j ; 
        j = j + Offsets[i];
        if(j>=maxSpikes){
          mexPrintf("ERROR : Number of Spikes(%d) > Space(%d)\n Truncating ...",j,maxSpikes);         
          break;
        }
        nCh++;
        Offsets[i]= k;
    }
    

         
  //  for(i=0;i<numChannels;i++)
  //      mexPrintf("S : %d:%d \n",i,Offsets[i]);  
    
    for(i = 0 ; i < numSamples ; i++){
      for(j=0;j<4;j++){
          x = SpikeEncode[i*4 + j] ; 
          if(x !=0){              
              for(k=0;k<32;k++){
                  id2 = (1<<k);
                  if((x & id2)!=0){
                      Chid = j*32+k ;
                      
    //                  mexPrintf("Not 0 %d(%d)!\n",Chid,i);
                      if(Chid <= nCh){
                        spikeTimes[Offsets[Chid]] = i;
                        Offsets[Chid]++ ;
                        spikeCount[Chid]++ ;
                      }
                  }
              }
          }
      }
    }
    
    //for(i=0;i<numChannels;i++)
    //    mexPrintf("C : %d:%d \n",i,spikeCount[i]);
    

    
}
