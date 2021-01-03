
#include <math.h>


#include "FindThreshold.h"

extern Uint32 SendBuffer[];


ThresholdModes ThresholdMode ;

//#define ADC_SCALE(D,nShift) (((D>>nShift)&0x7FFF)|((D&80000)>>8))
#define ADC_SCALE(D,nShift) (((int)D)>>nShift)

void CopyDataToInternal(unsigned char nShift)
{

    Uint32 i;

    adc_intern_id = adc_intern_id + 1 ;
    if(adc_intern_id >=SAMPLE_STORE_LEN) adc_intern_id = 0 ;

    double* restrict HS_Data_p  = (double *)&MeaData[HS1_DATA_OFFSET];
    Int16* restrict HS_Data_q  = (Int16 *)&MeaData[HS1_DATA_OFFSET];
    Uint32* restrict adc_i_p0   = (Uint32 *)&adc_intern_0[0];
    Int16* restrict adc_i_p1    = &adc_intern_1[adc_intern_id];

    Uint32* restrict SendBuff_i   = (Uint32 *)&SendBuffer[4];

    _nassert(((int)(adc_i_p1) & 0x7) == 0);
    _nassert(((int)(adc_i_p0) & 0x7) == 0);
    _nassert(((int)(HS_Data_p) & 0x7) == 0);


    for(i = 0 ; i <  CHANNELS_FOR_CALC/2 ; i++)
    {
        //adc_i_p0[i] =  _pack2(_hi(HS_Data_p[i]),_lo(HS_Data_p[i]));
        adc_i_p0[i] =  _pack2(ADC_SCALE(_hi(HS_Data_p[i]),nShift),ADC_SCALE(_lo(HS_Data_p[i]),nShift));
        SendBuff_i[i] = adc_i_p0[i];
    }


/*
    //Copy yo Segment saver
    for(i = 0 ; i <  CHANNELS_FOR_CALC ; i++){
         *adc_i_p1 =HS_Data_q[2*i];
         adc_i_p1 += SAMPLE_STORE_LEN ;
    }
*/
}




