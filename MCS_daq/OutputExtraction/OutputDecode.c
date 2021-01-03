
#include "mex.h"
#include <math.h>
#include <stdio.h>


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    
    
    //Time:Config , Time:Status , StimEncoded
    
    
    double  *OutEncoded ;
    
    int  numSamples , numDecoders;
    int i , j , k  , l;
    
    int DecodeCount ;
    
    double *ptr1 ;
    OutEncoded   = mxGetPr(prhs[0]);
    numDecoders   = mxGetM(prhs[0]) ;
    numSamples    = mxGetN(prhs[0]) ;    
    
    DecodeCount = 0 ;
    for(i = 0 ; i < numSamples ; i++){
        if(OutEncoded[numDecoders*i] !=0  ) DecodeCount++ ;
    }    
    
    //mexPrintf("NumDecodeCount : %d\n",DecodeCount);
    
    plhs[0] = mxCreateDoubleMatrix(numDecoders+1, DecodeCount, mxREAL);
    
    ptr1 = mxGetPr(plhs[0]);
    
    for(i = 0 ; i < numSamples ; i++){
        if(OutEncoded[numDecoders*i] !=0) {
            *ptr1++ = i ;
            for(j=0;j<numDecoders;j++)
                *ptr1++ = OutEncoded[numDecoders*i+j];
        }
    }
}

