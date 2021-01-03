;******************************************************************************
;* TMS320C6x C/C++ Codegen                                          PC v7.4.2 *
;* Date/Time created: Sat May 31 10:49:59 2014                                *
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

	.global	_ThresholdMode
	.bss	_ThresholdMode,4,4
;	opt6x C:\\Users\\45c\\AppData\\Local\\Temp\\061642 C:\\Users\\45c\\AppData\\Local\\Temp\\061644 
	.sect	".text"
	.clink
	.global	_CopyDataToInternal

;******************************************************************************
;* FUNCTION NAME: CopyDataToInternal                                          *
;*                                                                            *
;*   Regs Modified     : A3,A4,A5,A6,A7,A8,A9,B0,B4,B5,B6,B7,B8,B9,A16,B16,   *
;*                           B17                                              *
;*   Regs Used         : A3,A4,A5,A6,A7,A8,A9,B0,B3,B4,B5,B6,B7,B8,B9,DP,A16, *
;*                           B16,B17                                          *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_CopyDataToInternal:
;** --------------------------------------------------------------------------*
           LDW     .D2T2   *+DP(_adc_intern_id),B4 ; |20| 
           MVK     .S2     95,B5             ; |20| 
           MVKL    .S1     _MeaData+8,A5
           MVKH    .S1     _MeaData+8,A5
           NOP             1
           ADD     .L2     1,B4,B4           ; |20| 

           CMPGTU  .L2     B4,B5,B0          ; |20| 
||         MVK     .S2     0x1e,B5           ; |35| 

   [!B0]   STW     .D2T2   B4,*+DP(_adc_intern_id)
||         SUB     .L2     B5,2,B4
||         ZERO    .S2     B5                ; |21| 

;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\FindThreshold.c
;*      Loop source line                 : 35
;*      Loop opening brace source line   : 36
;*      Loop closing brace source line   : 40
;*      Loop Unroll Multiple             : 2x
;*      Known Minimum Trip Count         : 30                    
;*      Known Maximum Trip Count         : 30                    
;*      Known Max Trip Count Factor      : 30
;*      Loop Carried Dependency Bound(^) : 2
;*      Unpartitioned Resource Bound     : 3
;*      Partitioned Resource Bound(*)    : 3
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     3*       1     
;*      .D units                     3*       3*    
;*      .M units                     0        0     
;*      .X cross paths               1        1     
;*      .T address paths             3*       3*    
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           1        1     (.L or .S unit)
;*      Addition ops (.LSD)          0        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             2        1     
;*      Bound(.L .S .D .LS .LSD)     3*       2     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 3  Schedule found with 4 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 0
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1 (after unrolling)
;*----------------------------------------------------------------------------*
$C$L1:    ; PIPED LOOP PROLOG

           SPLOOPD 3       ;12               ; (P) 
||         MVC     .S2     B4,ILC
||         MV      .L2X    A5,B9
|| [ B0]   STW     .D2T2   B5,*+DP(_adc_intern_id) ; |21| 

;** --------------------------------------------------------------------------*
$C$L2:    ; PIPED LOOP KERNEL

           SPMASK          L1
||         ADD     .L1     8,A5,A8
||         LDDW    .D2T2   *B9++(16),B7:B6   ; |38| (P) <0,0> 

           LDDW    .D1T1   *A8++(16),A7:A6   ; |38| (P) <0,1> 

           SPMASK          L1,S1
||         MV      .L1     A4,A3             ; |16| 
||         MVKL    .S1     _SendBuffer+16,A4

           SPMASK          S1
||         MVKH    .S1     _SendBuffer+16,A4

           SPMASK          S2
||         MVKL    .S2     _adc_intern_0,B16

           SPMASK          L1,L2,S2
||         MVKH    .S2     _adc_intern_0,B16
||         ADD     .L1     4,A4,A16
||         MV      .L2X    A4,B17
||         SHR     .S1X    B6,A3,A4          ; |38| (P) <0,5>  ^ 

           SPMASK          L2
||         MV      .L2X    A3,B4
||         SHR     .S1     A6,A3,A6          ; |38| (P) <0,6> 

           SPMASK          L1
||         ADD     .L1X    4,B16,A9
||         SHR     .S1     A7,A3,A7          ; |38| (P) <0,7> 
||         SHR     .S2     B7,B4,B5          ; |38| (P) <0,7> 

           PACK2   .L1     A7,A6,A5          ; |38| (P) <0,8> 
||         PACK2   .L2X    B5,A4,B8          ; |38| (P) <0,8>  ^ 

           STW     .D1T1   A5,*A9++(8)       ; |38| <0,9> 
           STW     .D2T2   B8,*B16++(8)      ; |38| <0,10> 

           SPKERNEL 1,0
||         STW     .D1T1   A5,*A16++(8)      ; |39| <0,11> 
||         STW     .D2T2   B8,*B17++(8)      ; |39| <0,11> 

;** --------------------------------------------------------------------------*
$C$L3:    ; PIPED LOOP EPILOG
           RETNOP  .S2     B3,5              ; |50| 
           ; BRANCH OCCURS {B3}              ; |50| 
;*****************************************************************************
;* UNDEFINED EXTERNAL REFERENCES                                             *
;*****************************************************************************
	.global	_adc_intern_0
	.global	_adc_intern_id
	.global	_MeaData
	.global	_SendBuffer

;******************************************************************************
;* BUILD ATTRIBUTES                                                           *
;******************************************************************************
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_needed(0)
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_preserved(0)
	.battr "TI", Tag_File, 1, Tag_Tramps_Use_SOC(1)
