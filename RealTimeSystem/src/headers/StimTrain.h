
typedef struct _StimTrainElement_ {
    uint16 nRepeat;
    uint16 nPatterns;
    uint8  PatternId[4];
}StimTrainElement;

typedef struct _StimTrainSequence_{
    Uint32 nRepeat  ;
    Uint32 nElements;
    StimTrainElement Elements[128];
} StimTrainSequence;

typedef struct _StimTrainExecute_{
    Uint32 isEnabled ;
    Uint32 NextPattern;
    Uint32 CurrentElement;
    Uint32 CurrentElementRepeatCount ;
    Uint32 SequenceRepeatCount;
}StimTrainExecute;



void StimTrain_Setup(Uint32 *p);
void StimTrain_Trigger();
void StimTrain_Step();
