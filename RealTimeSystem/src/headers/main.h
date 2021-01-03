#ifndef MAIN_H_
#define MAIN_H_

#include <cslr_dev.h>
#include <cslr_gpio.h>


typedef volatile CSL_DevRegs             *CSL_DevRegsOvly;


extern CSL_GpioRegsOvly gpioRegs;

void SetSegment0(int Channel, int Segment);
void ClearChannel0(int Channel);
void UploadSine0(int Channel, int Amplitude, int Period, int Repeats, int Threshold);

void SetupTrigger0();

void AddLoop0(int Channel, int Vectors, int Repeats);
int AddDataPoint0(int Channel, int duration, int value);




#endif /*MAIN_H_*/
