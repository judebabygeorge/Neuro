#include <csl.h>
#include <cslr_tmr.h>
#include <cslr_gpio.h>
#include <cslr_chip.h>
#include <cslr_edma3cc.h>
#include <soc.h>
#include <c6x.h>
#include "MEA21_lib.h"
#include "RobotComm.h"

void RobotComm_Setup(){
  //Configure Digital Data Out , 4 bits output
    WRITE_REGISTER(0x308 ,0xFFFFFFF8);

  //Configure Pulse Generation
  //Bits 0-7
    WRITE_REGISTER(0x704 ,50*10); //10ms DOUT1 : CLK
    WRITE_REGISTER(0x708 ,50*10); //10ms DOUT2 : M1
    WRITE_REGISTER(0x70C ,50*10); //10ms DOUT3 : M2
  //Select Mux for DIG-OUT
    WRITE_REGISTER(0x840 ,(40<<16)|(32)); //OUT0 & OUT1
    WRITE_REGISTER(0x844 , 48); //OUT2

    //AUX0: SensorI n
}

//State Can be 0 1 or 2
void  RobotComm_Trigger(int state_M1,int state_M2){

    unsigned int data = (1<<0);

   if (state_M1 == 2) {
        WRITE_REGISTER(0x708 ,50*20); //20ms
   }else{
        WRITE_REGISTER(0x708 ,50*10); //10ms
   }
   if (state_M2 == 2) {
        WRITE_REGISTER(0x70C ,50*20); //20ms
   }else{
        WRITE_REGISTER(0x70C ,50*10); //10ms
   }
   if (state_M1 > 0){
      data |=(1<<8);
   }
   if (state_M2 > 0){
      data |=(1<<16);
   }
   WRITE_REGISTER(0x700 , data);
}

unsigned int RobotComm_Sensor(){
 static unsigned int val = 0 ;
 //val = (READ_REGISTER(0x304)>>3)&0x1;
 // val = READ_REGISTER(0x304)&0xF;
  val = READ_REGISTER(0x314)&0x1 ;
  val = val == 0 ? 1:0;
 return val;
}
