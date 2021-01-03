
#include "global.h"
#include "typedef.h"

#include "StimPatterns.h"
#include "StimTrain.h"

StimTrainExecute uStimTrainExecute ;
StimTrainSequence uStimTrainSequence;

void StimTrain_Setup(Uint32 *p){
     int i;
     uStimTrainSequence.nRepeat   =  *p++;
     uStimTrainSequence.nElements =  *p++;
     uStimTrainSequence.nElements = uStimTrainSequence.nElements  > 128 ? 128 : uStimTrainSequence.nElements ;
     for(i=0 ; i < uStimTrainSequence.nElements ; i++){
       *((Uint32 *)&uStimTrainSequence.Elements[i] + 0) = *p++;
       *((Uint32 *)&uStimTrainSequence.Elements[i] + 1) = *p++;
     }
}
void StimTrain_Trigger(Uint32 Enabled){
    uStimTrainExecute.NextPattern = 0;
    uStimTrainExecute.CurrentElement = 0;
    uStimTrainExecute.CurrentElementRepeatCount = 0;
    uStimTrainExecute.SequenceRepeatCount = 0;
    uStimTrainExecute.isEnabled = Enabled;
}
void StimTrain_Step(){
    if(uStimTrainExecute.isEnabled == 1){
        //Set Up indices
        if(uStimTrainExecute.NextPattern == uStimTrainSequence.Elements[uStimTrainExecute.CurrentElement].nPatterns){
            uStimTrainExecute.NextPattern = 0;
            uStimTrainExecute.CurrentElementRepeatCount = uStimTrainExecute.CurrentElementRepeatCount + 1 ;
            if(uStimTrainExecute.CurrentElementRepeatCount >= uStimTrainSequence.Elements[uStimTrainExecute.CurrentElement].nRepeat){
                uStimTrainExecute.CurrentElementRepeatCount = 0;
                uStimTrainExecute.CurrentElement = uStimTrainExecute.CurrentElement + 1;
                if(uStimTrainExecute.CurrentElement == uStimTrainSequence.nElements){
                    uStimTrainExecute.CurrentElement = 0;
                    uStimTrainExecute.SequenceRepeatCount = uStimTrainExecute.SequenceRepeatCount + 1;
                }
            }
        }
        if(uStimTrainExecute.SequenceRepeatCount < uStimTrainSequence.nRepeat){
        //Execute Pattern
            Uint32 Pid = uStimTrainSequence.Elements[uStimTrainExecute.CurrentElement].PatternId[uStimTrainExecute.NextPattern];
            if(Pid > 0){
                Pid = Pid - 1;
                StimPatternSequence_Start(2*Pid ,2*(Pid+1) - 1 , 1 , 1 , current_time + 100 );
            }
            uStimTrainExecute.NextPattern = uStimTrainExecute.NextPattern + 1;
        }else{
            uStimTrainExecute.isEnabled = 0;
        }
    }
}
