
#include "MEA21_lib.h"
#include "global.h"
#include "Stim.h"
#include "StimPatterns.h"
#include "OutputDecoder.h"

Uint32  PatternBuffer[PATTERN_BUFFER_SIZE] ;
Stim_PatternSequence u_Stim_PatternSequence;


void StimPatternSequence_Start(Uint32 Start , Uint32 End, Uint32 nLoop , Uint32 Triggers , Uint32 StartTime ){

  Uint32 p , q;

  u_Stim_PatternSequence.Start       = Start     ;
  u_Stim_PatternSequence.End         = End       ;
  u_Stim_PatternSequence.nLoop       = nLoop     ;
  u_Stim_PatternSequence.Triggers    = Triggers  ;

  u_Stim_PatternSequence.NextPattern = u_Stim_PatternSequence.Start      ;
  u_Stim_PatternSequence.NextElement = 0 ;

  p = u_Stim_PatternSequence.Patterns[u_Stim_PatternSequence.NextPattern];

  q = PatternBuffer[1+p];
  u_Stim_PatternSequence.Next_TimeStamp = StartTime + PatternBuffer[q + 1 + (u_Stim_PatternSequence.NextElement)*2 + 1] ;


  if(End >= Start){
   StimPatternSequence_Enabled = 1  ;
   StimStatus[1] = 1  + (((current_time%50000)&0xFFFF)<<16) ;
  }


}

void StimPatternSequence_Check(Uint32 current_time){

    Uint32 p , q;
    //Stim_Pattern  * Pat_i ;
    Uint32 Config         ;



    if(StimPatternSequence_Enabled==1){
        if(current_time >= u_Stim_PatternSequence.Next_TimeStamp){

            //Execute The Pattern Element Config Config
            p = u_Stim_PatternSequence.Patterns[u_Stim_PatternSequence.NextPattern];

            q = PatternBuffer[1+p];
            Config=PatternBuffer[q + 1 + (u_Stim_PatternSequence.NextElement)*2 + 0] ;
            if(((Config & 0xFF000000)== 0)&&((Config&0xFF)!=0)){ // Is a valid config
               //Stim_Trigger((Config>>8)&0xFF,Config&0xFF,u_Stim_PatternSequence.Triggers);
               Stim_Trigger((Config>>8)&0xFF,Config&0xFF,(Config>>16)&0xFF);
               StimStatus[0] = p + (u_Stim_PatternSequence.NextElement << 8)  + ((Config & 0x00FF0000)) + ((Config&0x000000FF)<<24);
               //If this is the first element of a pattern sequence
               if(u_Stim_PatternSequence.NextElement == 0){
                   reset_decoder_state();
               }
            }



            //Find the next element to execute
            u_Stim_PatternSequence.NextElement = u_Stim_PatternSequence.NextElement + 1 ;
            if(u_Stim_PatternSequence.NextElement == PatternBuffer[q]){ //Done with the elements in this pattern
              //Go to next pattern
              u_Stim_PatternSequence.NextPattern = u_Stim_PatternSequence.NextPattern + 1 ;
              u_Stim_PatternSequence.NextElement = 0 ;

              if(u_Stim_PatternSequence.NextPattern > u_Stim_PatternSequence.End){ //Done with this pattern sequence
                   u_Stim_PatternSequence.NextPattern = u_Stim_PatternSequence.Start ;
                   u_Stim_PatternSequence.nLoop       -=1 ;

                   if(u_Stim_PatternSequence.nLoop > 0){
                     StimStatus[1] = 2 + (u_Stim_PatternSequence.nLoop<<8);
                   } else { // Done with all looping
                     StimPatternSequence_Enabled = 0 ;
                     StimStatus[1] = 3;
                   }
              }
            }

            //Next pattern and element is figured out here
            //Now set the delay for this elemnt
            p = u_Stim_PatternSequence.Patterns[u_Stim_PatternSequence.NextPattern];
            q = PatternBuffer[1+p];
            u_Stim_PatternSequence.Next_TimeStamp += PatternBuffer[q + 1 + (u_Stim_PatternSequence.NextElement)*2 + 1];
        }

    }

          #ifdef 0
          if(Stim_BlankingCounter>=0){
            if(Stim_BlankingCounter==86){
                Stim_BlankElectrodes(1);
            }
            Stim_BlankingCounter-- ;
            if(Stim_BlankingCounter==0){
                Stim_BlankElectrodes(0);
            }
            Stim_BlankingCounter-- ;
          }
          #endif

}

void StimPatternSequence_LoadPatterBuffer(Uint32 Count , Uint32 * p) {
    Uint32 i ;
    Uint32 Offset ;

    Offset = p[0] ;
    for(i=0;i<Count-1;i++){
      PatternBuffer[Offset + i] =  p[i+1];
    }


}

void StimPatternSequence_LoadPatternSequence(Uint32 Count , Uint32 * p){
   Uint32 i ;
   u_Stim_PatternSequence.nPatterns = Count ;
   for(i=0;i<Count;i++){
      u_Stim_PatternSequence.Patterns[i] = p[i];
   }
}

