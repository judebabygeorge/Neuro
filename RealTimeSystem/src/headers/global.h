#ifndef GLOBAL_H_
#define GLOBAL_H_

#define PROCESS_IN_DSP

// #define USE_SIMULATOR
#define INIT_IRQ
#define USE_MAILBOX_IRQ

#include <csl.h>

#define I2C_BUFFER_SIZE 512

#define MONITOR_ARRAY   		256
#define SEND_BUFFER_SIZE        80

#define STIMULUS_VECTOR_SIZE 	10
#define SENDDATA_PER_FRAME 		64

#define DOWNSAMPLE         	1
#define FRAMES_PER_LOOP    	1

#define SAMPLE_STORE_LEN      96

#define CHANNELS_FOR_CALC     120

extern Int16 adc_intern_0[CHANNELS_FOR_CALC];
extern Int16 adc_intern_1[CHANNELS_FOR_CALC*SAMPLE_STORE_LEN];
extern Uint32 adc_intern_id ;

#ifndef PROCESS_IN_DSP
#define INCLUDE_HS1_DATA
//#define INCLUDE_HS2_DATA
#endif


//#define INCLUDE_IF_DATA

#ifdef PROCESS_IN_DSP
#define INCLUDE_HS1_FILTER_DATA
//#define INCLUDE_HS2_FILTER_DATA
#endif


//#define INCLUDE_DIGIO_DATA
//#define INCLUDE_STATUS_DATA

#define TOTAL_ANALOG_CHANNELS 256

extern Int32 adc_intern[TOTAL_ANALOG_CHANNELS];

extern unsigned int ddr_data[1000000]; // this makes the variable visible to all .c files that include global.h

extern int threshold;
extern int deadtime;


extern Uint32 StimulusEnable[2];
extern Uint32 DAC_select[4];
extern Uint32 elec_config[4];

extern Uint32 current_time  ;
extern Uint32 Debug_Data[8] ;
extern Uint32 last_timer_count ;
extern Uint32 DataMode;
extern Uint32 StimSequence_Enabled ;
extern Uint32 StimPatternSequence_Enabled;

extern int    Stim_BlankingCounter ;
extern int    StimStatus[2]        ;
extern unsigned int    SpikeChannel[4]      ;

extern volatile int    ExectueCommand_flag;
extern volatile int    StimCheck_flag     ;
extern volatile int    RobotComm_flag     ;
extern volatile unsigned int    RobotStimEnable    ;

extern volatile unsigned char    ADCDataShift       ;
extern volatile unsigned char    EnableAmpBlanking;

extern volatile unsigned int frame_sync;
extern volatile unsigned int ExecutionMode;
extern volatile unsigned int StimTrain_flag;

#define BASE 0xA000
#endif /*GLOBAL_H_*/
