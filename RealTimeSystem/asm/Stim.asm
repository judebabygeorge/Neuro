;******************************************************************************
;* TMS320C6x C/C++ Codegen                                          PC v7.4.2 *
;* Date/Time created: Sat May 31 10:51:07 2014                                *
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

	.global	_u_Stim_SequenceList
_u_Stim_SequenceList:	.usect	".far",2072,8
;	opt6x C:\\Users\\45c\\AppData\\Local\\Temp\\094802 C:\\Users\\45c\\AppData\\Local\\Temp\\094804 
	.sect	".text"
	.clink
	.global	_SetSegment

;******************************************************************************
;* FUNCTION NAME: SetSegment                                                  *
;*                                                                            *
;*   Regs Modified     : A3,A4,B5,B6                                          *
;*   Regs Used         : A3,A4,B3,B4,B5,B6                                    *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_SetSegment:
;** --------------------------------------------------------------------------*
           ZERO    .L2     B6

           SET     .S2     B6,0x1b,0x1c,B6
||         ZERO    .L1     A3
||         MV      .L2X    A4,B5             ; |14| 

           STW     .D2T2   B4,*-B5[B6]       ; |15| 
||         SET     .S1     A3,0x1c,0x1e,A3
||         ZERO    .L1     A4                ; |15| 

           STW     .D1T1   A4,*A3            ; |15| 
||         RET     .S2     B3                ; |16| 

           LDW     .D1T1   *A3,A3            ; |15| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |16| 
	.sect	".text"
	.clink
	.global	_ClearChannel

;******************************************************************************
;* FUNCTION NAME: ClearChannel                                                *
;*                                                                            *
;*   Regs Modified     : A3,B4,B5                                             *
;*   Regs Used         : A3,A4,B3,B4,B5                                       *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_ClearChannel:
;** --------------------------------------------------------------------------*
           ZERO    .L2     B4
           SET     .S2     B4,0x1d,0x1e,B4

           SUB     .L2X    A4,B4,B5          ; |126| 
||         ZERO    .S2     B4                ; |126| 
||         ZERO    .L1     A3

           STW     .D2T2   B4,*B5            ; |126| 
||         SET     .S1     A3,0x1c,0x1e,A3

           STW     .D1T2   B4,*A3            ; |126| 
||         RET     .S2     B3                ; |127| 

           LDW     .D1T1   *A3,A3            ; |126| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |127| 
	.sect	".text"
	.clink
	.global	_Stim_LoadChannel_T2

;******************************************************************************
;* FUNCTION NAME: Stim_LoadChannel_T2                                         *
;*                                                                            *
;*   Regs Modified     : A0,A3,A4,A5,A6,A7,B0,B4,B5,B6,B7                     *
;*   Regs Used         : A0,A3,A4,A5,A6,A7,B0,B3,B4,B5,B6,B7                  *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_Stim_LoadChannel_T2:
;** --------------------------------------------------------------------------*
           LDW     .D2T2   *+B4(4),B0        ; |57| 
           MV      .L2X    A4,B6             ; |55| 
           ZERO    .L2     B7                ; |57| 
           ZERO    .L1     A4                ; |57| 
           ADD     .L2     12,B4,B5

   [!B0]   BNOP    .S1     $C$L4,5           ; |57| 
|| [ B0]   MVK     .L1     0x1,A0

           ; BRANCHCC OCCURS {$C$L4}         ; |57| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\Stim.c
;*      Loop source line                 : 57
;*      Loop opening brace source line   : 57
;*      Loop closing brace source line   : 59
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 7
;*      Unpartitioned Resource Bound     : 3
;*      Partitioned Resource Bound(*)    : 3
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     1        0     
;*      .S units                     1        1     
;*      .D units                     3*       2     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             3*       2     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          4        2     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1        1     
;*      Bound(.L .S .D .LS .LSD)     3*       2     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 7  Unsafe schedule for irregular loop
;*         ii = 7  Unsafe schedule for irregular loop
;*         ii = 7  Unsafe schedule for irregular loop
;*         ii = 7  Did not find schedule
;*         ii = 8  Unsafe schedule for irregular loop
;*         ii = 8  Unsafe schedule for irregular loop
;*         ii = 8  Unsafe schedule for irregular loop
;*         ii = 8  Did not find schedule
;*         ii = 9  Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 1
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      For further improvement on this loop, try option -mh56
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L1:    ; PIPED LOOP PROLOG
   [ A0]   SPLOOPW 9       ;18               ; (P) 
;** --------------------------------------------------------------------------*
$C$L2:    ; PIPED LOOP KERNEL

           SPMASK          L1
||         MV      .L1X    B4,A6
||         LDW     .D2T2   *B5++,B4          ; |58| (P) <0,0>  ^ 

           NOP             1
           ZERO    .L2     B4                ; (P) <0,2> 
           SET     .S2     B4,0x1d,0x1e,B4   ; (P) <0,3> 

           SPMASK          S1
||         MV      .S1X    B7,A5
||         ZERO    .L1     A3                ; (P) <0,4> 
||         SUB     .L2     B6,B4,B7          ; |58| (P) <0,4> 

           SET     .S1     A3,0x1c,0x1e,A3   ; (P) <0,5> 
|| [ A0]   STW     .D2T2   B4,*B7            ; |58| (P) <0,5>  ^ 

   [ A0]   STW     .D1T1   A5,*A3            ; |58| (P) <0,6>  ^ 
           LDW     .D1T1   *+A6(4),A3        ; |57| (P) <0,7> 
   [ A0]   LDW     .D1T1   *A3,A7            ; |58| (P) <0,8> 
           NOP             2
           ADD     .L1     1,A4,A4           ; |57| <0,11> 
           CMPLTU  .L1     A4,A3,A3          ; |57| <0,12> 
           MV      .S1     A3,A0             ; |57| <0,13> 
           NOP             2
           NOP             1
           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L3:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
$C$L4:    
           RETNOP  .S2     B3,5              ; |60| 
           ; BRANCH OCCURS {B3}              ; |60| 
	.sect	".text"
	.clink
	.global	_AddDataPoint

;******************************************************************************
;* FUNCTION NAME: AddDataPoint                                                *
;*                                                                            *
;*   Regs Modified     : A0,A1,A3,A4,A5,A6,A7,A8,B4,B5,B6,B7,B8,B9            *
;*   Regs Used         : A0,A1,A3,A4,A5,A6,A7,A8,B3,B4,B5,B6,B7,B8,B9         *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_AddDataPoint:
;** --------------------------------------------------------------------------*
           MVKL    .S2     0x10624dd3,B5
           MVKH    .S2     0x10624dd3,B5
           MPY32U  .M2     B5,B4,B9:B8       ; |26| 
           ZERO    .L1     A7
           MVK     .S1     1000,A3           ; |27| 
           SET     .S1     A7,0x10,0x10,A7
           MV      .L2     B9,B8             ; |26| 
           SHRU    .S2     B8,6,B9           ; |27| 
           MV      .L1     A4,A5             ; |17| 

           MPY32   .M1X    A3,B9,A4          ; |27| 
||         EXTU    .S2     B8,10,16,B6       ; |26| 

           SHL     .S2     B6,16,B6          ; |26| 
||         MV      .L2X    A6,B5             ; |17| 

           SUB     .L2X    B6,A7,B6          ; |26| 
||         EXTU    .S2     B5,16,16,B8       ; |26| 
||         ZERO    .L1     A6
||         MV      .S1X    B4,A0             ; |17| 

           OR      .L2     B8,B6,B6          ; |26| 
||         SET     .S1     A6,0x1d,0x1e,A6
||         CMPGTU  .L1X    B4,A3,A1          ; |17| 

   [ A1]   SUB     .L1X    B4,A4,A0          ; |27| 
||         SET     .S2     B6,26,26,B4       ; |26| 
||         SUB     .S1     A5,A6,A3          ; |26| 
||         ZERO    .L2     B7

   [ A1]   STW     .D1T2   B4,*A3            ; |26| 
||         SHL     .S1     A0,16,A3          ; |33| 
||         SET     .S2     B7,0x1c,0x1e,B7

           SUB     .L1     A3,A7,A3          ; |33| 
||         ZERO    .L2     B4                ; |18| 

   [ A1]   STW     .D2T2   B4,*B7            ; |26| 
||         EXTU    .S2     B5,16,16,B4       ; |33| 
||         MV      .L1X    B7,A8             ; |26| 

           OR      .L2X    B4,A3,B4          ; |33| 
||         SUB     .L1     A5,A6,A5          ; |33| 
|| [ A1]   LDW     .D1T1   *A8,A3            ; |26| 

   [ A0]   STW     .D1T2   B4,*A5            ; |33| 
||         ZERO    .L2     B4                ; |33| 

   [ A0]   STW     .D2T2   B4,*B7            ; |33| 
||         MV      .L2     B7,B6             ; |26| 
||         RET     .S2     B3                ; |38| 

   [ A0]   LDW     .D2T2   *B6,B4            ; |33| 
           ZERO    .L1     A4                ; |18| 
   [ A1]   MVK     .L1     0x1,A4            ; |28| 
   [ A0]   ADD     .L1     1,A4,A4           ; |34| 
           NOP             1
           ; BRANCH OCCURS {B3}              ; |38| 
	.sect	".text"
	.clink
	.global	_AddLoop

;******************************************************************************
;* FUNCTION NAME: AddLoop                                                     *
;*                                                                            *
;*   Regs Modified     : A0,A3,A4,A5,B4,B5,B6                                 *
;*   Regs Used         : A0,A3,A4,A5,A6,B3,B4,B5,B6                           *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_AddLoop:
;** --------------------------------------------------------------------------*
           AND     .L2     3,B6,B6           ; |45| 

           PACK2   .L1X    A6,B4,A3          ; |45| 
||         SHL     .S2     B6,26,B4          ; |45| 

           ZERO    .L1     A5

           OR      .L1X    B4,A3,A3          ; |45| 
||         SET     .S1     A5,0x1d,0x1e,A5

           SET     .S1     A3,28,28,A3       ; |45| 
||         SUB     .D1     A4,A5,A4          ; |45| 
||         CMPLTU  .L1     A6,2,A0           ; |42| 
||         ZERO    .L2     B5

   [!A0]   STW     .D1T1   A3,*A4            ; |45| 
||         ZERO    .L1     A3                ; |45| 
||         SET     .S2     B5,0x1c,0x1e,B5

   [!A0]   STW     .D2T1   A3,*B5            ; |45| 
||         RET     .S2     B3                ; |49| 

   [!A0]   LDW     .D2T2   *B5,B4            ; |45| 
           MVK     .L1     0x1,A4            ; |48| 
   [ A0]   MV      .L1     A3,A4             ; |45| 
           NOP             2
           ; BRANCH OCCURS {B3}              ; |49| 
	.sect	".text"
	.clink
	.global	_AddEndVector

;******************************************************************************
;* FUNCTION NAME: AddEndVector                                                *
;*                                                                            *
;*   Regs Modified     : A3,A4,B4,B5                                          *
;*   Regs Used         : A3,A4,B3,B4,B5                                       *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_AddEndVector:
;** --------------------------------------------------------------------------*

           ZERO    .L2     B4
||         ZERO    .L1     A3

           SET     .S2     B4,0x1d,0x1e,B4
||         SET     .S1     A3,0x1c,0x1e,A3

           NOP             1

           SUB     .L1X    A4,B4,A4          ; |51| 
||         ZERO    .L2     B4                ; |51| 
||         MV      .S2X    A3,B5             ; |51| 

           STW     .D1T1   A3,*A4            ; |51| 
||         STW     .D2T2   B4,*B5            ; |51| 
||         RET     .S2     B3                ; |53| 

           LDW     .D1T1   *A3,A3            ; |51| 
           MVK     .L1     0x1,A4            ; |52| 
           NOP             3
           ; BRANCH OCCURS {B3}              ; |53| 
	.sect	".text"
	.clink
	.global	_Stim_LoadChannel_T1

;******************************************************************************
;* FUNCTION NAME: Stim_LoadChannel_T1                                         *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B3,B4,B5,B6,B7,B8,  *
;*                           B9,A16,A17,A18,B16,B17                           *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B3,B4,B5,B6,B7,B8,  *
;*                           B9,SP,A16,A17,A18,B16,B17                        *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_Stim_LoadChannel_T1:
;** --------------------------------------------------------------------------*
           MV      .L2     B4,B16            ; |68| 

           MV      .L1X    B3,A2             ; |68| 
||         CALLP   .S2     _AddDataPoint,B3
||         LDW     .D2T2   *+B16(16),B4      ; |77| 
||         MVK     .S1     0xffff8000,A6     ; |77| 
||         MV      .D1     A4,A9             ; |68| 

$C$RL0:    ; CALL OCCURS {_AddDataPoint} {0}  ; |77| 
;** --------------------------------------------------------------------------*
           LDH     .D2T2   *+B16(4),B5       ; |79| 
           ZERO    .L2     B17
           SET     .S2     B17,0xf,0xf,B17
           LDW     .D2T2   *+B16(8),B4       ; |79| 
           MV      .L1     A9,A4             ; |79| 
           SUB     .L2     B5,B17,B5         ; |79| 
           EXT     .S2     B5,16,16,B5       ; |79| 
           ZERO    .L1     A18

           CALLP   .S2     _AddDataPoint,B3
||         MV      .L1X    B5,A6             ; |79| 

$C$RL1:    ; CALL OCCURS {_AddDataPoint} {0}  ; |79| 
           LDH     .D2T1   *+B16(6),A3       ; |80| 
           LDW     .D2T2   *+B16(12),B4      ; |80| 
           MV      .L1     A4,A16            ; |79| 
           MV      .L1     A9,A4             ; |80| 
           SET     .S1     A18,0x1c,0x1e,A18
           SUB     .L1X    A3,B17,A3         ; |80| 

           CALLP   .S2     _AddDataPoint,B3
||         EXT     .S1     A3,16,16,A6       ; |80| 

$C$RL2:    ; CALL OCCURS {_AddDataPoint} {0}  ; |80| 

           CALLP   .S2     _AddDataPoint,B3
||         LDW     .D2T2   *+B16(20),B4      ; |81| 
||         MV      .L1     A4,A17            ; |80| 
||         MV      .D1     A9,A4             ; |81| 
||         MVK     .S1     0xffff8000,A6     ; |81| 

$C$RL3:    ; CALL OCCURS {_AddDataPoint} {0}  ; |81| 
           LDHU    .D2T2   *+B16(28),B4      ; |42| 
           ADD     .L1     A17,A16,A3        ; |80| 
           ADD     .L1     A4,A3,A3          ; |81| 

           EXTU    .S1     A3,16,16,A16      ; |79| 
||         ZERO    .L2     B17

           SET     .S2     B17,0x1d,0x1e,B17
           PACK2   .L2X    B4,A16,B5         ; |45| 

           CMPLTU  .L2     B4,2,B0           ; |42| 
||         SET     .S2     B5,28,28,B4       ; |45| 
||         SUB     .L1X    A9,B17,A3         ; |45| 

   [!B0]   STW     .D1T2   B4,*A3            ; |45| 
||         ZERO    .L1     A17

   [!B0]   STW     .D1T1   A17,*A18          ; |45| 

           MVK     .S1     0xffff8000,A3     ; |83| 
||         LDW     .D2T2   *+B16(24),B4      ; |83| 

           CALLP   .S2     _AddDataPoint,B3
||         EXT     .S1     A3,16,16,A6       ; |83| 
|| [!B0]   LDW     .D1T1   *A18,A3           ; |45| 
||         MV      .L1     A9,A4             ; |83| 

$C$RL4:    ; CALL OCCURS {_AddDataPoint} {0}  ; |83| 
;** --------------------------------------------------------------------------*
           MV      .L1     A17,A3            ; |83| 

   [!B0]   MVK     .L1     0x1,A3            ; |46| 
||         LDHU    .D2T2   *+B16(30),B4      ; |42| 

           ADD     .L1     A3,A16,A3         ; |82| 
           ADD     .L1     A4,A3,A3          ; |83| 
           EXTU    .S1     A3,16,16,A16      ; |82| 
           ZERO    .L2     B6

           PACK2   .L2X    B4,A16,B5         ; |45| 
||         MVKH    .S2     0x14000000,B6

           OR      .D2     B6,B5,B5          ; |45| 
||         CMPLTU  .L2     B4,2,B0           ; |42| 
||         SUB     .S2X    A9,B17,B4         ; |45| 

   [!B0]   STW     .D2T2   B5,*B4            ; |45| 
||         MV      .L1     A18,A3            ; |45| 

   [!B0]   STW     .D1T1   A17,*A3           ; |45| 

           SUB     .L1X    A9,B17,A6         ; |51| 
|| [!B0]   LDW     .D1T1   *A18,A3           ; |45| 

           STW     .D1T1   A18,*A6           ; |51| 
||         MV      .L1     A18,A4            ; |45| 

           STW     .D1T1   A17,*A4           ; |51| 
||         RET     .S2X    A2                ; |87| 
||         MV      .L1     A18,A5            ; |45| 

           LDW     .D1T1   *A5,A3            ; |51| 
           NOP             4
           ; BRANCH OCCURS {A2}              ; |87| 
	.sect	".text"
	.clink
	.global	_Stim_LoadChannelSB_T2

;******************************************************************************
;* FUNCTION NAME: Stim_LoadChannelSB_T2                                       *
;*                                                                            *
;*   Regs Modified     : A0,A3,A4,A5,A6,A7,B0,B4,B5,B6,B7,B8                  *
;*   Regs Used         : A0,A3,A4,A5,A6,A7,B0,B3,B4,B5,B6,B7,B8               *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_Stim_LoadChannelSB_T2:
;** --------------------------------------------------------------------------*
           LDW     .D2T2   *+B4(8),B5        ; |63| 
           LDW     .D2T2   *+B4(4),B7        ; |63| 
           ZERO    .L1     A5
           MV      .L2X    A4,B6             ; |61| 
           NOP             2

           ADD     .L2     B5,B7,B8          ; |63| 
||         ADDAW   .D2     B4,B7,B5

           CMPLTU  .L2     B7,B8,B0          ; |63| 
||         ADD     .S2     12,B5,B5

   [!B0]   BNOP    .S1     $C$L8,5           ; |63| 
|| [ B0]   MVK     .L1     0x1,A0

           ; BRANCHCC OCCURS {$C$L8}         ; |63| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\Stim.c
;*      Loop source line                 : 63
;*      Loop opening brace source line   : 63
;*      Loop closing brace source line   : 65
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 7
;*      Unpartitioned Resource Bound     : 3
;*      Partitioned Resource Bound(*)    : 4
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     1        0     
;*      .S units                     1        1     
;*      .D units                     3        3     
;*      .M units                     0        0     
;*      .X cross paths               2        1     
;*      .T address paths             3        3     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          4        4     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1        1     
;*      Bound(.L .S .D .LS .LSD)     3        3     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 7  Unsafe schedule for irregular loop
;*         ii = 7  Unsafe schedule for irregular loop
;*         ii = 7  Unsafe schedule for irregular loop
;*         ii = 7  Did not find schedule
;*         ii = 8  Unsafe schedule for irregular loop
;*         ii = 8  Unsafe schedule for irregular loop
;*         ii = 8  Unsafe schedule for irregular loop
;*         ii = 8  Did not find schedule
;*         ii = 9  Unsafe schedule for irregular loop
;*         ii = 9  Unsafe schedule for irregular loop
;*         ii = 9  Unsafe schedule for irregular loop
;*         ii = 9  Did not find schedule
;*         ii = 10 Unsafe schedule for irregular loop
;*         ii = 10 Unsafe schedule for irregular loop
;*         ii = 10 Unsafe schedule for irregular loop
;*         ii = 10 Did not find schedule
;*         ii = 11 Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 1
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      For further improvement on this loop, try option -mh56
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L5:    ; PIPED LOOP PROLOG
   [ A0]   SPLOOPW 11      ;22               ; (P) 
;** --------------------------------------------------------------------------*
$C$L6:    ; PIPED LOOP KERNEL
           NOP             2

           SPMASK          L1
||         MV      .L1X    B4,A6
||         LDW     .D2T2   *B5++,B4          ; |64| (P) <0,2>  ^ 

           NOP             1
           ZERO    .L2     B4                ; (P) <0,4> 
           SET     .S2     B4,0x1d,0x1e,B4   ; (P) <0,5> 

           SPMASK          S1
||         MV      .S1X    B7,A4
||         ZERO    .L1     A3                ; (P) <0,6> 
||         SUB     .L2     B6,B4,B7          ; |64| (P) <0,6> 

           SET     .S1     A3,0x1c,0x1e,A3   ; (P) <0,7> 
|| [ A0]   STW     .D2T2   B4,*B7            ; |64| (P) <0,7>  ^ 

   [ A0]   STW     .D1T1   A5,*A3            ; |64| (P) <0,8>  ^ 
           LDW     .D1T1   *+A6(4),A3        ; |63| (P) <0,9> 
           LDW     .D1T1   *+A6(8),A7        ; |63| (P) <0,10> 
           LDW     .D1T1   *A3,A7            ; |64| <0,11> 
           NOP             3

           ADD     .L1     1,A4,A4           ; |63| <0,15> 
||         ADD     .S1     A7,A3,A3          ; |63| <0,15> 

           CMPLTU  .L1     A4,A3,A3          ; |63| <0,16> 
           MV      .S1     A3,A0             ; |63| <0,17> 
           NOP             2
           NOP             1
           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L7:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
$C$L8:    
           RETNOP  .S2     B3,5              ; |66| 
           ; BRANCH OCCURS {B3}              ; |66| 
	.sect	".text"
	.clink
	.global	_Stim_LoadChannelSB_T1

;******************************************************************************
;* FUNCTION NAME: Stim_LoadChannelSB_T1                                       *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B3,B4,B5,B6,B7,  *
;*                           B8,B9,A16,A17,A18,A19,B16,B17,B18                *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B3,B4,B5,B6,B7,  *
;*                           B8,B9,DP,SP,A16,A17,A18,A19,B16,B17,B18          *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_Stim_LoadChannelSB_T1:
;** --------------------------------------------------------------------------*

           MV      .L2     B4,B18            ; |89| 
||         MVKL    .S2     0x10624dd3,B4
||         ZERO    .L1     A5
||         ZERO    .S1     A19
||         ZERO    .D1     A18
||         ZERO    .D2     B17               ; |26| 

           SET     .S1     A5,0x10,0x10,A5
||         ZERO    .L1     A9                ; |26| 
||         LDW     .D2T2   *+B18(16),B0      ; |108| 

           MVKH    .S2     0x10624dd3,B4
           LDW     .D2T2   *+B18(20),B16     ; |100| 
           SET     .S1     A19,0x1d,0x1e,A19
           MVK     .S2     1000,B5           ; |108| 
           MPY32U  .M2     B4,B0,B7:B6       ; |26| 
           SET     .S1     A18,0x1c,0x1e,A18
           MV      .L1     A18,A7            ; |26| 
           MV      .L1X    B5,A3             ; |27| 
           MV      .L2     B7,B4             ; |26| 
           SHRU    .S2     B4,6,B6           ; |27| 
           EXTU    .S2     B4,10,16,B4       ; |26| 
           MPY32   .M1X    A3,B6,A6          ; |27| 
           SHL     .S2     B4,16,B4          ; |26| 
           CMPGTU  .L2     B0,B5,B1          ; |108| 
           SUB     .L1X    B4,A5,A3          ; |26| 
           ZERO    .L2     B4                ; |26| 

   [ B1]   SUB     .L2X    B0,A6,B0          ; |27| 
||         SET     .S1     A3,26,26,A6       ; |26| 
||         SUB     .L1     A4,A19,A3         ; |26| 

           SHL     .S2     B0,16,B5          ; |33| 
|| [ B1]   STW     .D1T1   A6,*A3            ; |26| 

   [ B1]   STW     .D1T2   B4,*A18           ; |26| 

           SUB     .L1X    B5,A5,A6          ; |33| 
||         SUB     .S1     A4,A19,A5         ; |33| 
|| [ B1]   LDW     .D1T1   *A7,A3            ; |26| 

   [ B0]   STW     .D1T1   A6,*A5            ; |33| 
   [ B0]   STW     .D1T1   A9,*A18           ; |33| 
   [ B0]   LDW     .D1T1   *A18,A3           ; |33| 
           LDBU    .D2T2   *+DP(_EnableAmpBlanking),B1 ; |109| 
           MV      .L1X    B3,A2             ; |89| 
           MV      .L1     A4,A16            ; |89| 
           MVK     .S1     0x18,A6           ; |113| 
           CMPGTU  .L2     B16,30,B0         ; |100| 

   [ B1]   B       .S1     $C$L9             ; |109| 
|| [!B1]   LDW     .D2T2   *+B18(12),B5      ; |113| 

   [!B1]   CALL    .S1     _AddDataPoint     ; |113| 
|| [!B1]   LDW     .D2T2   *+B18(8),B4       ; |113| 

   [ B1]   LDW     .D2T2   *+B18(12),B5      ; |110| 

   [ B1]   CALL    .S1     _AddDataPoint     ; |110| 
|| [ B1]   LDW     .D2T2   *+B18(8),B4       ; |110| 

   [ B0]   SUB     .D2     B16,30,B17        ; |102| 
   [ B0]   MVK     .S2     0x1e,B16          ; |101| 
           ; BRANCHCC OCCURS {$C$L9}         ; |109| 
;** --------------------------------------------------------------------------*

           ADDKPC  .S2     $C$RL5,B3,0       ; |113| 
||         ADD     .L2     B5,B4,B4          ; |113| 

$C$RL5:    ; CALL OCCURS {_AddDataPoint} {0}  ; |113| 
;** --------------------------------------------------------------------------*

           CALLP   .S2     _AddDataPoint,B3
||         MV      .L2     B16,B4            ; |114| 
||         MVK     .S1     0x10,A6           ; |114| 
||         MV      .L1     A4,A17            ; |113| 
||         MV      .D1     A16,A4            ; |114| 

$C$RL6:    ; CALL OCCURS {_AddDataPoint} {0}  ; |114| 
;** --------------------------------------------------------------------------*
           B       .S1     $C$L10            ; |114| 
           CALL    .S1     _AddDataPoint     ; |117| 
           ADD     .L1     A4,A17,A3         ; |114| 
           EXTU    .S1     A3,16,16,A17      ; |113| 
           NOP             2
           ; BRANCH OCCURS {$C$L10}          ; |114| 
;** --------------------------------------------------------------------------*
$C$L9:    
           MVK     .S1     0x19,A6           ; |110| 
           ADDKPC  .S2     $C$RL7,B3,0       ; |110| 
           ADD     .L2     B5,B4,B4          ; |110| 
$C$RL7:    ; CALL OCCURS {_AddDataPoint} {0}  ; |110| 
;** --------------------------------------------------------------------------*

           CALLP   .S2     _AddDataPoint,B3
||         MV      .L2     B16,B4            ; |111| 
||         MVK     .S1     0x11,A6           ; |111| 
||         MV      .L1     A4,A17            ; |110| 
||         MV      .D1     A16,A4            ; |111| 

$C$RL8:    ; CALL OCCURS {_AddDataPoint} {0}  ; |111| 
;** --------------------------------------------------------------------------*
           CALL    .S1     _AddDataPoint     ; |117| 
           ADD     .L1     A4,A17,A3         ; |111| 
           EXTU    .S1     A3,16,16,A17      ; |110| 
           NOP             2
;** --------------------------------------------------------------------------*
$C$L10:    

           MV      .L1     A9,A6
||         MV      .L2     B17,B4            ; |117| 
||         MV      .S1     A16,A4            ; |117| 
||         ADDKPC  .S2     $C$RL9,B3,0       ; |117| 

$C$RL9:    ; CALL OCCURS {_AddDataPoint} {0}  ; |117| 
;** --------------------------------------------------------------------------*
           LDHU    .D2T2   *+B18(28),B4      ; |42| 
           ADD     .L1     A4,A17,A3         ; |117| 
           EXTU    .S1     A3,16,16,A17      ; |117| 
           SUB     .L1     A16,A19,A3        ; |45| 
           MV      .L1     A18,A4            ; |45| 
           PACK2   .L2X    B4,A17,B5         ; |45| 

           CMPLTU  .L2     B4,2,B0           ; |42| 
||         SET     .S2     B5,28,28,B4       ; |45| 

   [!B0]   STW     .D1T2   B4,*A3            ; |45| 
   [!B0]   STW     .D1T1   A9,*A4            ; |45| 

           MV      .L2X    A18,B5            ; |45| 
||         LDW     .D2T2   *+B18(24),B4      ; |120| 

           CALLP   .S2     _AddDataPoint,B3
|| [!B0]   LDW     .D2T2   *B5,B5            ; |45| 
||         MV      .L1     A16,A4            ; |120| 
||         MV      .S1     A9,A6             ; |45| 

$C$RL10:   ; CALL OCCURS {_AddDataPoint} {0}  ; |120| 
;** --------------------------------------------------------------------------*
           MV      .L2X    A9,B4             ; |120| 
   [!B0]   MVK     .L2     0x1,B4            ; |46| 
           ZERO    .L2     B7

           ADD     .L1X    B4,A17,A3         ; |118| 
||         LDHU    .D2T2   *+B18(30),B4      ; |42| 

           ADD     .L1     A4,A3,A3          ; |120| 
           EXTU    .S1     A3,16,16,A17      ; |118| 
           MVKH    .S2     0x14000000,B7
           SUB     .L1     A16,A19,A3        ; |45| 
           PACK2   .L2X    B4,A17,B5         ; |45| 

           CMPLTU  .L2     B4,2,B0           ; |42| 
||         OR      .S2     B7,B5,B4          ; |45| 

   [!B0]   STW     .D1T2   B4,*A3            ; |45| 
||         MV      .L1     A18,A4            ; |45| 

   [!B0]   STW     .D1T1   A9,*A4            ; |45| 
||         SUB     .L1     A16,A19,A3        ; |51| 
||         MV      .L2X    A18,B6            ; |45| 

   [!B0]   LDW     .D2T2   *B6,B4            ; |45| 
||         STW     .D1T1   A18,*A3           ; |51| 
||         MV      .L1     A18,A5            ; |45| 

           STW     .D1T1   A9,*A5            ; |51| 
||         MV      .L1     A18,A6            ; |45| 
||         RET     .S2X    A2                ; |124| 

           LDW     .D1T1   *A6,A3            ; |51| 
           NOP             4
           ; BRANCH OCCURS {A2}              ; |124| 
	.sect	".text"
	.clink
	.global	_UpLoadPatternToHS

;******************************************************************************
;* FUNCTION NAME: UpLoadPatternToHS                                           *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,A16,A17,A18,A19,A20,A21,A22,A23,B16,B17,*
;*                           B18,B19,B20                                      *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,DP,SP,A16,A17,A18,A19,A20,A21,A22,A23,  *
;*                           B16,B17,B18,B19,B20                              *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_UpLoadPatternToHS:
;** --------------------------------------------------------------------------*

           SHL     .S2     B4,6,B7           ; |15| 
||         MVKL    .S1     0x5ffffe00,A23
||         ZERO    .L2     B20
||         MV      .D2X    A6,B5             ; |129| 
||         ZERO    .L1     A20               ; |15| 
||         MV      .D1X    B6,A22            ; |129| 

           MVKH    .S1     0x5ffffe00,A23
||         SET     .S2     B20,0x1c,0x1e,B20
||         ADD     .L2     2,B6,B19          ; |142| 
||         MV      .D2     B3,B2             ; |129| 

           ADD     .L1X    A4,B7,A21         ; |15| 

           SUB     .L1     A21,A23,A8        ; |15| 
||         MV      .S1X    B20,A7            ; |15| 

           STW     .D1T2   B5,*A8            ; |15| 
||         MV      .L1X    B20,A6            ; |15| 

           STW     .D2T1   A20,*B20          ; |15| 
||         MV      .L1X    B20,A5            ; |15| 

           LDW     .D1T1   *A7,A7            ; |15| 
||         MV      .L1X    B20,A3            ; |15| 

           STW     .D1T2   B5,*+A8(32)       ; |15| 
||         MV      .L2X    A4,B5             ; |129| 

           STW     .D1T1   A20,*A6           ; |15| 
           LDW     .D1T1   *A5,A4            ; |15| 
           STW     .D1T1   A20,*+A8(12)      ; |126| 
           STW     .D1T1   A20,*A3           ; |126| 
           LDHU    .D2T1   *B19,A8           ; |142| 
           MV      .L1X    B20,A19           ; |15| 
           ADDAD   .D2     B5,B4,B18         ; |140| 
           MVK     .S1     3872,A3           ; |140| 
           ADD     .L1X    A3,B18,A4         ; |140| 

           CMPEQ   .L1     A8,1,A0           ; |142| 
||         CMPEQ   .L2X    A8,2,B0           ; |142| 

   [ A0]   B       .S1     $C$L14            ; |142| 
|| [ A0]   MVK     .L2     0x1,B0            ; |147| nullify predicate

   [!B0]   B       .S1     $C$L15            ; |142| 
   [ A0]   CALL    .S1     _Stim_LoadChannel_T1 ; |144| 
           LDW     .D1T1   *A19,A3           ; |126| 
           MV      .L2     B6,B4             ; |129| 
   [!A0]   MV      .L2X    A22,B7            ; |147| 
           ; BRANCHCC OCCURS {$C$L14}        ; |142| 
;** --------------------------------------------------------------------------*
   [ B0]   LDW     .D2T2   *+B7(4),B0        ; |57| 
           ; BRANCHCC OCCURS {$C$L15}        ; |142| 
;** --------------------------------------------------------------------------*
           MV      .L2X    A20,B6
           ADD     .L2     12,B7,B5
           NOP             2

   [!B0]   BNOP    .S1     $C$L15,5          ; |57| 
|| [ B0]   MVK     .L1     0x1,A0

           ; BRANCHCC OCCURS {$C$L15}        ; |57| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\Stim.c
;*      Loop source line                 : 57
;*      Loop opening brace source line   : 57
;*      Loop closing brace source line   : 59
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 7
;*      Unpartitioned Resource Bound     : 3
;*      Partitioned Resource Bound(*)    : 3
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     1        0     
;*      .S units                     0        1     
;*      .D units                     2        3*    
;*      .M units                     0        0     
;*      .X cross paths               1        1     
;*      .T address paths             3*       2     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          3        4     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1        1     
;*      Bound(.L .S .D .LS .LSD)     2        3*    
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 7  Unsafe schedule for irregular loop
;*         ii = 7  Unsafe schedule for irregular loop
;*         ii = 7  Unsafe schedule for irregular loop
;*         ii = 7  Did not find schedule
;*         ii = 8  Unsafe schedule for irregular loop
;*         ii = 8  Unsafe schedule for irregular loop
;*         ii = 8  Unsafe schedule for irregular loop
;*         ii = 8  Did not find schedule
;*         ii = 9  Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 1
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      For further improvement on this loop, try option -mh56
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L11:    ; PIPED LOOP PROLOG
   [ A0]   SPLOOPW 9       ;18               ; (P) 
;** --------------------------------------------------------------------------*
$C$L12:    ; PIPED LOOP KERNEL

           SPMASK          L1
||         MV      .L1X    B6,A7
||         LDW     .D2T2   *B5++,B6          ; |58| (P) <0,0>  ^ 

           NOP             1
           ZERO    .L2     B6                ; (P) <0,2> 

           SPMASK          L1,L2
||         MV      .L1X    B7,A6
||         MV      .L2X    A4,B7
||         SET     .S2     B6,0x1d,0x1e,B6   ; (P) <0,3> 

           SPMASK          S2
||         MV      .S2X    A20,B4
||         SUB     .L2     B7,B6,B8          ; |58| (P) <0,4> 

           MV      .L2X    A5,B6             ; |58| (P) <0,5> 
|| [ A0]   STW     .D2T2   B6,*B8            ; |58| (P) <0,5>  ^ 

   [ A0]   STW     .D2T2   B4,*B6            ; |58| (P) <0,6>  ^ 

           MV      .L1     A5,A3             ; |58| (P) <0,7> 
||         LDW     .D1T1   *+A6(4),A3        ; |57| (P) <0,7> 

   [ A0]   LDW     .D1T1   *A3,A4            ; |58| (P) <0,8> 
           NOP             2
           ADD     .L1     1,A7,A7           ; |57| <0,11> 
           CMPLTU  .L1     A7,A3,A3          ; |57| <0,12> 
           MV      .L1     A3,A0             ; |57| <0,13> 
           NOP             2
           NOP             1
           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L13:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*

           B       .S1     $C$L16            ; |57| 
||         MV      .D1X    B4,A20
||         MVK     .S2     3876,B4           ; |155| 
||         CMPEQ   .L1     A8,1,A1           ; |157| 

           CMPEQ   .L1     A8,2,A0           ; |157| 
||         MV      .S1     A5,A19

           ADD     .L2     B4,B18,B7         ; |155| 
           MV      .L1X    B20,A3            ; |126| 
           SUBAW   .D1     A23,11,A4
           SUB     .L1     A21,A4,A4         ; |126| 
           ; BRANCH OCCURS {$C$L16}          ; |57| 
;** --------------------------------------------------------------------------*
$C$L14:    
           ADDKPC  .S2     $C$RL11,B3,1      ; |144| 
$C$RL11:   ; CALL OCCURS {_Stim_LoadChannel_T1} {0}  ; |144| 
;** --------------------------------------------------------------------------*
           LDHU    .D2T1   *B19,A8
           NOP             4
;** --------------------------------------------------------------------------*
$C$L15:    

           CMPEQ   .L1     A8,1,A1           ; |157| 
||         MVK     .S2     3876,B4           ; |155| 
||         SUBAW   .D1     A23,11,A4

           SUB     .S1     A21,A4,A4         ; |126| 
||         ADD     .L2     B4,B18,B7         ; |155| 
||         CMPEQ   .L1     A8,2,A0           ; |157| 
||         MV      .D1X    B20,A3            ; |126| 

;** --------------------------------------------------------------------------*
$C$L16:    
           STW     .D1T1   A20,*A4           ; |126| 
           STW     .D1T1   A20,*A3           ; |126| 

   [ A1]   BNOP    .S1     $C$L20,4          ; |157| 
||         LDW     .D2T2   *B20,B4           ; |126| 

           MV      .L2X    A22,B4            ; |159| 
||         MV      .L1X    B7,A4             ; |159| 
|| [ A1]   MVK     .S1     0x1,A0            ; nullify predicate

           ; BRANCHCC OCCURS {$C$L20}        ; |157| 
;** --------------------------------------------------------------------------*
   [!A0]   BNOP    .S1     $C$L21,4          ; |157| 
   [ A0]   LDW     .D2T2   *+B4(8),B6        ; |63| 
           ; BRANCHCC OCCURS {$C$L21}        ; |157| 
;** --------------------------------------------------------------------------*
           LDW     .D2T2   *+B4(4),B5        ; |63| 
           NOP             4

           ADD     .L2     B6,B5,B8          ; |63| 
||         ADDAW   .D2     B4,B5,B6

           CMPLTU  .L2     B5,B8,B0          ; |63| 
||         ADD     .S2     12,B6,B8

   [!B0]   BNOP    .S1     $C$L21,5          ; |63| 
|| [ B0]   MVK     .L1     0x1,A0

           ; BRANCHCC OCCURS {$C$L21}        ; |63| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\Stim.c
;*      Loop source line                 : 63
;*      Loop opening brace source line   : 63
;*      Loop closing brace source line   : 65
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 7
;*      Unpartitioned Resource Bound     : 3
;*      Partitioned Resource Bound(*)    : 3
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     1        0     
;*      .S units                     0        1     
;*      .D units                     3*       3*    
;*      .M units                     0        0     
;*      .X cross paths               2        1     
;*      .T address paths             3*       3*    
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          4        4     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1        1     
;*      Bound(.L .S .D .LS .LSD)     3*       3*    
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 7  Unsafe schedule for irregular loop
;*         ii = 7  Unsafe schedule for irregular loop
;*         ii = 7  Unsafe schedule for irregular loop
;*         ii = 7  Did not find schedule
;*         ii = 8  Unsafe schedule for irregular loop
;*         ii = 8  Unsafe schedule for irregular loop
;*         ii = 8  Unsafe schedule for irregular loop
;*         ii = 8  Did not find schedule
;*         ii = 9  Unsafe schedule for irregular loop
;*         ii = 9  Unsafe schedule for irregular loop
;*         ii = 9  Unsafe schedule for irregular loop
;*         ii = 9  Did not find schedule
;*         ii = 10 Unsafe schedule for irregular loop
;*         ii = 10 Unsafe schedule for irregular loop
;*         ii = 10 Unsafe schedule for irregular loop
;*         ii = 10 Did not find schedule
;*         ii = 11 Unsafe schedule for irregular loop
;*         ii = 11 Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 1
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      For further improvement on this loop, try option -mh56
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L17:    ; PIPED LOOP PROLOG
   [ A0]   SPLOOPW 11      ;22               ; (P) 
;** --------------------------------------------------------------------------*
$C$L18:    ; PIPED LOOP KERNEL
           NOP             2

           SPMASK          L1
||         MV      .L1X    B5,A5
||         LDW     .D2T2   *B8++,B5          ; |64| (P) <0,2>  ^ 

           NOP             1
           ZERO    .L2     B5                ; (P) <0,4> 

           SPMASK          L1,L2
||         MV      .L1X    B4,A4
||         MV      .L2X    A19,B4
||         SET     .S2     B5,0x1d,0x1e,B5   ; (P) <0,5> 

           SUB     .L2     B7,B5,B6          ; |64| (P) <0,6> 

           SPMASK          S1
||         MV      .S1     A20,A6
||         MV      .L1X    B4,A3             ; |64| (P) <0,7> 
|| [ A0]   STW     .D2T2   B5,*B6            ; |64| (P) <0,7>  ^ 

   [ A0]   STW     .D1T1   A6,*A3            ; |64| (P) <0,8>  ^ 
           LDW     .D1T1   *+A4(4),A3        ; |63| (P) <0,9> 
           LDW     .D1T1   *+A4(8),A7        ; |63| (P) <0,10> 
           NOP             4

           ADD     .L1     1,A5,A5           ; |63| <0,15> 
||         ADD     .S1     A7,A3,A3          ; |63| <0,15> 

           MV      .L2     B4,B6             ; |64| <0,16> 
||         CMPLTU  .L1     A5,A3,A3          ; |63| <0,16> 

           LDW     .D2T2   *B6,B5            ; |64| <0,17> 
||         MV      .L1     A3,A0             ; |63| <0,17> 

           NOP             2
           NOP             1
           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L19:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
           RETNOP  .S2     B2,5              ; |167| 
           ; BRANCH OCCURS {B2}              ; |167| 
;** --------------------------------------------------------------------------*
$C$L20:    
           CALL    .S1     _Stim_LoadChannelSB_T1 ; |159| 
           NOP             4
           ADDKPC  .S2     $C$RL12,B3,0      ; |159| 
$C$RL12:   ; CALL OCCURS {_Stim_LoadChannelSB_T1} {0}  ; |159| 
;** --------------------------------------------------------------------------*
$C$L21:    
           RETNOP  .S2     B2,5              ; |167| 
           ; BRANCH OCCURS {B2}              ; |167| 
	.sect	".text"
	.clink
	.global	_Stim_SetElectrodeConfig

;******************************************************************************
;* FUNCTION NAME: Stim_SetElectrodeConfig                                     *
;*                                                                            *
;*   Regs Modified     : A3,A5,A6,A7,A8,B4,B5,B6,B7,B8                        *
;*   Regs Used         : A3,A4,A5,A6,A7,A8,B3,B4,B5,B6,B7,B8                  *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_Stim_SetElectrodeConfig:
;** --------------------------------------------------------------------------*

           MVKL    .S2     0xa0000a40,B6
||         ZERO    .L1     A3

           MVKH    .S2     0xa0000a40,B6
||         SET     .S1     A3,0x1c,0x1e,A3
||         ZERO    .L2     B5                ; |400| 

           STW     .D2T1   A4,*B6            ; |400| 
||         ADD     .L2     4,B6,B7
||         STW     .D1T2   B5,*A3            ; |400| 
||         MV      .L1     A3,A5             ; |400| 

           STW     .D2T1   A4,*B7            ; |401| 
||         LDW     .D1T2   *A5,B7            ; |400| 

           MV      .L2X    A3,B8             ; |400| 
           STW     .D2T2   B5,*B8            ; |401| 
           MV      .L1     A3,A6             ; |400| 
           MV      .L1     A3,A7             ; |400| 

           LDW     .D1T1   *A6,A5            ; |401| 
||         ADD     .L2     8,B6,B7

           STW     .D2T1   A4,*B7            ; |402| 
||         STW     .D1T2   B5,*A7            ; |402| 
||         ADD     .L2     12,B6,B6
||         MV      .L1     A3,A8             ; |400| 

           STW     .D2T1   A4,*B6            ; |403| 
||         LDW     .D1T2   *A8,B6            ; |402| 
||         MV      .L2X    A3,B4             ; |400| 

           STW     .D2T2   B5,*B4            ; |403| 
||         RET     .S2     B3                ; |405| 

           LDW     .D1T1   *A3,A3            ; |403| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |405| 
	.sect	".text"
	.clink
	.global	_Stim_Trigger

;******************************************************************************
;* FUNCTION NAME: Stim_Trigger                                                *
;*                                                                            *
;*   Regs Modified     : A3,A4,A5,A6,A7,A8,A9,B4,B5,B6,B7,B8,B9               *
;*   Regs Used         : A3,A4,A5,A6,A7,A8,A9,B3,B4,B5,B6,B7,B8,B9            *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_Stim_Trigger:
;** --------------------------------------------------------------------------*
           MVKL    .S2     0xa0000a40,B7

           MVKH    .S2     0xa0000a40,B7
||         ZERO    .L2     B6

           STW     .D2T2   B4,*B7            ; |400| 
||         SET     .S2     B6,0x1c,0x1e,B6
||         ZERO    .L1     A5                ; |400| 

           STW     .D2T1   A5,*B6            ; |400| 

           ADD     .L1X    4,B7,A3
||         LDW     .D2T2   *B6,B5            ; |400| 

           STW     .D1T2   B4,*A3            ; |401| 
||         MV      .L2     B6,B8             ; |400| 

           STW     .D2T1   A5,*B8            ; |401| 
||         MV      .L1X    B6,A4             ; |400| 

           LDW     .D1T2   *A4,B5            ; |401| 

           ADD     .L2     8,B7,B8
||         SHL     .S1     A6,3,A3           ; |303| 

           STW     .D2T2   B4,*B8            ; |402| 
||         MV      .L2     B6,B9             ; |400| 
||         OR      .L1     A6,A3,A6          ; |303| 

           STW     .D2T1   A5,*B9            ; |402| 
||         ADD     .L2     12,B7,B7
||         MV      .L1X    B6,A8             ; |400| 
||         SHL     .S1     A6,16,A3          ; |303| 

           LDW     .D1T1   *A8,A8            ; |402| 
||         STW     .D2T2   B4,*B7            ; |403| 
||         MVKL    .S1     0xa0000214,A4
||         MV      .L1X    B6,A9             ; |400| 

           MV      .L2     B6,B5             ; |400| 
||         STW     .D1T1   A5,*A9            ; |403| 
||         OR      .L1     A6,A3,A3          ; |303| 
||         MVKH    .S1     0xa0000214,A4

           LDW     .D2T2   *B5,B4            ; |403| 
||         STW     .D1T1   A3,*A4            ; |303| 
||         MV      .L1X    B6,A7             ; |400| 

           STW     .D1T1   A5,*A7            ; |303| 
||         RET     .S2     B3                ; |304| 

           LDW     .D2T2   *B6,B4            ; |303| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |304| 
	.sect	".text"
	.clink
	.global	_Stim_StopSequence

;******************************************************************************
;* FUNCTION NAME: Stim_StopSequence                                           *
;*                                                                            *
;*   Regs Modified     : B4                                                   *
;*   Regs Used         : B3,B4,DP                                             *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_Stim_StopSequence:
;** --------------------------------------------------------------------------*
           RETNOP  .S2     B3,3              ; |438| 
           ZERO    .L2     B4                ; |437| 
           STW     .D2T2   B4,*+DP(_StimSequence_Enabled) ; |437| 
           ; BRANCH OCCURS {B3}              ; |438| 
	.sect	".text"
	.clink
	.global	_Stim_StartSequence

;******************************************************************************
;* FUNCTION NAME: Stim_StartSequence                                          *
;*                                                                            *
;*   Regs Modified     : A3,A4,A5,A7,B0,B4,B5,B6,B7,B9,B16                    *
;*   Regs Used         : A3,A4,A5,A6,A7,A8,B0,B3,B4,B5,B6,B7,B8,B9,DP,B16     *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_Stim_StartSequence:
;** --------------------------------------------------------------------------*
           MVKL    .S1     _u_Stim_SequenceList,A5
           MVKH    .S1     _u_Stim_SequenceList,A5
           MV      .L1     A5,A7             ; |422| 
           STW     .D1T1   A4,*A7            ; |422| 
           LDW     .D1T1   *A5,A3            ; |428| 
           MV      .L2     B4,B0             ; |419| 
           MVK     .S2     8,B4
           ADD     .L2X    A5,B4,B4
           ADDAH   .D2     B4,7,B5

           ADDAD   .D1     A7,A3,A3          ; |428| 
|| [ B0]   LDHU    .D2T2   *B5,B16           ; |431| 

           LDW     .D1T1   *+A3(28),A3       ; |428| 
           MVK     .L2     1,B9              ; |432| 
           RET     .S2     B3                ; |435| 

           MV      .L2X    A6,B7             ; |419| 
|| [ B0]   STW     .D2T2   B9,*+DP(_StimSequence_Enabled) ; |432| 

           MVKL    .S2     _StimStatus+4,B5
||         STW     .D1T2   B7,*+A7(12)       ; |424| 

           ADD     .L2X    B8,A3,B7          ; |428| 
||         MV      .L1X    B6,A4             ; |419| 
|| [ B0]   SHL     .S2     B16,16,B6         ; |431| 
||         STW     .D1T2   B0,*+A7(4)        ; |423| 

           STW     .D2T2   B7,*B4            ; |428| 
|| [ B0]   ADD     .L2     1,B6,B4           ; |431| 
||         MVKH    .S2     _StimStatus+4,B5
||         STH     .D1T1   A8,*+A7(20)       ; |427| 

   [ B0]   STW     .D2T2   B4,*B5            ; |431| 
||         STW     .D1T1   A4,*+A7(16)       ; |425| 

           ; BRANCH OCCURS {B3}              ; |435| 
	.sect	".text"
	.clink
	.global	_Stim_StartBlanking

;******************************************************************************
;* FUNCTION NAME: Stim_StartBlanking                                          *
;*                                                                            *
;*   Regs Modified     : B4                                                   *
;*   Regs Used         : B3,B4,DP                                             *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_Stim_StartBlanking:
;** --------------------------------------------------------------------------*
           RETNOP  .S2     B3,3              ; |490| 
           MVK     .S2     86,B4             ; |488| 
           STW     .D2T2   B4,*+DP(_Stim_BlankingCounter) ; |488| 
           ; BRANCH OCCURS {B3}              ; |490| 
	.sect	".text"
	.clink
	.global	_Stim_SetupTrigger

;******************************************************************************
;* FUNCTION NAME: Stim_SetupTrigger                                           *
;*                                                                            *
;*   Regs Modified     : A3,A4,A5,A6,A7,A8,A9,B4,B5,B6,B7,B8,B9               *
;*   Regs Used         : A3,A4,A5,A6,A7,A8,A9,B3,B4,B5,B6,B7,B8,B9            *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_Stim_SetupTrigger:
;** --------------------------------------------------------------------------*

           MVKL    .S1     0xa0000200,A4
||         ZERO    .L2     B4

           MVKH    .S1     0xa0000200,A4
||         SET     .S2     B4,0x1c,0x1e,B6

           ZERO    .L2     B7                ; |235| 
||         MVK     .L1     0x1,A7            ; |235| 

           STW     .D2T2   B7,*B6            ; |235| 
||         ADD     .L2X    4,A4,B4
||         STW     .D1T1   A7,*A4            ; |235| 
||         MV      .L1X    B6,A3             ; |235| 

;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\Stim.c
;*      Loop source line                 : 258
;*      Loop opening brace source line   : 258
;*      Loop closing brace source line   : 261
;*      Known Minimum Trip Count         : 12                    
;*      Known Maximum Trip Count         : 12                    
;*      Known Max Trip Count Factor      : 12
;*      Loop Carried Dependency Bound(^) : 1
;*      Unpartitioned Resource Bound     : 2
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     0        0     
;*      .D units                     1        2*    
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             1        2*    
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          2        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        0     
;*      Bound(.L .S .D .LS .LSD)     1        1     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 2  Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 0
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L22:    ; PIPED LOOP PROLOG

           LDW     .D1T1   *A3,A3            ; |235| 
||         STW     .D2T2   B7,*B4            ; |236| 

           MV      .L1X    B6,A3             ; |235| 
||         STW     .D2T2   B7,*B6            ; |236| 

           ADD     .L1     8,A4,A5
||         LDW     .D1T1   *A3,A3            ; |236| 

           MV      .L2     B6,B4             ; |235| 
||         STW     .D1T2   B7,*A5            ; |237| 

           MV      .L1X    B6,A6             ; |235| 
||         STW     .D2T2   B7,*B4            ; |237| 

           ADD     .L1     12,A4,A4
||         LDW     .D1T1   *A6,A3            ; |237| 

           STW     .D1T2   B7,*A4            ; |238| 

           MV      .L1X    B6,A5             ; |235| 
||         STW     .D2T2   B7,*B6            ; |238| 

           ADD     .L1     4,A4,A4
||         LDW     .D1T1   *A5,A3            ; |238| 

           MVK     .S2     8,B4
||         MV      .L2     B6,B5             ; |235| 
||         STW     .D1T2   B7,*A4            ; |239| 

           ADD     .L2X    A4,B4,B4
||         STW     .D2T2   B7,*B5            ; |239| 

           LDW     .D1T1   *A6,A3            ; |239| 
||         STW     .D2T2   B7,*B4            ; |241| 

           MV      .L1X    B6,A4             ; |235| 
||         ADD     .L2     4,B4,B5
||         STW     .D2T2   B7,*B6            ; |241| 

           MV      .L2     B6,B8             ; |235| 
||         LDW     .D1T1   *A4,A3            ; |241| 
||         STW     .D2T2   B7,*B5            ; |242| 

           MV      .L1X    B6,A3             ; |235| 
||         ADD     .L2     8,B4,B5
||         STW     .D2T2   B7,*B8            ; |242| 

           LDW     .D1T1   *A3,A3            ; |242| 
||         STW     .D2T2   B7,*B5            ; |243| 

           ADD     .L2     12,B4,B5
||         STW     .D2T2   B7,*B6            ; |243| 

           MV      .L2     B6,B9             ; |235| 
||         LDW     .D1T1   *A5,A3            ; |243| 
||         STW     .D2T2   B7,*B5            ; |244| 

           ADD     .L2     4,B5,B4
||         STW     .D2T2   B7,*B9            ; |244| 

           LDW     .D1T1   *A6,A3            ; |244| 
||         STW     .D2T2   B7,*B4            ; |245| 

           STW     .D2T2   B7,*B6            ; |245| 

           ADD     .L2     8,B5,B4
||         LDW     .D2T1   *B8,A3            ; |245| 

           MV      .L2     B6,B4             ; |235| 
||         STW     .D2T2   B7,*B4            ; |246| 

           MVKL    .S1     0xa0009190,A4
||         STW     .D2T2   B7,*B4            ; |246| 

           MVKH    .S1     0xa0009190,A4
||         LDW     .D1T1   *A5,A3            ; |246| 

           MV      .L1X    B6,A5             ; |235| 
||         STW     .D1T1   A7,*A4            ; |248| 
||         STW     .D2T2   B7,*B9            ; |248| 

           ADD     .L1     4,A4,A3
||         LDW     .D1T1   *A5,A5            ; |248| 

           STW     .D1T1   A7,*A3            ; |249| 
||         STW     .D2T2   B7,*B6            ; |249| 

           MV      .L2     B6,B9             ; |235| 
||         ADD     .L1     8,A4,A4
||         LDW     .D1T1   *A6,A3            ; |249| 

           MVKL    .S1     0xa000a190,A8
||         MV      .L1X    B6,A9             ; |235| 
||         STW     .D1T1   A7,*A4            ; |250| 
||         STW     .D2T2   B7,*B9            ; |250| 

           MVKH    .S1     0xa000a190,A8
||         LDW     .D1T1   *A9,A3            ; |250| 

           MV      .L1X    B6,A4             ; |235| 
||         STW     .D1T1   A7,*A8            ; |252| 
||         STW     .D2T2   B7,*B4            ; |252| 

           ADD     .L1     4,A8,A4
||         LDW     .D1T1   *A4,A6            ; |252| 

           MV      .L1X    B6,A4             ; |235| 
||         STW     .D1T1   A7,*A4            ; |253| 

           STW     .D1T2   B7,*A4            ; |253| 

           ADD     .L1     8,A8,A3
||         LDW     .D2T2   *B4,B5            ; |253| 

           STW     .D1T1   A7,*A3            ; |254| 
||         STW     .D2T2   B7,*B9            ; |254| 

           LDW     .D2T1   *B8,A3            ; |254| 
           NOP             1

           MVK     .L2     10,B4             ; |258| 
||         ZERO    .L1     A4

           SET     .S1     A4,0x1d,0x1e,A4
||         MVC     .S2     B4,ILC

           SPLOOPD 2       ;4                ; (P) 
||         MVK     .S1     0xa00,A5          ; |257| 

;** --------------------------------------------------------------------------*
$C$L23:    ; PIPED LOOP KERNEL

           SPMASK          S1,L2
||         MVK     .S1     0xff,A6
||         MV      .L2     B7,B5
||         SUB     .L1     A5,A4,A3          ; |259| (P) <0,0>  ^ 

           ADD     .L1     4,A5,A5           ; |260| (P) <0,1>  ^ 
||         STW     .D1T1   A6,*A3            ; |259| (P) <0,1>  ^ 
||         STW     .D2T2   B5,*B6            ; |259| (P) <0,1>  ^ 

           SPKERNEL 0,0
||         LDW     .D2T2   *B6,B4            ; |259| <0,2>  ^ 

;** --------------------------------------------------------------------------*
$C$L24:    ; PIPED LOOP EPILOG

           MVK     .S1     0xa40,A5          ; |262| 
||         MVK     .L2     2,B7              ; |263| 

;** --------------------------------------------------------------------------*
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\Stim.c
;*      Loop source line                 : 263
;*      Loop opening brace source line   : 263
;*      Loop closing brace source line   : 266
;*      Known Minimum Trip Count         : 4                    
;*      Known Maximum Trip Count         : 4                    
;*      Known Max Trip Count Factor      : 4
;*      Loop Carried Dependency Bound(^) : 2
;*      Unpartitioned Resource Bound     : 2
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     0        0     
;*      .D units                     1        2*    
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             2*       1     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          2        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        0     
;*      Bound(.L .S .D .LS .LSD)     1        1     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 2  Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 0
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L25:    ; PIPED LOOP PROLOG
           MVC     .S2     B7,ILC
           SPLOOPD 2       ;4                ; (P) 
;** --------------------------------------------------------------------------*
$C$L26:    ; PIPED LOOP KERNEL

           SPMASK          S1
||         MV      .S1X    B5,A6
||         SUB     .L1     A5,A4,A3          ; |264| (P) <0,0> 

           SPMASK          L2
||         MV      .L2     B6,B5             ; |262| 
||         ADD     .L1     4,A5,A5           ; |265| (P) <0,1> 
||         STW     .D1T1   A6,*A3            ; |264| (P) <0,1>  ^ 

           STW     .D2T1   A6,*B5            ; |264| <0,2>  ^ 

           SPKERNEL 0,0
||         LDW     .D2T2   *B5,B4            ; |264| <0,3>  ^ 

;** --------------------------------------------------------------------------*
$C$L27:    ; PIPED LOOP EPILOG

           MVK     .S1     0xa80,A5          ; |267| 
||         MVK     .L2     2,B6              ; |268| 

           NOP             1
;** --------------------------------------------------------------------------*
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\Stim.c
;*      Loop source line                 : 268
;*      Loop opening brace source line   : 268
;*      Loop closing brace source line   : 271
;*      Known Minimum Trip Count         : 4                    
;*      Known Maximum Trip Count         : 4                    
;*      Known Max Trip Count Factor      : 4
;*      Loop Carried Dependency Bound(^) : 2
;*      Unpartitioned Resource Bound     : 2
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     0        0     
;*      .D units                     1        2*    
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             2*       1     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          2        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        0     
;*      Bound(.L .S .D .LS .LSD)     1        1     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 2  Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 0
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L28:    ; PIPED LOOP PROLOG
           MVC     .S2     B6,ILC
           SPLOOPD 2       ;4                ; (P) 
;** --------------------------------------------------------------------------*
$C$L29:    ; PIPED LOOP KERNEL
           SUB     .L1     A5,A4,A3          ; |269| (P) <0,0> 

           ADD     .L1     4,A5,A5           ; |270| (P) <0,1> 
||         STW     .D1T1   A6,*A3            ; |269| (P) <0,1>  ^ 

           STW     .D2T1   A6,*B5            ; |269| <0,2>  ^ 

           SPKERNEL 0,0
||         LDW     .D2T2   *B5,B4            ; |269| <0,3>  ^ 

;** --------------------------------------------------------------------------*
$C$L30:    ; PIPED LOOP EPILOG
           RETNOP  .S2     B3,5              ; |274| 
           ; BRANCH OCCURS {B3}              ; |274| 
	.sect	".text"
	.clink
	.global	_Stim_SetupStimGen0

;******************************************************************************
;* FUNCTION NAME: Stim_SetupStimGen0                                          *
;*                                                                            *
;*   Regs Modified     : A0,A3,A4,A5,A6,A7,A8,A9,B0,B4,B5,B6,B7,B8,B9,A16,B16,*
;*                           B17                                              *
;*   Regs Used         : A0,A3,A4,A5,A6,A7,A8,A9,B0,B3,B4,B5,B6,B7,B8,B9,A16, *
;*                           B16,B17                                          *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_Stim_SetupStimGen0:
;** --------------------------------------------------------------------------*
           MVKL    .S1     0x5ffffe00,A3

           MVKH    .S1     0x5ffffe00,A3
||         ZERO    .L1     A5

           SUB     .L1     A4,A3,A6          ; |185| 
||         SET     .S1     A5,0x1d,0x1d,A5
||         ZERO    .L2     B4

           STW     .D1T1   A5,*A6            ; |185| 
||         SET     .S2     B4,0x1c,0x1e,B5
||         ZERO    .L1     A8                ; |185| 

           STW     .D2T1   A8,*B5            ; |185| 

           LDW     .D2T2   *B5,B4            ; |185| 
||         MVK     .L2     0x1,B0

;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\Stim.c
;*      Loop source line                 : 186
;*      Loop closing brace source line   : 186
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 7
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 1
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     0        0     
;*      .D units                     1*       0     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             1*       0     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          2        1     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        0     
;*      Bound(.L .S .D .LS .LSD)     1*       1*    
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 7  Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 1
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L31:    ; PIPED LOOP PROLOG
   [ B0]   SPLOOPW 7       ;14               ; (P) 
;** --------------------------------------------------------------------------*
$C$L32:    ; PIPED LOOP KERNEL
           NOP             1

           SPMASK          L1,S1
||         MV      .L1     A4,A6
||         MV      .S1     A3,A4

           SUB     .L1     A6,A4,A7          ; |186| (P) <0,2> 
   [ B0]   LDW     .D1T1   *A7,A3            ; |186| (P) <0,3>  ^ 
           NOP             1

           SPMASK          L1
||         ZERO    .L1     A5

           SPMASK          S1
||         SET     .S1     A5,0x1c,0x1d,A5

           NOP             1
           AND     .L1     A5,A3,A0          ; |186| <0,8>  ^ 
   [!A0]   ZERO    .L2     B0                ; |186| <0,9>  ^ 
           NOP             2
           NOP             1
           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L33:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
           MVK     .L2     2,B4              ; |191| 

           MVC     .S2     B4,ILC
||         MV      .L1     A6,A7
||         ZERO    .D1     A9
||         MVK     .S1     288,A5            ; |190| 

;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\Stim.c
;*      Loop source line                 : 191
;*      Loop opening brace source line   : 191
;*      Loop closing brace source line   : 194
;*      Known Minimum Trip Count         : 4                    
;*      Known Maximum Trip Count         : 4                    
;*      Known Max Trip Count Factor      : 4
;*      Loop Carried Dependency Bound(^) : 2
;*      Unpartitioned Resource Bound     : 2
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     0        0     
;*      .D units                     1        2*    
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             2*       1     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          2        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        0     
;*      Bound(.L .S .D .LS .LSD)     1        1     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 2  Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 0
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L34:    ; PIPED LOOP PROLOG

           SPLOOPD 2       ;4                ; (P) 
||         MV      .L1     A4,A9
||         ADD     .D1     A5,A6,A6          ; |190| 
||         SET     .S1     A9,0x1d,0x1e,A4

;** --------------------------------------------------------------------------*
$C$L35:    ; PIPED LOOP KERNEL

           SPMASK          S1
||         MV      .S1     A8,A5
||         SUB     .L1     A6,A4,A3          ; |192| (P) <0,0> 

           ADD     .L1     4,A6,A6           ; |193| (P) <0,1> 
||         STW     .D1T1   A5,*A3            ; |192| (P) <0,1>  ^ 

           STW     .D2T1   A5,*B5            ; |192| <0,2>  ^ 

           SPKERNEL 0,0
||         LDW     .D2T2   *B5,B4            ; |192| <0,3>  ^ 

;** --------------------------------------------------------------------------*
$C$L36:    ; PIPED LOOP EPILOG

           MV      .L2     B5,B9             ; |196| 
||         MVK     .S2     128,B6
||         MV      .L1     A5,A8
||         MVK     .S1     172,A3

           MVKL    .S2     0x20100,B7
||         MV      .L2     B5,B16            ; |196| 
||         MVKL    .S1     0x4200420,A5
||         MV      .L1X    B5,A16            ; |196| 
||         ADD     .D1     A9,A3,A4

;** --------------------------------------------------------------------------*
           SUB     .L1     A7,A4,A3          ; |196| 
           SUB     .L2X    A4,B6,B6
           MVKH    .S1     0x4200420,A5
           SUB     .L1X    A7,B6,A7          ; |200| 
           MVKL    .S2     0x2100210,B4
           MVKH    .S2     0x2100210,B4
           STW     .D1T2   B4,*A3            ; |196| 
           STW     .D1T1   A8,*A16           ; |196| 

           LDW     .D2T2   *B5,B6            ; |196| 
||         STW     .D1T1   A5,*+A3(124)      ; |199| 

           STW     .D2T1   A8,*B9            ; |199| 
||         MVK     .S1     1329,A4           ; |200| 

           LDW     .D2T2   *B5,B9            ; |199| 
||         STW     .D1T1   A4,*A7            ; |200| 

           STW     .D2T1   A8,*B16           ; |200| 
||         MV      .L2     B5,B17            ; |196| 
||         MVKH    .S2     0x20100,B7

           LDW     .D2T1   *B17,A4           ; |200| 
||         STW     .D1T2   B7,*-A3(80)       ; |202| 
||         MV      .L1X    B5,A9             ; |196| 

           STW     .D1T1   A8,*A9            ; |202| 
||         MV      .L2     B5,B8             ; |196| 

           LDW     .D2T2   *B8,B4            ; |202| 

           STW     .D1T2   B7,*-A3(76)       ; |203| 
||         MV      .L1X    B5,A6             ; |196| 

           STW     .D1T1   A8,*A6            ; |203| 
||         RET     .S2     B3                ; |205| 

           LDW     .D2T2   *B5,B4            ; |203| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |205| 
	.sect	".text"
	.clink
	.global	_Set_Segment

;******************************************************************************
;* FUNCTION NAME: Set_Segment                                                 *
;*                                                                            *
;*   Regs Modified     : A3,A4,A5,A6,B4,B5,B6,B7,B8,B9,B16                    *
;*   Regs Used         : A3,A4,A5,A6,B3,B4,B5,B6,B7,B8,B9,B16                 *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_Set_Segment:
;** --------------------------------------------------------------------------*
           MVKL    .S1     0xa0000218,A5

           MVKH    .S1     0xa0000218,A5
||         SHL     .S2X    A4,16,B5          ; |278| 
||         ZERO    .L2     B7

           STW     .D1T2   B5,*A5            ; |278| 
||         SET     .S2     B7,0x1c,0x1e,B7
||         ZERO    .L2     B6                ; |278| 

           STW     .D2T2   B6,*B7            ; |278| 
||         ADD     .L1     4,A5,A3

           STW     .D1T2   B5,*A3            ; |279| 
||         LDW     .D2T1   *B7,A3            ; |278| 

           MV      .L1X    B7,A4             ; |278| 
           STW     .D1T2   B6,*A4            ; |279| 
           MV      .L2     B7,B4             ; |278| 
           MV      .L1X    B7,A6             ; |278| 
           ADD     .L1     8,A5,A3

           STW     .D1T2   B5,*A3            ; |280| 
||         LDW     .D2T1   *B4,A3            ; |279| 

           STW     .D1T2   B6,*A6            ; |280| 
           MV      .L2     B7,B8             ; |278| 
           LDW     .D2T2   *B8,B4            ; |280| 
           MV      .L2     B7,B9             ; |278| 
           ADD     .L1     12,A5,A3
           STW     .D1T2   B5,*A3            ; |281| 

           STW     .D2T2   B6,*B8            ; |281| 
||         ADD     .L1     4,A3,A4

           STW     .D1T2   B5,*A4            ; |282| 
||         LDW     .D2T1   *B9,A4            ; |281| 
||         MV      .L1X    B7,A5             ; |278| 

           STW     .D1T2   B6,*A5            ; |282| 
||         MV      .L2     B7,B16            ; |278| 

           ADD     .L1     8,A3,A3
||         LDW     .D2T2   *B16,B8           ; |282| 

           STW     .D1T2   B5,*A3            ; |283| 
||         MV      .L2     B7,B4             ; |278| 

           STW     .D2T2   B6,*B4            ; |283| 
||         RET     .S2     B3                ; |284| 

           LDW     .D2T1   *B7,A3            ; |283| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |284| 
	.sect	".text"
	.clink
	.global	_Stim_SetupStimGen

;******************************************************************************
;* FUNCTION NAME: Stim_SetupStimGen                                           *
;*                                                                            *
;*   Regs Modified     : A0,A1,A3,A4,A5,A6,A7,A8,A9,B0,B3,B4,B5,B6,B7,B8,B9,  *
;*                           A16,B16,B17                                      *
;*   Regs Used         : A0,A1,A3,A4,A5,A6,A7,A8,A9,B0,B3,B4,B5,B6,B7,B8,B9,  *
;*                           SP,A16,B16,B17                                   *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_Stim_SetupStimGen:
;** --------------------------------------------------------------------------*
           MVKL    .S1     0x9000,A4

           MV      .L1X    B3,A1             ; |206| 
||         CALLP   .S2     _Stim_SetupStimGen0,B3
||         MVKH    .S1     0x9000,A4

$C$RL13:   ; CALL OCCURS {_Stim_SetupStimGen0} {0}  ; |212| 
;** --------------------------------------------------------------------------*
           MVKL    .S1     0xa000,A4

           CALLP   .S2     _Stim_SetupStimGen0,B3
||         MVKH    .S1     0xa000,A4

$C$RL14:   ; CALL OCCURS {_Stim_SetupStimGen0} {0}  ; |213| 
;** --------------------------------------------------------------------------*
           MVKL    .S2     0xa0000218,B6

           ZERO    .L2     B4
||         MVKH    .S2     0xa0000218,B6

           SET     .S2     B4,0x1c,0x1e,B4
||         ZERO    .L1     A3                ; |278| 

           STW     .D2T1   A3,*B6            ; |278| 

           MV      .L1X    B4,A4             ; |278| 
||         STW     .D2T1   A3,*B4            ; |278| 

           LDW     .D1T2   *A4,B5            ; |278| 
           ADD     .L1X    4,B6,A4
           STW     .D1T1   A3,*A4            ; |279| 
           MV      .L1X    B4,A5             ; |278| 

           STW     .D1T1   A3,*A5            ; |279| 
||         MV      .L1X    B4,A6             ; |278| 

           ADD     .L2     8,B6,B5
||         LDW     .D1T1   *A6,A4            ; |279| 

           STW     .D2T1   A3,*B5            ; |280| 

           STW     .D2T1   A3,*B4            ; |280| 
||         MV      .L2     B4,B7             ; |278| 

           ADD     .L2     12,B6,B6
||         LDW     .D2T2   *B7,B5            ; |280| 

           STW     .D2T1   A3,*B6            ; |281| 
||         MV      .L2     B4,B8             ; |278| 

           STW     .D2T1   A3,*B8            ; |281| 
||         MV      .L2     B4,B9             ; |278| 

           LDW     .D2T2   *B9,B5            ; |281| 
           ADD     .L2     4,B6,B7
           STW     .D2T1   A3,*B7            ; |282| 
           STW     .D2T1   A3,*B4            ; |282| 
           ADD     .L2     8,B6,B6
           MV      .L2     B4,B5             ; |278| 
           LDW     .D2T2   *B5,B5            ; |282| 

           STW     .D2T1   A3,*B6            ; |283| 
||         MV      .L2     B4,B7             ; |278| 

           MVKL    .S1     0xa0008140,A4
||         ZERO    .L2     B16
||         STW     .D2T1   A3,*B7            ; |283| 

           MVKH    .S1     0xa0008140,A4
||         SET     .S2     B16,0x0,0x1d,B16
||         LDW     .D2T2   *B8,B5            ; |283| 

           STW     .D1T2   B16,*A4           ; |220| 

           STW     .D2T1   A3,*B4            ; |220| 
||         MV      .L2     B4,B6             ; |278| 

           ADD     .L1     4,A4,A5
||         LDW     .D2T2   *B6,B5            ; |220| 

           STW     .D1T2   B16,*A5           ; |221| 
           STW     .D2T1   A3,*B7            ; |221| 

           ADD     .L2X    8,A4,B6
||         LDW     .D2T2   *B8,B5            ; |221| 

           STW     .D2T2   B16,*B6           ; |222| 
           STW     .D2T1   A3,*B4            ; |222| 

           ADD     .L1     12,A4,A4
||         LDW     .D2T2   *B9,B5            ; |222| 

           STW     .D1T2   B16,*A4           ; |223| 
||         MV      .L2     B4,B6             ; |278| 

           STW     .D2T1   A3,*B6            ; |223| 

           ADD     .L1     4,A4,A5
||         LDW     .D2T2   *B7,B5            ; |223| 

           STW     .D1T2   B16,*A5           ; |224| 
           STW     .D2T1   A3,*B4            ; |224| 
           LDW     .D2T2   *B8,B5            ; |224| 
           ADD     .L1     8,A4,A5
           STW     .D1T2   B16,*A5           ; |225| 
           STW     .D2T1   A3,*B6            ; |225| 
           ADD     .L1     12,A4,A4
           MV      .L2     B4,B5             ; |278| 
           LDW     .D2T2   *B5,B5            ; |225| 
           STW     .D1T2   B16,*A4           ; |226| 
           STW     .D2T1   A3,*B7            ; |226| 

           ADD     .L1     4,A4,A4
||         LDW     .D2T2   *B8,B5            ; |226| 

           STW     .D1T2   B16,*A4           ; |227| 

           STW     .D2T1   A3,*B6            ; |227| 
||         RET     .S2X    A1                ; |229| 

           LDW     .D2T2   *B4,B4            ; |227| 
           NOP             4
           ; BRANCH OCCURS {A1}              ; |229| 
	.sect	".text"
	.clink
	.global	_Stim_LoadStimSequenceList

;******************************************************************************
;* FUNCTION NAME: Stim_LoadStimSequenceList                                   *
;*                                                                            *
;*   Regs Modified     : A0,A3,A4,A5,A6,B4,B5,B6,B7                           *
;*   Regs Used         : A0,A3,A4,A5,A6,B3,B4,B5,B6,B7                        *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_Stim_LoadStimSequenceList:
;** --------------------------------------------------------------------------*

           MV      .L1X    B4,A0             ; |407| 
||         MV      .D1     A4,A3             ; |407| 
||         MVKL    .S1     _u_Stim_SequenceList,A4
||         MV      .L2X    A6,B6             ; |407| 
||         ZERO    .S2     B5                ; |412| 

   [!A0]   BNOP    .S2     $C$L40,2          ; |412| 
||         SHRU    .S1     A3,16,A5          ; |410| 
|| [ A0]   SUB     .L2     B4,1,B7

           MVKH    .S1     _u_Stim_SequenceList,A4
           STH     .D1T1   A5,*+A4(22)       ; |410| 
           EXTU    .S1     A3,16,13,A5
           ; BRANCHCC OCCURS {$C$L40}        ; |412| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\Stim.c
;*      Loop source line                 : 412
;*      Loop opening brace source line   : 412
;*      Loop closing brace source line   : 415
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 6
;*      Unpartitioned Resource Bound     : 2
;*      Partitioned Resource Bound(*)    : 3
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     0        0     
;*      .D units                     2        2     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             0        3*    
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          2        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        0     
;*      Bound(.L .S .D .LS .LSD)     2        1     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 6  Did not find schedule
;*         ii = 7  Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 0
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L37:    ; PIPED LOOP PROLOG

           SPLOOPD 7       ;14               ; (P) 
||         ADD     .L2     4,B6,B7
||         MVC     .S2     B7,ILC

;** --------------------------------------------------------------------------*
$C$L38:    ; PIPED LOOP KERNEL

           SPMASK          L1
||         MV      .L1X    B5,A6
||         LDW     .D2T2   *B7++(8),B5       ; |414| (P) <0,0>  ^ 

           LDW     .D2T2   *B6++(8),B4       ; |414| (P) <0,1>  ^ 
           NOP             2
           ADDAD   .D1     A5,A6,A3          ; |414| (P) <0,4> 
           ADD     .L1     A4,A3,A3          ; |414| (P) <0,5> 

           ADD     .L1     1,A6,A6           ; |412| (P) <0,6> 
||         STDW    .D1T2   B5:B4,*+A3(24)    ; |414| (P) <0,6>  ^ 

           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L39:    ; PIPED LOOP EPILOG
           NOP             1
;** --------------------------------------------------------------------------*
$C$L40:    
           RETNOP  .S2     B3,5              ; |417| 
           ; BRANCH OCCURS {B3}              ; |417| 
	.sect	".text"
	.clink
	.global	_Stim_LoadPattern

;******************************************************************************
;* FUNCTION NAME: Stim_LoadPattern                                            *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,A16,A17,A18,A19,A20,A21,A22,A23,A24,A25,*
;*                           A26,A27,A28,B16,B17,B18,B19,B20,B21,B22          *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,DP,SP,A16,A17,A18,A19,A20,A21,A22,A23,  *
;*                           A24,A25,A26,A27,A28,B16,B17,B18,B19,B20,B21,B22  *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_Stim_LoadPattern:
;** --------------------------------------------------------------------------*

           MV      .L2X    A4,B22            ; |305| 
||         MVKL    .S1     0x9000,A25
||         ADD     .L1     12,A4,A24         ; |313| 
||         ZERO    .S2     B21               ; |315| 
||         MVK     .D1     0xfffffffe,A27

           LDW     .D2T2   *+B22(8),B0       ; |315| 
           MV      .L1X    B3,A28            ; |305| 
           MVKL    .S1     0xa000,A26
           MVKH    .S1     0x9000,A25
           MVKH    .S1     0xa000,A26
   [!B0]   BNOP    .S1     $C$L42,5          ; |315| 
           ; BRANCHCC OCCURS {$C$L42}        ; |315| 
;** --------------------------------------------------------------------------*
           CALL    .S1     _UpLoadPatternToHS ; |317| 
           LDW     .D2T1   *+B22(4),A6       ; |317| 
           MV      .L2X    A24,B6            ; |317| 
           MV      .L2     B21,B4            ; |317| 
           MV      .L1     A25,A4            ; |317| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*      Disqualified loop: Loop contains a call
;*      Disqualified loop: Loop contains non-pipelinable instructions
;*      Disqualified loop: Loop contains a call
;*      Disqualified loop: Loop contains non-pipelinable instructions
;*----------------------------------------------------------------------------*
$C$L41:    
           ADDKPC  .S2     $C$RL15,B3,0      ; |317| 
$C$RL15:   ; CALL OCCURS {_UpLoadPatternToHS} {0}  ; |317| 
;** --------------------------------------------------------------------------*
           MV      .L2     B21,B4            ; |319| 

           CALLP   .S2     _UpLoadPatternToHS,B3
||         LDW     .D2T1   *+B22(4),A6       ; |319| 
||         MV      .L1     A26,A4            ; |319| 
||         MV      .L2X    A24,B6            ; |319| 

$C$RL16:   ; CALL OCCURS {_UpLoadPatternToHS} {0}  ; |319| 
;** --------------------------------------------------------------------------*

           LDW     .D2T2   *+B22(8),B4       ; |315| 
||         LDHU    .D1T1   *A24,A3           ; |321| 

           ADD     .L2     1,B21,B21         ; |315| 
           NOP             3

           CMPGTU  .L2     B4,B21,B0         ; |315| 
||         AND     .L1     A27,A3,A3         ; |321| 

           ADD     .L1     A3,A24,A24        ; |321| 
|| [ B0]   B       .S1     $C$L41            ; |315| 

   [ B0]   CALL    .S1     _UpLoadPatternToHS ; |317| 
   [ B0]   LDW     .D2T1   *+B22(4),A6       ; |317| 
   [ B0]   MV      .L2     B21,B4            ; |317| 
   [ B0]   MV      .L1     A25,A4            ; |317| 
   [ B0]   MV      .L2X    A24,B6            ; |317| 
           ; BRANCHCC OCCURS {$C$L41}        ; |315| 
;** --------------------------------------------------------------------------*
$C$L42:    
           RETNOP  .S2X    A28,5             ; |324| 
           ; BRANCH OCCURS {A28}             ; |324| 
	.sect	".text"
	.clink
	.global	_Stim_LoadElectrodeConfig

;******************************************************************************
;* FUNCTION NAME: Stim_LoadElectrodeConfig                                    *
;*                                                                            *
;*   Regs Modified     : A3,A4,A5,A6,A7,A8,A9,B4,B5,B6,B7,B8                  *
;*   Regs Used         : A3,A4,A5,A6,A7,A8,A9,B3,B4,B5,B6,B7,B8               *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_Stim_LoadElectrodeConfig:
;** --------------------------------------------------------------------------*
           MVKL    .S2     0xa0009150,B6

           ZERO    .L2     B5
||         MVKH    .S2     0xa0009150,B6

           SET     .S2     B5,0x1c,0x1e,B5

           STW     .D2T1   A4,*B6            ; |336| 
||         ZERO    .L1     A9                ; |336| 

           MVKL    .S1     0xa000a150,A5
||         MV      .L1X    B5,A3             ; |336| 
||         STW     .D2T1   A9,*B5            ; |336| 

           MVKH    .S1     0xa000a150,A5
||         LDW     .D1T1   *A3,A3            ; |336| 

           STW     .D1T1   A4,*A5            ; |337| 
||         MV      .L1X    B5,A6             ; |336| 

           STW     .D1T1   A9,*A6            ; |337| 
           LDW     .D2T1   *B4,A6            ; |343| 
           MVK     .S1     8,A4
           MV      .L1X    B5,A3             ; |336| 
           ADD     .L1X    B6,A4,A4
           LDW     .D1T1   *A3,A3            ; |337| 

           STW     .D1T1   A6,*A4            ; |343| 
||         MV      .L1X    B5,A7             ; |336| 

           STW     .D1T1   A9,*A7            ; |343| 
           LDW     .D2T1   *+B4(4),A6        ; |344| 
           ADD     .L1     4,A4,A7
           MV      .L1X    B5,A3             ; |336| 
           LDW     .D1T1   *A3,A3            ; |343| 
           MV      .L1X    B5,A8             ; |336| 
           STW     .D1T1   A6,*A7            ; |344| 
           STW     .D1T1   A9,*A8            ; |344| 
           LDW     .D2T2   *+B4(8),B7        ; |346| 
           MVK     .S2     8,B6
           MV      .L1X    B5,A3             ; |336| 
           ADD     .L2X    A5,B6,B6
           LDW     .D1T1   *A3,A3            ; |344| 

           STW     .D2T2   B7,*B6            ; |346| 
||         MV      .L1X    B5,A6             ; |336| 

           STW     .D1T1   A9,*A6            ; |346| 
           LDW     .D2T1   *+B4(12),A5       ; |347| 
           ADD     .L1X    4,B6,A6
           MV      .L1X    B5,A3             ; |336| 
           LDW     .D1T1   *A3,A3            ; |346| 
           MV      .L1X    B5,A7             ; |336| 
           STW     .D1T1   A5,*A6            ; |347| 
           STW     .D1T1   A9,*A7            ; |347| 
           LDW     .D2T1   *+B4(16),A5       ; |350| 
           MV      .L1X    B5,A3             ; |336| 
           ADD     .L1     8,A4,A6
           LDW     .D1T1   *A3,A3            ; |347| 
           ADD     .L1     12,A4,A4
           STW     .D1T1   A5,*A6            ; |350| 
           STW     .D1T1   A9,*A7            ; |350| 
           LDW     .D2T1   *+B4(20),A5       ; |351| 
           MV      .L1X    B5,A3             ; |336| 
           LDW     .D1T1   *A3,A3            ; |350| 
           MV      .L1X    B5,A6             ; |336| 
           NOP             1
           STW     .D1T1   A5,*A4            ; |351| 
           STW     .D1T1   A9,*A6            ; |351| 
           LDW     .D2T1   *+B4(24),A5       ; |352| 
           MV      .L1X    B5,A3             ; |336| 
           ADD     .L1     4,A4,A6
           LDW     .D1T1   *A3,A3            ; |351| 
           NOP             1
           STW     .D1T1   A5,*A6            ; |352| 
           STW     .D1T1   A9,*A7            ; |352| 
           LDW     .D2T1   *+B4(28),A5       ; |353| 
           MV      .L1X    B5,A3             ; |336| 
           LDW     .D1T2   *A3,B7            ; |352| 
           ADD     .L1     8,A4,A3
           MV      .L1X    B5,A6             ; |336| 
           STW     .D1T1   A5,*A3            ; |353| 
           STW     .D1T1   A9,*A6            ; |353| 
           LDW     .D2T1   *+B4(32),A4       ; |355| 
           MV      .L1X    B5,A3             ; |336| 
           ADD     .L2     8,B6,B7
           MV      .L1X    B5,A5             ; |336| 
           NOP             1

           STW     .D2T1   A4,*B7            ; |355| 
||         LDW     .D1T2   *A3,B7            ; |353| 

           STW     .D1T1   A9,*A5            ; |355| 
           LDW     .D2T2   *+B4(36),B8       ; |356| 
           MV      .L1X    B5,A4             ; |336| 
           NOP             2

           ADD     .L2     12,B6,B7
||         LDW     .D1T2   *A3,B6            ; |355| 

           STW     .D2T2   B8,*B7            ; |356| 
           STW     .D1T1   A9,*A4            ; |356| 
           LDW     .D2T1   *+B4(40),A4       ; |357| 
           NOP             3
           ADD     .L2     4,B7,B6

           STW     .D2T1   A4,*B6            ; |357| 
||         LDW     .D1T2   *A3,B6            ; |356| 

           STW     .D1T1   A9,*A5            ; |357| 
           LDW     .D2T2   *+B4(44),B4       ; |358| 
           MV      .L1X    B5,A4             ; |336| 
           ADD     .L2     8,B7,B5
           LDW     .D1T2   *A3,B6            ; |357| 
           NOP             1
           STW     .D2T2   B4,*B5            ; |358| 

           STW     .D1T1   A9,*A5            ; |358| 
||         RET     .S2     B3                ; |388| 

           LDW     .D1T2   *A4,B4            ; |358| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |388| 
	.sect	".text"
	.clink
	.global	_Stim_CheckSequence

;******************************************************************************
;* FUNCTION NAME: Stim_CheckSequence                                          *
;*                                                                            *
;*   Regs Modified     : A0,A1,A3,A4,A5,A6,A7,A8,A9,B0,B3,B4,B5,B6,B7,B8,B9,  *
;*                           A16,B16,B17,B18                                  *
;*   Regs Used         : A0,A1,A3,A4,A5,A6,A7,A8,A9,B0,B3,B4,B5,B6,B7,B8,B9,  *
;*                           DP,SP,A16,B16,B17,B18                            *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_Stim_CheckSequence:
;** --------------------------------------------------------------------------*
           LDW     .D2T2   *+DP(_StimSequence_Enabled),B4 ; |443| 
           MV      .L1X    B3,A1             ; |440| 
           MV      .L1     A4,A16            ; |440| 
           MVKL    .S2     _u_Stim_SequenceList+8,B17
           MVKH    .S2     _u_Stim_SequenceList+8,B17
           CMPEQ   .L2     B4,1,B0           ; |443| 

   [!B0]   BNOP    .S1     $C$L45,4          ; |443| 
|| [ B0]   LDW     .D2T2   *B17,B4           ; |444| 

           CMPLTU  .L1X    A16,B4,A0         ; |444| 
           ; BRANCHCC OCCURS {$C$L45}        ; |443| 
;** --------------------------------------------------------------------------*

           SUBAW   .D2     B17,2,B16
|| [ A0]   B       .S1     $C$L45            ; |444| 

   [!A0]   LDW     .D2T1   *B16,A5           ; |450| 
           ZERO    .L1     A7
           MVK     .S1     24,A6
           SET     .S1     A7,0x0,0xf,A7
           ADD     .L1X    B16,A6,A6
           ; BRANCHCC OCCURS {$C$L45}        ; |444| 
;** --------------------------------------------------------------------------*

           ADDAD   .D1     A6,A5,A3          ; |450| 
||         ZERO    .L1     A8
||         MVKL    .S2     _StimStatus,B18
||         ADD     .S1     -4,A6,A6

           LDW     .D1T1   *A3,A3            ; |450| 
||         SET     .S1     A8,0x10,0x17,A8
||         MVKH    .S2     _StimStatus,B18

           NOP             4

           SHRU    .S2X    A3,16,B4          ; |450| 
||         SHRU    .S1     A3,8,A4           ; |451| 

           CMPEQ   .L2X    B4,A7,B0          ; |450| 
||         AND     .L1     A8,A4,A8          ; |451| 
||         EXTU    .S1     A3,24,24,A4       ; |452| 

   [ B0]   BNOP    .S2     $C$L43,1          ; |450| 
||         OR      .L1     A8,A5,A3          ; |451| 
||         EXTU    .S1     A3,8,24,A5        ; |452| 

           MV      .L2X    A5,B4             ; |452| 
           NOP             3
           ; BRANCHCC OCCURS {$C$L43}        ; |450| 
;** --------------------------------------------------------------------------*
           STW     .D2T1   A3,*B18           ; |451| 

           CALLP   .S2     _Stim_Trigger,B3
||         LDHU    .D1T1   *A6,A6            ; |452| 

$C$RL17:   ; CALL OCCURS {_Stim_Trigger} {0}  ; |452| 
;** --------------------------------------------------------------------------*
$C$L43:    
           ADD     .L2     -4,B17,B4
           LDW     .D2T2   *B4,B5            ; |454| 
           MV      .L2     B16,B7            ; |454| 
           MV      .L1X    B16,A4            ; |454| 
           MV      .L2     B16,B6            ; |454| 
           MV      .L1X    B17,A3
           SUB     .L2     B5,1,B0           ; |454| 

   [ B0]   B       .S1     $C$L44            ; |455| 
||         STW     .D2T2   B0,*+B7(4)        ; |454| 
|| [ B0]   LDW     .D1T1   *A4,A4            ; |456| 
||         ADD     .L2     4,B17,B7

   [!B0]   LDW     .D2T2   *B7,B8            ; |460| 
           MV      .L2     B17,B5
           NOP             2
   [ B0]   ADD     .L2X    1,A4,B7           ; |456| 
           ; BRANCHCC OCCURS {$C$L44}        ; |455| 
;** --------------------------------------------------------------------------*

           SUB     .L2     B8,1,B0           ; |460| 
||         ADD     .S2     4,B7,B8
||         ZERO    .D2     B9                ; |468| 
||         ADD     .L1X    4,B18,A3
||         MVK     .S1     3,A5              ; |467| 

   [!B0]   B       .S1     $C$L46            ; |468| 
|| [ B0]   LDW     .D1T1   *A4,A4            ; |462| 
|| [ B0]   LDW     .D2T2   *B8,B9            ; |462| 
||         MV      .L1X    B5,A6
||         MV      .L2     B6,B5

   [!B0]   RETNOP  .S2X    A1,2              ; |486| 
|| [!B0]   STW     .D1T1   A5,*A3            ; |467| 
|| [!B0]   STW     .D2T2   B9,*+DP(_StimSequence_Enabled) ; |468| 

           STW     .D2T2   B0,*+B16(12)      ; |460| 
           SUB     .L2X    A4,B9,B9          ; |462| 
           ; BRANCHCC OCCURS {$C$L46}        ; |468| 
;** --------------------------------------------------------------------------*
           STW     .D2T2   B9,*B5            ; |462| 
           LDW     .D2T2   *B6,B6            ; |464| 
           LDW     .D2T2   *B7,B7            ; |465| 
           LDW     .D2T2   *B8,B5            ; |463| 
           NOP             2
           ADDAD   .D2     B16,B6,B6         ; |464| 

           LDW     .D2T2   *+B6(28),B6       ; |464| 
||         SHL     .S2     B7,16,B7          ; |465| 

           RETNOP  .S2X    A1,1              ; |486| 
||         ADD     .L2     2,B7,B7           ; |465| 
||         ADD     .D2     1,B5,B5           ; |463| 

           STW     .D1T2   B7,*A3            ; |465| 
           STW     .D2T2   B5,*B4            ; |463| 
           ADD     .L1X    A16,B6,A3         ; |464| 
           STW     .D1T1   A3,*A6            ; |464| 
           ; BRANCH OCCURS {A1}              ; |486| 
;** --------------------------------------------------------------------------*
$C$L44:    

           ADDAD   .D2     B16,B7,B4         ; |457| 
||         LDW     .D1T1   *A3,A3            ; |457| 

           LDW     .D2T2   *+B4(28),B4       ; |457| 
           STW     .D2T2   B7,*B6            ; |456| 
           NOP             3
           ADD     .L2X    B4,A3,B4          ; |457| 
           STW     .D2T2   B4,*B5            ; |457| 
;** --------------------------------------------------------------------------*
$C$L45:    
           RETNOP  .S2X    A1,4              ; |486| 
;** --------------------------------------------------------------------------*
$C$L46:    
           NOP             1
           ; BRANCH OCCURS {A1}              ; |486| 
	.sect	".text"
	.clink
	.global	_Stim_BlankElectrodes

;******************************************************************************
;* FUNCTION NAME: Stim_BlankElectrodes                                        *
;*                                                                            *
;*   Regs Modified     :                                                      *
;*   Regs Used         : B3                                                   *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_Stim_BlankElectrodes:
;** --------------------------------------------------------------------------*
           RETNOP  .S2     B3,5              ; |503| 
           ; BRANCH OCCURS {B3}              ; |503| 
	.sect	".text"
	.clink
	.global	_ModifyRegister

;******************************************************************************
;* FUNCTION NAME: ModifyRegister                                              *
;*                                                                            *
;*   Regs Modified     : A3,A4,A5,B4,B5                                       *
;*   Regs Used         : A3,A4,A5,A6,B3,B4,B5                                 *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_ModifyRegister:
;** --------------------------------------------------------------------------*
           ZERO    .L1     A3
           SET     .S1     A3,0x1d,0x1e,A3
           SUB     .L1     A4,A3,A4          ; |172| 
           LDW     .D1T1   *A4,A3            ; |172| 
           AND     .L1X    B4,A6,A5          ; |173| 
           ZERO    .L2     B5
           SET     .S2     B5,0x1c,0x1e,B5
           NOP             1
           ANDN    .L1X    A3,B4,A3          ; |173| 

           OR      .L1     A3,A5,A3          ; |173| 
||         ZERO    .L2     B4                ; |175| 

           STW     .D1T1   A3,*A4            ; |175| 
||         STW     .D2T2   B4,*B5            ; |175| 
||         RET     .S2     B3                ; |176| 

           LDW     .D2T2   *B5,B4            ; |175| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |176| 
;*****************************************************************************
;* UNDEFINED EXTERNAL REFERENCES                                             *
;*****************************************************************************
	.global	_StimSequence_Enabled
	.global	_Stim_BlankingCounter
	.global	_StimStatus
	.global	_EnableAmpBlanking

;******************************************************************************
;* BUILD ATTRIBUTES                                                           *
;******************************************************************************
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_needed(0)
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_preserved(0)
	.battr "TI", Tag_File, 1, Tag_Tramps_Use_SOC(1)
