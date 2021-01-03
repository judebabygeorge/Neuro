#include "global.h"
#include "typedef.h"

#define STIM_SEQUENCE_MAX_ELEMENTS 256


struct StimPattern_T1{
    //Pattern Type
    uint16 len         ; //Length in bytes
    uint16 PatternType ; //0 => dummy

    //Pattern Description
    //Pulse Definition
    int16 Up    ; // Positive Pulse Amplitude
    int16 Un    ; // Negative Pulse Amplitude

    uint32 Tp    ; // Positive Pulse Width
    uint32 Tn    ; // Negative Pulse Width

    //Delay Definitions

    uint32 d      ; // Start Delay

    uint32 dP     ; // Delay Between pulses in a train
    uint32 dT     ; // Delay Between trains

    uint16 CountP ; // Number of Pulses
    uint16 CountT ; // Number of Trains

};
typedef struct StimPattern_T1 StimPattern_T1;

struct StimPattern_T2{
    //Pattern Type
    uint16 len         ; //Length in bytes
    uint16 PatternType ; //0 => dummy

    uint32 nVectors_P    ;
    uint32 nVectors_SB    ;
    uint32 Vectors[256]; //Max 256 Words / Vector = ~256 Samples
};
typedef struct StimPattern_T2 StimPattern_T2;

struct StimInfo{
    uint16 len ;
    uint16 Type;
    Uint32 SegmentID;
    Uint32 nPatterns;
    uint16 Patterns[1024] ;
};
typedef struct StimInfo StimInfo ;

struct Stim_SequenceElement{
    Uint32 Config   ;
    Uint32 Delay    ;
};
typedef struct Stim_SequenceElement Stim_SequenceElement ;

struct Stim_SequenceList{
  Uint32 Next_Element   ;
  Uint32 nElements      ;
  Uint32 Next_TimeStamp ;

  Uint32 nLoop          ;
  Uint32 nJumpBack      ;

  Uint16 Triggers       ;
  Uint16 SequenceId     ;
  Stim_SequenceElement E[STIM_SEQUENCE_MAX_ELEMENTS];
};
typedef struct Stim_SequenceList Stim_SequenceList ;
extern Stim_SequenceList u_Stim_SequenceList ;


void Stim_LoadPattern(StimInfo * uStimInfo);

void UpLoadPatternToHS(Uint32 HS_Addr,Uint32 ChannelId,Uint32 SegmentId,uint16 * uP);
//void AssignElectrodes2DAC(Uint32 HS,Uint32 SegmentID , StimPattern_T0 * uP,uint32 DAC_ID);
void Stim_SetupStimGen();
void Stim_SetupTrigger();
void Stim_Trigger(Uint32 Segment , Uint32 ConfigId ,Uint32 Triggers);
void Stim_LoadElectrodeConfig(Uint32 ConfigId, Uint32 * Config);

void Stim_SetElectrodeConfig(Uint32 ConfigId);
void Stim_SetElectrodeConfig0(Uint32 HS , Uint32 ConfigId);

void Stim_LoadStimSequenceList(Uint32 Offset , Uint32 nList , Uint32 * Data);
void Stim_StartSequence(Uint32 Offset,Uint32 nElements , Uint32 nLoop , Uint32 nJumpBack ,Uint32 Triggers , Uint32 StartTime);
void Stim_CheckSequence(Uint32 current_time);
void Stim_StopSequence();

void Stim_StartBlanking();
void Stim_BlankElectrodes(Uint32 Enable);
void Set_Segment(Uint32 Segment);
