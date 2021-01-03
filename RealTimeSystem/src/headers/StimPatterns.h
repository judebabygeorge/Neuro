
#define PATTERN_BUFFER_SIZE 1024
#define MAX_STIM_PATTRENS   256

struct Stim_PatternElement {
    Uint32 Config ;  //[ValidConfig:0000:Segment:Config]
    Uint32 Delay  ;
};
typedef struct Stim_PatternElement Stim_PatternElement ;

struct Stim_Pattern {
    Uint32 nElements        ;
    Stim_PatternElement * E ; //nElements
};
typedef struct Stim_Pattern Stim_Pattern ;

//128*(2*4 + 1) + 128 + 1 = 1300 words
struct Stim_PatternSequence{

    Uint32 Start                      ;
    Uint32 End                        ;
    Uint32 nLoop                      ;
    Uint32 Triggers                   ;

    Uint32 NextPattern                ;
    Uint32 NextElement                ;
    Uint32 Next_TimeStamp             ;


    Uint32 nPatterns                  ;
    Uint32 Patterns[MAX_STIM_PATTRENS];//[Marker:PatternId]
};
typedef struct Stim_PatternSequence Stim_PatternSequence;
extern Uint32  PatternBuffer[PATTERN_BUFFER_SIZE] ;
extern Stim_PatternSequence u_Stim_PatternSequence;

void StimPatternSequence_Start(Uint32 Start , Uint32 End, Uint32 nLoop , Uint32 Triggers , Uint32 StartTime );
void StimPatternSequence_Check(Uint32 current_time);
void StimPatternSequence_LoadPatterBuffer(Uint32 Count , Uint32 * p);
void StimPatternSequence_LoadPatternSequence(Uint32 Count , Uint32 * p);
