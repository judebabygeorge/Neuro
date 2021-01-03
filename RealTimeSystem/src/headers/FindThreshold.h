

#ifndef FINDTHRESHOLD_H
#define FINDTHRESHOLD_H

#include "global.h"
#include "typedef.h"
#include "MEA21_lib.h"


#define THRESHOLD_ACCUM_LEN 50000

struct ThresholdParams {
	Int32 Mean      ;
	Int32 Std       ;
	Int32 Threshold ;
};

typedef struct ThresholdParams ThresholdParams ;


/*
  0=>-ve threshold
  1=>+ve threshold
  2=>both
 */

typedef enum {
   negative,positive,both,neo
} ThresholdModes ;

extern Uint32 ThresholdData[CHANNELS_FOR_CALC] ;
extern ThresholdModes ThresholdMode ;
/*
    Loop gets data from the mea data buffer
    Indicates that the work is done with a return value of 0 (1=> Still Accumlating Data)
 */

void CopyDataToInternal(unsigned char nShift);

extern ThresholdModes ThresholdMode ;
#endif
