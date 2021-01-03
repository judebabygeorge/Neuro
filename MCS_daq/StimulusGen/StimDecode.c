
#include "mex.h"
#include <math.h>
#include <stdio.h>


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    
    
    //Time:Config , Time:Status , StimEncoded
    
    
    double  *StimEncoded ;           

    int  numSamples ;
    int i , j , k  , l;

    int ConfigCount ; 
    int EventCount  ;
    
    double *ptr1,*ptr2 ; 
    StimEncoded   = mxGetPr(prhs[0]);
    numSamples    = mxGetN(prhs[0]) ;    
    

    ConfigCount = 0 ; EventCount= 0 ;
    for(i = 0 ; i < numSamples ; i++){
        if(StimEncoded[2*i] !=-1) ConfigCount++ ;
        if(StimEncoded[2*i+1] !=-1) EventCount++ ;
    }
    
    //mexPrint("Events %d:%d\n",ConfigCount,EventCount);
    
    plhs[0] = mxCreateDoubleMatrix(2,ConfigCount, mxREAL);
    plhs[1] = mxCreateDoubleMatrix(2,EventCount , mxREAL);
    
    ptr1 = mxGetPr(plhs[0]);
    ptr2 = mxGetPr(plhs[1]);
    
        for(i = 0 ; i < numSamples ; i++){
        if(StimEncoded[2*i] !=-1) {
            *ptr1++ = i ;
            *ptr1++ = StimEncoded[2*i] ;
        }
        if(StimEncoded[2*i+1] !=-1){
            *ptr2++ = i ;
            *ptr2++ = StimEncoded[2*i+1] ;
        }
    }
}

