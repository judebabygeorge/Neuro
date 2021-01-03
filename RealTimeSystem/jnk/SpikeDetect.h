
#ifndef SPIKE_DECTECT_H
#define SPIKE_DETECT_H

#include "global.h"
#include "typedef.h"


#include "FindThreshold.h"
#include "SendData.h"


#define SPD_DEADTIME    30*50                ; //(Number pf Samples)30ms

#define MAX_SPIKE_LIST 64

#define POST_DETECT_LEN 64

struct SpikeInfo {
	Uint8  Channel     ; //Channel in which spike detected
	Uint8  type        ; //TypeofSpike (After Sorting)
	Uint16 trigger_id  ; //Location in the buffer where threshold crossed
	Uint32 time        ; //Time of occurrence
};

typedef struct SpikeInfo SpikeInfo ;

struct SpikeList{
  Uint32 Count    ;
  Uint32 Missed_A ;
  Uint32 Missed_B ;
  Uint32 write_id ;
  Uint32 read_id  ;
  Uint32 dummy_dwordalign ;

  SpikeInfo uSpikeInfo[MAX_SPIKE_LIST];
  Uint32 wait_for_acq[MAX_SPIKE_LIST];
};

typedef struct SpikeList SpikeList ;

void SpikeDetect_Setup();
void sdp_DummyCall();
void SpikeDetect();
void SendSpikeBuffer();
void setThresholdParams(Uint32 * restrict param_ptr , Uint32  Count);
void setCommonThresholdParams(Int16 Threshold , Int16 Mean);
void SpikeDetect_Slope();
void AddToSpikeList(Uint8 Channel);
void RemoveTopFromSpikeList(Uint32 Count);
void SendSpikeSegment();
void SendSpikeSegments();
void CopyToSpikeSegment(Uint32 SpikeListIndex);
void SendSpikeSegments2(Uint32 send);
extern Uint32 spd_LastCross[CHANNELS_FOR_CALC]        ;
#endif
