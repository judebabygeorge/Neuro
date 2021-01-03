;******************************************************************************
;* TMS320C6x C/C++ Codegen                                          PC v7.4.2 *
;* Date/Time created: Thu Apr 11 14:59:33 2013                                *
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

;	opt6x C:\\Users\\45c\\AppData\\Local\\Temp\\045762 C:\\Users\\45c\\AppData\\Local\\Temp\\045764 
	.sect	".text"
	.clink
	.global	_NEO

;******************************************************************************
;* FUNCTION NAME: NEO                                                         *
;*                                                                            *
;*   Regs Modified     : A0,A2,A3,A5,A6,A7,A8,A9,B0,B4,B5,B6,B7,B8,B9,B16,B17 *
;*   Regs Used         : A0,A2,A3,A4,A5,A6,A7,A8,A9,B0,B3,B4,B5,B6,B7,B8,B9,  *
;*                           B16,B17                                          *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_NEO:
;** --------------------------------------------------------------------------*

           MVK     .L1     0x1,A8
||         LDW     .D1T2   *+A6(40),B7       ; |25| 
||         SUB     .L2X    A6,4,B17
||         ZERO    .S2     B5                ; |30| 

           ZERO    .L1     A6                ; |30| 
||         MV      .L2     B5,B9             ; |30| 
||         MV      .D1X    B4,A7             ; |2| 
||         MVK     .S1     120,A9            ; |27| 
||         SUB     .S2X    A6,8,B16

;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\neo.c
;*      Loop source line                 : 27
;*      Loop opening brace source line   : 27
;*      Loop closing brace source line   : 35
;*      Loop Unroll Multiple             : 2x
;*      Known Minimum Trip Count         : 60                    
;*      Known Maximum Trip Count         : 60                    
;*      Known Max Trip Count Factor      : 60
;*      Loop Carried Dependency Bound(^) : 28
;*      Unpartitioned Resource Bound     : 5
;*      Partitioned Resource Bound(*)    : 6
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     3        2     
;*      .S units                     0        1     
;*      .D units                     5        5     
;*      .M units                     0        0     
;*      .X cross paths               1        2     
;*      .T address paths             5        5     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          5        8     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             2        2     
;*      Bound(.L .S .D .LS .LSD)     5        6*    
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 28 Did not find schedule
;*         ii = 29 Did not find schedule
;*      Disqualified loop: Did not find schedule
;*----------------------------------------------------------------------------*
$C$L1:    
           LDW     .D2T2   *++B16(8),B4      ; |28| 
           NOP             4
;** --------------------------------------------------------------------------*
           CMPGTU  .L2     B4,10,B0          ; |28| 
   [ B0]   LDH     .D1T1   *+A4[A6],A5       ; |28| 
   [ B0]   LDH     .D1T1   *+A7[A6],A3       ; |28| 
   [!B0]   MV      .L1X    B5,A0             ; |28| 
           MV      .L2X    A6,B8             ; |30| 
           ADD     .L1     2,A6,A6           ; |27| 
           CMPLTU  .L1     A6,A9,A2          ; |27| 
   [ B0]   CMPGT   .L1     A5,A3,A0          ; |28| 
   [ A0]   STW     .D2T2   B7,*B16           ; |29| 
           LDW     .D2T2   *++B17(8),B4      ; |28| 
   [ A0]   STDW    .D2T2   B9:B8,*B6++       ; |30| 
           NOP             3

           CMPGTU  .L2     B4,10,B0          ; |28| 
||         MV      .S2X    A8,B4             ; |30| 

   [ B0]   LDH     .D1T1   *+A4[A8],A5       ; |28| 
|| [!B0]   MV      .L1X    B5,A0             ; |28| 

   [ B0]   LDH     .D1T1   *+A7[A8],A3       ; |28| 
           ADD     .L1     2,A8,A8           ; |27| 
   [ A2]   B       .S1     $C$L1             ; |27| 
   [!A2]   RETNOP  .S2     B3,1              ; |36| 
   [ B0]   CMPGT   .L1     A5,A3,A0          ; |28| 
   [ A0]   STDW    .D2T2   B5:B4,*B6++       ; |30| 
   [ A0]   STW     .D2T2   B7,*B17           ; |29| 
           ; BRANCHCC OCCURS {$C$L1}         ; |27| 
;** --------------------------------------------------------------------------*
           NOP             1
           ; BRANCH OCCURS {B3}              ; |36| 

;******************************************************************************
;* BUILD ATTRIBUTES                                                           *
;******************************************************************************
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_needed(0)
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_preserved(0)
	.battr "TI", Tag_File, 1, Tag_Tramps_Use_SOC(1)
