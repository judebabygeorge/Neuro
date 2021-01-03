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

	.global	_spd_LastCross
_spd_LastCross:	.usect	".far",480,8
	.global	_spd_ThresholdData
_spd_ThresholdData:	.usect	".far",480,8
	.global	_SpikeData
_SpikeData:	.usect	".far",960,8
	.global	_nSpikes
	.bss	_nSpikes,4,4
	.global	_SpikeData_Compressed
_SpikeData_Compressed:	.usect	".far",120,8
	.global	_uSpikeList
_uSpikeList:	.usect	".far",792,8
	.global	_spike_segment
_spike_segment:	.usect	".far",200,8
	.global	_dummy_segment
_dummy_segment:	.usect	".far",200,8
;	opt6x C:\\Users\\45c\\AppData\\Local\\Temp\\069682 C:\\Users\\45c\\AppData\\Local\\Temp\\069684 
	.sect	".text"
	.clink
	.global	_setThresholdParams

;******************************************************************************
;* FUNCTION NAME: setThresholdParams                                          *
;*                                                                            *
;*   Regs Modified     : A3,A4,A5,A6,B0,B4,B5,B6,B7                           *
;*   Regs Used         : A3,A4,A5,A6,B0,B3,B4,B5,B6,B7                        *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_setThresholdParams:
;** --------------------------------------------------------------------------*
           MV      .L2     B4,B0             ; |98| 

   [!B0]   BNOP    .S1     $C$L4,1           ; |105| 
||         SHRU    .S2     B0,2,B4           ; |106| 

   [ B0]   MVC     .S2     B4,ILC
           ADD     .L1     8,A4,A6
           MVKL    .S1     _spd_ThresholdData,A3
           MVKH    .S1     _spd_ThresholdData,A3
           ; BRANCHCC OCCURS {$C$L4}         ; |105| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\SpikeDetect.c
;*      Loop source line                 : 105
;*      Loop opening brace source line   : 105
;*      Loop closing brace source line   : 107
;*      Loop Unroll Multiple             : 4x
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 0
;*      Unpartitioned Resource Bound     : 2
;*      Partitioned Resource Bound(*)    : 3
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     0        0     
;*      .D units                     2        2     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             3*       3*    
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          0        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        0     
;*      Bound(.L .S .D .LS .LSD)     1        1     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 3  Schedule found with 3 iterations in parallel
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
           SPLOOP  3       ;9                ; (P) 
;** --------------------------------------------------------------------------*
$C$L2:    ; PIPED LOOP KERNEL

           SPMASK          L2
||         MV      .L2X    A4,B5
||         LDNDW   .D1T1   *A6++(16),A5:A4   ; |106| (P) <0,0> 

           NOP             1
           LDNDW   .D2T2   *B5++(16),B7:B6   ; |106| (P) <0,2> 
           NOP             2

           SPMASK          L1,L2
||         MV      .L2X    A3,B4
||         ADD     .L1     8,A3,A3

           NOP             1

           SPKERNEL 1,0
||         STDW    .D2T2   B7:B6,*B4++(16)   ; |106| <0,7> 
||         STDW    .D1T1   A5:A4,*A3++(16)   ; |106| <0,7> 

;** --------------------------------------------------------------------------*
$C$L3:    ; PIPED LOOP EPILOG
           NOP             2
;** --------------------------------------------------------------------------*
$C$L4:    
           RETNOP  .S2     B3,5              ; |108| 
           ; BRANCH OCCURS {B3}              ; |108| 
	.sect	".text"
	.clink
	.global	_setCommonThresholdParams

;******************************************************************************
;* FUNCTION NAME: setCommonThresholdParams                                    *
;*                                                                            *
;*   Regs Modified     : A3,A4,A5,A7,B4,B5,B6                                 *
;*   Regs Used         : A3,A4,A5,A7,B3,B4,B5,B6                              *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_setCommonThresholdParams:
;** --------------------------------------------------------------------------*
           MVK     .S2     0x3c,B5           ; |91| 

           SUB     .L2     B5,2,B5
||         MVKL    .S1     _spd_ThresholdData,A7

           MV      .L2X    A4,B5
||         MVC     .S2     B5,ILC
||         MVKH    .S1     _spd_ThresholdData,A7

;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\SpikeDetect.c
;*      Loop source line                 : 91
;*      Loop opening brace source line   : 91
;*      Loop closing brace source line   : 94
;*      Loop Unroll Multiple             : 2x
;*      Known Minimum Trip Count         : 60                    
;*      Known Maximum Trip Count         : 60                    
;*      Known Max Trip Count Factor      : 60
;*      Loop Carried Dependency Bound(^) : 0
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
;*         ii = 2  Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 0
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1 (after unrolling)
;*----------------------------------------------------------------------------*
$C$L5:    ; PIPED LOOP PROLOG

           SPLOOPD 2       ;4                ; (P) 
||         MV      .L1X    B4,A5             ; |88| 
||         ADD     .S1     2,A7,A3
||         MV      .L2X    A7,B4

;** --------------------------------------------------------------------------*
$C$L6:    ; PIPED LOOP KERNEL

           SPMASK          L1,L2
||         ADD     .L1     6,A7,A4
||         ADD     .L2X    4,A7,B6
||         STH     .D2T2   B5,*B4++(8)       ; |92| (P) <0,0> 
||         STH     .D1T1   A5,*A3++(8)       ; |93| (P) <0,0> 

           STH     .D2T2   B5,*B6++(8)       ; |92| (P) <0,1> 
||         STH     .D1T1   A5,*A4++(8)       ; |93| (P) <0,1> 

           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L7:    ; PIPED LOOP EPILOG
           RETNOP  .S2     B3,5              ; |95| 
           ; BRANCH OCCURS {B3}              ; |95| 
	.sect	".text"
	.clink
	.global	_SpikeDetect_Setup

;******************************************************************************
;* FUNCTION NAME: SpikeDetect_Setup                                           *
;*                                                                            *
;*   Regs Modified     : A3,A4,A5,A6,A7,A8,A9,B4,B5,B6,B7,B8,B9,A16,A17,A31,  *
;*                           B30,B31                                          *
;*   Regs Used         : A3,A4,A5,A6,A7,A8,A9,B3,B4,B5,B6,B7,B8,B9,DP,A16,A17,*
;*                           A31,B30,B31                                      *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_SpikeDetect_Setup:
;** --------------------------------------------------------------------------*
           MVKL    .S1     _spd_LastCross,A7

           MVKH    .S1     _spd_LastCross,A7
||         ZERO    .L1     A4
||         MVK     .L2     14,B5             ; |43| 
||         MVK     .S2     2,B4              ; |41| 

;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\SpikeDetect.c
;*      Loop source line                 : 43
;*      Loop opening brace source line   : 44
;*      Loop closing brace source line   : 44
;*      Loop Unroll Multiple             : 8x
;*      Known Minimum Trip Count         : 15                    
;*      Known Maximum Trip Count         : 15                    
;*      Known Max Trip Count Factor      : 15
;*      Loop Carried Dependency Bound(^) : 0
;*      Unpartitioned Resource Bound     : 2
;*      Partitioned Resource Bound(*)    : 4
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     0        0     
;*      .D units                     2        2     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             4*       4*    
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          0        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        0     
;*      Bound(.L .S .D .LS .LSD)     1        1     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 4  Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 0
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1 (after unrolling)
;*----------------------------------------------------------------------------*
$C$L8:    ; PIPED LOOP PROLOG

           SPLOOPD 4       ;8                ; (P) 
||         ZERO    .L1     A5
||         MVC     .S2     B5,ILC
||         STW     .D2T2   B4,*+DP(_ThresholdMode) ; |41| 
||         MV      .S1     A7,A6
||         MV      .D1     A7,A8

;** --------------------------------------------------------------------------*
$C$L9:    ; PIPED LOOP KERNEL

           SPMASK          L1,S1
||         MV      .L1     A7,A3
||         ADD     .S1     8,A7,A7
||         STNDW   .D1T1   A5:A4,*A8++(32)   ; |44| (P) <0,0> 

           SPMASK          S1
||         ADDK    .S1     16,A6
||         STNDW   .D1T1   A5:A4,*A7++(32)   ; |44| (P) <0,1> 

           SPMASK          S1
||         ADDK    .S1     24,A3
||         STNDW   .D1T1   A5:A4,*A6++(32)   ; |44| (P) <0,2> 

           STNDW   .D1T1   A5:A4,*A3++(32)   ; |44| (P) <0,3> 
           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L10:    ; PIPED LOOP EPILOG

           MV      .L1     A5,A7
||         MVKL    .S1     _SpikeData,A8
||         MV      .D1     A4,A6
||         MVKL    .S2     _spd_ThresholdData-8,B4

;** --------------------------------------------------------------------------*
           MVKH    .S2     _spd_ThresholdData-8,B4
           MVK     .S2     58,B31            ; |46| 
           MV      .L1X    B4,A9
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\SpikeDetect.c
;*      Loop source line                 : 46
;*      Loop opening brace source line   : 46
;*      Loop closing brace source line   : 50
;*      Loop Unroll Multiple             : 2x
;*      Known Minimum Trip Count         : 60                    
;*      Known Maximum Trip Count         : 60                    
;*      Known Max Trip Count Factor      : 60
;*      Loop Carried Dependency Bound(^) : 0
;*      Unpartitioned Resource Bound     : 3
;*      Partitioned Resource Bound(*)    : 3
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     0        0     
;*      .D units                     3*       2     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             3*       2     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          0        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        0     
;*      Bound(.L .S .D .LS .LSD)     1        1     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 3  Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 0
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1 (after unrolling)
;*----------------------------------------------------------------------------*
$C$L11:    ; PIPED LOOP PROLOG

           SPLOOPD 3       ;6                ; (P) 
||         ZERO    .L1     A5
||         MVKH    .S1     _SpikeData,A8
||         MVC     .S2     B31,ILC

;** --------------------------------------------------------------------------*
$C$L12:    ; PIPED LOOP KERNEL

           SPMASK          L1,S1,L2,S2,D2
||         MVK     .S2     0x3e80,B6
||         ADD     .L2     12,B4,B5
||         ADD     .L1X    14,B4,A4
||         ADD     .S1     10,A9,A3
||         ADD     .D2X    8,A9,B4
||         STDW    .D1T1   A7:A6,*A8++       ; |47| (P) <0,0> 

           STH     .D2T2   B6,*B4++(8)       ; |48| (P) <0,1> 
||         STH     .D1T1   A5,*A3++(8)       ; |49| (P) <0,1> 

           STH     .D2T2   B6,*B5++(8)       ; |48| (P) <0,2> 
||         STH     .D1T1   A5,*A4++(8)       ; |49| (P) <0,2> 

           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L13:    ; PIPED LOOP EPILOG

           ZERO    .L2     B5                ; |52| 
||         ZERO    .D2     B4                ; |52| 
||         MV      .L1     A6,A16
||         MV      .D1     A7,A17
||         MVKL    .S1     _uSpikeList,A5
||         MVKL    .S2     _spike_segment-4,B6

;** --------------------------------------------------------------------------*

           MVKH    .S2     _spike_segment-4,B6
||         STW     .D2T2   B5,*+DP(_adc_intern_id) ; |52| 
||         MVKH    .S1     _uSpikeList,A5

           STW     .D1T2   B4,*A5            ; |53| 
||         ADD     .L1     8,A5,A4
||         MVK     .S2     0x10,B30          ; |61| 

           MV      .L1X    B6,A4             ; |59| 
||         STW     .D1T2   B4,*A4            ; |57| 
||         SUB     .L2     B30,2,B5
||         ADD     .S1     4,A5,A31
||         MVK     .S2     12,B31

           ADD     .L2X    A5,B31,B5
||         MVC     .S2     B5,ILC
||         STW     .D1T2   B4,*A31           ; |56| 
||         MVK     .D2     0x1,B8

           MV      .L2X    A4,B5
||         STW     .D2T2   B4,*B5            ; |54| 
||         ADD     .S2     4,B5,B9
||         MV      .L1X    B6,A7             ; |59| 
||         ZERO    .S1     A8                ; |52| 

;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\SpikeDetect.c
;*      Loop source line                 : 61
;*      Loop opening brace source line   : 61
;*      Loop closing brace source line   : 63
;*      Loop Unroll Multiple             : 6x
;*      Known Minimum Trip Count         : 16                    
;*      Known Maximum Trip Count         : 16                    
;*      Known Max Trip Count Factor      : 16
;*      Loop Carried Dependency Bound(^) : 2
;*      Unpartitioned Resource Bound     : 3
;*      Partitioned Resource Bound(*)    : 3
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     0        0     
;*      .D units                     3*       3*    
;*      .M units                     0        0     
;*      .X cross paths               0        2     
;*      .T address paths             3*       3*    
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          3        3     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        0     
;*      Bound(.L .S .D .LS .LSD)     2        2     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 3  Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 0
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1 (after unrolling)
;*----------------------------------------------------------------------------*
$C$L14:    ; PIPED LOOP PROLOG

           SPLOOPD 3       ;6                ; (P) 
||         MV      .L1X    B6,A6             ; |59| 
||         ADD     .L2     14,B6,B6
||         ADDK    .S1     18,A7
||         ADD     .D1     12,A4,A4
||         STW     .D2T2   B4,*B9            ; |55| 
||         MV      .S2X    A4,B4

;** --------------------------------------------------------------------------*
$C$L15:    ; PIPED LOOP KERNEL

           SPMASK          S2
||         ADDK    .S2     20,B4
||         STH     .D2T2   B8,*B6++(12)      ; |62| (P) <0,0> 
||         STH     .D1T1   A8,*A4++(12)      ; |62| (P) <0,0> 
||         ADD     .L1     3,A8,A5           ; |62| (P) <0,0> 
||         ADD     .L2X    4,A8,B7           ; |62| (P) <0,0>  ^ 
||         ADD     .S1     5,A8,A3           ; |62| (P) <0,0> 

           SPMASK          S1,S2
||         ADDK    .S1     22,A6
||         ADDK    .S2     16,B5
||         ADD     .L2X    2,A8,B7           ; |62| (P) <0,1>  ^ 
||         ADD     .L1     6,A8,A8           ; |61| (P) <0,1>  ^ 
||         STH     .D1T1   A5,*A7++(12)      ; |62| (P) <0,1> 
||         STH     .D2T2   B7,*B4++(12)      ; |62| (P) <0,1> 

           ADD     .L2     6,B8,B8           ; |61| (P) <0,2> 
||         STH     .D2T2   B7,*B5++(12)      ; |62| (P) <0,2> 
||         STH     .D1T1   A3,*A6++(12)      ; |62| (P) <0,2> 

           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L16:    ; PIPED LOOP EPILOG

           MVKL    .S1     _SpikeChannel,A3
||         RET     .S2     B3                ; |68| 

           MVKH    .S1     _SpikeChannel,A3
           STDW    .D1T1   A17:A16,*A3       ; |65| 
           STDW    .D1T1   A17:A16,*+A3(8)   ; |67| 
           NOP             2
           ; BRANCH OCCURS {B3}              ; |68| 
	.sect	".text"
	.clink
	.global	_SpikeDetect

;******************************************************************************
;* FUNCTION NAME: SpikeDetect                                                 *
;*                                                                            *
;*   Regs Modified     : A0,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B4,B5,B6,B7,B8,B9,  *
;*                           A16,A17,A18,A19,B16,B31                          *
;*   Regs Used         : A0,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,B7,B8,  *
;*                           B9,DP,A16,A17,A18,A19,B16,B31                    *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_SpikeDetect:
;** --------------------------------------------------------------------------*

           LDW     .D2T2   *+DP(_ThresholdMode),B0 ; |135| 
||         MVKL    .S2     _spd_LastCross,B8
||         MVKL    .S1     _SpikeData,A4
||         ZERO    .L1     A8
||         ZERO    .D1     A6
||         ZERO    .L2     B6

           LDW     .D2T2   *+DP(_current_time),B4 ; |131| 
||         MVKH    .S2     _spd_LastCross,B8
||         MVKH    .S1     _SpikeData,A4
||         ZERO    .L1     A17

           MVKL    .S1     _spd_ThresholdData,A7
||         MVKL    .S2     _adc_intern_0,B5

           MVKH    .S1     _spd_ThresholdData,A7
||         MV      .L1X    B8,A9             ; |128| 
||         MV      .L2X    A4,B16            ; |124| 
||         MVKH    .S2     _adc_intern_0,B5

           MV      .L2X    A4,B8             ; |124| 
||         SUB     .L1     A7,8,A4
||         MVK     .S2     125,B7            ; |131| 
||         SUB     .D2     B5,4,B9
||         MVK     .S1     0x3c,A5           ; |136| 
||         SUB     .D1     A7,4,A7

   [ B0]   BNOP    .S2     $C$L20,2          ; |135| 
||         MVK     .S1     0x78,A3           ; |144| 
|| [!B0]   SUB     .L1     A5,2,A6

   [ B0]   SUB     .L1     A3,2,A8

           SUB     .L2     B4,B7,B5          ; |131| 
||         SUB     .S2     B5,2,B7

   [!B0]   MV      .L2X    A4,B7
           ; BRANCHCC OCCURS {$C$L20}        ; |135| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\SpikeDetect.c
;*      Loop source line                 : 136
;*      Loop opening brace source line   : 136
;*      Loop closing brace source line   : 141
;*      Known Minimum Trip Count         : 60                    
;*      Known Maximum Trip Count         : 60                    
;*      Known Max Trip Count Factor      : 60
;*      Loop Carried Dependency Bound(^) : 1
;*      Unpartitioned Resource Bound     : 3
;*      Partitioned Resource Bound(*)    : 3
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     1        1     
;*      .S units                     0        0     
;*      .D units                     3*       2     
;*      .M units                     0        0     
;*      .X cross paths               0        1     
;*      .T address paths             3*       2     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          3        3     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1        1     
;*      Bound(.L .S .D .LS .LSD)     3*       2     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 3  Schedule found with 5 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 0
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L17:    ; PIPED LOOP PROLOG

           SPLOOPD 3       ;15               ; (P) 
||         MV      .L1     A9,A17
||         MV      .S1X    B9,A9
||         MVC     .S2X    A6,ILC

;** --------------------------------------------------------------------------*
$C$L18:    ; PIPED LOOP KERNEL

           LDH     .D2T2   *++B7(8),B9       ; |137| (P) <0,0> 
||         LDH     .D1T1   *++A9(4),A4       ; |137| (P) <0,0> 

           NOP             4
           CMPLT   .L2X    A4,B9,B1          ; |137| (P) <0,5> 
   [ B1]   ADD     .L1     A8,A17,A7         ; |137| (P) <0,6>  ^ 

           MVD     .M2     B1,B0             ; |137| (P) <0,7> Split a long life
|| [ B1]   LDW     .D1T1   *A7,A5            ; |137| (P) <0,7> 

           MVD     .M1     A7,A3             ; |137| (P) <0,8> Split a long life
||         ADD     .L1     8,A8,A8           ; |136| (P) <0,8>  ^ 

           NOP             1

           SPMASK          L1
||         MV      .L1X    B4,A16

           SPMASK          S1
||         MV      .S1X    B5,A6

           NOP             1

           ZERO    .L2     B5                ; |139| <0,13> 
||         MV      .S2     B6,B4             ; |139| <0,13>  ^ 
|| [!B0]   ZERO    .S1     A0                ; |137| <0,13>  ^ 
|| [ B0]   CMPLTU  .L1     A5,A6,A0          ; |137| <0,13>  ^ 

           SPKERNEL 2,0
||         ADD     .S2     2,B6,B6           ; |136| <0,14>  ^ 
|| [ A0]   STW     .D1T1   A16,*A3           ; |138| <0,14> 
|| [ A0]   STDW    .D2T2   B5:B4,*B8++       ; |139| <0,14> 

;** --------------------------------------------------------------------------*
$C$L19:    ; PIPED LOOP EPILOG
           BNOP    .S2     $C$L23,5          ; |136| 
           ; BRANCH OCCURS {$C$L23}          ; |136| 
;** --------------------------------------------------------------------------*
           SUB     .L1     A3,2,A8
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\SpikeDetect.c
;*      Loop source line                 : 144
;*      Loop opening brace source line   : 144
;*      Loop closing brace source line   : 149
;*      Known Minimum Trip Count         : 120                    
;*      Known Maximum Trip Count         : 120                    
;*      Known Max Trip Count Factor      : 120
;*      Loop Carried Dependency Bound(^) : 1
;*      Unpartitioned Resource Bound     : 3
;*      Partitioned Resource Bound(*)    : 3
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     1        2     
;*      .S units                     0        0     
;*      .D units                     3*       2     
;*      .M units                     0        0     
;*      .X cross paths               0        1     
;*      .T address paths             3*       2     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          3        3     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1        1     
;*      Bound(.L .S .D .LS .LSD)     3*       3*    
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 3  Schedule found with 8 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 0
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L20:    ; PIPED LOOP PROLOG

           SPLOOPD 3       ;24               ; (P) 
||         MV      .L2     B8,B9
||         MV      .D2     B7,B8
||         MVC     .S2X    A8,ILC

;** --------------------------------------------------------------------------*
$C$L21:    ; PIPED LOOP KERNEL

           LDH     .D2T2   *++B8,B6          ; |145| (P) <0,0> 
||         LDH     .D1T1   *++A7(4),A18      ; |145| (P) <0,0> 

           NOP             4

           SPMASK          L1
||         MV      .L1X    B5,A16
||         ABS     .L2     B6,B5             ; |145| (P) <0,5> 

           CMPGT   .L2X    B5,A18,B2         ; |145| (P) <0,6> 
           NOP             1

           SPMASK          S2
||         MV      .S2X    A17,B7

           MV      .S2     B2,B0             ; |145| (P) <0,9> Split a long life
|| [ B2]   ADD     .L1     A6,A9,A17         ; |145| (P) <0,9>  ^ 
||         ADD     .S1     4,A6,A6           ; |144| (P) <0,9>  ^ 

   [ B0]   LDW     .D1T1   *A17,A19          ; |145| (P) <0,10> 

           SPMASK          L1
||         MV      .L1X    B4,A8
||         MVD     .M2     B0,B4             ; |145| (P) <0,11> Split a long life

           MVD     .M1     A17,A4            ; |145| (P) <0,12> Split a long life
           NOP             3

           MVD     .M1     A19,A3            ; |145| (P) <0,16> Split a long life
||         MVD     .M2     B4,B1             ; |145| (P) <0,16> Split a long life

           MVD     .M1     A4,A5             ; |145| (P) <0,17> Split a long life
           NOP             4

           ZERO    .L2     B5                ; |147| <0,22> 
||         MV      .S2     B7,B4             ; |147| <0,22>  ^ 
|| [!B1]   ZERO    .S1     A0                ; |145| <0,22>  ^ 
|| [ B1]   CMPLTU  .L1     A3,A16,A0         ; |145| <0,22>  ^ 

           SPKERNEL 7,0
||         ADD     .S2     1,B7,B7           ; |144| <0,23>  ^ 
|| [ A0]   STW     .D1T1   A8,*A5            ; |146| <0,23> 
|| [ A0]   STDW    .D2T2   B5:B4,*B9++       ; |147| <0,23> 

;** --------------------------------------------------------------------------*
$C$L22:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
           MV      .L2     B9,B8
;** --------------------------------------------------------------------------*
$C$L23:    

           SUB     .L2     B8,B16,B4         ; |153| 
||         SUB     .S2     B8,B16,B31        ; |162| 
||         ZERO    .L1     A8                ; |158| 
||         MVKL    .S1     _SpikeChannel,A4
||         ZERO    .D2     B5                ; |158| 
||         ZERO    .D1     A9                ; |158| 

           SHR     .S2     B4,2,B4           ; |153| 
||         MVKH    .S1     _SpikeChannel,A4

           SHRU    .S2     B4,1,B0           ; |153| 
||         SHR     .S1X    B31,2,A3          ; |162| 
||         MV      .L2X    A8,B4             ; |162| 
||         STDW    .D1T1   A9:A8,*+A4(8)     ; |158| 

   [!B0]   BNOP    .S2     $C$L27,3          ; |161| 
||         SHRU    .S1     A3,1,A3           ; |162| 
||         MV      .L2X    A4,B6             ; |156| 
||         STW     .D2T2   B0,*+DP(_nSpikes) ; |153| 

           STDW    .D1T2   B5:B4,*A4         ; |156| 
   [ B0]   SUB     .L1     A3,1,A6
           ; BRANCHCC OCCURS {$C$L27}        ; |161| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\SpikeDetect.c
;*      Loop source line                 : 161
;*      Loop opening brace source line   : 161
;*      Loop closing brace source line   : 166
;*      Known Minimum Trip Count         : 1                    
;*      Known Maximum Trip Count         : 121                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 7
;*      Unpartitioned Resource Bound     : 2
;*      Partitioned Resource Bound(*)    : 3
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     2        1     
;*      .D units                     2        1     
;*      .M units                     0        0     
;*      .X cross paths               2        1     
;*      .T address paths             2        1     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          3        1     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1        1     
;*      Bound(.L .S .D .LS .LSD)     3*       1     
;*
;*      Searching for software pipeline schedule at ...
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
$C$L24:    ; PIPED LOOP PROLOG

           SPLOOPD 7       ;14               ; (P) 
||         MV      .L1X    B16,A6
||         MVC     .S2X    A6,ILC

;** --------------------------------------------------------------------------*
$C$L25:    ; PIPED LOOP KERNEL
           LDW     .D1T1   *A6++(8),A5       ; |165| (P) <0,0> 
           NOP             4
           SHRU    .S1     A5,5,A3           ; |165| (P) <0,5> 

           EXTU    .S1     A5,27,27,A5       ; |165| (P) <0,6> 
||         LDW     .D1T1   *+A4[A3],A3       ; |165| (P) <0,6>  ^ 

           MV      .L2X    A3,B5             ; |165| <0,7> Define a twin register

           MVK     .L2     1,B7              ; |165| <0,8> 
||         MV      .S2X    A5,B4             ; |165| <0,8> Define a twin register

           SHL     .S2     B7,B4,B4          ; |165| <0,9> 
           NOP             1
           OR      .L2X    B4,A3,B4          ; |165| <0,11>  ^ 

           SPKERNEL 0,0
||         STW     .D2T2   B4,*+B6[B5]       ; |165| <0,12>  ^ 

;** --------------------------------------------------------------------------*
$C$L26:    ; PIPED LOOP EPILOG
           NOP             6
;** --------------------------------------------------------------------------*
$C$L27:    
           RETNOP  .S2     B3,5              ; |169| 
           ; BRANCH OCCURS {B3}              ; |169| 
	.sect	".text"
	.clink
	.global	_CopyToSpikeSegment

;******************************************************************************
;* FUNCTION NAME: CopyToSpikeSegment                                          *
;*                                                                            *
;*   Regs Modified     : A3,A4,A5,A6,A7,B0,B1,B4,B5,B6,B7                     *
;*   Regs Used         : A3,A4,A5,A6,A7,B0,B1,B3,B4,B5,B6,B7                  *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_CopyToSpikeSegment:
;** --------------------------------------------------------------------------*

           MVKL    .S1     _uSpikeList,A3
||         MVK     .S2     95,B5             ; |261| 

           MVKH    .S1     _uSpikeList,A3
||         MVKL    .S2     _spike_segment,B6

           MVKH    .S2     _spike_segment,B6
||         ADDAD   .D1     A3,A4,A6          ; |256| 

           ADD     .D1     A6,24,A5          ; |256| 
           LDHU    .D1T1   *+A5(2),A4        ; |261| 
           LDHU    .D1T2   *+A6(26),B4       ; |260| 
           LDBU    .D1T1   *A5,A3            ; |256| 
           MVKL    .S1     _adc_intern_1,A7
           MVKH    .S1     _adc_intern_1,A7
           ADDAD   .D1     A4,8,A6           ; |261| 
           ADDAD   .D2     B4,8,B4           ; |260| 

           CMPGTU  .L2X    A6,B5,B0          ; |261| 
||         MVK     .S2     32,B5             ; |261| 
||         SHL     .S1     A3,7,A6           ; |278| 

   [ B0]   SUB     .L2X    A4,B5,B4          ; |261| 
||         MVK     .S2     96,B5             ; |280| 
||         LDDW    .D1T1   *A5,A5:A4         ; |268| 

           AND     .L2     -4,B4,B7          ; |274| 
||         SHL     .S2X    A3,6,B4           ; |278| 

           SUB     .L2     B5,B7,B5          ; |280| 
||         ADD     .D2X    B4,A6,B4          ; |278| 
||         MVK     .S1     192,A6            ; |278| 
||         SHRU    .S2     B7,2,B0           ; |274| 

           SHRU    .S2     B5,2,B1           ; |280| 
||         ADDAH   .D2     B4,B7,B4          ; |278| 
||         MPYUS   .M1     A3,A6,A6          ; |278| 

   [!B1]   BNOP    .S1     $C$L31,2          ; |280| 
|| [ B1]   MVC     .S2     B1,ILC

           STDW    .D2T1   A5:A4,*B6         ; |268| 
           ADD     .L2     8,B6,B6           ; |269| 
           ADD     .L1X    A7,B4,A3          ; |278| 
           ; BRANCHCC OCCURS {$C$L31}        ; |280| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\SpikeDetect.c
;*      Loop source line                 : 280
;*      Loop opening brace source line   : 280
;*      Loop closing brace source line   : 283
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 0
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     0        0     
;*      .D units                     1        1     
;*      .M units                     0        0     
;*      .X cross paths               2*       0     
;*      .T address paths             1        1     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          2        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        0     
;*      Bound(.L .S .D .LS .LSD)     1        1     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 2  Schedule found with 4 iterations in parallel
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
           SPLOOP  2       ;8                ; (P) 
;** --------------------------------------------------------------------------*
$C$L29:    ; PIPED LOOP KERNEL
           LDDW    .D1T1   *A3++,A5:A4       ; |281| (P) <0,0> 
           NOP             4
           MV      .L2X    A5,B5             ; |281| (P) <0,5> Define a twin register
           MV      .L2X    A4,B4             ; |281| <0,6> Define a twin register

           SPKERNEL 3,0
||         STDW    .D2T2   B5:B4,*B6++       ; |281| <0,7> 

           NOP             1                 ; SDSCM00012367 HW bug workaround
;** --------------------------------------------------------------------------*
$C$L30:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
$C$L31:    

   [!B0]   BNOP    .S1     $C$L35,5          ; |287| 
|| [ B0]   MVC     .S2     B0,ILC
||         ADD     .L1     A6,A7,A3          ; |286| 

           ; BRANCHCC OCCURS {$C$L35}        ; |287| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\SpikeDetect.c
;*      Loop source line                 : 287
;*      Loop opening brace source line   : 287
;*      Loop closing brace source line   : 290
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 0
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     0        0     
;*      .D units                     1        1     
;*      .M units                     0        0     
;*      .X cross paths               2*       0     
;*      .T address paths             1        1     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          2        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        0     
;*      Bound(.L .S .D .LS .LSD)     1        1     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 2  Schedule found with 4 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 0
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L32:    ; PIPED LOOP PROLOG
           SPLOOP  2       ;8                ; (P) 
;** --------------------------------------------------------------------------*
$C$L33:    ; PIPED LOOP KERNEL
           LDDW    .D1T1   *A3++,A5:A4       ; |288| (P) <0,0> 
           NOP             4
           MV      .L2X    A5,B5             ; |288| (P) <0,5> Define a twin register
           MV      .L2X    A4,B4             ; |288| <0,6> Define a twin register

           SPKERNEL 3,0
||         STDW    .D2T2   B5:B4,*B6++       ; |288| <0,7> 

;** --------------------------------------------------------------------------*
$C$L34:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
$C$L35:    
           RETNOP  .S2     B3,5              ; |293| 
           ; BRANCH OCCURS {B3}              ; |293| 
	.sect	".text"
	.clink
	.global	_SendSpikeSegment

;******************************************************************************
;* FUNCTION NAME: SendSpikeSegment                                            *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,SP,A16,A17,A18,A19,A20,A21,A22,A23,A24, *
;*                           A25,A26,A27,A28,A29,A30,A31,B16,B17,B18,B19,B20, *
;*                           B21,B22,B23,B24,B25,B26,B27,B28,B29,B30,B31      *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,DP,SP,A16,A17,A18,A19,A20,A21,A22,A23,  *
;*                           A24,A25,A26,A27,A28,A29,A30,A31,B16,B17,B18,B19, *
;*                           B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B30,B31  *
;*   Local Frame Size  : 0 Args + 0 Auto + 4 Save = 4 byte                    *
;******************************************************************************
_SendSpikeSegment:
;** --------------------------------------------------------------------------*
           MVKL    .S2     _spike_segment,B4
           MVKH    .S2     _spike_segment,B4

           STW     .D2T2   B3,*SP--(8)       ; |295| 
||         CALLP   .S2     _SendDataBuffer,B3
||         MVK     .L1     0x2,A4            ; |297| 
||         MVK     .S1     0xc8,A6           ; |297| 

$C$RL0:    ; CALL OCCURS {_SendDataBuffer} {0}  ; |297| 
;** --------------------------------------------------------------------------*
           MVKL    .S1     _uSpikeList+8,A3
           MVKH    .S1     _uSpikeList+8,A3
           LDW     .D1T1   *A3,A5            ; |298| 
           CMPEQ   .L1     A4,0,A4           ; |298| 
           XOR     .L1     1,A4,A4           ; |298| 
           NOP             2
           ADD     .L1     A4,A5,A4          ; |298| 
           STW     .D1T1   A4,*A3            ; |298| 
           LDW     .D2T2   *++SP(8),B3       ; |299| 
           NOP             4
           RETNOP  .S2     B3,5              ; |299| 
           ; BRANCH OCCURS {B3}              ; |299| 
	.sect	".text"
	.clink
	.global	_SendSpikeSegments2

;******************************************************************************
;* FUNCTION NAME: SendSpikeSegments2                                          *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,B0,*
;*                           B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B13,SP,A16,   *
;*                           A17,A18,A19,A20,A21,A22,A23,A24,A25,A26,A27,A28, *
;*                           A29,A30,A31,B16,B17,B18,B19,B20,B21,B22,B23,B24, *
;*                           B25,B26,B27,B28,B29,B30,B31                      *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,B0,*
;*                           B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B13,DP,SP,A16,*
;*                           A17,A18,A19,A20,A21,A22,A23,A24,A25,A26,A27,A28, *
;*                           A29,A30,A31,B16,B17,B18,B19,B20,B21,B22,B23,B24, *
;*                           B25,B26,B27,B28,B29,B30,B31                      *
;*   Local Frame Size  : 0 Args + 0 Auto + 40 Save = 40 byte                  *
;******************************************************************************
_SendSpikeSegments2:
;** --------------------------------------------------------------------------*
           STW     .D2T2   B13,*SP--(8)      ; |225| 

           STDW    .D2T2   B11:B10,*SP--     ; |225| 
||         MVKL    .S1     _uSpikeList+16,A3

           STDW    .D2T1   A13:A12,*SP--     ; |225| 
||         MVKH    .S1     _uSpikeList+16,A3

           STDW    .D2T1   A11:A10,*SP--     ; |225| 
||         MVK     .S2     16,B4

           STW     .D2T1   A14,*SP--(8)      ; |225| 
||         SUB     .L2X    A3,B4,B4

           LDW     .D2T1   *B4,A0            ; |230| 
           MVKL    .S2     _spike_segment,B5
           MVKH    .S2     _spike_segment,B5
           LDW     .D1T1   *A3,A11           ; |227| 
           MVKL    .S2     _Debug_Data+12,B4
   [!A0]   BNOP    .S1     $C$L38,3          ; |234| 

           MVKH    .S2     _Debug_Data+12,B4
||         MVK     .S1     0xc8,A12
||         MV      .L2     B3,B13            ; |225| 

           STW     .D2T1   A0,*B4            ; |231| 
||         MV      .L1     A0,A14            ; |230| 
||         MV      .D1X    B5,A10
||         MVK     .S1     0x40,A13
||         MV      .L2X    A4,B10            ; |225| 
||         MVK     .S2     0xffffffff,B11

           ; BRANCHCC OCCURS {$C$L38}        ; |234| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*      Disqualified loop: Loop contains control code
;*----------------------------------------------------------------------------*
$C$L36:    

           CMPEQ   .L2     B10,1,B0          ; |236| 
||         SUB     .L1     A14,1,A14         ; |234| 

   [!B0]   B       .S2     $C$L37            ; |236| 
|| [!B0]   MV      .L1     A14,A2            ; |245| 
|| [ B0]   ZERO    .D1     A2                ; |245| nullify predicate
|| [ B0]   MVKL    .S1     _Debug_Data+16,A3

   [ B0]   CALL    .S2     _CopyToSpikeSegment ; |238| 
|| [!B0]   ADD     .L1     1,A11,A11         ; |245| 
|| [!B0]   MVK     .S1     64,A3             ; |245| 

   [ A2]   BNOP    .S2     $C$L36,3          ; |234| 
|| [!B0]   CMPEQ   .L1     A11,A3,A0         ; |245| 
|| [ B0]   MVKH    .S1     _Debug_Data+16,A3

           ; BRANCHCC OCCURS {$C$L37}        ; |236| 
;** --------------------------------------------------------------------------*

           MV      .L1     A11,A4            ; |238| 
||         STW     .D1T1   A11,*A3           ; |237| 
||         ADDKPC  .S2     $C$RL1,B3,0       ; |238| 

$C$RL1:    ; CALL OCCURS {_CopyToSpikeSegment} {0}  ; |238| 
;** --------------------------------------------------------------------------*

           CALLP   .S2     _SendDataBuffer,B3
||         MVK     .L1     0x2,A4            ; |297| 
||         MV      .L2X    A10,B4            ; |297| 
||         MV      .S1     A12,A6            ; |297| 

$C$RL2:    ; CALL OCCURS {_SendDataBuffer} {0}  ; |297| 
;** --------------------------------------------------------------------------*
           MVKL    .S2     _uSpikeList,B5
           MVKH    .S2     _uSpikeList,B5

           MVK     .S1     16,A3
||         ADDAD   .D2     B5,1,B4

           ADD     .L1X    B5,A3,A3
||         LDW     .D2T2   *B5,B7            ; |240| 

           LDW     .D1T1   *A3,A3            ; |241| 
||         LDW     .D2T2   *B4,B31           ; |298| 

           CMPEQ   .L1     A4,0,A4           ; |298| 
           MV      .L1     A14,A2            ; |245| 
           XOR     .L1     1,A4,A4           ; |298| 

   [ A2]   B       .S1     $C$L36            ; |234| 
||         ADD     .L2     B11,B7,B7         ; |240| 
||         MV      .L1X    B5,A6
||         ADD     .D1     1,A11,A11         ; |245| 

           ADD     .L1     1,A3,A3           ; |241| 
||         ADDAD   .D2     B5,2,B6
||         MV      .S1X    B4,A5
||         ADD     .L2X    A4,B31,B4         ; |298| 
||         STW     .D1T2   B7,*A6            ; |240| 

           CMPEQ   .L1     A3,A13,A0         ; |242| 
||         STW     .D2T1   A3,*B6            ; |241| 
||         MVK     .S1     64,A3             ; |245| 
||         MV      .L2     B6,B5             ; |241| 
||         ZERO    .S2     B30               ; |242| 
||         STW     .D1T2   B4,*A5            ; |298| 

   [ A0]   STW     .D2T2   B30,*B5           ; |242| 
||         CMPEQ   .L1     A11,A3,A0         ; |245| 

;** --------------------------------------------------------------------------*
$C$L37:    
   [ A0]   ZERO    .L1     A11               ; |245| 
           NOP             1
           ; BRANCHCC OCCURS {$C$L36}        ; |234| 
;** --------------------------------------------------------------------------*
$C$L38:    
           LDW     .D2T1   *++SP(8),A14      ; |248| 
           LDDW    .D2T1   *++SP,A11:A10     ; |248| 

           LDDW    .D2T1   *++SP,A13:A12     ; |248| 
||         MV      .L2     B13,B3            ; |248| 

           LDDW    .D2T2   *++SP,B11:B10     ; |248| 
||         RET     .S2     B3                ; |248| 

           LDW     .D2T2   *++SP(8),B13      ; |248| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |248| 
	.sect	".text"
	.clink
	.global	_SendSpikeSegments

;******************************************************************************
;* FUNCTION NAME: SendSpikeSegments                                           *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,   *
;*                           A15,B0,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B13,SP,*
;*                           A16,A17,A18,A19,A20,A21,A22,A23,A24,A25,A26,A27, *
;*                           A28,A29,A30,A31,B16,B17,B18,B19,B20,B21,B22,B23, *
;*                           B24,B25,B26,B27,B28,B29,B30,B31                  *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,   *
;*                           A15,B0,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B13,DP,*
;*                           SP,A16,A17,A18,A19,A20,A21,A22,A23,A24,A25,A26,  *
;*                           A27,A28,A29,A30,A31,B16,B17,B18,B19,B20,B21,B22, *
;*                           B23,B24,B25,B26,B27,B28,B29,B30,B31              *
;*   Local Frame Size  : 0 Args + 0 Auto + 40 Save = 40 byte                  *
;******************************************************************************
_SendSpikeSegments:
;** --------------------------------------------------------------------------*

           STW     .D2T2   B13,*SP--(8)      ; |196| 
||         MVK     .S2     536,B5
||         MV      .L2     B3,B13            ; |196| 

           STDW    .D2T2   B11:B10,*SP--     ; |196| 
||         MVK     .S2     0x5f,B11

           STDW    .D2T1   A15:A14,*SP--     ; |196| 
||         MVKL    .S1     _uSpikeList+16,A14

           STDW    .D2T1   A13:A12,*SP--     ; |196| 
||         MVKH    .S1     _uSpikeList+16,A14

           STDW    .D2T1   A11:A10,*SP--     ; |196| 
||         SUBAW   .D1     A14,4,A11

           LDW     .D1T2   *A11,B4           ; |206| 
           LDW     .D1T1   *A14,A10          ; |198| 
           MVK     .S2     0x40,B10
           MVK     .L1     0xffffffff,A15
           ADD     .L1X    B5,A11,A13
           MV      .L1X    B4,A0

   [!A0]   BNOP    .S1     $C$L49,3          ; |206| 
|| [ A0]   LDW     .D1T1   *+A13[A10],A3     ; |211| 
||         MV      .L1X    B4,A12            ; |206| 

   [ A0]   SUB     .L1     A12,1,A12         ; |210| 
   [ A0]   ADDAD   .D1     A11,A10,A4        ; |256| 
           ; BRANCHCC OCCURS {$C$L49}        ; |206| 
;** --------------------------------------------------------------------------*
;**   BEGIN LOOP $C$L39
;** --------------------------------------------------------------------------*
$C$L39:    
           NOP             1
           ADD     .L1     A15,A3,A0         ; |211| 

           STW     .D1T1   A0,*+A13[A10]     ; |211| 
|| [ A0]   B       .S1     $C$L48            ; |212| 

   [!A0]   LDHU    .D1T1   *+A4(26),A3       ; |260| 
           NOP             4
           ; BRANCHCC OCCURS {$C$L48}        ; |212| 
;** --------------------------------------------------------------------------*

           ADD     .L2X    B10,A3,B6         ; |260| 
||         MVK     .S2     32,B4             ; |261| 
||         LDBU    .D1T1   *+A4(24),A4       ; |256| 
||         MVK     .D2     0xfffffffc,B5
||         MVKL    .S1     _spike_segment+8,A5

           CMPGTU  .L2     B6,B11,B0         ; |261| 
||         MVK     .S2     0x60,B31
||         ADDAD   .D1     A11,A10,A6        ; |268| 
||         MVKH    .S1     _spike_segment+8,A5

   [ B0]   SUB     .L2X    A3,B4,B6          ; |261| 
||         LDDW    .D1T1   *+A6(24),A7:A6    ; |268| 
||         MVKL    .S1     _adc_intern_1,A8
||         MVK     .S2     8,B9

           AND     .D2     B5,B6,B5          ; |264| 
||         MVKH    .S1     _adc_intern_1,A8
||         SUB     .L2X    A5,B9,B9
||         MVK     .S2     192,B16           ; |278| 

           SUB     .L2     B31,B5,B4         ; |280| 
||         SHRU    .S2     B5,2,B0           ; |274| 
||         MV      .D2X    A5,B6

           SHRU    .S2     B4,2,B1           ; |280| 
||         SHL     .S1     A4,7,A9           ; |278| 

   [!B1]   B       .S1     $C$L43            ; |280| 
|| [ B1]   MVC     .S2     B1,ILC

           SHL     .S2X    A4,6,B7           ; |278| 
||         STDW    .D2T1   A7:A6,*B9         ; |268| 
||         MVK     .S1     0xc8,A6

           ADD     .L2X    B7,A9,B8          ; |278| 

           ADDAH   .D2     B8,B5,B5          ; |278| 
||         MPYUS   .M2X    A4,B16,B8         ; |278| 

           ADD     .L2X    A8,B5,B4          ; |278| 
           MV      .L2X    A8,B7             ; |278| 
           ; BRANCHCC OCCURS {$C$L43}        ; |280| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\SpikeDetect.c
;*      Loop source line                 : 280
;*      Loop opening brace source line   : 280
;*      Loop closing brace source line   : 283
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 0
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     0        0     
;*      .D units                     1        1     
;*      .M units                     0        0     
;*      .X cross paths               2*       0     
;*      .T address paths             1        1     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          2        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        0     
;*      Bound(.L .S .D .LS .LSD)     1        1     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 2  Schedule found with 4 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 0
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L40:    ; PIPED LOOP PROLOG

           SPLOOP  2       ;8                ; (P) 
||         MV      .L1X    B4,A3

;** --------------------------------------------------------------------------*
$C$L41:    ; PIPED LOOP KERNEL
           LDDW    .D1T1   *A3++,A5:A4       ; |281| (P) <0,0> 
           NOP             4
           MV      .L2X    A5,B5             ; |281| (P) <0,5> Define a twin register
           MV      .L2X    A4,B4             ; |281| <0,6> Define a twin register

           SPKERNEL 3,0
||         STDW    .D2T2   B5:B4,*B6++       ; |281| <0,7> 

           NOP             1                 ; SDSCM00012367 HW bug workaround
;** --------------------------------------------------------------------------*
$C$L42:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
$C$L43:    

   [!B0]   BNOP    .S1     $C$L47,5          ; |287| 
|| [ B0]   MVC     .S2     B0,ILC
||         ADD     .L2     B8,B7,B4          ; |286| 

           ; BRANCHCC OCCURS {$C$L47}        ; |287| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\SpikeDetect.c
;*      Loop source line                 : 287
;*      Loop opening brace source line   : 287
;*      Loop closing brace source line   : 290
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 0
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     0        0     
;*      .D units                     1        1     
;*      .M units                     0        0     
;*      .X cross paths               2*       0     
;*      .T address paths             1        1     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          2        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        0     
;*      Bound(.L .S .D .LS .LSD)     1        1     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 2  Schedule found with 4 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 0
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L44:    ; PIPED LOOP PROLOG

           SPLOOP  2       ;8                ; (P) 
||         MV      .L1X    B4,A3

;** --------------------------------------------------------------------------*
$C$L45:    ; PIPED LOOP KERNEL
           LDDW    .D1T1   *A3++,A5:A4       ; |288| (P) <0,0> 
           NOP             4
           MV      .L2X    A5,B5             ; |288| (P) <0,5> Define a twin register
           MV      .L2X    A4,B4             ; |288| <0,6> Define a twin register

           SPKERNEL 3,0
||         STDW    .D2T2   B5:B4,*B6++       ; |288| <0,7> 

;** --------------------------------------------------------------------------*
$C$L46:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
$C$L47:    

           CALLP   .S2     _SendDataBuffer,B3
||         MV      .L2     B9,B4
||         MVK     .L1     0x2,A4            ; |297| 

$C$RL3:    ; CALL OCCURS {_SendDataBuffer} {0}  ; |297| 
;** --------------------------------------------------------------------------*

           MV      .L2X    A14,B5            ; |216| 
||         MV      .L1     A11,A3            ; |298| 
||         SUBAW   .D1     A14,2,A5

           LDW     .D2T2   *B5,B6            ; |217| 
||         LDW     .D1T1   *A3,A3            ; |216| 

           LDW     .D1T1   *A5,A6            ; |298| 
           CMPEQ   .L1     A4,0,A4           ; |298| 
           XOR     .L1     1,A4,A4           ; |298| 
           MV      .L2X    A11,B4            ; |298| 

           ADD     .L2     1,B6,B6           ; |217| 
||         ADD     .L1     A15,A3,A3         ; |216| 

           CMPEQ   .L2     B6,B10,B0         ; |218| 
||         STW     .D1T2   B6,*A14           ; |217| 
||         ADD     .L1     A4,A6,A31         ; |298| 
||         ZERO    .S2     B31               ; |218| 
||         STW     .D2T1   A3,*B4            ; |216| 

   [ B0]   STW     .D2T2   B31,*B5           ; |218| 
||         STW     .D1T1   A31,*A5           ; |298| 

;** --------------------------------------------------------------------------*
$C$L48:    

           MVK     .S1     64,A3             ; |221| 
||         ADD     .L1     1,A10,A10         ; |221| 
||         MV      .D1     A12,A2            ; |221| 

           CMPEQ   .L1     A10,A3,A0         ; |221| 
|| [ A2]   B       .S1     $C$L39            ; |210| 

   [ A0]   ZERO    .L1     A10               ; |221| 
   [ A2]   LDW     .D1T1   *+A13[A10],A3     ; |211| 
   [ A2]   SUB     .L1     A12,1,A12         ; |210| 
   [ A2]   ADDAD   .D1     A11,A10,A4        ; |256| 
           NOP             1
           ; BRANCHCC OCCURS {$C$L39}        ; |210| 
;** --------------------------------------------------------------------------*
$C$L49:    
           LDDW    .D2T1   *++SP,A11:A10     ; |224| 
           LDDW    .D2T1   *++SP,A13:A12     ; |224| 

           LDDW    .D2T1   *++SP,A15:A14     ; |224| 
||         MV      .L2     B13,B3            ; |224| 

           LDDW    .D2T2   *++SP,B11:B10     ; |224| 
||         RET     .S2     B3                ; |224| 

           LDW     .D2T2   *++SP(8),B13      ; |224| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |224| 
	.sect	".text"
	.clink
	.global	_SendSpikeBuffer

;******************************************************************************
;* FUNCTION NAME: SendSpikeBuffer                                             *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,A16,A17,A18,A19,A20,A21,A22,A23,A24,A25,*
;*                           A26,A27,A28,A29,A30,A31,B16,B17,B18,B19,B20,B21, *
;*                           B22,B23,B24,B25,B26,B27,B28,B29,B30,B31          *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,DP,SP,A16,A17,A18,A19,A20,A21,A22,A23,  *
;*                           A24,A25,A26,A27,A28,A29,A30,A31,B16,B17,B18,B19, *
;*                           B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B30,B31  *
;*   Local Frame Size  : 0 Args + 0 Auto + 4 Save = 4 byte                    *
;******************************************************************************
_SendSpikeBuffer:
;** --------------------------------------------------------------------------*
           CALLRET .S1     _SendDataBuffer   ; |302| 
           MVKL    .S2     _SpikeData_Compressed,B4
           MVKH    .S2     _SpikeData_Compressed,B4
           MV      .L1     A4,A6             ; |301| 
           MVK     .L1     0x1,A4            ; |302| 
           NOP             1
$C$RL4:    ; CALL-RETURN OCCURS {_SendDataBuffer} 0  ; |302| 
	.sect	".text"
	.clink
	.global	_RemoveTopFromSpikeList

;******************************************************************************
;* FUNCTION NAME: RemoveTopFromSpikeList                                      *
;*                                                                            *
;*   Regs Modified     : A0,A3,A4,A5,B4,B5                                    *
;*   Regs Used         : A0,A3,A4,A5,B3,B4,B5                                 *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_RemoveTopFromSpikeList:
;** --------------------------------------------------------------------------*
           MVKL    .S1     _uSpikeList,A5
           MVKH    .S1     _uSpikeList,A5
           LDW     .D1T1   *A5,A3            ; |190| 
           MVK     .S2     16,B4
           ADD     .L2X    A5,B4,B4
           NOP             2
           CMPLTU  .L1     A3,A4,A0          ; |190| 
   [!A0]   LDW     .D2T2   *B4,B5            ; |192| 
           NOP             1
           RETNOP  .S2     B3,2              ; |194| 

   [!A0]   ADD     .L1X    A4,B5,A3          ; |192| 
||         SUB     .S1     A3,A4,A4          ; |191| 

   [!A0]   EXTU    .S1     A3,26,26,A3       ; |192| 
|| [!A0]   STW     .D1T1   A4,*A5            ; |191| 

   [!A0]   STW     .D2T1   A3,*B4            ; |192| 
           ; BRANCH OCCURS {B3}              ; |194| 
	.sect	".text"
	.clink
	.global	_AddToSpikeList

;******************************************************************************
;* FUNCTION NAME: AddToSpikeList                                              *
;*                                                                            *
;*   Regs Modified     : A0,A3,A4,A5,A6,B4,B5,B6,B7,B8,B9,B16,B17,B18,B19,B20 *
;*   Regs Used         : A0,A3,A4,A5,A6,B3,B4,B5,B6,B7,B8,B9,DP,B16,B17,B18,  *
;*                           B19,B20                                          *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_AddToSpikeList:
;** --------------------------------------------------------------------------*
           MVKL    .S1     _uSpikeList,A3
           MVKH    .S1     _uSpikeList,A3
           LDW     .D1T1   *A3,A5            ; |172| 
           MVK     .S2     64,B5             ; |172| 
           MVK     .S2     12,B4
           ADD     .L2X    A3,B4,B7
           LDHU    .D2T2   *+DP(_adc_intern_id),B17 ; |177| 
           CMPLTU  .L1X    A5,B5,A0          ; |172| 
   [ A0]   LDW     .D2T2   *B7,B18           ; |177| 
           ADDAW   .D1     A3,3,A6
           LDW     .D2T2   *+DP(_current_time),B16 ; |176| 

   [ A0]   LDW     .D1T2   *A6,B8            ; |175| 
||         ADD     .L2X    A3,B4,B9

   [ A0]   LDW     .D2T2   *B9,B7            ; |178| 
||         MV      .L2X    A3,B5             ; |172| 

   [ A0]   ADD     .L2X    A3,B4,B20
||         ADD     .L1     1,A5,A5           ; |173| 
|| [ A0]   ADDAD   .D2     B5,B18,B18        ; |177| 

           ADD     .L1X    A3,B4,A6
||         ADD     .L2X    A3,B4,B4
|| [ A0]   STW     .D2T1   A5,*B5            ; |173| 

   [ A0]   LDW     .D2T2   *B4,B6            ; |174| 
   [ A0]   ADDAD   .D2     B5,B8,B8          ; |175| 

   [ A0]   LDW     .D1T1   *A6,A6            ; |180| 
|| [ A0]   LDW     .D2T2   *B4,B9            ; |176| 

   [ A0]   ADDAW   .D2     B5,B7,B19         ; |178| 

           ADD     .L1     4,A3,A3
|| [ A0]   STH     .D2T2   B17,*+B18(26)     ; |177| 

   [!A0]   LDW     .D1T1   *A3,A4            ; |184| 
|| [ A0]   ADDAD   .D2     B5,B6,B6          ; |174| 

   [ A0]   STB     .D2T1   A4,*+B6(24)       ; |174| 

   [ A0]   ADD     .L1     1,A6,A3           ; |180| 
||         RET     .S2     B3                ; |187| 
|| [ A0]   ADDAD   .D2     B5,B9,B7          ; |176| 

   [ A0]   STW     .D2T1   A3,*B4            ; |180| 
||         MVK     .S2     64,B4             ; |178| 

           ZERO    .L2     B5                ; |175| 
|| [ A0]   STW     .D2T2   B16,*+B7(28)      ; |176| 

           MV      .L1X    B4,A6             ; |184| 
|| [ A0]   ADDK    .S2     536,B19           ; |178| 
|| [!A0]   ADD     .S1     1,A4,A4           ; |184| 
|| [ A0]   STB     .D2T2   B5,*+B8(25)       ; |175| 
||         ZERO    .D1     A5                ; |175| 

   [ A0]   STW     .D2T2   B4,*B19           ; |178| 
|| [!A0]   STW     .D1T1   A4,*A3            ; |184| 
|| [ A0]   CMPEQ   .L1     A3,A6,A0          ; |181| 
|| [!A0]   ZERO    .S1     A0                ; |181| 

   [ A0]   STW     .D2T1   A5,*B20           ; |181| 
           ; BRANCH OCCURS {B3}              ; |187| 
;*****************************************************************************
;* UNDEFINED EXTERNAL REFERENCES                                             *
;*****************************************************************************
	.global	_SendDataBuffer
	.global	_adc_intern_0
	.global	_adc_intern_1
	.global	_adc_intern_id
	.global	_current_time
	.global	_Debug_Data
	.global	_SpikeChannel
	.global	_ThresholdMode

;******************************************************************************
;* BUILD ATTRIBUTES                                                           *
;******************************************************************************
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_needed(0)
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_preserved(0)
	.battr "TI", Tag_File, 1, Tag_Tramps_Use_SOC(1)
