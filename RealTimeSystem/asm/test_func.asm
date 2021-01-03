;******************************************************************************
;* TMS320C6x C/C++ Codegen                                          PC v7.4.2 *
;* Date/Time created: Thu Apr 11 15:00:14 2013                                *
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
;*   Speculate Loads   : Enabled with threshold = 0                           *
;*   Memory Aliases    : Presume are aliases (pessimistic)                    *
;*   Debug Info        : No Debug Info                                        *
;*                                                                            *
;******************************************************************************

	.asg	A15, FP
	.asg	B14, DP
	.asg	B15, SP
	.global	$bss

;	opt6x C:\\Users\\45c\\AppData\\Local\\Temp\\016683 C:\\Users\\45c\\AppData\\Local\\Temp\\016685 
	.sect	".text"
	.clink
	.global	_SpikeDetect_Slope_Chk

;******************************************************************************
;* FUNCTION NAME: SpikeDetect_Slope_Chk                                       *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B5,B6,B7,B8,  *
;*                           B9,A31,B16,B17,B18,B19,B20,B21                   *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,A31,B16,B17,B18,B19,B20,B21             *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_SpikeDetect_Slope_Chk:
;** --------------------------------------------------------------------------*

           MVK     .L1     0x4,A8
||         ZERO    .S1     A7
||         SUB     .L2     B5,4,B20
||         SUB     .S2X    B4,A6,B21         ; |32| 

           ZERO    .L2     B5
||         MVK     .L1     1,A6              ; |38| 
||         MVK     .S2     0x1,B8
||         MVK     .D1     3,A9              ; |38| 
||         MVK     .S1     120,A5            ; |35| 
||         SUB     .D2     B5,8,B17

;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\test_func.c
;*      Loop source line                 : 35
;*      Loop opening brace source line   : 35
;*      Loop closing brace source line   : 43
;*      Loop Unroll Multiple             : 2x
;*      Known Minimum Trip Count         : 60                    
;*      Known Maximum Trip Count         : 60                    
;*      Known Max Trip Count Factor      : 60
;*      Loop Carried Dependency Bound(^) : 44
;*      Unpartitioned Resource Bound     : 9
;*      Partitioned Resource Bound(*)    : 10
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     4        3     
;*      .S units                     0        1     
;*      .D units                     8        8     
;*      .M units                     0        0     
;*      .X cross paths               3        1     
;*      .T address paths             7        7     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)         17       12     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             2        2     
;*      Bound(.L .S .D .LS .LSD)    10*       8     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 44 Did not find schedule
;*         ii = 45 Did not find schedule
;*         ii = 46 Cannot allocate machine registers
;*                   Regs Live Always   : 10/8  (A/B-side)
;*                   Max Regs Live      : 17/15
;*                   Max Cond Regs Live :  4/4 
;*         ii = 46 Cannot allocate machine registers
;*                   Regs Live Always   : 10/8  (A/B-side)
;*                   Max Regs Live      : 17/15
;*                   Max Cond Regs Live :  4/4 
;*         ii = 46 Cannot allocate machine registers
;*                   Regs Live Always   : 10/8  (A/B-side)
;*                   Max Regs Live      : 19/17
;*                   Max Cond Regs Live :  4/3 
;*         ii = 46 Did not find schedule
;*         ii = 47 Cannot allocate machine registers
;*                   Regs Live Always   : 10/8  (A/B-side)
;*                   Max Regs Live      : 17/14
;*                   Max Cond Regs Live :  4/4 
;*         ii = 47 Cannot allocate machine registers
;*                   Regs Live Always   : 10/8  (A/B-side)
;*                   Max Regs Live      : 17/14
;*                   Max Cond Regs Live :  4/4 
;*         ii = 47 Cannot allocate machine registers
;*                   Regs Live Always   : 10/8  (A/B-side)
;*                   Max Regs Live      : 19/16
;*                   Max Cond Regs Live :  4/3 
;*         ii = 47 Did not find schedule
;*         ii = 48 Cannot allocate machine registers
;*                   Regs Live Always   : 10/8  (A/B-side)
;*                   Max Regs Live      : 17/14
;*                   Max Cond Regs Live :  4/4 
;*         ii = 48 Cannot allocate machine registers
;*                   Regs Live Always   : 10/8  (A/B-side)
;*                   Max Regs Live      : 17/14
;*                   Max Cond Regs Live :  4/4 
;*         ii = 48 Cannot allocate machine registers
;*                   Regs Live Always   : 10/8  (A/B-side)
;*                   Max Regs Live      : 19/16
;*                   Max Cond Regs Live :  4/3 
;*         ii = 48 Did not find schedule
;*      Disqualified loop: Did not find schedule
;*----------------------------------------------------------------------------*
$C$L1:    
           LDW     .D2T2   *++B17(8),B9      ; |37| 
           NOP             4
;** --------------------------------------------------------------------------*

           CMPLTU  .L2     B9,B21,B2         ; |37| 
||         ADD     .L1     A5,A7,A3          ; |38| 

   [ B2]   LDH     .D2T2   *+B4[B5],B9       ; |38| 
   [ B2]   LDH     .D2T2   *+B4[B5],B6       ; |38| 
   [ B2]   LDH     .D1T1   *A3,A3            ; |38| 
           MV      .L1X    B5,A4
   [!B2]   MVK     .L2     0x1,B0            ; |38| 
           ADD     .L1     8,A7,A7           ; |35| 
   [ B2]   SUB     .L2     B9,B6,B6          ; |38| 

   [ B2]   CMPLT   .L2X    B6,A3,B0          ; |38| 
||         ADDAH   .D1     A6,A4,A3          ; |38| 

   [!B0]   LDH     .D1T1   *+A5[A3],A3       ; |38| 
           ADD     .L1     2,A4,A31          ; |35| 
           CMPLTU  .L1     A31,A5,A2         ; |35| 
           NOP             2

   [!B0]   CMPLT   .L2X    B6,A3,B1          ; |38| 
|| [!B2]   ZERO    .S2     B0                ; |38| 

   [ B0]   ZERO    .L2     B1                ; |38| 
   [!B2]   ZERO    .L2     B1                ; |38| 
   [ B1]   STW     .D2T2   B4,*B17           ; |39| 
           LDW     .D2T2   *++B20(8),B9      ; |37| 
           ADD     .L1     A5,A8,A3          ; |38| 
           ADD     .L1     8,A8,A8           ; |35| 
   [ B1]   ZERO    .L2     B19               ; |40| 
   [ B1]   MV      .L2     B5,B18            ; |40| 
           CMPLTU  .L2     B9,B21,B0         ; |37| 
   [ B0]   LDH     .D2T2   *+B4[B8],B9       ; |38| 
   [ B0]   LDH     .D2T2   *+B4[B8],B7       ; |38| 
   [ B0]   LDH     .D1T1   *A3,A3            ; |38| 
   [!B0]   MVK     .L1     0x1,A0            ; |38| 
           ADD     .L2     2,B5,B5           ; |35| Define a twin register
   [ B1]   STDW    .D2T2   B19:B18,*B16++    ; |40| 
   [ B0]   SUB     .L2     B9,B7,B7          ; |38| 
           NOP             1

   [ B0]   CMPLT   .L1X    B7,A3,A0          ; |38| 
||         ADDAH   .D1     A9,A4,A3          ; |38| 

   [!A0]   LDH     .D1T1   *+A5[A3],A3       ; |38| 
           NOP             3
   [ A2]   B       .S1     $C$L1             ; |35| 

   [!A2]   RET     .S2     B3                ; |47| 
|| [!A0]   CMPLT   .L1X    B7,A3,A1          ; |38| 
|| [!B0]   ZERO    .S1     A0                ; |38| 

   [ A0]   ZERO    .L1     A1                ; |38| 
   [!B0]   ZERO    .L1     A1                ; |38| 

   [ A1]   ZERO    .L2     B9                ; |40| 
|| [ A1]   STW     .D2T2   B4,*B20           ; |39| 

   [ A1]   STDW    .D2T2   B9:B8,*B16++      ; |40| 
||         ADD     .L2     2,B8,B8           ; |35| 

           ; BRANCHCC OCCURS {$C$L1}         ; |35| 
;** --------------------------------------------------------------------------*
           NOP             1
           ; BRANCH OCCURS {B3}              ; |47| 

;******************************************************************************
;* BUILD ATTRIBUTES                                                           *
;******************************************************************************
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_needed(0)
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_preserved(0)
	.battr "TI", Tag_File, 1, Tag_Tramps_Use_SOC(1)
