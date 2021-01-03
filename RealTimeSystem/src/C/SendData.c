
#include <stdio.h>
#include <string.h>



#include <csl.h>
#include <soc.h>
#include <cslr_edma3cc.h>




#include "MEA21_lib.h"
#include "SendData.h"


volatile CSL_Edma3ccParamsetRegs  SendData_DMAPARAMSET[2] ;

Uint32 SendData_EvId ;

Uint32 SendBuffer[SEND_BUFFER_SIZE] ;
#pragma DATA_ALIGN(SendBuffer, 8);
double RecBuffer[SEND_BUFFER_SIZE] ;
#pragma DATA_ALIGN(RecBuffer, 8);
Uint32 SendDataCount ; //Number of Words to Send

SendDataStore uSendDataStore ;

Uint32 SendDataBuffer (Uint32 Header,void *ptr , Uint32 nBytes){ //Max 64*4 - 16 - 8 bytes


	Uint32 Count        ; //Here Count is in words

	if(nBytes > (SEND_BUFFER_SIZE*4 - 4*4 -2*4)) return 2 ; //Can never be send

	Header = (Header&0xFFFF)|((nBytes&0xFFFF)<<16); //Add Number of bytes to header

	if(nBytes%8 !=0){
		nBytes = ((nBytes/8) + 1)*8 ;
	}

    Count = (nBytes/4) + 2;



    if((SendDataCount + Count) > SEND_BUFFER_SIZE ) {return  SendData_StoreToBuffer(Count,  Header , ptr);}
    else return CopyDataToSendBuffer(Count,  Header , ptr) ;

}

//Linear Source and Destination
Uint32 CopyDataToSendBuffer(Uint32 Count , Uint32 Header , void * ptr){ //Count = number words to copy + Header

	double * restrict pS   = (double *)ptr;
	double * restrict pD   = (double *)&SendBuffer[SendDataCount];

	_nassert((Uint32)pS&0x07 == 0);
	_nassert((Uint32)pD&0x07 == 0);
    _nassert(Count&0x01 == 0 );


    SendDataCount = SendDataCount + Count ;
	Count = Count/2 ;//Now as double words

	//Copy Header ;
    *pD++ = _itod(current_time,Header);
    Count--                ;
   //Copy Into Internal Buffer
   while(Count > 0){
	 *pD++ = *pS++ ;
     Count-- ;
   }

   return 0 ;

}

//Source Linear Dest Circular
Uint32 SendData_StoreToBuffer(Uint32 Count , Uint32 Header , void *ptr ){//Count = number words to copy + Header

	if ((uSendDataStore.Count + Count)> SEND_STORE_BUFFER_SIZE) {uSendDataStore.Missed++ ; return 1 ;}

	//Else Copy Data to internal buffer
	double * restrict pS   = (double *)ptr;
	double * restrict pD   ;

	_nassert((Uint32)pS&0x07 == 0);
	_nassert((Uint32)pD&0x07 == 0);
    _nassert(Count&0x01 == 0 );


	Count = Count/2 ;//Now as double words

	//Circular Buffer Copy
	Uint32 C1 , C2 ;

	C1 = (SEND_STORE_BUFFER_SIZE - uSendDataStore.write_idx)/2 ; //Space Left in straight (dWords) would never be zero!
	C1 = (C1 >= Count)  ? Count  : C1 ;
	C2 = Count - C1                   ;

    pD = (double *)&uSendDataStore.DATA_ARRAY[uSendDataStore.write_idx] ;

    //Tag Header from this buffer
    Header = Header | (0x8000) ;
	//Copy Header ;
    *pD++ = _itod(current_time,Header);
    C1--                ;

    //Copy Initial Segment
    while(C1 > 0){
     *pD++ = *pS++ ;
      C1-- ;
    }

    pD = (double *)&uSendDataStore.DATA_ARRAY[0] ;
    //Copy Second Segment
    while(C2 > 0){
	  *pD++ = *pS++ ;
      C2-- ;
    }

    Count = Count*2 ; //Back to words
    uSendDataStore.Count = uSendDataStore.Count + Count ;
    uSendDataStore.write_idx = (uSendDataStore.write_idx + Count)%(SEND_STORE_BUFFER_SIZE) ;

    return 0 ;
}

//Source Circular dest linear
Uint32 SendData_CopyDataFromStoreBuffer(){

	Uint32 Count ;
	double * restrict pS   ;
	double * restrict pD  = (double *)&SendBuffer[SendDataCount]; ;

	_nassert((Uint32)pS&0x07 == 0);
	_nassert((Uint32)pD&0x07 == 0);
    _nassert(Count&0x01 == 0 );

    while(uSendDataStore.Count > 0){
		//read number of bytes
		Count = uSendDataStore.DATA_ARRAY[uSendDataStore.read_idx] ; //read header
		Count = ((Count >> 16) & (0xFFFF))/4  + 2                  ; //Extract Number of words (bytes/4) + Header

		if((SendDataCount + Count) <= SEND_BUFFER_SIZE ){
			//Do the copying

		   Count = Count/2 ; //Change to double words
		   Uint32 C1,C2 ;

		   C1 = (SEND_STORE_BUFFER_SIZE - uSendDataStore.read_idx)/2 ; //Number of double words that can be read till end
		   if(C1 > Count) C1 = Count ; //Actual required
		   C2 = Count - C1 ;

		   pS =(double *)&uSendDataStore.DATA_ARRAY[uSendDataStore.read_idx] ;

		   //Copy Initial Segment
			 while(C1 > 0){
			  *pD++ = *pS++ ;
			   C1-- ;
			 }

			 pS = (double *)&uSendDataStore.DATA_ARRAY[0] ;
			 //Copy Second Segment
			 while(C2 > 0){
			  *pD++ = *pS++ ;
			   C2-- ;
			 }

			Count = Count*2 ; //Count to words
			SendDataCount = SendDataCount + Count ;
			uSendDataStore.Count = uSendDataStore.Count - Count;
			uSendDataStore.read_idx = (uSendDataStore.read_idx + Count)%(SEND_STORE_BUFFER_SIZE) ;

    }else{
    	break ;
    }

    }
    return 0 ;
}
Uint32 SendData_GetAvailableSpace(){
	return SEND_STORE_BUFFER_SIZE - uSendDataStore.Count;
}

void SendDataDMA(){

    Uint32 nWords ;

    SendData_CopyDataFromStoreBuffer() ; //Check if some data is there and can be copied from buffer

	SendBuffer[1] = SendDataCount;
	SendBuffer[2] = current_time ;
    SendBuffer[3] = last_timer_count;


	nWords = SEND_BUFFER_SIZE;//Fixed Transfer


	  //Send For Transfer
	   SendData_DMAPARAMSET[0].SRC =  ((Uint32)&SendBuffer[0]) ;
/*
	   if((SendBufferStart + ndWords) <= SEND_BUFFER_SIZE){ //Single Transfer
*/
		   SendData_DMAPARAMSET[0].A_B_CNT = (1<<16)|(SEND_BUFFER_SIZE*4);
		   SendData_DMAPARAMSET[0].LINK_BCNTRLD =(0<<16)|(0xffff);
		   //No Chaining
		   SendData_DMAPARAMSET[0].OPT &= (~(1<<22)) ;//(TCCHEN)(TCC)
/*
	   }else{ //Multiple Transfers
		   Uint32 C1 = SEND_BUFFER_SIZE-SendBufferStart ;
		   Uint32 C2 = nWords - C1 ;
		   SendData_DMAPARAMSET[0].A_B_CNT = (1<<16)|C1*4;
		   SendData_DMAPARAMSET[0].LINK_BCNTRLD =(0<<16)|((SendData_EvId+1)<<5);
		   //Chaining for first paramset
		   SendData_DMAPARAMSET[0].OPT |= (1<<22) ;//(TCCHEN)(TCC)

		   SendData_DMAPARAMSET[1].A_B_CNT = (1<<16)|C2*8;
	   }
*/

        CSL_Edma3ccRegsOvly edma3ccRegs = (CSL_Edma3ccRegsOvly)CSL_EDMA3CC_0_REGS;
     	volatile CSL_Edma3ccParamsetRegs  * param_ptr ;
	    param_ptr = &edma3ccRegs->PARAMSET[SendData_EvId +0];
        memcpy((void *) param_ptr , (void *)&SendData_DMAPARAMSET[0], 2*sizeof(CSL_Edma3ccParamsetRegs));
	   //Trigger Transfer by manual write
	   if(SendData_EvId <32){
	    edma3ccRegs->ESR  = 1<<SendData_EvId;
	   }else{
	    edma3ccRegs->ESRH = 1<<(SendData_EvId-32);
	   }

	   SendDataCount = 4 ; //Fixed Header Size

}
//Uses 2 adjacent param sets
//USes the event number  & +1 paramsets
void init_SendDataDMA(Uint32 EventId){

	Uint32 i ;

	for(i=0;i<SEND_BUFFER_SIZE;i++)SendBuffer[i] = i ;
    SendBuffer[SEND_BUFFER_SIZE-1]=100;

	SendDataCount = 4 ;
	SendBuffer[0] = 0x55AA55AA ;
	SendBuffer[3] = 0x55AA55AA ;

//No interrupts to CPU
	 CSL_Edma3ccRegsOvly edma3ccRegs = (CSL_Edma3ccRegsOvly)CSL_EDMA3CC_0_REGS;
     SendData_EvId = EventId ;
    // Initialize parameters in Ram

    //Clear both param sets
     memset((void *)SendData_DMAPARAMSET, 0, 2*sizeof(CSL_Edma3ccParamsetRegs));

    //Event Id /Channel to parameter mapping
	//Use event number same as ParamStart for triggering
	CSL_FINS(edma3ccRegs->DCHMAP[EventId], EDMA3CC_DCHMAP_PAENTRY, EventId);
	//Not using CSL
    //Setup Queue to Use
	edma3ccRegs->DMAQNUM[EventId/8] = ((edma3ccRegs->DMAQNUM[EventId/8])&(0x7<<((EventId%8)*4))) | (1<<((EventId%8)*4));

	//Setup Param Sets
	SendData_DMAPARAMSET[0].OPT =  (SendData_EvId<<12)|(1<<1);
   // SendData_DMAPARAMSET[0].OPT =  (SendData_EvId<<12);
	SendData_DMAPARAMSET[0].SRC =  (Uint32)&SendBuffer[0] ;
	SendData_DMAPARAMSET[0].A_B_CNT = (1<<16)|(4*SEND_BUFFER_SIZE);
	SendData_DMAPARAMSET[0].DST =  0xb0000000 ;
	//SendData_DMAPARAMSET[0].DST = (Uint32)&RecBuffer[0];

	SendData_DMAPARAMSET[0].SRC_DST_BIDX =0;
	SendData_DMAPARAMSET[0].LINK_BCNTRLD =(0<<16)|(0xffff);
	SendData_DMAPARAMSET[0].SRC_DST_CIDX = 0;
	SendData_DMAPARAMSET[0].CCNT= 1;

    SendData_DMAPARAMSET[1] = SendData_DMAPARAMSET[0];




    //Initialize Internal copy
    uSendDataStore.Count = 0 ;
    uSendDataStore.Missed = 0 ;
    uSendDataStore.write_idx=0;
    uSendDataStore.read_idx =0;


}

