;******************************************************************************
;* TMS320C6x C/C++ Codegen                                          PC v7.4.2 *
;* Date/Time created: Sat May 31 10:51:08 2014                                *
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

	.global	_PatternBuffer
_PatternBuffer:	.usect	".far",4096,8
	.global	_u_Stim_PatternSequence
_u_Stim_PatternSequence:	.usect	".far",1056,4
;	opt6x C:\\Users\\45c\\AppData\\Local\\Temp\\079362 C:\\Users\\45c\\AppData\\Local\\Temp\\079364 
	.sect	".text"
	.clink
	.global	_StimPatternSequence_Start

;******************************************************************************
;* FUNCTION NAME: StimPatternSequence_Start                                   *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A7,A9,B0,B1,B2,B3,B4,B5,B7,B8,B9,  *
;*                           B30,B31                                          *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,DP,SP,B30,B31                           *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_StimPatternSequence_Start:
;** --------------------------------------------------------------------------*

           CMPLTU  .L1X    B4,A4,A0          ; |30| 
||         MVKL    .S1     _u_Stim_PatternSequence,A5

           MVKH    .S1     _u_Stim_PatternSequence,A5
           MVK     .S2     16,B5
           MV      .L2X    A5,B8             ; |16| 
           STW     .D2T1   A4,*B8            ; |16| 
           LDW     .D1T1   *A5,A3            ; |21| 
           MV      .L1X    B3,A2             ; |12| 
           MVKL    .S2     _PatternBuffer,B9
           MVKL    .S1     _StimStatus+4,A9
           ADD     .L2X    A5,B5,B5
           STW     .D2T1   A3,*+B8(16)       ; |21| 
           LDW     .D2T2   *B5,B7            ; |27| 
           MVKH    .S2     _PatternBuffer,B9
           MVKH    .S1     _StimStatus+4,A9
           STW     .D2T2   B4,*+B8(4)        ; |17| 
           MVKL    .S2     0xc350,B4
           ADDAW   .D2     B8,B7,B7          ; |27| 
           LDW     .D2T2   *+B7(32),B7       ; |27| 
           MVKH    .S2     0xc350,B4
           LDW     .D2T1   *+DP(_current_time),A4 ; |32| 
           STW     .D2T2   B6,*+B8(12)       ; |19| 
           STW     .D2T1   A6,*+B8(8)        ; |18| 
           ADD     .L2     1,B7,B7           ; |27| 
           LDW     .D2T2   *+B9[B7],B7       ; |27| 
           MVK     .S1     8,A3
           ADD     .L1X    B5,A3,A3
           ZERO    .L2     B5                ; |22| 
           STW     .D2T2   B5,*+B8(20)       ; |22| 
           ADD     .L2     2,B7,B7           ; |27| 
           LDW     .D2T2   *+B9[B7],B7       ; |27| 
   [ A0]   B       .S1     $C$L1             ; |30| 
   [!A0]   CALL    .S1     __remu            ; |32| 
   [ A0]   RETNOP  .S2X    A2,1              ; |36| 
           ADD     .L1X    A8,B7,A5          ; |27| 

           STW     .D1T1   A5,*A3            ; |27| 
||         MVK     .L1     1,A3              ; |31| 

           ; BRANCHCC OCCURS {$C$L1}         ; |30| 
;** --------------------------------------------------------------------------*

           ADDKPC  .S2     $C$RL0,B3,0       ; |32| 
||         STW     .D2T1   A3,*+DP(_StimPatternSequence_Enabled) ; |31| 

$C$RL0:    ; CALL OCCURS {__remu} {0}        ; |32| 
;** --------------------------------------------------------------------------*
           RET     .S2X    A2                ; |36| 
           SHL     .S1     A4,16,A3          ; |32| 
           ADD     .L1     1,A3,A3           ; |32| 
           STW     .D1T1   A3,*A9            ; |32| 
;** --------------------------------------------------------------------------*
$C$L1:    
           NOP             2
           ; BRANCH OCCURS {A2}              ; |36| 
	.sect	".text"
	.clink
	.global	_StimPatternSequence_LoadPatternSequence

;******************************************************************************
;* FUNCTION NAME: StimPatternSequence_LoadPatternSequence                     *
;*                                                                            *
;*   Regs Modified     : A0,A3,A5,B4,B5,B6                                    *
;*   Regs Used         : A0,A3,A4,A5,B3,B4,B5,B6                              *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_StimPatternSequence_LoadPatternSequence:
;** --------------------------------------------------------------------------*

           MV      .L1     A4,A0             ; |122| 
||         MVKL    .S1     _u_Stim_PatternSequence,A3

   [!A0]   BNOP    .S2     $C$L5,2           ; |125| 
||         MVKH    .S1     _u_Stim_PatternSequence,A3

           STW     .D1T1   A0,*+A3(28)       ; |124| 
           ADDAD   .D1     A3,4,A5
   [ A0]   SUB     .L1     A4,1,A3
           ; BRANCHCC OCCURS {$C$L5}         ; |125| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\StimPatterns.c
;*      Loop source line                 : 125
;*      Loop opening brace source line   : 125
;*      Loop closing brace source line   : 127
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 6
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     0        0     
;*      .D units                     0        2*    
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             0        2*    
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          0        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        0     
;*      Bound(.L .S .D .LS .LSD)     0        1     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 6  Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 0
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L2:    ; PIPED LOOP PROLOG

           SPLOOPD 6       ;12               ; (P) 
||         MV      .L2     B4,B5
||         MVC     .S2X    A3,ILC

;** --------------------------------------------------------------------------*
$C$L3:    ; PIPED LOOP KERNEL
           LDW     .D2T2   *B5++,B4          ; |126| (P) <0,0>  ^ 
           NOP             3

           SPMASK          L2
||         MV      .L2X    A5,B6

           STW     .D2T2   B4,*B6++          ; |126| (P) <0,5>  ^ 
           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L4:    ; PIPED LOOP EPILOG
           NOP             1
;** --------------------------------------------------------------------------*
$C$L5:    
           RETNOP  .S2     B3,5              ; |128| 
           ; BRANCH OCCURS {B3}              ; |128| 
	.sect	".text"
	.clink
	.global	_StimPatternSequence_LoadPatterBuffer

;******************************************************************************
;* FUNCTION NAME: StimPatternSequence_LoadPatterBuffer                        *
;*                                                                            *
;*   Regs Modified     : A0,A3,B4,B5,B6,B7                                    *
;*   Regs Used         : A0,A3,A4,B3,B4,B5,B6,B7                              *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_StimPatternSequence_LoadPatterBuffer:
;** --------------------------------------------------------------------------*

           CMPEQ   .L1     A4,1,A0           ; |115| 
||         SUB     .S1     A4,1,A3
||         MVKL    .S2     _PatternBuffer,B6
||         ADD     .L2     4,B4,B5

   [ A0]   BNOP    .S1     $C$L9,5           ; |115| 
|| [!A0]   SUB     .L1     A3,1,A3
||         MVKH    .S2     _PatternBuffer,B6

           ; BRANCHCC OCCURS {$C$L9}         ; |115| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\StimPatterns.c
;*      Loop source line                 : 115
;*      Loop opening brace source line   : 115
;*      Loop closing brace source line   : 117
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 6
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     0        0     
;*      .D units                     0        2*    
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             0        2*    
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          0        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        0     
;*      Bound(.L .S .D .LS .LSD)     0        1     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 6  Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 0
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L6:    ; PIPED LOOP PROLOG

           SPLOOPD 6       ;12               ; (P) 
||         LDW     .D2T2   *B4,B7
||         MVC     .S2X    A3,ILC

;** --------------------------------------------------------------------------*
$C$L7:    ; PIPED LOOP KERNEL
           LDW     .D2T2   *B5++,B4          ; |116| (P) <0,0>  ^ 
           NOP             3

           SPMASK          D2
||         ADDAW   .D2     B6,B7,B6

           STW     .D2T2   B4,*B6++          ; |116| (P) <0,5>  ^ 
           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L8:    ; PIPED LOOP EPILOG
           NOP             1
;** --------------------------------------------------------------------------*
$C$L9:    
           RETNOP  .S2     B3,5              ; |120| 
           ; BRANCH OCCURS {B3}              ; |120| 
	.sect	".text"
	.clink
	.global	_StimPatternSequence_Check

;******************************************************************************
;* FUNCTION NAME: StimPatternSequence_Check                                   *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,B0,*
;*                           B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,SP,   *
;*                           A16,A17,A18,A19,A20,A21,A22,A23,A24,A25,A26,A27, *
;*                           A28,A29,A30,A31,B16,B17,B18,B19,B20,B21,B22,B23, *
;*                           B24,B25,B26,B27,B28,B29,B30,B31                  *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,B0,*
;*                           B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,DP,SP,*
;*                           A16,A17,A18,A19,A20,A21,A22,A23,A24,A25,A26,A27, *
;*                           A28,A29,A30,A31,B16,B17,B18,B19,B20,B21,B22,B23, *
;*                           B24,B25,B26,B27,B28,B29,B30,B31                  *
;*   Local Frame Size  : 0 Args + 0 Auto + 40 Save = 40 byte                  *
;******************************************************************************
_StimPatternSequence_Check:
;** --------------------------------------------------------------------------*
           STW     .D2T1   A14,*SP--(8)      ; |38| 
           STDW    .D2T2   B13:B12,*SP--     ; |38| 
           STDW    .D2T2   B11:B10,*SP--     ; |38| 
           STDW    .D2T1   A13:A12,*SP--     ; |38| 
           STDW    .D2T1   A11:A10,*SP--     ; |38| 
           LDW     .D2T2   *+DP(_StimPatternSequence_Enabled),B4 ; |46| 
           MV      .L1X    B3,A14            ; |38| 
           NOP             3

           CMPEQ   .L2     B4,1,B0           ; |46| 
||         MVKL    .S2     _u_Stim_PatternSequence+24,B4

   [!B0]   B       .S1     $C$L14            ; |46| 
||         MVKH    .S2     _u_Stim_PatternSequence+24,B4

   [ B0]   LDW     .D2T2   *B4,B5            ; |47| 
           NOP             4
           ; BRANCHCC OCCURS {$C$L14}        ; |46| 
;** --------------------------------------------------------------------------*

           SUBAW   .D2     B4,2,B10
||         CMPLTU  .L1X    A4,B5,A0          ; |47| 
||         MVKL    .S2     _PatternBuffer,B7
||         MVK     .S1     16,A3

   [ A0]   BNOP    .S1     $C$L14,2          ; |47| 
|| [!A0]   LDW     .D2T2   *B10,B4           ; |50| 
||         MVKH    .S2     _PatternBuffer,B7
||         ADD     .L2     4,B10,B6

           MV      .L2     B7,B11            ; |52| 
           SUB     .L1X    B10,A3,A11
           SHL     .S2     B4,2,B4           ; |50| 
           ; BRANCHCC OCCURS {$C$L14}        ; |47| 
;** --------------------------------------------------------------------------*
           ADD     .L2X    A11,B4,B31        ; |50| 

           ADD     .L1X    A11,B4,A3         ; |54| 
||         LDW     .D2T2   *+B31(32),B13     ; |50| 

           LDW     .D1T1   *+A3(32),A3       ; |54| 
           LDW     .D2T2   *B6,B30           ; |53| 
           MV      .L1X    B6,A10            ; |56| 
           NOP             1
           ADD     .L2     1,B13,B29         ; |52| 

           ADD     .L2X    1,A3,B5           ; |54| 
||         LDW     .D2T2   *+B7[B29],B12     ; |52| 

           LDW     .D2T2   *+B11[B5],B8      ; |54| 
           ADD     .L2     B30,B30,B4        ; |53| 
           NOP             3

           ADD     .L2     B4,B8,B5          ; |54| 
||         ADD     .S2     B12,B4,B4         ; |53| 

           ADD     .L2     1,B5,B5           ; |54| 
||         ADD     .S2     1,B4,B4           ; |53| 

           LDW     .D2T2   *+B11[B5],B5      ; |54| 
           LDW     .D2T1   *+B7[B4],A3       ; |53| 
           NOP             3
           EXTU    .S2     B5,24,24,B4       ; |54| 

           CMPEQ   .L2     B4,0,B9           ; |54| 
||         CLR     .S2     B5,0,23,B8        ; |54| 
||         SHL     .S1     A3,24,A13         ; |57| 

           XOR     .D2     1,B9,B7           ; |54| 
||         CMPEQ   .L2     B8,0,B6           ; |54| 
||         EXTU    .S1     A3,8,24,A4        ; |57| 
||         EXTU    .S2     B5,16,24,B27      ; |56| 

           AND     .L2     B7,B6,B0          ; |54| 
||         EXTU    .S2     B5,8,24,B28       ; |56| 
||         SHL     .S1     A4,16,A12         ; |57| 

   [!B0]   B       .S1     $C$L11            ; |54| 
|| [!B0]   LDW     .D1T1   *A10,A3           ; |67| 

   [ B0]   CALL    .S1     _Stim_Trigger     ; |56| 
   [!B0]   LDW     .D2T2   *+B11[B12],B5     ; |68| 
           MV      .L1X    B27,A4            ; |56| 
           MV      .L1X    B28,A6            ; |56| 
   [!B0]   ADD     .L1     1,A3,A3           ; |67| 
           ; BRANCHCC OCCURS {$C$L11}        ; |54| 
;** --------------------------------------------------------------------------*
           ADDKPC  .S2     $C$RL1,B3,0       ; |56| 
$C$RL1:    ; CALL OCCURS {_Stim_Trigger} {0}  ; |56| 
;** --------------------------------------------------------------------------*
           LDW     .D1T1   *A10,A0           ; |57| 
           MVKL    .S2     _StimStatus,B4
           MVKH    .S2     _StimStatus,B4
           NOP             2

   [ A0]   B       .S2     $C$L10            ; |59| 
||         SHL     .S1     A0,8,A3           ; |57| 

   [!A0]   CALL    .S1     _reset_decoder_state ; |60| 
||         ADD     .L1     A12,A3,A3         ; |57| 

           ADD     .L1     A13,A3,A3         ; |57| 
           NOP             1

           ADD     .L2X    B13,A3,B5         ; |57| 
|| [ A0]   LDW     .D1T1   *A10,A3           ; |67| 

           STW     .D2T2   B5,*B4            ; |57| 
           ; BRANCHCC OCCURS {$C$L10}        ; |59| 
;** --------------------------------------------------------------------------*
           ADDKPC  .S2     $C$RL2,B3,0       ; |60| 
$C$RL2:    ; CALL OCCURS {_reset_decoder_state} {0}  ; |60| 
           LDW     .D1T1   *A10,A3           ; |67| 
           NOP             1
;** --------------------------------------------------------------------------*
$C$L10:    
           LDW     .D2T2   *+B11[B12],B5     ; |68| 
           NOP             2
           ADD     .L1     1,A3,A3           ; |67| 
;** --------------------------------------------------------------------------*
$C$L11:    

           STW     .D1T1   A3,*A10           ; |67| 
||         MV      .L2     B10,B4            ; |68| 
||         ZERO    .S2     B7                ; |71| 
||         MV      .D2X    A10,B6
||         MV      .L1X    B10,A4            ; |68| 

           CMPEQ   .L2X    A3,B5,B0          ; |68| 
||         ADD     .L1     4,A11,A3

   [!B0]   BNOP    .S1     $C$L12,4          ; |68| 
|| [ B0]   LDW     .D2T2   *B10,B5           ; |70| 

           ADD     .L2     1,B5,B5           ; |70| 
           ; BRANCHCC OCCURS {$C$L12}        ; |68| 
;** --------------------------------------------------------------------------*

           STW     .D2T2   B5,*B4            ; |70| 
||         LDW     .D1T1   *A3,A5            ; |73| 

           LDW     .D1T1   *A4,A6            ; |73| 
           MV      .L2X    A11,B5            ; |73| 
           ADD     .L1     4,A3,A3
           STW     .D2T2   B7,*B6            ; |71| 
           NOP             1
           CMPGTU  .L1     A6,A5,A0          ; |73| 

   [ A0]   LDW     .D1T1   *A3,A5            ; |75| 
|| [!A0]   B       .S1     $C$L13            ; |73| 
|| [ A0]   LDW     .D2T2   *B5,B5            ; |74| 

           MV      .L1     A0,A1             ; |73| branch predicate copy
   [!A1]   LDW     .D1T1   *A4,A3            ; |90| 
   [ A0]   MV      .L1X    B7,A31            ; |75| 
   [ A0]   MVKL    .S2     _StimStatus,B4
           SUB     .L1     A5,1,A0           ; |75| 
           ; BRANCHCC OCCURS {$C$L13}        ; |73| 
;** --------------------------------------------------------------------------*

           MVKH    .S2     _StimStatus,B4
||         SHL     .S1     A0,8,A5           ; |78| 
||         STW     .D1T1   A0,*A3            ; |75| 
||         MVK     .L2     3,B31             ; |81| 

           ADD     .L2     4,B4,B4
||         ADD     .L1     2,A5,A3           ; |78| 
||         STW     .D1T2   B5,*A4            ; |74| 
|| [!A0]   STW     .D2T1   A31,*+DP(_StimPatternSequence_Enabled) ; |80| 

   [!A0]   STW     .D2T2   B31,*B4           ; |81| 
   [ A0]   STW     .D2T1   A3,*B4            ; |78| 
;** --------------------------------------------------------------------------*
$C$L12:    
           LDW     .D1T1   *A4,A3            ; |90| 
           NOP             3
;** --------------------------------------------------------------------------*
$C$L13:    
           LDW     .D2T2   *B6,B5            ; |90| 
           ADDAW   .D1     A11,A3,A3         ; |90| 
           LDW     .D1T1   *+A3(32),A3       ; |90| 
           NOP             4

           ADD     .L2X    1,A3,B4           ; |90| 
||         MVKL    .S1     _u_Stim_PatternSequence+24,A3

           LDW     .D2T2   *+B11[B4],B4      ; |90| 
           MVKH    .S1     _u_Stim_PatternSequence+24,A3
           NOP             1
           MV      .L2X    A3,B6             ; |90| 
           LDW     .D2T2   *B6,B31           ; |90| 
           ADDAH   .D2     B4,B5,B4          ; |90| 
           ADD     .L2     2,B4,B5           ; |90| 
           LDW     .D2T2   *+B11[B5],B6      ; |90| 
           MV      .L2X    A3,B30            ; |90| 
           NOP             3
           ADD     .L2     B6,B31,B4         ; |90| 
           STW     .D2T2   B4,*B30           ; |90| 
;** --------------------------------------------------------------------------*
$C$L14:    
           LDDW    .D2T1   *++SP,A11:A10     ; |108| 
           LDDW    .D2T1   *++SP,A13:A12     ; |108| 

           LDDW    .D2T2   *++SP,B11:B10     ; |108| 
||         MV      .L2X    A14,B3            ; |108| 

           LDDW    .D2T2   *++SP,B13:B12     ; |108| 
||         RET     .S2     B3                ; |108| 

           LDW     .D2T1   *++SP(8),A14      ; |108| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |108| 
;*****************************************************************************
;* UNDEFINED EXTERNAL REFERENCES                                             *
;*****************************************************************************
	.global	_Stim_Trigger
	.global	_reset_decoder_state
	.global	_current_time
	.global	_StimPatternSequence_Enabled
	.global	_StimStatus
	.global	__remu

;******************************************************************************
;* BUILD ATTRIBUTES                                                           *
;******************************************************************************
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_needed(0)
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_preserved(0)
	.battr "TI", Tag_File, 1, Tag_Tramps_Use_SOC(1)
