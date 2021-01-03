#include <stdio.h>
#include <string.h>

#include <cslr_pllc.h>
#include <cslr_gpio.h>
#include <cslr_emifa.h>
#include <cslr_ddr2.h>
#include <cslr_dev.h>
#include <cslr_intc.h>
#include <cslr_chip.h>
#include <cslr_edma3cc.h>
#include <cslr_tmr.h>
#include <soc.h>

#include <math.h>

#include <c6x.h>

extern void intcVectorTable(void);

#include "global.h"
#include "main.h"
#include "version.h"
#include "MEA21_lib.h"

#include "SendData.h"
#include "SpikeDetect.h"
#include "Stim.h"
#include "StimPatterns.h"
#include "timer.h"
#include "OutputDecoder.h"
#include "RobotComm.h"
#include "StimTrain.h"

char dsp_version[] = "(>)"SW_STRING"(<)";


CSL_GpioRegsOvly gpioRegs = (CSL_GpioRegsOvly)CSL_GPIO_0_REGS;

#if 0
void timer_setup()
{
	CSL_TmrRegsOvly tmr1Regs = (CSL_TmrRegsOvly)CSL_TMR_1_REGS;

 	// clear TIM12 register
	CSL_FINST(tmr1Regs->TIMLO,TMR_TIMLO_TIMLO,RESETVAL);


	CSL_FINS(tmr1Regs->TCR, TMR_TCR_CLKSRC_LO, 0);

	// select 32 bit unchained mode and take the timer out of reset
	CSL_FINS(tmr1Regs->TGCR, TMR_TGCR_TIMMODE, 1);  // 32bit unchained
	CSL_FINST(tmr1Regs->TGCR, TMR_TGCR_TIMLORS, RESET_OFF);
}

void timer_setperiod(int period)
{
	CSL_TmrRegsOvly tmr1Regs = (CSL_TmrRegsOvly)CSL_TMR_1_REGS;

	CSL_FINST(tmr1Regs->TCR, TMR_TCR_ENAMODE_LO, DISABLE);
	CSL_FINS(tmr1Regs->PRDLO,TMR_PRDLO_PRDLO, period);
	CSL_FINST(tmr1Regs->TIMLO,TMR_TIMLO_TIMLO,RESETVAL);
	CSL_FINS(tmr1Regs->TCR, TMR_TCR_ENAMODE_LO, 2);  // continous mode
}
void UpLoadData();
#endif



Uint32  load_command_data(){
    Uint32 Count  ;
    Uint32 addr   ;
    Uint32 i ;
    addr = 0x1000 + 4*1 ;
    Count = READ_REGISTER(addr) ;

	for(i=0;i<Count;i++){
         addr+=4;
         MonitorData[i] = READ_REGISTER(addr);
	}
    return Count ;
}

void ExecuteCommand(){

    Uint32 i;
    Uint32 addr;
    Uint32 Count ;
    Uint32 reg_written;
    Uint32 reg_value;


        switch(ExectueCommand_flag){

        case 1 : //Set Common Threshold Param
            addr = 0x1000 + 4*1 ;
            MonitorData[0] = READ_REGISTER(addr);
            setCommonThresholdParams((MonitorData[0]&0x0000FFFF),(MonitorData[0]&0xFFFF0000)>>16);
            break ;
        case 2 : //Set Threshold Vector
            Count = load_command_data() ;
		    setThresholdParams(&MonitorData[0],Count);
            break ;
        case 3 : //Set the data to be copied on every interrupt
            addr = 0x1000 + 4*1 ;
            DataMode = READ_REGISTER(addr) ;
            break ;
        case 4 : //Stimulus Load
		    Count = load_command_data() ;
		    Stim_LoadPattern((StimInfo *)&MonitorData[0]);
		    break ;
        case 5: //Electrode Config
            Count = load_command_data() ;
            Stim_LoadElectrodeConfig(MonitorData[0],&MonitorData[1]);
            break ;

        case 6: //Stimulate Trigger
		    Count = load_command_data() ;
            Stim_Trigger((MonitorData[0])&0xFFFF,(MonitorData[0]>>16)&0xFFFF,MonitorData[1]);
            break ;
        case 7: //Load Stim Sequence List
            Count = load_command_data() ;
            Stim_LoadStimSequenceList(MonitorData[0] , MonitorData[1] , &MonitorData[2]);
            break ;
        case 8: //Start Stim Sequence
            Count = load_command_data() ;
            i     = MonitorData[5] ;
            while(i<current_time){
                i = i + 50000 ;
            }
            Stim_StartSequence(MonitorData[0],MonitorData[1] , MonitorData[2], MonitorData[3] ,MonitorData[4] , i);
            break ;
        case 9 : //Stop Stim Sequence
            Stim_StopSequence();
            break ;
        case 10: //Load pattern Buffer
            Count = load_command_data() ;
            StimPatternSequence_LoadPatterBuffer(Count , &MonitorData[0] );
            break ;
        case 11: //Load Pattern Sequence
            Count = load_command_data() ;
            StimPatternSequence_LoadPatternSequence(Count , &MonitorData[0] );
            break;
        case 12: //Start Pattern Sequence ;
            Count = load_command_data() ;
            i     = MonitorData[4] ;
            while(i<current_time){
                i = i + 50000 ;
            }
            StimPatternSequence_Start(MonitorData[0],MonitorData[1] , MonitorData[2], MonitorData[3] ,i);
            break ;
        case 13: //Decoder Type_1 setup
            Count = load_command_data() ;
            setup_decoder(&MonitorData[0] );
            break;
        case 14: //Decoder Type_1 setup
            Count = load_command_data() ;
            setup_decoder_2(&MonitorData[0] );
            break;
        case 15: //Set the ADC Gain
            Count = load_command_data() ;
            ADCDataShift = MonitorData[0]&0xFF;
            break;
        case 16: //Change Blanking Enable
            Count = load_command_data() ;
            EnableAmpBlanking = MonitorData[0]&0xFF;
            break;
        case 17: //Enabling RobotControl/StimTrainControl
            Count = load_command_data() ;
            frame_sync      = MonitorData[0];
            ExecutionMode   = MonitorData[1];
            if(ExecutionMode== 2)
                StimTrain_Trigger(1);
            else
                StimTrain_Trigger(0);
            break;
        case 18: //Loading Stimulus Train pattern
            Count = load_command_data() ;
            StimTrain_Setup(&MonitorData[0]);
            break;
        default: //Ignore Command

           break;
        }


	ExectueCommand_flag = 0;
}



void filter_update(uint32 addr,uint32 Filter);
void filter_setup();

void filter_update(uint32 addr,uint32 Filter){
    uint32 b[3] , a[3] ;

switch(Filter){

    case 1 : //MCS Gain 2
        b[0] = 0x0D890000 ;
        b[1] = 0xF4CA8000 ;
        b[2] = 0x00000000 ;
        a[1] = 0x15560000 ;
        a[2] = 0x00000000 ;
        break ;
    case 2 : //300Hz HP
        b[0] = 0x3ED0C000 ;
        b[1] = 0xC12F4000 ;
        b[2] = 0x00000000 ;
        a[1] = 0xC25E4E33 ;
        a[2] = 0x00000000 ;
        break;
    case 3 : //1000Hz HP
        b[0] = 0x3C364000 ;
        b[1] = 0xC3C9C000 ;
        b[2] = 0x00000000 ;
        a[1] = 0xC7938F9D ;
        a[2] = 0x00000000 ;
        break;
    case 4 : //1000Hz HP2
        b[0] = 0x3A8EC000 ;
        b[1] = 0x8AE24000 ;
        b[2] = 0x3A8EC000 ;
        a[1] = 0x8B58F762 ;
        a[2] = 0x35946259 ;
        break;
    case 5:
        b[0] = 0x40000000 ;
        b[1] = 0x00000000 ;
        b[2] = 0x00000000 ;
        a[1] = 0x00000000 ;
        a[2] = 0x00000000 ;
        break ;

}

    WRITE_REGISTER ((addr + 0*4) , b[0]);
    WRITE_REGISTER ((addr + 2*4) , b[1]);
    WRITE_REGISTER ((addr + 3*4) , a[1]);
    WRITE_REGISTER ((addr + 4*4) , b[2]);
    WRITE_REGISTER ((addr + 5*4) , a[2]);

}
void filter_setup(){
    Uint32 d ;
    //DSP FILTERS
    #if 0
    filter_update(0x600);
    WRITE_REGISTER(0x61C , 0x00000001);
    filter_update(0x620);
    WRITE_REGISTER(0x63C , 0x00000001);
    filter_update(0x640);
    WRITE_REGISTER(0x65C , 0x00000001);
    filter_update(0x660);
    WRITE_REGISTER(0x67C , 0x00000001);
    #endif

    //ADC Filters
    filter_update((0x8000 + 0x600),1);
    WRITE_REGISTER((0x8000 + 0x61C),0x00000003);
    filter_update((0x8000 + 0x620),3);
    WRITE_REGISTER((0x8000 + 0x63C),0x00000003);
    #if 0
    filter_update(0x8000 + 0x640);
    WRITE_REGISTER((0x8000 + 0x65C),0x00000001);
    filter_update(0x8000 + 0x660);
    WRITE_REGISTER((0x8000 + 0x67C),0x00000001);
    #endif

    d = READ_REGISTER((0x8000 + 0x100));
    d |= (1<<1) ;
    WRITE_REGISTER((0x8000 + 0x100),d);
}
void main()
{
	static int count = 0;
	int count_test1;
	int count_test2;

	static int value = 0;
	volatile int i;


    DataMode = 2 ;
    StimSequence_Enabled = 0 ;
    Stim_BlankingCounter = -1;
    StimStatus[0] = -1 ;
    StimStatus[1] = -1 ;
    ExectueCommand_flag = 0;
    current_time = 2*1500;
    last_timer_count = 0;
    StimCheck_flag = 0;
    DecoderOutputValid=0;
    RobotStimEnable = 0;
    frame_sync=0;

    ExecutionMode = 0;

    ADCDataShift = 0;
    EnableAmpBlanking=1;
    SpikeDetect_Setup();
    init_decoder();
	MEA21_init();
    init_SendDataDMA(54);
    timer_setup();

    #ifdef PROCESS_IN_DSP
    filter_setup();
    #endif

	WRITE_REGISTER(DSP_INDATA_CTRL, DSPINDATACTRL_VALUE);  // Enable Irq and HS1 Data

   	WRITE_REGISTER(0x318 , 0x0);  // set AUX 1 as output
	WRITE_REGISTER(0x0310, 0x0); // set AUX 1 to value 0


    Stim_SetupStimGen();
    Stim_SetupTrigger();
    RobotComm_Setup();


    unsigned int M1,M2,SensorValue[2],si;
    M1 = 0; M2 = 1;SensorValue[0]=0;SensorValue[1]=0;
    si=0;
	while(1)
	{
        if(ExectueCommand_flag > 0 ){
           //ExectueCommand_flag = 100;
           ExecuteCommand();
        }

        if(StimCheck_flag==1){
           //Stim_CheckSequence(current_time);
           StimPatternSequence_Check(current_time);
           StimCheck_flag = 0;

        }

        if(DecoderCheck==1){
            calculate_decoder_output();
            DecoderCheck = 0;
        }

        if(ExecutionMode==1){
            if(RobotComm_flag==1){
               // int OutputState = SensorValue[1] + SensorValue[0]*2;
                int OutputState = (((uDecoderOutput_compressed[0]>>16)&(0xFFFF))-1);
                #if 1
                switch(OutputState){
                    case 0:
                            RobotComm_Trigger(2,2);
                            break;
                    case 1:
                            RobotComm_Trigger(1,2);
                            break;
                    case 2:
                            RobotComm_Trigger(2,1);
                            break;
                    case 3:
                            RobotComm_Trigger(1,1);
                            break;
                }
                #else
                /*
                if(SensorValue[0] == 1){
                    RobotComm_Trigger(2,2);
                }else{
                    RobotComm_Trigger(1,1);
                }
                */
                //RobotComm_Trigger(2,2);

                #endif
                RobotComm_flag = 0;
            }else if(RobotComm_flag==2){
                SensorValue[0] = RobotComm_Sensor();
                RobotComm_flag = 0;
            }else if(RobotComm_flag==3){
                SensorValue[1] = RobotComm_Sensor();
                RobotComm_flag = 0;
            }
            else if(RobotComm_flag==4){
                //Apply Stimulus
                int p,q;
                int SensorState = SensorValue[1] + SensorValue[0]*2;
                int Config ;
                si = (si+1)%4;
                //si = SensorState;
                StimPatternSequence_Start(2*si ,2*(si+1) - 1 , 1 , 1 , current_time + 100 );
                RobotComm_flag = 0;
            }
        }else if(ExecutionMode==2){
            //Execute the pattern Sequence defined in the formar
            if(StimTrain_flag != 0){
                if(StimTrain_flag == 1){
                    StimTrain_Step();
                }
                StimTrain_flag = 0;
            }
        }
	}

}


