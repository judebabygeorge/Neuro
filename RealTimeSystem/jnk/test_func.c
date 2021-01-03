
#include "global.h"
#include "typedef.h"

void SpikeDetect_Slope_Chk(Uint32 adc_intern_id,Uint32 current_time,Uint32 spd_deadtime){

   #define SLOPE_CALC_OFFSET (96-20)

   Int16* restrict adc_p_c ;


   Int16* restrict thd_p  ;
   Uint32* restrict lst_cr_p  ;

   Uint32 i ;


   double * restrict SpikeData_ptr_i  ;

   Uint32 prev_id = adc_intern_id + SLOPE_CALC_OFFSET ;
   if(prev_id >= SAMPLE_STORE_LEN ) prev_id = prev_id - SAMPLE_STORE_LEN;

   Int16* restrict adc_p_p   ;

   _nassert(((int)(adc_p_c) & 0x7) == 0);
   _nassert(((int)(adc_p_p) & 0x7) == 0);
   _nassert(((int)(thd_p) & 0x7) == 0);
   _nassert(((int)(lst_cr_p) & 0x7) == 0);

   //Int32 Slope ;

    Uint32 lst_cr_x = current_time-spd_deadtime ;

	 //Finding Slope ?
	 for (i = 0 ; i < 120; i++){
		    Int32  Slope = adc_p_c[i] - adc_p_p[i] ;
		     if(lst_cr_p[i] < lst_cr_x){
				if((Slope >=  thd_p[2*i])&&(Slope < thd_p[2*i+1])){
					 lst_cr_p[i]= current_time ;
					 *SpikeData_ptr_i++ =  (_itod(0,i));
				}
		     }
     }



}
