
#include "FindThreshold.h"
#include "SpikeDetect.h"
//#include "timer.h"

Uint32 spd_LastCross[CHANNELS_FOR_CALC]        ;
Int16  spd_ThresholdData[CHANNELS_FOR_CALC*2]  ;
#pragma DATA_ALIGN(spd_LastCross, 8)           ;
#pragma DATA_ALIGN(spd_ThresholdData, 8)       ;




//Store up to so many spike informations (2 times number of channels to implement the ping pong fifo)
#define SPIKE_BUFFER_LEN (CHANNELS_FOR_CALC)


//No Idea: Compiler does a good job for a double pointer hence 2*int32
Uint32 SpikeData[SPIKE_BUFFER_LEN*2]     ; //EntryContains the list of spikes
Uint32 nSpikes  ; //Number of Spikes

unsigned char SpikeData_Compressed[CHANNELS_FOR_CALC];


#pragma DATA_ALIGN(SpikeData, 8)       ;

SpikeList uSpikeList ;
#pragma DATA_ALIGN(uSpikeList, 8)       ;

double spike_segment[sizeof(SpikeInfo)/8 + SAMPLE_STORE_LEN*2/8];
#pragma DATA_ALIGN(spike_segment, 8)       ;

double dummy_segment[sizeof(SpikeInfo)/8 + SAMPLE_STORE_LEN*2/8];
#pragma DATA_ALIGN(spike_segment, 8)       ;

void SpikeDetect_Setup(){
  Uint32 i;
  Uint32* restrict lst_cr_p = (Uint32 *)&spd_LastCross[0];


  ThresholdMode = both ;

  for(i = 0 ; i < CHANNELS_FOR_CALC; i++)
	  lst_cr_p[i] = 0;

  for(i = 0; i < CHANNELS_FOR_CALC ; i++){
	  SpikeData[i] = 0 ;
	  spd_ThresholdData[2*i]   = 16000 ;
	  spd_ThresholdData[2*i+1] = 0     ;
  }

  adc_intern_id       = 0 ;
  uSpikeList.Count    = 0 ;
  uSpikeList.write_id = 0 ;
  uSpikeList.read_id  = 0 ;
  uSpikeList.Missed_A = 0 ;
  uSpikeList.Missed_B = 0 ;

  Int16 * ptr = (Int16*) &spike_segment[1];

  for(i = 0 ; i < 96 ; i++){
      *ptr++ = i;
   }
   SpikeChannel[0] = 0;
   SpikeChannel[1] = 0;
   SpikeChannel[2] = 0;
   SpikeChannel[3] = 0;
}

#if 0
void sdp_DummyCall(){
  Uint32 i ;

  Int16* restrict adc_p   = (Int16 *)&adc_intern_0[0];
  Int16* restrict thd_p   = (Int16 *)&spd_ThresholdData[0];

  current_time = current_time + SPD_DEADTIME + 100 ;

  for (i = 0 ; i < CHANNELS_FOR_CALC; i++){
	  thd_p[2*i] = 1000 ;
	  thd_p[2*i+1] = 0  ;
	  adc_p[i] = thd_p[2*i] - 100 ;
  }

}
#endif

void setCommonThresholdParams(Int16 Threshold , Int16 Mean){
	Uint32 i ;
	Int16* restrict thd_p   = (Int16 *)&spd_ThresholdData[0];
	for (i = 0 ; i < CHANNELS_FOR_CALC; i++){
		  thd_p[2*i]   = Threshold    ;
		  thd_p[2*i+1] = Mean         ;
    }
}


void setThresholdParams(Uint32 * restrict param_ptr , Uint32  Count){
	Uint32 i ;
	Uint32* restrict thd_p   = (Uint32 *)&spd_ThresholdData[0];

	_nassert(((int)(thd_p) & 0x7) == 0);
	_nassert(((int)(Count) & 0x3) == 0);

	 for (i = 0 ; i < Count; i++){
			  thd_p[i]   = param_ptr[i]    ;
		  }
}



void SpikeDetect(){
   Uint32 i ;
   Uint32 Ch,Bit ;

   Int16* restrict adc_p   = (Int16 *)&adc_intern_0[0];

   Int16* restrict thd_p   = (Int16 *)&spd_ThresholdData[0];
   Uint32* restrict lst_cr_p = (Uint32 *)&spd_LastCross[0];




    double * restrict SpikeData_ptr_i = (double *)&SpikeData[0] ;

   _nassert(((int)(adc_p) & 0x7) == 0);
   _nassert(((int)(thd_p) & 0x7) == 0);
   _nassert(((int)(lst_cr_p) & 0x7) == 0);


   Uint32 lst_cr_x = current_time-SPD_DEADTIME ;

   //Compiler does a better job with double word writes . Generates a more optimized code in thiscase
   //3cycles vs 4cycles /loop
   if(ThresholdMode == negative){
	   for (i = 0; i < CHANNELS_FOR_CALC; i+=2){
			if((adc_p[i] <  thd_p[2*i]) &&(lst_cr_p[i] < lst_cr_x)){
				 lst_cr_p[i]= current_time ;
				*SpikeData_ptr_i++ = (_itod(0,i));
			}
	   }
   }
   else{ //ThresholdMode = both
	   for (i = 0 ; i < CHANNELS_FOR_CALC; i++){
			if((_abs(adc_p[i]) >  thd_p[2*i]) &&(lst_cr_p[i] < lst_cr_x)){
				 lst_cr_p[i]= current_time ;
				*SpikeData_ptr_i++ = (_itod(0,i));
			}
	   }
   }


   nSpikes =  (Uint32)((Uint32 *)SpikeData_ptr_i - SpikeData)/2 ;

   SpikeChannel[0] = 0;
   SpikeChannel[1] = 0;
   SpikeChannel[2] = 0;
   SpikeChannel[3] = 0;


   for(i=0;i<nSpikes;i++){
     Ch  = SpikeData[2*i]  ;
     Bit = Ch & 0x00000001F;
     Ch  = Ch >> 5         ;
     SpikeChannel[Ch] |= (1<<Bit);
   }


}

void AddToSpikeList(Uint8 Channel){
 if(uSpikeList.Count < MAX_SPIKE_LIST){
	uSpikeList.Count++ ;
	uSpikeList.uSpikeInfo[uSpikeList.write_id].Channel = Channel       ;
	uSpikeList.uSpikeInfo[uSpikeList.write_id].type    = 0             ;
	uSpikeList.uSpikeInfo[uSpikeList.write_id].time    = current_time  ;
	uSpikeList.uSpikeInfo[uSpikeList.write_id].trigger_id    = adc_intern_id ;
	uSpikeList.wait_for_acq[uSpikeList.write_id] = POST_DETECT_LEN ;

	uSpikeList.write_id++ ;
	if(uSpikeList.write_id == MAX_SPIKE_LIST) uSpikeList.write_id = 0   ;

 }else{
	 uSpikeList.Missed_A++;
 }

}

void RemoveTopFromSpikeList(Uint32 Count){
	if(uSpikeList.Count >= Count){
		uSpikeList.Count-=Count ;
		uSpikeList.read_id = (uSpikeList.read_id + Count)%MAX_SPIKE_LIST;
	}
}

void SendSpikeSegments(){
   Uint32 i ;
   Uint32 read_idx  = uSpikeList.read_id ;

   /*
   Debug_Data[0] = current;
   Debug_Data[1] = uSpikeList.uSpikeInfo[SpikeListIndex].Channel ;
   SendDataBuffer (0x3,&Debug_Data[0] ,4*2) ;
   */

   i = uSpikeList.Count;
   //Debug_Data[3] = i ;


   while(i-- > 0){
	   uSpikeList.wait_for_acq[read_idx]-- ;
	   if(uSpikeList.wait_for_acq[read_idx]==0){
		   //Debug_Data[4] = read_idx ;
		   CopyToSpikeSegment(read_idx);
		   SendSpikeSegment() ;
		   uSpikeList.Count-=1 ;
		   uSpikeList.read_id++ ;
		   if(uSpikeList.read_id == MAX_SPIKE_LIST) uSpikeList.read_id=0;
	   }
	   read_idx++ ;
       if(read_idx== MAX_SPIKE_LIST) read_idx = 0 ;
   }

}
void SendSpikeSegments2(Uint32 send){
   Uint32 i ;
   Uint32 read_idx  = uSpikeList.read_id ;


   i = uSpikeList.Count;
   Debug_Data[3] = i ;


   while(i-- > 0){
	   //uSpikeList.wait_for_acq[read_idx]-- ;
	   if(send==1){
		   Debug_Data[4] = read_idx ;
		   CopyToSpikeSegment(read_idx);
		   SendSpikeSegment() ;
		   uSpikeList.Count-=1 ;
		   uSpikeList.read_id++ ;
		   if(uSpikeList.read_id == MAX_SPIKE_LIST) uSpikeList.read_id=0;
	   }
	   read_idx++ ;
       if(read_idx== MAX_SPIKE_LIST) read_idx = 0 ;
   }

}
void CopyToSpikeSegment(Uint32 SpikeListIndex){


	 //Now copy the segment
	 //The copying would have a jitter of max 3 samples . This is for faster copying using
	 //aligned DWORD copy. The info on the jitter can be extracted from the trigger_id info
	 Uint32 start_id = uSpikeList.uSpikeInfo[SpikeListIndex].trigger_id ;
	 Uint32 Channel  = uSpikeList.uSpikeInfo[SpikeListIndex].Channel    ;



	 start_id = start_id + POST_DETECT_LEN ;
	 if(start_id >= SAMPLE_STORE_LEN) start_id = start_id - SAMPLE_STORE_LEN ;

	 //Align
	 start_id = start_id - start_id%4 ;

	 Uint32 C1,C2 ;

	 spike_segment[0] = *((double *)&uSpikeList.uSpikeInfo[SpikeListIndex]);
	 double * restrict pD = &spike_segment[1];
	 double * restrict pS ;


	 C1 = (SAMPLE_STORE_LEN - start_id) ; //Number of double words
	 C2 = (SAMPLE_STORE_LEN - C1      )/4 ;
	 C1 = C1/4 ;


	 pS = (double *)&(adc_intern_1[SAMPLE_STORE_LEN*Channel + start_id]) ;

	 while(C1>0){
		 *pD++ = *pS++ ;
		 C1--;
	 }


	 pS = (double *)&(adc_intern_1[SAMPLE_STORE_LEN*Channel  + 0]) ;
	 while(C2>0){
		*pD++ = *pS++ ;
		 C2--;
     }


}

void SendSpikeSegment(){
  Uint32 R = 0;
  R = SendDataBuffer (0x2,&spike_segment[0] ,sizeof(SpikeInfo)+SAMPLE_STORE_LEN*2) ;
  if(R!=0) uSpikeList.Missed_B++;
}

void SendSpikeBuffer(Uint32 nSpikes){
	SendDataBuffer (0x1,&SpikeData_Compressed[0] , nSpikes) ;
}

