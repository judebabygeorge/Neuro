#include "SpikeDetect.h"
void NEO(void *ptr_data,void *ptr_th,void *ptr_thc,void *str){

   Uint32 i ;

   Int16* restrict adc_p   = (Int16 *)ptr_data;
   Int16* restrict thd_p   = (Int16 *)ptr_th;
   Uint32* restrict lst_cr_p = (Uint32 *)ptr_thc;

   //Int32* restrict
   //Uint32 nSpikes  ; //Number of Spikes



   //Uint32 * restrict SpikeData_ptr = &SpikeData[0] ;

    double * restrict SpikeData_ptr_i = (double *)str;

   _nassert(((int)(adc_p) & 0x7) == 0);
   _nassert(((int)(thd_p) & 0x7) == 0);
   _nassert(((int)(lst_cr_p) & 0x7) == 0);


   Uint32 lst_cr_x = 10 ;//current_time-30 ;
   Uint32 nV       = *(lst_cr_p+10);

	   for (i = 0 ; i < CHANNELS_FOR_CALC; i++){
           if((lst_cr_p[i] > lst_cr_x) && (adc_p[i] > thd_p[i])){
			lst_cr_p[i]=nV;
			*SpikeData_ptr_i++ = (_itod(0,i));
           }
			//lst_cr_p++;
            //adc_p++;

	   }
}
