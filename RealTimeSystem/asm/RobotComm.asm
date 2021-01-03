;******************************************************************************
;* TMS320C6x C/C++ Codegen                                          PC v7.4.2 *
;* Date/Time created: Sat May 31 10:51:06 2014                                *
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

;*****************************************************************************
;* CINIT RECORDS                                                             *
;*****************************************************************************
	.sect	".cinit"
	.align	8
	.field  	4,32
	.field  	_val$1+0,32
	.field	0,32			; _val$1 @ 0

	.bss	_val$1,4,4
;	opt6x C:\\Users\\45c\\AppData\\Local\\Temp\\085642 C:\\Users\\45c\\AppData\\Local\\Temp\\085644 
	.sect	".text"
	.clink
	.global	_RobotComm_Trigger

;******************************************************************************
;* FUNCTION NAME: RobotComm_Trigger                                           *
;*                                                                            *
;*   Regs Modified     : A0,A3,A4,A5,A6,A7,A8,A9,B0,B1,B4,B5,B6,A16,A17       *
;*   Regs Used         : A0,A3,A4,A5,A6,A7,A8,A9,B0,B1,B3,B4,B5,B6,A16,A17    *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_RobotComm_Trigger:
;** --------------------------------------------------------------------------*

           ZERO    .L1     A3
||         MVKL    .S1     0xa0000708,A5

           SET     .S1     A3,0x1c,0x1e,A3

           MVKH    .S1     0xa0000708,A5
||         MVK     .S2     1000,B5           ; |33| 
||         CMPEQ   .L1     A4,2,A0           ; |32| 

           MV      .L1     A3,A7             ; |35| 
|| [ A0]   STW     .D1T2   B5,*A5            ; |33| 
||         ZERO    .S1     A6                ; |35| 

           MV      .L2X    A3,B6             ; |35| 
|| [ A0]   STW     .D1T1   A6,*A7            ; |33| 

           MVK     .S2     500,B5            ; |35| 
|| [ A0]   LDW     .D2T2   *B6,B5            ; |33| 

   [!A0]   STW     .D1T2   B5,*A5            ; |35| 
   [!A0]   STW     .D1T1   A6,*A3            ; |35| 
   [!A0]   LDW     .D1T1   *A3,A7            ; |35| 
           ADD     .L1     4,A5,A5

           CMPEQ   .L2     B4,2,B0           ; |37| 
||         MVK     .S2     500,B5            ; |40| 

   [!B0]   STW     .D1T2   B5,*A5            ; |40| 
||         MVK     .S1     1000,A16          ; |38| 

           MVK     .S2     0x101,B5          ; |43| 
||         CMPGT   .L2X    A4,0,B1           ; |43| 
|| [ B0]   STW     .D1T1   A16,*A5           ; |38| 
||         MV      .L1     A3,A8             ; |35| 

   [!B1]   MVK     .D2     0x1,B5            ; |43| 
||         CMPGT   .L2     B4,0,B1           ; |45| 
||         MVK     .S2     12,B4
|| [!B0]   STW     .D1T1   A6,*A8            ; |40| 
||         MV      .L1     A3,A9             ; |35| 

           SUB     .L2X    A5,B4,B4
|| [ B1]   SET     .S2     B5,16,16,B5       ; |46| 
|| [ B0]   STW     .D2T1   A6,*B6            ; |38| 
||         MV      .L1     A3,A17            ; |35| 
|| [!B0]   LDW     .D1T2   *A9,B6            ; |40| 

   [ B0]   LDW     .D1T1   *A17,A4           ; |38| 
||         STW     .D2T2   B5,*B4            ; |48| 

           STW     .D1T1   A6,*A3            ; |48| 
||         MV      .L1     A3,A7             ; |35| 
||         RET     .S2     B3                ; |49| 

           LDW     .D1T1   *A7,A3            ; |48| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |49| 
	.sect	".text"
	.clink
	.global	_RobotComm_Setup

;******************************************************************************
;* FUNCTION NAME: RobotComm_Setup                                             *
;*                                                                            *
;*   Regs Modified     : A3,A4,A5,A6,A7,A8,A9,B4,B5,B6,B7,B8                  *
;*   Regs Used         : A3,A4,A5,A6,A7,A8,A9,B3,B4,B5,B6,B7,B8               *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_RobotComm_Setup:
;** --------------------------------------------------------------------------*
           MVKL    .S1     0xa0000308,A3

           ZERO    .L1     A5
||         MVKH    .S1     0xa0000308,A3

           SET     .S1     A5,0x1c,0x1e,A5
||         MVK     .L2     -8,B4             ; |13| 

           STW     .D1T2   B4,*A3            ; |13| 
||         ZERO    .L2     B4                ; |13| 

           MVKL    .S2     0xa0000704,B6
||         MV      .L2X    A5,B5             ; |13| 
||         STW     .D1T2   B4,*A5            ; |13| 

           MVKH    .S2     0xa0000704,B6
||         MVK     .S1     0x1f4,A4          ; |17| 
||         LDW     .D2T1   *B5,A3            ; |13| 

           STW     .D2T1   A4,*B6            ; |17| 
||         STW     .D1T2   B4,*A5            ; |17| 
||         ADD     .L2     4,B6,B5
||         MV      .L1     A5,A6             ; |13| 

           STW     .D2T1   A4,*B5            ; |18| 
||         LDW     .D1T2   *A6,B5            ; |17| 
||         MV      .L2X    A5,B7             ; |13| 

           STW     .D2T2   B4,*B7            ; |18| 

           ADD     .L2     8,B6,B6
||         MV      .L1     A5,A7             ; |13| 
||         LDW     .D1T1   *A6,A6            ; |18| 

           MVKL    .S2     0xa0000840,B8
||         MVKL    .S1     0x280020,A8
||         STW     .D2T1   A4,*B6            ; |19| 
||         STW     .D1T2   B4,*A7            ; |19| 

           MVKH    .S2     0xa0000840,B8
||         MVKH    .S1     0x280020,A8
||         LDW     .D2T1   *B7,A4            ; |19| 

           STW     .D2T1   A8,*B8            ; |21| 
||         STW     .D1T2   B4,*A5            ; |21| 
||         MVK     .S2     48,B7             ; |22| 
||         ADD     .L2     4,B8,B6
||         MV      .L1     A5,A9             ; |13| 

           MV      .L2X    A5,B5             ; |13| 
||         LDW     .D1T1   *A9,A4            ; |21| 
||         STW     .D2T2   B7,*B6            ; |22| 

           STW     .D2T2   B4,*B5            ; |22| 
||         MV      .L1     A5,A3             ; |13| 
||         RET     .S2     B3                ; |25| 

           LDW     .D1T1   *A3,A3            ; |22| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |25| 
	.sect	".text"
	.clink
	.global	_RobotComm_Sensor

;******************************************************************************
;* FUNCTION NAME: RobotComm_Sensor                                            *
;*                                                                            *
;*   Regs Modified     : A3,A4                                                *
;*   Regs Used         : A3,A4,B3,DP                                          *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_RobotComm_Sensor:
;** --------------------------------------------------------------------------*
           MVKL    .S1     0xa0000314,A3
           MVKH    .S1     0xa0000314,A3
           LDW     .D1T1   *A3,A3            ; |55| 
           NOP             1
           RETNOP  .S2     B3,2              ; |58| 
           AND     .L1     1,A3,A3           ; |55| 
           XOR     .L1     1,A3,A4           ; |56| 
           STW     .D2T1   A4,*+DP(_val$1)   ; |56| 
           ; BRANCH OCCURS {B3}              ; |58| 

;******************************************************************************
;* BUILD ATTRIBUTES                                                           *
;******************************************************************************
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_needed(0)
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_preserved(0)
	.battr "TI", Tag_File, 1, Tag_Tramps_Use_SOC(1)
