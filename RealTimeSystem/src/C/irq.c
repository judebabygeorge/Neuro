#include <csl.h>
#include <cslr_tmr.h>
#include <cslr_gpio.h>
#include <cslr_chip.h>
#include <cslr_edma3cc.h>
#include <soc.h>
#include <c6x.h>

#include "global.h"
#include "main.h"
#include "timer.h"
#include "FindThreshold.h"
#include "SpikeDetect.h"
#include "SendData.h"
#include "Stim.h"
#include "OutputDecoder.h"

#include "irq.h"
#include "MEA21_lib.h"



extern Uint32 SendBuffer[80] ;
// Mailbox write interrupt
// use "#define USE_MAILBOX_IRQ" in global.h to enable this interrupt

#define STIM_STATUS_OFFSET  (4+60  )
#define SPIKE_DETECT_OFFSET (4+60+2)
#define DECODER_OUT_OFFSET  (4+60+2+4)


interrupt void interrupt8(void)
{
    Uint32 i;
    Uint32 addr;
    Uint32 Count ;
    Uint32 reg_written;
    Uint32 reg_value;


	reg_written = READ_REGISTER(0x428);
	reg_value   = READ_REGISTER(0x1000 + reg_written);

	// a write to a mailbox register occurred
    if(reg_written == 0 ){
       if(ExectueCommand_flag  == 0)
       ExectueCommand_flag = reg_value;
       //ExecuteCommand();
	}


}

// FPGA data available (do not use)
interrupt void interrupt4(void)
{
}

// I2C Interrupt
interrupt void interrupt5(void)
{
	//handle_i2c_commands();
}

// DMA finished Interrupt
interrupt void interrupt6(void)
{
	static int timestamp = 0; // exists only in this function but is created only once on the first function call (i.e. static)
	static int segment = 0;

    Uint32 Buff[60] ;
	Uint32 i;
	CSL_Edma3ccRegsOvly edma3ccRegs = (CSL_Edma3ccRegsOvly)CSL_EDMA3CC_0_REGS;

    double * restrict src_p ;
    double * restrict dst_p ;
	// Prepare DMA for next data transfer DO NOT CHANGE THE FOLLOWING LINE
	CSL_FINST(edma3ccRegs->ICRH, EDMA3CC_ICRH_I52, CLEAR);	// Clear pending interrupt for event 52

    timer_tic();
	// Write to AUX register to see how long interrupt takes (set output to high, at the end set output to low)
//	WRITE_REGISTER(0x0310, 0x1); // set AUX 1 to value one

    CopyDataToInternal(ADCDataShift); // This Copies to DMA buffer too

    SendBuffer[STIM_STATUS_OFFSET+0] = StimStatus[0] ; StimStatus[0] = -1 ;
    SendBuffer[STIM_STATUS_OFFSET+1] = StimStatus[1] ; StimStatus[1] = -1 ;

#if 1
    SendBuffer[SPIKE_DETECT_OFFSET+0] = SpikeChannel[0] ;
    SendBuffer[SPIKE_DETECT_OFFSET+1] = SpikeChannel[1] ;
    SendBuffer[SPIKE_DETECT_OFFSET+2] = SpikeChannel[2] ;
    SendBuffer[SPIKE_DETECT_OFFSET+3] = SpikeChannel[3] ;
#endif

    dst_p = (double *)(&SendBuffer[DECODER_OUT_OFFSET]);
    if(DecoderOutputValid==1){
       src_p = (double *)(&uDecoderOutput_compressed[0]);
       for(i=0;i<5;i++){
        *dst_p++ = *src_p++ ;
       }
       DecoderOutputValid=0;
    }else{
       SendBuffer[DECODER_OUT_OFFSET]   = 0 ;
    }

#if 0
    src_p = (double *)(&Decoder_V[0]);
    for(i = 0 ; i < 5 ; i++){
       *dst_p++ = *src_p++ ;
    }
#endif

    SendDataDMA();

    #ifdef PROCESS_IN_DSP
    SpikeDetect();
    update_decoder_state();
    //update_decoder_state_2();
    #endif


    //do_scaling();

    StimCheck_flag=1;


    if (timestamp == 0)
    {
		WRITE_REGISTER(0x002C, 0x404); //switch on HS2 LED
    }
	else if (timestamp == 50000)
	{
		WRITE_REGISTER(0x002C, 0x400); //switch off HS2 LED
    }
    else if (timestamp == 100000)
    {
	    timestamp =-1;
    }

//	WRITE_REGISTER(0x0310, 0x0); // set AUX 1 to value zero


	timestamp++;
    current_time++ ;
    i = timestamp - frame_sync; //Align to frameSync

if(ExecutionMode==1){
    i = i%(50*250) ;
    if(i == 0){ //Trigger every 250ms
        RobotComm_flag = 1 ;

    }else if(i==50*5){ //Read gpio for sensor 1
        RobotComm_flag = 2 ;
    }
    else if(i==50*15){ //Read gpio for sensor 2
        RobotComm_flag = 3 ;
    }
    else if(i==50*25){ //Stimulate
        RobotComm_flag = 4 ;
    }
}else if (ExecutionMode==2){
    i = i%(50*250) ;
    if(i==0){
        StimTrain_flag = 1;
    }
}


    if(DecoderCheck > 1) DecoderCheck--;

    last_timer_count = timer_toc() ;
}


// timer irq
interrupt void interrupt7(void)
{
	static int led = 0;
	CSL_FINS(gpioRegs->OUT_DATA, GPIO_OUT_DATA_OUT2, led); // LED
	led = 1 - led;
}
