
#include "Stim.h"
#include "MEA21_lib.h"

#define STIMULUS_BOARD_HS1_A 0x9000
#define STIMULUS_BOARD_HS1_B 0xA000

Stim_SequenceList u_Stim_SequenceList ;
#pragma DATA_ALIGN(u_Stim_SequenceList, 8);




void SetSegment(Uint32 SegmentReg, int Segment){
	WRITE_REGISTER(SegmentReg, Segment);  // Any write to this register clears the Channeldata
}
Uint32 AddDataPoint(Uint32 ChannelReg, Uint32 duration, int16 value){
	Uint32 vectors_used = 0;
	Uint32	Vector          ;

    //value +=0x8000;

	if (duration > 1000)
	{
		Vector = 0x04000000 | (((duration / 1000) - 1) << 16) | (value & 0xffff);
		WRITE_REGISTER(ChannelReg, Vector);  // Write Datapoint to STG Memory
		duration %= 1000;
		vectors_used++;
	}
	if (duration > 0)
	{
		Vector = ((duration - 1) << 16) | (value & 0xffff);
		WRITE_REGISTER(ChannelReg, Vector);  // Write Datapoint to STG Memory
		vectors_used++;
	}

	return vectors_used;
}
Uint32 AddLoop(Uint32 ChannelReg, uint16 Vectors, uint16 Repeats , Uint32 LoopLevel){
	Uint32 LoopVector;
    Uint32 vectors_used = 0;
	if (Repeats > 1)
	{
		LoopVector = 0x10000000 | (Repeats << 16) | Vectors | ((LoopLevel&0x3)<<26);
		WRITE_REGISTER(ChannelReg, LoopVector);
		vectors_used++;
	}
	return vectors_used;
}
Uint32 AddEndVector(Uint32 ChannelReg){
    WRITE_REGISTER(ChannelReg, 0x70000000);
    return 1 ;
}

void Stim_LoadChannel_T2(Uint32 ChannelReg  , StimPattern_T2 * uP){
    int i;
    for(i=0;i<uP->nVectors_P;i++){
        WRITE_REGISTER(ChannelReg, uP->Vectors[i]);
    }
}
void Stim_LoadChannelSB_T2(Uint32 ChannelReg  , StimPattern_T2 * uP){
    int i;
    for(i=uP->nVectors_P;i<(uP->nVectors_P + uP->nVectors_SB);i++){
        WRITE_REGISTER(ChannelReg, uP->Vectors[i]);
    }
}
//Load Pattern Type 0
void Stim_LoadChannel_T1(Uint32 ChannelReg  , StimPattern_T1 * uP){
    //For Loading Pattern type T0
    //Pattern is defined biphasic pulses
    //with pulse repeat and train repeat

    //I_DELAY : UH UL INTER_PULSE_DELAY (REPEAT): INTER_TRAIN_DELAY (REPEAT) :END

    uint16 vectors_used = 0 ;

                   AddDataPoint(ChannelReg, uP->d ,0+0x8000)      ;// I_DELAY

    vectors_used+= AddDataPoint(ChannelReg, uP->Tp,uP->Up+0x8000) ;// Up
    vectors_used+= AddDataPoint(ChannelReg, uP->Tn,uP->Un+0x8000) ;// Un
    vectors_used+= AddDataPoint(ChannelReg, uP->dP,0+0x8000)      ;// INTER_PULSE_DELAY
    vectors_used+= AddLoop(ChannelReg,vectors_used , uP->CountP , 0); //REPEAT LOOP
    vectors_used+= AddDataPoint(ChannelReg, uP->dT,0+0x8000)      ;// INTER_TRAIN_DELAY
    vectors_used+= AddLoop(ChannelReg,vectors_used , uP->CountT , 1); //REPEAT LONG_LOOP

    vectors_used+=AddEndVector(ChannelReg);
}
//Load Sideand Info for T0
void Stim_LoadChannelSB_T1(Uint32 ChannelReg  , StimPattern_T1 * uP){
    //For Loading Pattern type T0
    //Pattern is defined biphasic pulses
    //with pulse repeat and train repeat

    //I_DELAY : UH UL INTER_PULSE_DELAY (REPEAT): INTER_TRAIN_DELAY (REPEAT) :END

    uint16 vectors_used = 0 ;

    Uint32 BlankingTime , IdleTime ;

    if((uP->dP) > (600/20)){
      BlankingTime  = (600/20) ; //600us after end of pulse
      IdleTime      = uP->dP - (600/20);
    }else{
      BlankingTime  = uP->dP ;
      IdleTime      = 0      ;
    }

                   AddDataPoint(ChannelReg, uP->d ,0x00)          ;// I_DELAY
    if(EnableAmpBlanking != 0){
        vectors_used+= AddDataPoint(ChannelReg, uP->Tp + uP->Tn,0x19) ;// Tp+Tp
        vectors_used+= AddDataPoint(ChannelReg, BlankingTime,0x11)    ;// 600uS
    }else{
        vectors_used+= AddDataPoint(ChannelReg, uP->Tp + uP->Tn,0x18) ;// Tp+Tp
        vectors_used+= AddDataPoint(ChannelReg, BlankingTime,0x10)    ;// 600uS
    }

    vectors_used+= AddDataPoint(ChannelReg, IdleTime,0x00)        ;// INTER_PULSE_DELAY - 600uS
    vectors_used+= AddLoop(ChannelReg,vectors_used , uP->CountP , 0); //REPEAT LOOP

    vectors_used+= AddDataPoint(ChannelReg, uP->dT,0x00)      ;// INTER_TRAIN_DELAY
    vectors_used+= AddLoop(ChannelReg,vectors_used , uP->CountT , 1); //REPEAT LONG_LOOP

    vectors_used+=AddEndVector(ChannelReg);
}
void ClearChannel(Uint32 ClearReg){
	WRITE_REGISTER(ClearReg, 0);  		// Any write to this register clears the Channeldata
}

void UpLoadPatternToHS(Uint32 HS_Addr,Uint32 ChannelId,Uint32 SegmentId,uint16 * p){
    //Channel Data
    Uint32 ChannelReg ;
    ChannelReg = HS_Addr + 0x200 + 0x20*(ChannelId*2) ;
    SetSegment(ChannelReg, SegmentId);
    ChannelReg = HS_Addr + 0x200 + 0x20*(ChannelId*2 +1);
    SetSegment(ChannelReg, SegmentId);

    //Load DAC Data
    ChannelReg = HS_Addr + 0x20C + 0x20*(ChannelId*2) ;
    ClearChannel(ChannelReg);
    ChannelReg = HS_Addr + 0xF20 + 4*(ChannelId*2);

    switch(p[1]){
        case 1:
            Stim_LoadChannel_T1(ChannelReg,(StimPattern_T1 *)p);
            break;
        case 2:
            Stim_LoadChannel_T2(ChannelReg,(StimPattern_T2 *)p);
            break;
        default:
            break;
    }
    //SideBand Data
    ChannelReg = HS_Addr + 0x20C + 0x20*(ChannelId*2+1) ;
    ClearChannel(ChannelReg);
    ChannelReg = HS_Addr + 0xF20 + 4*(ChannelId*2+1);

    switch(p[1]){
        case 1:
            Stim_LoadChannelSB_T1(ChannelReg,(StimPattern_T1 *)p);
            break;
        case 2:
            Stim_LoadChannelSB_T2(ChannelReg,(StimPattern_T2 *)p);
            break;
        default:
            break;
    }
}
void ModifyRegister(Uint32 reg, Uint32 Mask, Uint32 Value){

	Uint32 Temp;

	Temp = READ_REGISTER(reg);
	Temp &= ~Mask;
	Temp |= (Value & Mask);
	WRITE_REGISTER(reg, Temp);
}

void Stim_SetupStimGen0(HS_Addr){


   Uint32 i ;
   Uint32 Addr ;

  //WRITE_REGISTER((HS_Addr + 0x200), 0x10000000);         // Inititialze STG Memory, use only one segment
   WRITE_REGISTER((HS_Addr + 0x200), 0x20000000);         // Inititialze STG Memory, use 256 segments
   while (READ_REGISTER((HS_Addr + 0x200)) & 0x30000000); // wait for segment initialization to finish


 //Configure All Electrodes to Automatic Mode
   Addr = HS_Addr + 0x120 ;
   for(i=0;i<4;i++){
    WRITE_REGISTER(Addr,0x00000000);
    Addr+=4 ;
   }
  //Assign SBS to DAC
  WRITE_REGISTER((HS_Addr + 0x154),0x02100210);

  //DataSources for DAC and SBS
  WRITE_REGISTER((HS_Addr + 0x1D0),0x04200420);
  WRITE_REGISTER((HS_Addr + 0x1D4),0x00000531);

  WRITE_REGISTER((HS_Addr+0x104), 0x00020100); // DAC1 to Trigger1, DAC2 to Trigger2, DAC3 to Trigger3
  WRITE_REGISTER((HS_Addr+0x108), 0x00020100); // SBS1 to Trigger1, SBS2 to Trigger2, SBS3 to Trigger3

}
void Stim_SetupStimGen(){

    Uint32 Addr , data;



    Stim_SetupStimGen0(STIMULUS_BOARD_HS1_A);
    Stim_SetupStimGen0(STIMULUS_BOARD_HS1_B);

    Set_Segment(0);

    //Blanking amplifier switch
    Addr = 0x8000 + 0x140 ;
    data = 0x3FFFFFFF ;
    WRITE_REGISTER(Addr,data);Addr+=4;
    WRITE_REGISTER(Addr,data);Addr+=4;
    WRITE_REGISTER(Addr,data);Addr+=4;
    WRITE_REGISTER(Addr,data);Addr+=4;
    WRITE_REGISTER(Addr,data);Addr+=4;
    WRITE_REGISTER(Addr,data);Addr+=4;
    WRITE_REGISTER(Addr,data);Addr+=4;
    WRITE_REGISTER(Addr,data);Addr+=4;

}
void Stim_SetupTrigger(){

    Uint32 i ;
    Uint32 Addr ;

    WRITE_REGISTER(0x0200, 0x1);  // Enable Trigger Packets
	WRITE_REGISTER(0x0204, 0x0);  // Setup Trigger
	WRITE_REGISTER(0x0208, 0x0);  // Setup Trigger
	WRITE_REGISTER(0x020c, 0x0);  // Setup Trigger
	WRITE_REGISTER(0x0210, 0x0);  // Setup Trigger

	WRITE_REGISTER(0x0218, 0x0);  // Setup Trigger
	WRITE_REGISTER(0x021c, 0x0);  // Setup Trigger
	WRITE_REGISTER(0x0220, 0x0);  // Setup Trigger
	WRITE_REGISTER(0x0224, 0x0);  // Setup Trigger
	WRITE_REGISTER(0x0228, 0x0);  // Setup Trigger
	WRITE_REGISTER(0x022c, 0x0);  // Setup Trigger

    WRITE_REGISTER((STIMULUS_BOARD_HS1_A + 0x190), 1); // Trigger 1 Repeat
    WRITE_REGISTER((STIMULUS_BOARD_HS1_A + 0x194), 1); // Trigger 2 Repeat
    WRITE_REGISTER((STIMULUS_BOARD_HS1_A + 0x198), 1); // Trigger 3 Repeat

    WRITE_REGISTER((STIMULUS_BOARD_HS1_B + 0x190), 1); // Trigger 1 Repeat
    WRITE_REGISTER((STIMULUS_BOARD_HS1_B + 0x194), 1); // Trigger 2 Repeat
    WRITE_REGISTER((STIMULUS_BOARD_HS1_B + 0x198), 1); // Trigger 3 Repeat

    //List Mode Config
    Addr = 0x0A00 ;
    for(i=0;i<12;i++){
        WRITE_REGISTER(Addr,(0x00<<16)|(0xFF));
        Addr+=4 ;
    }
    Addr = 0x0A40 ;
    for(i=0;i<4;i++){
        WRITE_REGISTER(Addr,0);
        Addr+=4;
    }
    Addr = 0x0A80 ;
    for(i=0;i<4;i++){
        WRITE_REGISTER(Addr,0);
        Addr+=4;
    }


}

void Set_Segment(Uint32 Segment){
    Segment = Segment << 16 ;
    WRITE_REGISTER(0x0218, Segment );
    WRITE_REGISTER(0x021C, Segment );
    WRITE_REGISTER(0x0220, Segment );
    WRITE_REGISTER(0x0224, Segment );
    WRITE_REGISTER(0x0228, Segment );
    WRITE_REGISTER(0x022C, Segment );
}

void Stim_Trigger(Uint32 Segment , Uint32 ConfigId ,Uint32 Triggers){ //Corresponding bits  have to be set


    //Select the electrode Configuration
    Stim_SetElectrodeConfig(ConfigId);
    //Select the Segment

    //REMOVED FROM HERE: DONE ONLY ONCE DURING
    //Initial Setup
    //Set_Segment(Segment)



    //On Both HS1_A and HS1_B
    Triggers = Triggers | (Triggers<<3) ;
    //On HS_1 & HS_2
    Triggers = Triggers | (Triggers<<16);
    WRITE_REGISTER(0x0214, Triggers);     // Start Trigger
}
void Stim_LoadPattern(StimInfo * uStimInfo){

  Uint32 i , len;
  uint16 * p;

  //Fill the data for each pattern in HS0 & HS1
  //Channel 0:2 used for DAC Data

  p = uStimInfo->Patterns;

  for(i=0;i<uStimInfo->nPatterns;i++){
    //HS_1_A
     UpLoadPatternToHS(STIMULUS_BOARD_HS1_A,i,uStimInfo->SegmentID,p);
    //HS_1_B
     UpLoadPatternToHS(STIMULUS_BOARD_HS1_B,i,uStimInfo->SegmentID,p);
     len = p[0];
     p = p + (len/2) ;//Len in number of bytes
  }

}

void Stim_LoadElectrodeConfig(Uint32 ConfigId, Uint32 * Config){

  Uint32 i ;
  Uint32 Addr1 , Addr2 ;

  Addr1 = STIMULUS_BOARD_HS1_A ;
  Addr2 = STIMULUS_BOARD_HS1_B ;


  //Select Config to Update
  WRITE_REGISTER ((Addr1+0x150),(0<<28)|ConfigId);
  WRITE_REGISTER ((Addr2+0x150),(0<<28)|ConfigId);


  Addr1 = Addr1 + 0x158 ;
  Addr2 = Addr2 + 0x158 ;

  WRITE_REGISTER (Addr1 , Config[0 + 0]);Addr1+=4 ;
  WRITE_REGISTER (Addr1 , Config[0 + 1]);Addr1+=4 ;

  WRITE_REGISTER (Addr2 , Config[2 + 0]);Addr2+=4 ;
  WRITE_REGISTER (Addr2 , Config[2 + 1]);Addr2+=4 ;


  WRITE_REGISTER (Addr1 , Config[4 + 0]);Addr1+=4 ;
  WRITE_REGISTER (Addr1 , Config[4 + 1]);Addr1+=4 ;
  WRITE_REGISTER (Addr1 , Config[4 + 2]);Addr1+=4 ;
  WRITE_REGISTER (Addr1 , Config[4 + 3]);Addr1+=4 ;

  WRITE_REGISTER (Addr2 , Config[8 + 0]);Addr2+=4 ;
  WRITE_REGISTER (Addr2 , Config[8 + 1]);Addr2+=4 ;
  WRITE_REGISTER (Addr2 , Config[8 + 2]);Addr2+=4 ;
  WRITE_REGISTER (Addr2 , Config[8 + 3]);Addr2+=4 ;

#if 0
  for(i = 0 ; i < 2;i++){
     WRITE_REGISTER (Addr1 , Config[0 + i]);
     WRITE_REGISTER (Addr2 , Config[2 + i]);
     Addr1 += 4 ;
     Addr2 += 4 ;
  }

/*
  for(i = 0 ; i < 4;i++){
     WRITE_REGISTER (Addr1 , Config[4 + i]);
     WRITE_REGISTER (Addr2 , Config[8 + i]);
     Addr1 += 4 ;
     Addr2 += 4 ;
  }
*/

  for(i = 0 ; i < 4;i++){
     WRITE_REGISTER (Addr1 , Config[4 + i]);
     Addr1 += 4 ;
  }
  for(i = 0 ; i < 4;i++){
     WRITE_REGISTER (Addr2 , Config[8 + i]);
     Addr2 += 4 ;
  }
#endif


}
void Stim_SetElectrodeConfig(Uint32 ConfigId){
    Uint32 i,Addr ;
    Addr = 0x0A40 ;

    #if 0  //Unroll Loop
    for(i=0;i<4;i++){
        WRITE_REGISTER(Addr,ConfigId);
        Addr+=4;
    }
    #endif
    #if 1
    WRITE_REGISTER(Addr,ConfigId); Addr+=4 ;
    WRITE_REGISTER(Addr,ConfigId); Addr+=4 ;
    WRITE_REGISTER(Addr,ConfigId); Addr+=4 ;
    WRITE_REGISTER(Addr,ConfigId); Addr+=4 ;
    #endif
}

void Stim_LoadStimSequenceList(Uint32 Offset , Uint32 nList , Uint32 * Data){
#if 1
  Uint32 i ;
  u_Stim_SequenceList.SequenceId = (Offset >> 16) & 0xFFFF ;
  Offset = Offset & 0xFFFF ;
  for(i = 0 ; i < nList ; i++ ){
    u_Stim_SequenceList.E[Offset+i].Config = Data[2*i+0] ;
    u_Stim_SequenceList.E[Offset+i].Delay  = Data[2*i+1] ;
  }
#endif
}

void Stim_StartSequence(Uint32 Offset,Uint32 nElements , Uint32 nLoop , Uint32 nJumpBack ,Uint32 Triggers , Uint32 StartTime){
#if 1

  u_Stim_SequenceList.Next_Element = Offset    ;
  u_Stim_SequenceList.nElements    = nElements ;
  u_Stim_SequenceList.nLoop        = nLoop     ;
  u_Stim_SequenceList.nJumpBack    = nJumpBack ;

  u_Stim_SequenceList.Triggers     = (Triggers&0xFFFF)  ;
  u_Stim_SequenceList.Next_TimeStamp= StartTime + u_Stim_SequenceList.E[u_Stim_SequenceList.Next_Element].Delay ;

  if(nElements>0){
    StimStatus[1] = 1 + (u_Stim_SequenceList.SequenceId<<16);
    StimSequence_Enabled = 1 ;
  }
#endif
}
void Stim_StopSequence(){
    StimSequence_Enabled = 0 ;
}

void Stim_CheckSequence(Uint32 current_time){
  Uint32 Config , ConfigId;
  #if 1
  if(StimSequence_Enabled==1){
      if(current_time >= u_Stim_SequenceList.Next_TimeStamp){

        Config = u_Stim_SequenceList.E[u_Stim_SequenceList.Next_Element].Config ;


        ConfigId = (Config>>16)&0xFFFF ;
        if(ConfigId != 0xFFFF){ //To allow a dummy Element For delay
          StimStatus[0] =    (u_Stim_SequenceList.Next_Element)|((Config&0XFF000000) >> 8);
          Stim_Trigger(Config&0xFF, (Config>>16)&0xFF ,u_Stim_SequenceList.Triggers) ;
        }
        u_Stim_SequenceList.nElements-- ;
        if(u_Stim_SequenceList.nElements > 0){
            u_Stim_SequenceList.Next_Element++  ;
            u_Stim_SequenceList.Next_TimeStamp+=  u_Stim_SequenceList.E[u_Stim_SequenceList.Next_Element].Delay ;
        }
        else{
            u_Stim_SequenceList.nLoop--;
            if(u_Stim_SequenceList.nLoop>0){
              u_Stim_SequenceList.Next_Element -= u_Stim_SequenceList.nJumpBack     ;
              u_Stim_SequenceList.nElements     = u_Stim_SequenceList.nJumpBack + 1 ;
              u_Stim_SequenceList.Next_TimeStamp= current_time + u_Stim_SequenceList.E[u_Stim_SequenceList.Next_Element].Delay ;
              StimStatus[1] = 2 + (u_Stim_SequenceList.nLoop << 16);
            }else{
              StimStatus[1] = 3;
              StimSequence_Enabled = 0 ;
            }
        }
      }
  }

  #ifdef ENABLE_BLANKING
  if(Stim_BlankingCounter>=0){
    if(Stim_BlankingCounter==86){
       Stim_BlankElectrodes(1);
    }
    if(Stim_BlankingCounter==0){
        Stim_BlankElectrodes(0);
    }
    Stim_BlankingCounter-- ;
  }
  #endif
 #endif
}
void Stim_StartBlanking(){
    Stim_BlankingCounter = 86 ;
    //Stim_BlankElectrodes(1)   ;
}
void Stim_BlankElectrodes(Uint32 Enable){
    Uint32 Addr , i , data;

    Addr = 0x8000 + 0x150 ;
    data = Enable ? 0x3FFFFFFF : 0x00000000 ;
    //for(i = 0 ; i < 8 ; i++){
    //  WRITE_REGISTER(Addr,data);
    //}




}

