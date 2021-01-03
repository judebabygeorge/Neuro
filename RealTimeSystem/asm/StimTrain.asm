;******************************************************************************
;* TMS320C6x C/C++ Codegen                                          PC v7.4.2 *
;* Date/Time created: Sun Jun 01 23:30:47 2014                                *
;******************************************************************************
	.compiler_opts --abi=coffabi --c64p_l1d_workaround=default --endian=little --hll_source=on --long_precision_bits=40 --mem_model:code=near --mem_model:const=data --mem_model:data=far_aggregates --object_format=coff --silicon_version=6500 --symdebug:none 

;******************************************************************************
;* GLOBAL FILE PARAMETERS                                                     *
;*                                                                            *
;*   Architecture      : TMS320C64x+                                          *
;*   Optimization      : Enabled at level 3                                   *
;*   Optimizing for    : Speed                                                *
;*                       Based on options: -o3, no -ms                        *
;*   Endian            : Little                                               *
;*   Interrupt Thrshld : Disabled                                             *
;*   Data Access Model : Far Aggregate Data                                   *
;*   Pipelining        : Enabled                                              *
;*   Speculate Loads   : Enabled with threshold = 17                          *
;*   Memory Aliases    : Presume are aliases (pessimistic)                    *
;*   Debug Info        : No Debug Info                                        *
;*                                                                            *
;******************************************************************************

	.asg	A15, FP
	.asg	B14, DP
	.asg	B15, SP
	.global	$bss

	.global	_uStimTrainExecute
_uStimTrainExecute:	.usect	".far",20,4
	.global	_uStimTrainSequence
_uStimTrainSequence:	.usect	".far",1032,4
;	opt6x C:\\Users\\45c\\AppData\\Local\\Temp\\096162 C:\\Users\\45c\\AppData\\Local\\Temp\\096164 
	.sect	".text"
	.clink
	.global	_StimTrain_Trigger

;******************************************************************************
;* FUNCTION NAME: StimTrain_Trigger                                           *
;*                                                                            *
;*   Regs Modified     : A3,A5,A6,B4,B5                                       *
;*   Regs Used         : A3,A4,A5,A6,B3,B4,B5                                 *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_StimTrain_Trigger:
;** --------------------------------------------------------------------------*

           RET     .S2     B3                ; |27| 
||         MVKL    .S1     _uStimTrainExecute+4,A3

           MVKH    .S1     _uStimTrainExecute+4,A3
           ZERO    .L2     B4                ; |22| 

           STW     .D1T2   B4,*A3            ; |22| 
||         ADD     .L2X    12,A3,B5
||         ADD     .L1     8,A3,A5
||         ZERO    .S1     A6                ; |22| 

           ADD     .L1     -4,A3,A3
||         ADD     .L2X    4,A3,B4
||         ZERO    .S2     B5                ; |22| 
||         STW     .D2T2   B4,*B5            ; |25| 
||         STW     .D1T1   A6,*A5            ; |24| 

           STW     .D1T1   A4,*A3            ; |26| 
||         STW     .D2T2   B5,*B4            ; |23| 

           ; BRANCH OCCURS {B3}              ; |27| 
	.sect	".text"
	.clink
	.global	_StimTrain_Step

;******************************************************************************
;* FUNCTION NAME: StimTrain_Step                                              *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,B10,B11,B13,SP,A16,A17,A18,A19,A20,A21, *
;*                           A22,A23,A24,A25,A26,A27,A28,A29,A30,A31,B16,B17, *
;*                           B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29, *
;*                           B30,B31                                          *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,B10,B11,B13,DP,SP,A16,A17,A18,A19,A20,  *
;*                           A21,A22,A23,A24,A25,A26,A27,A28,A29,A30,A31,B16, *
;*                           B17,B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28, *
;*                           B29,B30,B31                                      *
;*   Local Frame Size  : 0 Args + 0 Auto + 16 Save = 16 byte                  *
;******************************************************************************
_StimTrain_Step:
;** --------------------------------------------------------------------------*

           STW     .D2T2   B13,*SP--(8)      ; |28| 
||         MVKL    .S1     _uStimTrainExecute,A3
||         MVK     .S2     8,B4
||         MV      .L2     B3,B13            ; |28| 

           STDW    .D2T2   B11:B10,*SP--     ; |28| 
||         MVKH    .S1     _uStimTrainExecute,A3

           LDW     .D1T1   *A3,A4            ; |29| 
           MVKL    .S2     _uStimTrainSequence,B8
           MVKH    .S2     _uStimTrainSequence,B8
           ADD     .L2X    A3,B4,B4
           ADD     .L2     -4,B4,B10
           CMPEQ   .L1     A4,1,A0           ; |29| 

   [!A0]   BNOP    .S1     $C$L3,4           ; |29| 
|| [ A0]   LDW     .D2T2   *B4,B6            ; |31| 

           ADDAD   .D2     B8,B6,B7          ; |31| 
           ; BRANCHCC OCCURS {$C$L3}         ; |29| 
;** --------------------------------------------------------------------------*
           LDW     .D2T2   *B10,B5           ; |31| 
           LDHU    .D2T2   *+B7(10),B9       ; |31| 
           ZERO    .L1     A5                ; |32| 
           ADD     .L1X    4,B4,A6
           NOP             2
           CMPEQ   .L2     B5,B9,B0          ; |31| 

   [!B0]   BNOP    .S1     $C$L1,4           ; |31| 
|| [ B0]   LDW     .D1T1   *A6,A4            ; |33| 
|| [ B0]   LDHU    .D2T2   *+B7(8),B5        ; |34| 

           ADD     .L1     1,A4,A4           ; |33| 
           ; BRANCHCC OCCURS {$C$L1}         ; |31| 
;** --------------------------------------------------------------------------*

           ADD     .L2     4,B8,B31
||         CMPLTU  .L1X    A4,B5,A0          ; |34| 
||         ADD     .S2     1,B6,B30          ; |37| 
||         MV      .S1     A6,A7             ; |34| 
||         STW     .D2T1   A5,*B10           ; |32| 

   [!A0]   LDW     .D2T2   *B31,B7           ; |37| 
|| [!A0]   MV      .L1X    B4,A8
|| [!A0]   ADD     .L2     1,B6,B6           ; |37| 
|| [ A0]   MVK     .S2     0x1,B0            ; |39| 
|| [ A0]   STW     .D1T1   A4,*A6
||         MV      .S1     A5,A4

           MV      .L2X    A5,B5
   [!A0]   STW     .D1T1   A5,*A7            ; |35| 
           MV      .L1X    B4,A9             ; |38| 
   [!A0]   ADD     .L1     4,A6,A5
   [!A0]   CMPEQ   .L2     B30,B7,B0         ; |37| 

   [!B0]   STW     .D1T2   B6,*A8
|| [ A0]   MV      .L2X    A5,B0
|| [!A0]   ADD     .L1     4,A6,A8

   [!B0]   BNOP    .S1     $C$L1,3
|| [ B0]   LDW     .D1T1   *A5,A5            ; |39| 

   [ B0]   STW     .D1T1   A4,*A9            ; |38| 
           ADD     .L1     1,A5,A4           ; |39| 
           ; BRANCHCC OCCURS {$C$L1}  
;** --------------------------------------------------------------------------*

           MV      .L2     B5,B6             ; |39| 
||         STW     .D1T1   A4,*A8            ; |39| 

;** --------------------------------------------------------------------------*
$C$L1:    

           ADD     .L1     4,A6,A4
||         LDW     .D2T2   *B8,B4            ; |43| 

           LDW     .D1T1   *A4,A4            ; |43| 
           MVK     .L2     12,B7             ; |46| 
           ADDAD   .D2     B7,B6,B6          ; |46| 
           NOP             2

           CMPLTU  .L1X    A4,B4,A0          ; |43| 
||         ADD     .L2     B5,B6,B4          ; |46| 
||         ZERO    .S2     B6                ; |52| 

   [!A0]   BNOP    .S1     $C$L3,1           ; |43| 
|| [ A0]   LDBU    .D2T2   *+B4[B8],B0       ; |46| 

   [ A0]   LDW     .D2T2   *+DP(_current_time),B6 ; |48| 
   [!A0]   MVK     .L2     0x1,B0            ; |48| nullify predicate
   [!A0]   STW     .D1T2   B6,*A3            ; |52| 
   [!B0]   B       .S1     $C$L2             ; |46| 
           ; BRANCHCC OCCURS {$C$L3}         ; |43| 
;** --------------------------------------------------------------------------*

           MVK     .L1     0x1,A6            ; |48| 
|| [!B0]   MV      .L2     B13,B3            ; |55| 
|| [ B0]   CALL    .S1     _StimPatternSequence_Start ; |48| 
||         ADD     .S2     B0,B0,B4          ; |48| 
||         MV      .D2     B10,B11           ; |48| 

           ADDAW   .D2     B6,25,B8          ; |48| 

           MV      .L2X    A6,B6             ; |48| 
||         SUB     .L1X    B4,2,A4           ; |48| 
||         SUB     .S2     B4,1,B4           ; |48| 

           MV      .L1X    B8,A8             ; |48| 
|| [!B0]   ADD     .L2     1,B5,B4           ; |50| 

   [!B0]   STW     .D2T2   B4,*B10           ; |50| 
           ; BRANCHCC OCCURS {$C$L2}         ; |46| 
;** --------------------------------------------------------------------------*
           ADDKPC  .S2     $C$RL0,B3,0       ; |48| 
$C$RL0:    ; CALL OCCURS {_StimPatternSequence_Start} {0}  ; |48| 
;** --------------------------------------------------------------------------*
           LDW     .D2T2   *B11,B5           ; |48| 
           MV      .L2     B13,B3            ; |55| 
           NOP             3
           ADD     .L2     1,B5,B4           ; |50| 
           STW     .D2T2   B4,*B10           ; |50| 
;** --------------------------------------------------------------------------*
$C$L2:    

           LDDW    .D2T2   *++SP,B11:B10     ; |55| 
||         RET     .S2     B3                ; |55| 

           LDW     .D2T2   *++SP(8),B13      ; |55| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |55| 
;** --------------------------------------------------------------------------*
$C$L3:    

           LDDW    .D2T2   *++SP,B11:B10     ; |55| 
||         RET     .S2     B3                ; |55| 

           LDW     .D2T2   *++SP(8),B13      ; |55| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |55| 
	.sect	".text"
	.clink
	.global	_StimTrain_Setup

;******************************************************************************
;* FUNCTION NAME: StimTrain_Setup                                             *
;*                                                                            *
;*   Regs Modified     : A0,A3,A4,A5,B0,B4,B5,B6,B7                           *
;*   Regs Used         : A0,A3,A4,A5,B0,B3,B4,B5,B6,B7                        *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_StimTrain_Setup:
;** --------------------------------------------------------------------------*
           MV      .L2X    A4,B5             ; |11| 
           LDW     .D2T2   *B5++,B4          ; |13| 
           MVKL    .S1     _uStimTrainSequence,A3
           MVKH    .S1     _uStimTrainSequence,A3
           ADD     .L1     4,A3,A4
           MVK     .S1     0x80,A0           ; |15| 
           STW     .D1T2   B4,*A3            ; |13| 
           LDW     .D2T2   *B5,B4            ; |14| 
           NOP             4
           STW     .D1T2   B4,*A4            ; |14| 
           LDW     .D1T1   *A4,A4            ; |15| 
           MVK     .S2     128,B4            ; |15| 
           NOP             3
           CMPGTU  .L2X    A4,B4,B0          ; |15| 

   [!B0]   MV      .L1     A4,A0             ; |15| 
||         MV      .L2X    A3,B4             ; |13| 

   [!A0]   BNOP    .S1     $C$L7,5           ; |16| 
||         STW     .D1T1   A0,*+A3(4)        ; |15| 
|| [ A0]   SUB     .L2     B5,4,B7           ; |14| 
|| [ A0]   SUB     .L1     A0,1,A3

           ; BRANCHCC OCCURS {$C$L7}         ; |16| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\StimTrain.c
;*      Loop source line                 : 16
;*      Loop opening brace source line   : 16
;*      Loop closing brace source line   : 19
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 12
;*      Unpartitioned Resource Bound     : 2
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     0        0     
;*      .D units                     2*       2*    
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             2*       2*    
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          0        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        0     
;*      Bound(.L .S .D .LS .LSD)     1        1     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 12 Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 0
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L4:    ; PIPED LOOP PROLOG

           SPLOOPD 12      ;24               ; (P) 
||         ADD     .L2     8,B7,B5
||         MVC     .S2X    A3,ILC

;** --------------------------------------------------------------------------*
$C$L5:    ; PIPED LOOP KERNEL
           LDW     .D2T2   *B5++(8),B6       ; |17| (P) <0,0>  ^ 
           NOP             3

           SPMASK          L1,L2
||         ADD     .L1X    12,B4,A3
||         ADD     .L2     8,B4,B4

           SPMASK          L1
||         ADD     .L1X    12,B7,A4
||         STW     .D2T2   B6,*B4++(8)       ; |17| (P) <0,5>  ^ 

           LDW     .D1T1   *A4++(8),A5       ; |18| (P) <0,6>  ^ 
           NOP             4
           STW     .D1T1   A5,*A3++(8)       ; |18| (P) <0,11>  ^ 
           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L6:    ; PIPED LOOP EPILOG
           NOP             1
;** --------------------------------------------------------------------------*
$C$L7:    
           RETNOP  .S2     B3,5              ; |20| 
           ; BRANCH OCCURS {B3}              ; |20| 
;*****************************************************************************
;* UNDEFINED EXTERNAL REFERENCES                                             *
;*****************************************************************************
	.global	_StimPatternSequence_Start
	.global	_current_time

;******************************************************************************
;* BUILD ATTRIBUTES                                                           *
;******************************************************************************
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_needed(0)
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_preserved(0)
	.battr "TI", Tag_File, 1, Tag_Tramps_Use_SOC(1)
