#include "MEA21_lib.h"
#include "global.h"
#include "OutputDecoder.h"


extern Uint32 SpikeData[OUTPUT_CHANNELS*2]     ; //EntryContains the list of spikes
extern Uint32 nSpikes  ; //Number of Spikes
extern Uint32 current_time;


//This is an array with [SPIKED FIRST_SPIKE_TIME nSpikes 0]
Output_ChannelState DecoderState[OUTPUT_CHANNELS];

Uint32 nDecoders    ;
int ChannelWeights[(OUTPUT_CHANNELS + 1)*MAX_DECODERS];
int uDecoderOutput[MAX_DECODERS];
int uDecoderOutput_compressed[10]; //Top 10 to output
#pragma DATA_ALIGN(uDecoderOutput_compressed, 8);

volatile int  DecoderOutputValid ;
volatile int  DecoderCheck       ;
Uint32        DecoderCheckWindow ;

float         Decoder_SynapseWeights[MAX_DECODERS*(OUTPUT_CHANNELS + 1)];
float         Decoder_V[MAX_DECODERS];
#pragma DATA_ALIGN(Decoder_V, 8);
float         Decoder_Iex[MAX_DECODERS];
#pragma DATA_ALIGN(Decoder_Iex, 8);
float         Decoder_Iinh[MAX_DECODERS];
#pragma DATA_ALIGN(Decoder_Iinh, 8);
float Decoder_d_tau[3];

void setup_decoder(Uint32 * restrict ptr){
    //nDecoders : StartId : weights
    Uint32 i , j , offset , count ;
    Uint32 * restrict weights ;
    Uint32 * restrict p1 = ptr ;
    nDecoders = *p1++ ;
    DecoderCheckWindow = *p1++;
    offset    = *p1++ ;
    count     = *p1++ ;

    weights  = (Uint32 *)&(ChannelWeights[(OUTPUT_CHANNELS + 1)*offset]) ;


        for(j = 0 ; j < (OUTPUT_CHANNELS + 1)*count ; j++){
            *weights++ = *p1++ ;
        }


    DecoderCheck = 0 ;
}

void setup_decoder_2(Uint32 * restrict ptr){
    //nDecoders : StartId : weights
    //propeties : nDecoders , d_tau
    //weights   : SynId,nSyn , weights

    Uint32 i , j , SynId , nSyn , mode ;

    Uint32 * restrict weights ;
    Uint32 * restrict p1 = ptr ;

    mode = *p1++;
    switch(mode){
    case 1 : //Properties
        nDecoders = *p1++ ;
        for(i=0;i<3;i++)
            Decoder_d_tau[i] = *ptr++;
        break ;
    case 2 : //Synapse weights
        SynId = *ptr++ ;
        nSyn  = *ptr++ ;
        nSyn  = nSyn*nDecoders;
        weights  = (Uint32 *)&(Decoder_SynapseWeights[(nDecoders)*SynId]) ;
        for(i=0;i<nSyn;i++){
            *weights++ = *ptr++;
        }
        break;
    }


}

void init_decoder(){
     Uint32 i ;
    for(i=0;i<OUTPUT_CHANNELS;i++){
        DecoderState[i].Status         = 0 ;
        DecoderState[i].FirstSpikeTime = 0xFFFFFFFF ;
        DecoderState[i].nSpikes        = 0 ;
        DecoderState[i].Other          = 0 ;
    }
    for(i=0;i<10;i++){
        uDecoderOutput_compressed[i] = 0;
    }
    nDecoders = 0;
    DecoderCheckWindow = 200*50;

    for(i=0;i<MAX_DECODERS;i++){
        Decoder_Iex[i]  = 0 ;
        Decoder_Iinh[i] = 0 ;
        Decoder_V [i]   = 0 ;
    }
    Decoder_d_tau[0] = 0 ;
    Decoder_d_tau[1] = 0 ;
    Decoder_d_tau[2] = 0 ;
}
void reset_decoder_state(){
    Uint32 i ;
    for(i=0;i<OUTPUT_CHANNELS;i++){
        DecoderState[i].Status         = 0 ;
        DecoderState[i].FirstSpikeTime = 0xFFFFFFFF ;
        DecoderState[i].nSpikes        = 0 ;
    }
    if(nDecoders>0){
      DecoderCheck = DecoderCheckWindow ; // 200ms data post stimulus start
    }
    //StimStatus[1] = 5 + (((current_time%50000)&0xFFFF)<<16);
}

void update_decoder_state(){
     Uint32 i,Ch ;

if(DecoderCheck < (DecoderCheckWindow-5*50)){//Initial 5ms period blanking
     for(i=0;i<nSpikes;i++){
        Ch = SpikeData[2*i];
        if(DecoderState[Ch].FirstSpikeTime == 0xFFFFFFFF){
            DecoderState[Ch].FirstSpikeTime = current_time ;
        }
        DecoderState[Ch].nSpikes++ ;
     }
}

}

//Calculate based of occurance of spike
//If separating plane is crossed
void calculate_decoder_output(){
     Uint32 i , j;

     Uint32 acc ;
     int * restrict weights ;
     Uint32 w ;


     for(i=0;i<nDecoders;i++){
         acc = 0;
         weights = &ChannelWeights[i*(OUTPUT_CHANNELS + 1)];
         for(j=0;j<OUTPUT_CHANNELS;j++){
           w = *weights++ ;
           acc+= (DecoderState[j].FirstSpikeTime == 0xFFFFFFFF)? 0 : w ;
         }
         acc += *weights;
         uDecoderOutput[i] = acc ;
        //uDecoderOutput[i] = i ;
     }
     compress_decoder_out();
     DecoderOutputValid = 1 ;
     //StimStatus[1] = 6 + (((current_time%50000)&0xFFFF)<<16);
}

void compress_decoder_out(){
    unsigned int i;
    unsigned int I[MAX_DECODERS];
    sort_id(uDecoderOutput , I,nDecoders );

    //Copy top 10
    for(i=0;i<10;i++){
        uDecoderOutput_compressed[i] = ((I[i]+1)<<16) + (((unsigned int) uDecoderOutput[I[i]])&0xFFFF);
    }
}
//Implement a bubble sort for indices
void sort_id(int *ptr ,unsigned int * I, unsigned int count){

    unsigned  i , j  ;
    int p,q;
    unsigned int v , s;

    int temp_store[MAX_DECODERS];

    for (i = 0 ; i < count ; i++){
        I[i] = i ;
        temp_store[i] = ptr[i];
    }

    for(i = 0 ; i < (count-1) ; i++){
        v = I[i];
        p = ptr[v];
        s = 0;
        for(j=i+1 ; j < count ; j++){
             q = temp_store[j];
             if(p<q){
                v = I[j] ;
                s = j    ;
                p = q    ;
             }
        }

        if(v != I[i]){
         temp_store[s] = temp_store[i];
         temp_store[i] = p            ;
         I[s] = I[i];
         I[i] = v ;
        }
    }
}


void update_decoder_state_2(){

   Uint32 i,j,Ch ,SynId;
   //For all spikes , update the decoder currents
   float w ;
   for(i=0;i<nSpikes;i++){
      Ch = SpikeData[2*i];
      SynId = Ch*nDecoders ;
      for(j=0;j<nDecoders;j++){
         w = Decoder_SynapseWeights[SynId + j] ;
         if(w>0){
            Decoder_Iex[j]+= w ;
         }
         else{
            Decoder_Iinh[j]+= w ;
         }
      }
   }

  //Update membrane potential
  for(i=0;i<nDecoders;i++){
        Decoder_V[i] = Decoder_Iex[i] + Decoder_Iex[j];
  }

  //Decay memrane potential and currents
  //603.6844(0),603.6722(8),604.6014(16), 604.6582(32) , 1049.6796(128) , 1417(192),1847.6814(256)
  scale_array(((double *)&Decoder_V[0]),Decoder_d_tau[0],nDecoders);
  scale_array(((double *)&Decoder_Iex[0]),Decoder_d_tau[1],nDecoders);
  scale_array(((double *)&Decoder_Iinh[0]),Decoder_d_tau[2],nDecoders);
}

void scale_array(double a[restrict], const float b , unsigned int count)
{

    unsigned int i ;
    float r[2];

    _nassert((count & 0x3) == 0);

    count = count/2;
    for (i=0; i<count; i++)
    {
      r[0] = _itof(_lo(a[i])) * b;
      r[1] = _itof(_hi(a[i])) * b;
      a[i] = _itod(_ftoi(r[1]),_ftoi(r[0]));
    }

}


void scale_array_2(double a[restrict], const short  b, unsigned int n){
   unsigned int i ;
   int scale = b  ;
   scale = _pack2(scale,scale);
   double x[4] ;
   for(i=0;i<n>>3;i++){
      x[0] = _smpy2(_lo(a[2*i]),scale);
      x[1] = _smpy2(_hi(a[2*i]),scale);
      x[2] = _smpy2(_lo(a[2*i+1]),scale);
      x[3] = _smpy2(_hi(a[2*i+1]),scale);
      a[2*i] = _itod( _pack2(_lo(x[1]),_hi(x[1])), _pack2(_lo(x[0]),_hi(x[0])));
      a[2*i+1] = _itod( _pack2(_lo(x[3]),_hi(x[3])), _pack2(_lo(x[2]),_hi(x[2])));
   }
}

