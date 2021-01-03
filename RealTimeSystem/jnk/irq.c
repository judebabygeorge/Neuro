#include <csl.h>
#include <cslr_tmr.h>
#include <cslr_gpio.h>
#include <cslr_chip.h>
#include <cslr_edma3cc.h>
#include <soc.h>
#include <c6x.h>

#include "main.h"
#include "irq.h"
#include "MEA21_lib.h"

#include "FindThreshold.h"
#include "SpikeDetect.h"
#include "SendData.h"
#include "timer.h"

int num_tr_cross[HS1_CHANNELS/2];
int last_tr_cross[HS1_CHANNELS/2];

Uint32 reg_written;
Uint32 reg_value;

// Mailbox write interrupt
// use "#define USE_MAILBOX_IRQ" in global.h to enable this interrupt
interrupt void interrupt8(void)
{
	reg_written = READ_REGISTER(0x428);
	reg_value   = READ_REGISTER(0x1000 + reg_written);

	// a write to a mailbox register occurred
	if(reg_written == 0 ){ //For Setting Common Threshold
		setCommonThresholdParams((reg_value&0x0000FFFF),(reg_value&0xFFFF0000)>>16);
	}
	else if(reg_written == 1){
		Uint32 i;
		Uint32 Count = reg_value ;
		//Using MonitorData Array as a scratchpad
		_nassert(Count&0x3==0);
		for(i=0;i<Count;i++){
             MonitorData[i] = READ_REGISTER(0x1000 + i);
		}
		setThresholdParams(&MonitorData[0],Count);
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

    static Int32 timestamp = 0 ;
    static int segment = 0;

    Uint32 i ;

	CSL_Edma3ccRegsOvly edma3ccRegs = (CSL_Edma3ccRegsOvly)CSL_EDMA3CC_0_REGS;
	// Prepare DMA for next data transfer DO NOT CHANGE THE FOLLOWING LINE
	CSL_FINST(edma3ccRegs->ICRH, EDMA3CC_ICRH_I52, CLEAR);	// Clear pending interrupt for event 52
    // 
    

	// Write to AUX register to see how long interrupt takes (set output to high, at the end set output to low)
	WRITE_REGISTER(0x0310, 0x1); // set AUX 1 to value one

	//timer_tic();

	current_time++ ;
    timestamp++;


	CopyDataToInternal();
	WRITE_REGISTER(0x0310, 0x0); // set AUX 1 to value one
	SpikeDetect();
	WRITE_REGISTER(0x0310, 0x1); // set AUX 1 to value one
    //last_timer_count = timer_toc();

	SendDataDMA();




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
/*
                    int enable;
		        	int mux;
		        	int config;


		    		StimulusEnable[0] = 0;
		    		StimulusEnable[1] = 0;

		    		DAC_select[0] = 0;
		    		DAC_select[1] = 0;
		    		DAC_select[2] = 0;
		    		DAC_select[3] = 0;

		    		elec_config[0] = 0;
		    		elec_config[1] = 0;
		    		elec_config[2] = 0;
		    		elec_config[3] = 0;

		        	for (i = 0; i < HS1_CHANNELS/2; i++)
		        	{
		      			enable = 1;
		       			mux = 1; // Stimulation Source is DAC 1
		       			config = 0; // Use Sidestream 1 for Stimulation Switch

		        		StimulusEnable[i/30] |= (enable << i%30);
		        		DAC_select[i/15] |= (mux << 2*(i%15));
		        		elec_config[i/15] |= (config << 2*(i%15));
		           	}

		           	for (i = 0; i < 2; i++)
		           	{
		           		WRITE_REGISTER(0x9158+i*4, StimulusEnable[i]); // Enable Stimulation on STG
		    //			WRITE_REGISTER(0x8140+i*4, StimulusEnable[i]); // Enable hard blanking for Stimulation Electrodes
		           	}

		           	for (i = 0; i < 4; i++)
		           	{
		           		WRITE_REGISTER(0x9160+i*4, DAC_select[i]);  // Select DAC 1 for Stimulation Electrodes
		           		WRITE_REGISTER(0x9120+i*4, elec_config[i]); // Configure Stimulation Electrodes to Listen to Sideband 1
		           	}

		    		WRITE_REGISTER(0x0218, segment << 16);  // select segment for trigger 1
		    		WRITE_REGISTER(0x0214, 0x00010001);     // Start Trigger 1
		    		segment = 1 - segment; // alternate between segment 0 and 1
*/
	    }




    //CSL_FINST(edma3ccRegs->ESRH, EDMA3CC_ESRH_E53, SET);  // Trigger DMA event 53

	
	/*for (i = 0; i < HS2_CHANNELS; i++)
	{
		*adc_i_p++ = *HS2_Data_p++;
	}
	*/
	/*for (i = 0; i < IF_CHANNELS; i++)
	{
		*adc_i_p++ = *IF_Data_p++;
	}*/

   
	WRITE_REGISTER(0x0310, 0x0); // set AUX 1 to value zero

}


// timer irq
interrupt void interrupt7(void)
{
	static int led = 0;
	static int aux = 0;

	CSL_FINS(gpioRegs->OUT_DATA, GPIO_OUT_DATA_OUT2, led); // LED
	//WRITE_REGISTER(0x0310, aux); // set AUX value

	led = 1 - led;
//	interrupt6();
	//aux = 1 - aux;
}
