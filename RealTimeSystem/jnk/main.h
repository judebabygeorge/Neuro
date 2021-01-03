#ifndef MAIN_H_
#define MAIN_H_

#include <cslr_dev.h>
#include <cslr_gpio.h>


typedef volatile CSL_DevRegs             *CSL_DevRegsOvly;


extern CSL_GpioRegsOvly gpioRegs;

void SetSegment(int Channel, int Segment);
void ClearChannel(int Channel);
void UploadSine(int Channel, int Amplitude, int Period, int Repeats, int Threshold);

void SetupTrigger();

void AddLoop(int Channel, int Vectors, int Repeats);
int AddDataPoint(int Channel, int duration, int value);




#endif /*MAIN_H_*/
