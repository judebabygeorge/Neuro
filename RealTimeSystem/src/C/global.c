#include "MEA21_lib.h"



// the followign two lines create a variable in the external RAM
unsigned int ddr_data[1000000];
#pragma DATA_SECTION (ddr_data, ".dataddr");

Int16 adc_intern_0[CHANNELS_FOR_CALC];
Int16 adc_intern_1[CHANNELS_FOR_CALC*SAMPLE_STORE_LEN];
Uint32 adc_intern_id    ;
#pragma DATA_ALIGN(adc_intern_0, 8);
#pragma DATA_ALIGN(adc_intern_1, 8);


int threshold;
int deadtime;

Uint32 StimulusEnable[2];
Uint32 DAC_select[4];
Uint32 elec_config[4];


Uint32 current_time     ;
Uint32 Debug_Data[8]    ;
Uint32 last_timer_count ;

Uint32 DataMode                   ;
Uint32 StimSequence_Enabled       ;
Uint32 StimPatternSequence_Enabled;

int    Stim_BlankingCounter ;
int    StimStatus[2] ;
unsigned int    SpikeChannel[4]    ;
#pragma DATA_ALIGN(SpikeChannel, 8);

volatile int    ExectueCommand_flag;
volatile int    StimCheck_flag     ;

volatile int    RobotComm_flag     ;
volatile unsigned int    RobotStimEnable    ;

volatile unsigned char    ADCDataShift  ;
volatile unsigned char    EnableAmpBlanking;

volatile unsigned int frame_sync;

volatile unsigned int ExecutionMode;

volatile unsigned int StimTrain_flag;
