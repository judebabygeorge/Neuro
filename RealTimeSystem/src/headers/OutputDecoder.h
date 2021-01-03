#ifndef _OUTPUTDECODER_H_
#define _OUTPUTDECODER_H_


#define OUTPUT_CHANNELS (CHANNELS_FOR_CALC)
#define MAX_DECODERS    64


extern int uDecoderOutput[MAX_DECODERS];
extern int uDecoderOutput_compressed[10]; //Top 10 to output
extern Uint32 nDecoders    ;
extern volatile int    DecoderOutputValid ;
extern volatile int  DecoderCheck       ;
extern float         Decoder_V[MAX_DECODERS];

struct Output_ChannelState {
    Uint32 FirstSpikeTime ;
    Uint32 nSpikes ;
    Uint32 Status  ;
    float  Other   ;

};
typedef struct Output_ChannelState Output_ChannelState;

struct DecoderOutput{
      Uint32 ChannelWeights[OUTPUT_CHANNELS + 1];
      Uint32 ChannelOutput;
};
typedef struct DecoderOutput DecoderOutput ;


void setup_decoder(Uint32 * ptr);
void init_decoder();
void reset_decoder_state();
void update_decoder_state();
void calculate_decoder_output();
void compress_decoder_out();
void sort_id(int *ptr ,unsigned int * I, unsigned int count);
void scale_array(double a[restrict], const float b , unsigned int count);
void setup_decoder_2(Uint32 * ptr);
void update_decoder_state_2();
#endif // _OUTPUTDECODER_H_
