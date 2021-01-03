#include "MEA21_lib.h"



// the followign two lines create a variable in the external RAM
unsigned int ddr_data[1000000]; 
#pragma DATA_SECTION (ddr_data, ".dataddr");


Int16  adc_intern[CHANNELS_FOR_CALC*SAMPLE_STORE_LEN];

#pragma DATA_ALIGN(adc_intern, 8);


int threshold;
int deadtime;

Uint32 StimulusEnable[2];
Uint32 DAC_select[4]    ;
Uint32 elec_config[4]   ;

Uint32 current_time     ;
Uint32 adc_intern_id    ;
Uint32 Debug_Data[8]    ;
Uint32 last_timer_count ;


Uint32 StimulusEnable[2];
Uint32 DAC_select[4];
Uint32 elec_config[4];

