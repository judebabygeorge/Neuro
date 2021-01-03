
#include <math.h>
#include "FindThreshold.h"



ThresholdParams uThresholdParams[CHANNELS_FOR_CALC] ;
#pragma DATA_ALIGN(uThresholdParams, 8);

/*Format of Storage*/
/*
 * Threshold value and mean is required for spike detection
   So these need to be close
   Variance is required only for calculation of threshold
   So the arrangement is as follows

  Algorithm would calculate mean first then using this mean calculate standard deviation
  Then mean and   std is used to calculate threshold and is stores
  Hence 2N words would have [Mean , Std/Threshold]XN
  Threshold would replace Std in the final step
 */

Uint32 ThresholdData[CHANNELS_FOR_CALC] ;
#pragma DATA_ALIGN(ThresholdData, 8);


ThresholdModes ThresholdMode ;

void CopyDataToInternal(){

	Uint32 i;

	adc_intern_id = adc_intern_id + 1 ;
	if(adc_intern_id >=SAMPLE_STORE_LEN) adc_intern_id = 0 ;

	double* restrict HS_Data_p = (double *)&MeaData[HS1_DATA_OFFSET];
	Uint32* restrict adc_i_p1   =(Uint32 *)&adc_intern[adc_intern_id*CHANNELS_FOR_CALC];
	//double* restrict adc_i_p1   =(double *)&adc_intern[adc_intern_id*CHANNELS_FOR_CALC];
	//Uint32* restrict adc_i_p1   =(Uint32 *)&adc_intern[0];
	_nassert(((int)(adc_i_p1) & 0x7) == 0);
	_nassert(((int)(HS_Data_p) & 0x7) == 0);


	for(i = 0 ; i <  CHANNELS_FOR_CALC/2 ;i++){
			adc_i_p1[i] =  _pack2(_hi(HS_Data_p[i]),_lo(HS_Data_p[i]));
		}

    /*
	for(i = 0 ; i <  CHANNELS_FOR_CALC/4 ;i++){
		adc_i_p1[i] = _itod(_pack2(_hi(HS_Data_p[2*i+1]),_lo(HS_Data_p[2*i+1])),_pack2(_hi(HS_Data_p[2*i]),_lo(HS_Data_p[2*i])));
	}
	*/

}
void testfn2(){
	Uint32 i;

	Uint32* restrict adc_i_p1   =(Uint32 *)&adc_intern[0];
	_nassert(((int)(adc_i_p1) & 0x7) == 0);

	//Int32* restrict adc_i_p2 = &adc_intern[32];
	for(i = 0 ; i < 64 ;i++){
		adc_i_p1[i] =0;
	}
}

void Fth_ClearThresholdData(){
	Uint32 i;
	double * ptr = (double *)(&ThresholdData[0]);
			//Clear 2N words , N = CHANNEL_FOR_CALC
	for(i = 0 ; i < CHANNELS_FOR_CALC/2;i++){
		ptr[i] = 0;
	}
}

Uint32 FindThreshold(Uint32 start){

   static Uint32 SampleCount ;

   Uint32 SamplesForMean = THRESHOLD_ACCUM_LEN ;  //1 sec Data to estimate mean and std @50kHz sampling
   Uint32 SamplesForStd  = THRESHOLD_ACCUM_LEN ;
   Int32  ThresholdScale = 10    ;

   Int16* restrict adc_i_p = &adc_intern[0]; // we create here a pointer for compiler optimization reasons

   Uint32 i;

   SamplesForStd+=SamplesForMean ; //Sample Number to calculate std;


   if(start==1){
	   SampleCount = 0 ;
	   //Clears arrays
	   Fth_ClearThresholdData();
   }
   if(start==2){
	   SampleCount = 49999;
   }
   if(start==3){
  	   SampleCount = 50001;
   }
   if(start==4){
    	   SampleCount = 99999;
   }
   SampleCount++ ;


   if(SampleCount <= SamplesForMean) {
	   //Add data to mean accumulator
	   for(i = 0 ; i < CHANNELS_FOR_CALC ;i++){
	  				   ThresholdData[2*i] += adc_i_p[i] ;
	   }

	   if(SampleCount == SamplesForMean) {
		   //Calculate Mean
		   for(i = 0 ; i < CHANNELS_FOR_CALC ;i++){
			   ThresholdData[2*i] = ThresholdData[2*i]/SamplesForMean ;
		   }
	   }
   }
   else{
	   //Add data to variance accumlator
	   	   for(i = 0 ; i < CHANNELS_FOR_CALC ;i++){
	   		   Int32 Var ;
	   		   Var = adc_i_p[i];
	   		   Var = Var - ThresholdData[2*i]; //Subtract Mean
	   		   Var = Var*Var                 ; //Square
	   		   ThresholdData[2*i+1] += Var ;//Add to total
	   	   }
	   	   if(SampleCount == SamplesForStd) {
	   		   //Calculate Std
	   		   for(i = 0 ; i < CHANNELS_FOR_CALC ;i++){
	   			ThresholdData[2*i+1] = sqrt(ThresholdData[2*i+1]/(SamplesForMean-1)) ;
	   		   }
	   	   }
   }
   //Calculate the threshold
   if(SampleCount == SamplesForStd){
       if(ThresholdMode == negative) ThresholdScale = ThresholdScale*-1 ;
       for(i = 0 ; i < CHANNELS_FOR_CALC ;i++){
    	   ThresholdData[2*i+1]  = ThresholdData[2*i]  + ThresholdData[2*i+1]  ;
       }
   }

   if(SampleCount == SamplesForStd) return 0 ;
   else return  1 ;

}


