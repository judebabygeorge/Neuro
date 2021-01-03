;******************************************************************************
;* TMS320C6x C/C++ Codegen                                          PC v7.4.2 *
;* Date/Time created: Sun Jun 01 20:43:30 2014                                *
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
	.field  	$C$IR_1,32
	.field  	_dsp_version+0,32
	.field	40,8			; _dsp_version[0] @ 0
	.field	62,8			; _dsp_version[1] @ 8
	.field	41,8			; _dsp_version[2] @ 16
	.field	48,8			; _dsp_version[3] @ 24
	.field	46,8			; _dsp_version[4] @ 32
	.field	48,8			; _dsp_version[5] @ 40
	.field	51,8			; _dsp_version[6] @ 48
	.field	40,8			; _dsp_version[7] @ 56
	.field	60,8			; _dsp_version[8] @ 64
	.field	41,8			; _dsp_version[9] @ 72
	.field	0,8			; _dsp_version[10] @ 80
$C$IR_1:	.set	11

	.sect	".cinit"
	.align	8
	.field  	4,32
	.field  	_gpioRegs+0,32
	.field	45088768,32			; _gpioRegs @ 0

	.global	_dsp_version
_dsp_version:	.usect	".far",11,8
	.global	_gpioRegs
	.bss	_gpioRegs,4,4
	.bss	_count$1,4,4
	.bss	_value$2,4,4
;	opt6x C:\\Users\\45c\\AppData\\Local\\Temp\\043882 C:\\Users\\45c\\AppData\\Local\\Temp\\043884 
	.sect	".text"
	.clink
	.global	_filter_update

;******************************************************************************
;* FUNCTION NAME: filter_update                                               *
;*                                                                            *
;*   Regs Modified     : A3,A4,A5,A6,A7,B0,B4,B5,B6,B7,B8,B9,SP               *
;*   Regs Used         : A3,A4,A5,A6,A7,B0,B3,B4,B5,B6,B7,B8,B9,SP            *
;*   Local Frame Size  : 0 Args + 36 Auto + 0 Save = 36 byte                  *
;******************************************************************************
_filter_update:
;** --------------------------------------------------------------------------*

           SUB     .L2     B4,1,B5           ; |198| 
||         SHL     .S2     B4,2,B4           ; |198| 

           CMPGTU  .L2     B5,4,B0           ; |198| 
||         SUB     .S2     B4,4,B4           ; |198| 

   [!B0]   MVKL    .S1     $C$SW1,A3
|| [ B0]   B       .S2     $C$L6             ; |198| 

   [!B0]   MVKH    .S1     $C$SW1,A3
           ADD     .L1X    A3,B4,A3          ; |198| 
   [!B0]   LDW     .D1T1   *A3,A3            ; |198| 
           ADDK    .S2     -40,SP            ; |195| 
           NOP             1
           ; BRANCHCC OCCURS {$C$L6} {-6}    ; |198| 
;** --------------------------------------------------------------------------*
           NOP             2
           BNOP    .S2X    A3,5              ; |198| 
           ; BRANCH OCCURS {A3}              ; |198| 
	.sect	".switch:_filter_update"
	.clink
$C$SW1:	.word	$C$L5	; 1
	.word	$C$L4	; 2
	.word	$C$L3	; 3
	.word	$C$L2	; 4
	.word	$C$L1	; 5
	.sect	".text"
;** --------------------------------------------------------------------------*
$C$L1:    

           ZERO    .L2     B6
||         B       .S1     $C$L8             ; |234| 
||         ZERO    .S2     B7                ; |231| 
||         ZERO    .D2     B5                ; |231| 
||         ZERO    .L1     A3                ; |231| 
||         ZERO    .D1     A7                ; |238| 

           SET     .S2     B6,0x1e,0x1e,B6
||         ZERO    .L2     B4                ; |231| 
||         STW     .D2T1   A3,*+SP(16)       ; |231| 
||         ZERO    .L1     A3

           STDW    .D2T2   B7:B6,*+SP(8)     ; |230| 
||         SET     .S1     A3,0x1d,0x1e,A3

           STNDW   .D2T2   B5:B4,*+SP(28)    ; |233| 
||         ZERO    .L2     B4
||         SUB     .L1     A4,A3,A6          ; |238| 

           LDDW    .D2T2   *+SP(8),B7:B6     ; |238| 
||         SET     .S2     B4,0x1c,0x1e,B4

           MV      .L2     B4,B5             ; |238| 
           ; BRANCH OCCURS {$C$L8}           ; |234| 
;** --------------------------------------------------------------------------*
$C$L2:    

           B       .S2     $C$L7             ; |227| 
||         MVKL    .S1     0x3a8ec000,A6

           MVKH    .S1     0x3a8ec000,A6
||         MVKL    .S2     0x8b58f762,B4

           MVKL    .S2     0x35946259,B5
||         MV      .L1     A6,A3             ; |223| 
||         MVKL    .S1     0x8ae24000,A7

           MVKH    .S2     0x8b58f762,B4
||         STW     .D2T1   A3,*+SP(16)       ; |224| 
||         ZERO    .L1     A3
||         MVKH    .S1     0x8ae24000,A7

           MVKH    .S2     0x35946259,B5
||         SET     .S1     A3,0x1d,0x1e,A3
||         STDW    .D2T1   A7:A6,*+SP(8)     ; |223| 
||         ZERO    .L1     A7                ; |238| 

           STNDW   .D2T2   B5:B4,*+SP(28)    ; |226| 
||         ZERO    .L2     B4
||         SUB     .L1     A4,A3,A6          ; |238| 

           ; BRANCH OCCURS {$C$L7}           ; |227| 
;** --------------------------------------------------------------------------*
$C$L3:    

           MVKL    .S1     0x3c364000,A6
||         B       .S2     $C$L8             ; |220| 
||         ZERO    .L2     B5                ; |217| 
||         ZERO    .L1     A3

           MVKL    .S2     0xc7938f9d,B4
||         MVKL    .S1     0xc3c9c000,A7
||         STW     .D2T2   B5,*+SP(16)       ; |217| 

           MVKH    .S1     0x3c364000,A6
||         MVKH    .S2     0xc7938f9d,B4

           MVKH    .S1     0xc3c9c000,A7
||         STNDW   .D2T2   B5:B4,*+SP(28)    ; |219| 
||         ZERO    .L2     B4

           STDW    .D2T1   A7:A6,*+SP(8)     ; |216| 
||         SET     .S2     B4,0x1c,0x1e,B4
||         SET     .S1     A3,0x1d,0x1e,A3
||         ZERO    .L1     A7                ; |238| 

           LDDW    .D2T2   *+SP(8),B7:B6     ; |238| 
||         MV      .L2     B4,B5             ; |238| 
||         SUB     .L1     A4,A3,A6          ; |238| 

           ; BRANCH OCCURS {$C$L8}           ; |220| 
;** --------------------------------------------------------------------------*
$C$L4:    

           MVKL    .S2     0xc25e4e33,B4
||         MVKL    .S1     0x3ed0c000,A6
||         ZERO    .L2     B5                ; |210| 
||         ZERO    .L1     A3

           MVKL    .S1     0xc12f4000,A7
||         MVKH    .S2     0xc25e4e33,B4
||         STW     .D2T2   B5,*+SP(16)       ; |210| 

           B       .S2     $C$L9             ; |213| 
||         MVKH    .S1     0x3ed0c000,A6
||         STNDW   .D2T2   B5:B4,*+SP(28)    ; |212| 
||         ZERO    .L2     B4

           MVKH    .S1     0xc12f4000,A7
||         SET     .S2     B4,0x1c,0x1e,B4

           STDW    .D2T1   A7:A6,*+SP(8)     ; |209| 
||         SET     .S1     A3,0x1d,0x1e,A3
||         MV      .L2     B4,B5             ; |238| 
||         ZERO    .L1     A7                ; |238| 

           LDDW    .D2T2   *+SP(8),B7:B6     ; |238| 
           SUB     .L1     A4,A3,A6          ; |238| 
           MV      .L1X    B4,A5             ; |238| 
           ; BRANCH OCCURS {$C$L9}           ; |213| 
;** --------------------------------------------------------------------------*
$C$L5:    
           MVKL    .S1     0xf4ca8000,A7

           MVKH    .S1     0xf4ca8000,A7
||         ZERO    .L1     A6
||         ZERO    .L2     B4                ; |203| 

           STW     .D2T2   B4,*+SP(16)       ; |203| 
||         MVKH    .S1     0xd890000,A6
||         ZERO    .L2     B6

           STDW    .D2T1   A7:A6,*+SP(8)     ; |202| 
||         MVKH    .S2     0x15560000,B6
||         ZERO    .L2     B7                ; |203| 

           STNDW   .D2T2   B7:B6,*+SP(28)    ; |205| 
;** --------------------------------------------------------------------------*
$C$L6:    
           ZERO    .L1     A3
           SET     .S1     A3,0x1d,0x1e,A3

           SUB     .L1     A4,A3,A6          ; |238| 
||         ZERO    .S1     A7                ; |238| 
||         ZERO    .L2     B4

;** --------------------------------------------------------------------------*
$C$L7:    
           SET     .S2     B4,0x1c,0x1e,B4

           MV      .L2     B4,B5             ; |238| 
||         LDDW    .D2T2   *+SP(8),B7:B6     ; |238| 

;** --------------------------------------------------------------------------*
$C$L8:    
           MV      .L1X    B4,A5             ; |238| 
           NOP             1
;** --------------------------------------------------------------------------*
$C$L9:    
           NOP             2
           STW     .D1T2   B6,*A6            ; |238| 
           STW     .D2T1   A7,*B4            ; |238| 

           LDW     .D2T1   *B5,A3            ; |238| 
||         STW     .D1T2   B7,*+A6(8)        ; |239| 

           STW     .D2T1   A7,*B4            ; |239| 
           LDNDW   .D2T2   *+SP(28),B9:B8    ; |240| 
           LDW     .D2T1   *B5,A3            ; |239| 
           MV      .L2     B4,B6             ; |238| 
           MV      .L2     B4,B7             ; |238| 
           NOP             1
           STW     .D1T2   B8,*+A6(12)       ; |240| 
           STW     .D2T1   A7,*B4            ; |240| 
           LDW     .D2T2   *+SP(16),B5       ; |241| 
           MV      .L1X    B4,A3             ; |238| 
           LDW     .D2T1   *B6,A4            ; |240| 
           NOP             2
           STW     .D1T2   B5,*+A6(16)       ; |241| 
           STW     .D1T1   A7,*A3            ; |241| 
           LDW     .D2T2   *B4,B4            ; |241| 
           STW     .D1T2   B9,*+A6(20)       ; |242| 

           STW     .D1T1   A7,*A5            ; |242| 
||         RET     .S2     B3                ; |244| 

           LDW     .D2T2   *B7,B4            ; |242| 
           ADDK    .S2     40,SP             ; |244| 
           NOP             3
           ; BRANCH OCCURS {B3}              ; |244| 
	.sect	".text"
	.clink
	.global	_filter_setup

;******************************************************************************
;* FUNCTION NAME: filter_setup                                                *
;*                                                                            *
;*   Regs Modified     : A0,A3,A4,A5,A6,A7,A8,A9,B0,B3,B4,B5,B6,B7,B8,B9,B16, *
;*                           B17                                              *
;*   Regs Used         : A0,A3,A4,A5,A6,A7,A8,A9,B0,B3,B4,B5,B6,B7,B8,B9,SP,  *
;*                           B16,B17                                          *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_filter_setup:
;** --------------------------------------------------------------------------*
           MVKL    .S1     0x8600,A4

           MV      .L1X    B3,A0             ; |245| 
||         CALLP   .S2     _filter_update,B3
||         MVKH    .S1     0x8600,A4
||         MVK     .L2     0x1,B4            ; |260| 

$C$RL0:    ; CALL OCCURS {_filter_update} {0}  ; |260| 
;** --------------------------------------------------------------------------*
           MVKL    .S2     0xa000861c,B17

           MVKH    .S2     0xa000861c,B17
||         MVK     .L1     0x3,A9            ; |261| 
||         ZERO    .L2     B16

           STW     .D2T1   A9,*B17           ; |261| 
||         SET     .S2     B16,0x1c,0x1e,B16
||         ZERO    .L1     A8                ; |261| 

           STW     .D2T1   A8,*B16           ; |261| 
           LDW     .D2T2   *B16,B4           ; |261| 
           MVKL    .S1     0x8620,A4
           MVKH    .S1     0x8620,A4
           NOP             2

           CALLP   .S2     _filter_update,B3
||         MV      .L2X    A9,B4             ; |262| 

$C$RL1:    ; CALL OCCURS {_filter_update} {0}  ; |262| 
;** --------------------------------------------------------------------------*
           MVK     .S1     32,A3
           ADD     .L1X    B17,A3,A3

           STW     .D1T1   A9,*A3            ; |263| 
||         MV      .L1X    B16,A4            ; |261| 

           STW     .D1T1   A8,*A4            ; |263| 
||         MVKL    .S1     0xa0008100,A5

           LDW     .D2T2   *B16,B4           ; |263| 
||         MVKH    .S1     0xa0008100,A5

           LDW     .D1T1   *A5,A4            ; |271| 
           MV      .L1X    B16,A3            ; |261| 
           NOP             3
           OR      .L1     2,A4,A4           ; |273| 
           STW     .D1T1   A4,*A5            ; |273| 

           STW     .D1T1   A8,*A3            ; |273| 
||         MV      .L2     B16,B4            ; |261| 
||         RET     .S2X    A0                ; |274| 

           LDW     .D2T2   *B4,B4            ; |273| 
           NOP             4
           ; BRANCH OCCURS {A0}              ; |274| 
	.sect	".text"
	.clink
	.global	_load_command_data

;******************************************************************************
;* FUNCTION NAME: load_command_data                                           *
;*                                                                            *
;*   Regs Modified     : A0,A3,A4,A5,B4,B5                                    *
;*   Regs Used         : A0,A3,A4,A5,B3,B4,B5                                 *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_load_command_data:
;** --------------------------------------------------------------------------*
           MVKL    .S1     0xa0001004,A3
           MVKH    .S1     0xa0001004,A3
           LDW     .D1T1   *A3,A0            ; |75| 
           MVKL    .S2     _MonitorData,B5
           MVKH    .S2     _MonitorData,B5
           MVK     .S1     0x1004,A4         ; |74| 
           NOP             1

   [!A0]   BNOP    .S1     $C$L13,5          ; |75| 
|| [ A0]   SUB     .L1     A0,1,A5

           ; BRANCHCC OCCURS {$C$L13}        ; |75| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\main.c
;*      Loop source line                 : 77
;*      Loop opening brace source line   : 77
;*      Loop closing brace source line   : 80
;*      Known Minimum Trip Count         : 1                    
;*      Known Maximum Trip Count         : 257                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 6
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     2*       0     
;*      .D units                     1        1     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             0        2*    
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          2        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1        0     
;*      Bound(.L .S .D .LS .LSD)     2*       1     
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
$C$L10:    ; PIPED LOOP PROLOG

           SPLOOPD 6       ;12               ; (P) 
||         MVC     .S2X    A5,ILC

;** --------------------------------------------------------------------------*
$C$L11:    ; PIPED LOOP KERNEL
           MVKL    .S1     0x5ffffffc,A3     ; (P) <0,0> 
           MVKH    .S1     0x5ffffffc,A3     ; (P) <0,1> 
           SUB     .L1     A4,A3,A3          ; |79| (P) <0,2> 
           LDW     .D1T2   *A3,B4            ; |79| (P) <0,3>  ^ 
           NOP             3
           ADD     .L1     4,A4,A4           ; |78| <0,7> 

           SPKERNEL 0,0
||         STW     .D2T2   B4,*B5++          ; |79| <0,8>  ^ 

;** --------------------------------------------------------------------------*
$C$L12:    ; PIPED LOOP EPILOG
           NOP             3
;** --------------------------------------------------------------------------*
$C$L13:    
           RETNOP  .S2     B3,4              ; |82| 
           MV      .L1     A0,A4             ; |81| 
           ; BRANCH OCCURS {B3}              ; |82| 
	.sect	".text"
	.clink
	.global	_ExecuteCommand

;******************************************************************************
;* FUNCTION NAME: ExecuteCommand                                              *
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
_ExecuteCommand:
;** --------------------------------------------------------------------------*
           STW     .D2T2   B3,*SP--(8)       ; |84| 
           LDW     .D2T2   *+DP(_ExectueCommand_flag),B4 ; |93| 
           MVK     .S2     17,B6             ; |93| 
           NOP             3

           SUB     .L2     B4,1,B5           ; |93| 
||         SHL     .S2     B4,2,B4           ; |93| 

           CMPGTU  .L2     B5,B6,B0          ; |93| 
||         SUB     .S2     B4,4,B4           ; |93| 

   [!B0]   MVKL    .S1     $C$SW3,A3
|| [ B0]   B       .S2     $C$L69            ; |93| 

   [!B0]   MVKH    .S1     $C$SW3,A3
           ADD     .L1X    A3,B4,A3          ; |93| 
   [!B0]   LDW     .D1T1   *A3,A3            ; |93| 
           NOP             2
           ; BRANCHCC OCCURS {$C$L69} {-19}  ; |93| 
;** --------------------------------------------------------------------------*
           NOP             2
           BNOP    .S2X    A3,5              ; |93| 
           ; BRANCH OCCURS {A3}              ; |93| 
	.sect	".switch:_ExecuteCommand"
	.clink
$C$SW3:	.word	$C$L68	; 1
	.word	$C$L56	; 2
	.word	$C$L67	; 3
	.word	$C$L51	; 4
	.word	$C$L46	; 5
	.word	$C$L41	; 6
	.word	$C$L36	; 7
	.word	$C$L31	; 8
	.word	$C$L66	; 9
	.word	$C$L26	; 10
	.word	$C$L21	; 11
	.word	$C$L16	; 12
	.word	$C$L65	; 13
	.word	$C$L64	; 14
	.word	$C$L63	; 15
	.word	$C$L62	; 16
	.word	$C$L14	; 17
	.word	$C$L61	; 18
	.sect	".text"
;** --------------------------------------------------------------------------*
$C$L14:    
           CALLP   .S2     _load_command_data,B3
$C$RL2:    ; CALL OCCURS {_load_command_data} {0}  ; |169| 
;** --------------------------------------------------------------------------*
           MVKL    .S1     _MonitorData,A3
           MVKH    .S1     _MonitorData,A3
           LDDW    .D1T1   *A3,A5:A4         ; |170| 
           NOP             4
           STW     .D2T1   A4,*+DP(_frame_sync) ; |170| 
           STW     .D2T1   A5,*+DP(_ExecutionMode) ; |171| 
           LDW     .D2T2   *+DP(_ExecutionMode),B4 ; |172| 
           ZERO    .L1     A4                ; |175| 
           NOP             3
           CMPEQ   .L2     B4,2,B0           ; |172| 
   [ B0]   B       .S1     $C$L15            ; |172| 
   [!B0]   CALL    .S1     _StimTrain_Trigger ; |175| 
   [ B0]   CALL    .S1     _StimTrain_Trigger ; |173| 
           NOP             3
           ; BRANCHCC OCCURS {$C$L15}        ; |172| 
;** --------------------------------------------------------------------------*
           ADDKPC  .S2     $C$RL3,B3,0       ; |175| 
$C$RL3:    ; CALL OCCURS {_StimTrain_Trigger} {0}  ; |175| 
;** --------------------------------------------------------------------------*

           B       .S1     $C$L72            ; |175| 
||         ZERO    .L2     B4                ; |187| 

           STW     .D2T2   B4,*+DP(_ExectueCommand_flag) ; |187| 
           LDW     .D2T2   *++SP(8),B3       ; |188| 
           NOP             3
           ; BRANCH OCCURS {$C$L72}          ; |175| 
;** --------------------------------------------------------------------------*
$C$L15:    
           MVK     .L1     0x1,A4            ; |173| 
           ADDKPC  .S2     $C$RL4,B3,0       ; |173| 
$C$RL4:    ; CALL OCCURS {_StimTrain_Trigger} {0}  ; |173| 
;** --------------------------------------------------------------------------*

           B       .S1     $C$L72            ; |173| 
||         ZERO    .L2     B4                ; |187| 

           STW     .D2T2   B4,*+DP(_ExectueCommand_flag) ; |187| 
           LDW     .D2T2   *++SP(8),B3       ; |188| 
           NOP             3
           ; BRANCH OCCURS {$C$L72}          ; |173| 
;** --------------------------------------------------------------------------*
$C$L16:    
           CALLP   .S2     _load_command_data,B3
$C$RL5:    ; CALL OCCURS {_load_command_data} {0}  ; |145| 
;** --------------------------------------------------------------------------*

           MVKL    .S1     _MonitorData+16,A3
||         LDW     .D2T2   *+DP(_current_time),B6 ; |147| 

           MVKH    .S1     _MonitorData+16,A3
           LDW     .D1T1   *A3,A8            ; |146| 
           NOP             4
           CMPLTU  .L2X    A8,B6,B0          ; |147| 

   [!B0]   BNOP    .S1     $C$L20,5          ; |147| 
|| [ B0]   MVK     .L1     0x1,A0

           ; BRANCHCC OCCURS {$C$L20}        ; |147| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\main.c
;*      Loop source line                 : 147
;*      Loop opening brace source line   : 147
;*      Loop closing brace source line   : 149
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 2
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        1     
;*      .S units                     0        2*    
;*      .D units                     0        0     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             0        0     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          1        2     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        2*    
;*      Bound(.L .S .D .LS .LSD)     1        2*    
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 2  Schedule found with 5 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 4
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L17:    ; PIPED LOOP PROLOG
   [ A0]   SPLOOPW 2       ;10               ; (P) 
;** --------------------------------------------------------------------------*
$C$L18:    ; PIPED LOOP KERNEL
           NOP             1
           MVKL    .S2     0xc350,B4         ; (P) <0,1>  ^ 

           SPMASK          L2
||         MV      .L2X    A8,B7
||         MVKH    .S2     0xc350,B4         ; (P) <0,2>  ^ 

           ADD     .L2     B4,B7,B7          ; |147| (P) <0,3>  ^ 

   [ A0]   MV      .D2     B7,B5             ; |147| (P) <0,4> 
||         CMPLTU  .L2     B7,B6,B0          ; |147| (P) <0,4> 

   [!B0]   ZERO    .L1     A0                ; |147| (P) <0,5> 
           NOP             2
           NOP             1
           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L19:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
           MV      .L1X    B5,A8
;** --------------------------------------------------------------------------*
$C$L20:    
           SUBAW   .D1     A3,4,A3
           LDW     .D1T1   *+A3(8),A6        ; |150| 

           MV      .L2X    A3,B5             ; |150| 
||         LDW     .D1T2   *+A3(4),B4        ; |150| 

           CALLP   .S2     _StimPatternSequence_Start,B3
||         LDW     .D2T1   *B5,A4            ; |150| 
||         LDW     .D1T2   *+A3(12),B6       ; |150| 

$C$RL6:    ; CALL OCCURS {_StimPatternSequence_Start} {0}  ; |150| 
;** --------------------------------------------------------------------------*

           B       .S1     $C$L72            ; |151| 
||         ZERO    .L2     B4                ; |187| 

           STW     .D2T2   B4,*+DP(_ExectueCommand_flag) ; |187| 
           LDW     .D2T2   *++SP(8),B3       ; |188| 
           NOP             3
           ; BRANCH OCCURS {$C$L72}          ; |151| 
;** --------------------------------------------------------------------------*
$C$L21:    
           MVKL    .S1     0xa0001004,A3
           MVKH    .S1     0xa0001004,A3
           LDW     .D1T1   *A3,A0            ; |75| 
           MVKL    .S2     _MonitorData,B6
           MVKH    .S2     _MonitorData,B6
           MVK     .S1     0x1004,A4         ; |74| 
           MV      .L2     B6,B5

   [!A0]   BNOP    .S1     $C$L25,5          ; |75| 
|| [ A0]   SUB     .L1     A0,1,A5

           ; BRANCHCC OCCURS {$C$L25}        ; |75| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\main.c
;*      Loop source line                 : 77
;*      Loop opening brace source line   : 77
;*      Loop closing brace source line   : 80
;*      Known Minimum Trip Count         : 1                    
;*      Known Maximum Trip Count         : 257                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 6
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     2*       0     
;*      .D units                     1        1     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             0        2*    
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          2        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1        0     
;*      Bound(.L .S .D .LS .LSD)     2*       1     
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
$C$L22:    ; PIPED LOOP PROLOG

           SPLOOPD 6       ;12               ; (P) 
||         MVC     .S2X    A5,ILC

;** --------------------------------------------------------------------------*
$C$L23:    ; PIPED LOOP KERNEL
           MVKL    .S1     0x5ffffffc,A3     ; (P) <0,0> 
           MVKH    .S1     0x5ffffffc,A3     ; (P) <0,1> 
           SUB     .L1     A4,A3,A3          ; |79| (P) <0,2> 
           LDW     .D1T2   *A3,B4            ; |79| (P) <0,3>  ^ 
           NOP             3
           ADD     .L1     4,A4,A4           ; |78| <0,7> 

           SPKERNEL 0,0
||         STW     .D2T2   B4,*B5++          ; |79| <0,8>  ^ 

;** --------------------------------------------------------------------------*
$C$L24:    ; PIPED LOOP EPILOG
           NOP             3
;** --------------------------------------------------------------------------*
$C$L25:    

           CALLP   .S2     _StimPatternSequence_LoadPatternSequence,B3
||         MV      .L2     B6,B4             ; |142| 
||         MV      .L1     A0,A4             ; |142| 

$C$RL7:    ; CALL OCCURS {_StimPatternSequence_LoadPatternSequence} {0}  ; |142| 
;** --------------------------------------------------------------------------*

           B       .S1     $C$L72            ; |143| 
||         ZERO    .L2     B4                ; |187| 

           STW     .D2T2   B4,*+DP(_ExectueCommand_flag) ; |187| 
           LDW     .D2T2   *++SP(8),B3       ; |188| 
           NOP             3
           ; BRANCH OCCURS {$C$L72}          ; |143| 
;** --------------------------------------------------------------------------*
$C$L26:    
           MVKL    .S1     0xa0001004,A3
           MVKH    .S1     0xa0001004,A3
           LDW     .D1T1   *A3,A0            ; |75| 
           MVKL    .S2     _MonitorData,B6
           MVKH    .S2     _MonitorData,B6
           MVK     .S1     0x1004,A4         ; |74| 
           MV      .L2     B6,B5

   [!A0]   BNOP    .S1     $C$L30,5          ; |75| 
|| [ A0]   SUB     .L1     A0,1,A5

           ; BRANCHCC OCCURS {$C$L30}        ; |75| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\main.c
;*      Loop source line                 : 77
;*      Loop opening brace source line   : 77
;*      Loop closing brace source line   : 80
;*      Known Minimum Trip Count         : 1                    
;*      Known Maximum Trip Count         : 257                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 6
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     2*       0     
;*      .D units                     1        1     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             0        2*    
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          2        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1        0     
;*      Bound(.L .S .D .LS .LSD)     2*       1     
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
$C$L27:    ; PIPED LOOP PROLOG

           SPLOOPD 6       ;12               ; (P) 
||         MVC     .S2X    A5,ILC

;** --------------------------------------------------------------------------*
$C$L28:    ; PIPED LOOP KERNEL
           MVKL    .S1     0x5ffffffc,A3     ; (P) <0,0> 
           MVKH    .S1     0x5ffffffc,A3     ; (P) <0,1> 
           SUB     .L1     A4,A3,A3          ; |79| (P) <0,2> 
           LDW     .D1T2   *A3,B4            ; |79| (P) <0,3>  ^ 
           NOP             3
           ADD     .L1     4,A4,A4           ; |78| <0,7> 

           SPKERNEL 0,0
||         STW     .D2T2   B4,*B5++          ; |79| <0,8>  ^ 

;** --------------------------------------------------------------------------*
$C$L29:    ; PIPED LOOP EPILOG
           NOP             3
;** --------------------------------------------------------------------------*
$C$L30:    

           CALLP   .S2     _StimPatternSequence_LoadPatterBuffer,B3
||         MV      .L2     B6,B4             ; |138| 
||         MV      .L1     A0,A4             ; |138| 

$C$RL8:    ; CALL OCCURS {_StimPatternSequence_LoadPatterBuffer} {0}  ; |138| 
;** --------------------------------------------------------------------------*

           B       .S1     $C$L72            ; |139| 
||         ZERO    .L2     B4                ; |187| 

           STW     .D2T2   B4,*+DP(_ExectueCommand_flag) ; |187| 
           LDW     .D2T2   *++SP(8),B3       ; |188| 
           NOP             3
           ; BRANCH OCCURS {$C$L72}          ; |139| 
;** --------------------------------------------------------------------------*
$C$L31:    
           CALLP   .S2     _load_command_data,B3
$C$RL9:    ; CALL OCCURS {_load_command_data} {0}  ; |126| 
;** --------------------------------------------------------------------------*

           MVKL    .S1     _MonitorData+20,A3
||         LDW     .D2T2   *+DP(_current_time),B6 ; |128| 

           MVKH    .S1     _MonitorData+20,A3
           LDW     .D1T2   *A3,B5            ; |127| 
           NOP             4
           CMPLTU  .L2     B5,B6,B0          ; |128| 

   [!B0]   BNOP    .S1     $C$L35,5          ; |128| 
|| [ B0]   MVK     .L1     0x1,A0

           ; BRANCHCC OCCURS {$C$L35}        ; |128| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\main.c
;*      Loop source line                 : 128
;*      Loop opening brace source line   : 128
;*      Loop closing brace source line   : 130
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 2
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        1     
;*      .S units                     0        2*    
;*      .D units                     0        0     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             0        0     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          1        2     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        2*    
;*      Bound(.L .S .D .LS .LSD)     1        2*    
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 2  Schedule found with 5 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 4
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L32:    ; PIPED LOOP PROLOG
   [ A0]   SPLOOPW 2       ;10               ; (P) 
;** --------------------------------------------------------------------------*
$C$L33:    ; PIPED LOOP KERNEL
           NOP             1
           MVKL    .S2     0xc350,B4         ; (P) <0,1>  ^ 

           SPMASK          L2
||         MV      .L2     B5,B7
||         MVKH    .S2     0xc350,B4         ; (P) <0,2>  ^ 

           ADD     .L2     B4,B7,B7          ; |128| (P) <0,3>  ^ 

   [ A0]   MV      .D2     B7,B5             ; |128| (P) <0,4> 
||         CMPLTU  .L2     B7,B6,B0          ; |128| (P) <0,4> 

   [!B0]   ZERO    .L1     A0                ; |128| (P) <0,5> 
           NOP             2
           NOP             1
           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L34:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
$C$L35:    
           SUBAW   .D1     A3,5,A4
           LDW     .D1T1   *+A4(16),A8       ; |131| 
           LDW     .D1T2   *+A4(12),B6       ; |131| 
           LDW     .D1T1   *+A4(8),A6        ; |131| 
           LDW     .D1T2   *+A4(4),B4        ; |131| 

           CALLP   .S2     _Stim_StartSequence,B3
||         LDW     .D1T1   *A4,A4            ; |131| 
||         MV      .L2     B5,B8             ; |131| 

$C$RL10:   ; CALL OCCURS {_Stim_StartSequence} {0}  ; |131| 
;** --------------------------------------------------------------------------*

           B       .S1     $C$L72            ; |132| 
||         ZERO    .L2     B4                ; |187| 

           STW     .D2T2   B4,*+DP(_ExectueCommand_flag) ; |187| 
           LDW     .D2T2   *++SP(8),B3       ; |188| 
           NOP             3
           ; BRANCH OCCURS {$C$L72}          ; |132| 
;** --------------------------------------------------------------------------*
$C$L36:    
           MVKL    .S1     0xa0001004,A3
           MVKH    .S1     0xa0001004,A3
           LDW     .D1T1   *A3,A0            ; |75| 
           MVKL    .S1     _MonitorData,A5
           MVKH    .S1     _MonitorData,A5
           MVK     .S2     0x1004,B4         ; |74| 
           MV      .L2X    A5,B5

   [!A0]   BNOP    .S1     $C$L40,5          ; |75| 
|| [ A0]   SUB     .L1     A0,1,A4

           ; BRANCHCC OCCURS {$C$L40}        ; |75| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\main.c
;*      Loop source line                 : 77
;*      Loop opening brace source line   : 77
;*      Loop closing brace source line   : 80
;*      Known Minimum Trip Count         : 1                    
;*      Known Maximum Trip Count         : 257                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 6
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     2*       0     
;*      .D units                     1        1     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             0        2*    
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          2        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1        0     
;*      Bound(.L .S .D .LS .LSD)     2*       1     
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
$C$L37:    ; PIPED LOOP PROLOG

           SPLOOPD 6       ;12               ; (P) 
||         MVC     .S2X    A4,ILC

;** --------------------------------------------------------------------------*
$C$L38:    ; PIPED LOOP KERNEL
           MVKL    .S1     0x5ffffffc,A3     ; (P) <0,0> 

           SPMASK          L1
||         MV      .L1X    B4,A4
||         MVKH    .S1     0x5ffffffc,A3     ; (P) <0,1> 

           SUB     .L1     A4,A3,A3          ; |79| (P) <0,2> 
           LDW     .D1T2   *A3,B4            ; |79| (P) <0,3>  ^ 
           NOP             3
           ADD     .L1     4,A4,A4           ; |78| <0,7> 

           SPKERNEL 0,0
||         STW     .D2T2   B4,*B5++          ; |79| <0,8>  ^ 

;** --------------------------------------------------------------------------*
$C$L39:    ; PIPED LOOP EPILOG
           NOP             3
;** --------------------------------------------------------------------------*
$C$L40:    

           MV      .L1     A5,A3
||         LDW     .D1T2   *+A5(4),B4        ; |123| 

           CALLP   .S2     _Stim_LoadStimSequenceList,B3
||         LDW     .D1T1   *A3,A4            ; |123| 
||         ADD     .L1     8,A5,A6           ; |123| 

$C$RL11:   ; CALL OCCURS {_Stim_LoadStimSequenceList} {0}  ; |123| 
;** --------------------------------------------------------------------------*

           B       .S1     $C$L72            ; |124| 
||         ZERO    .L2     B4                ; |187| 

           STW     .D2T2   B4,*+DP(_ExectueCommand_flag) ; |187| 
           LDW     .D2T2   *++SP(8),B3       ; |188| 
           NOP             3
           ; BRANCH OCCURS {$C$L72}          ; |124| 
;** --------------------------------------------------------------------------*
$C$L41:    
           MVKL    .S1     0xa0001004,A3
           MVKH    .S1     0xa0001004,A3
           LDW     .D1T1   *A3,A0            ; |75| 
           MVKL    .S1     _MonitorData,A5
           MVKH    .S1     _MonitorData,A5
           MVK     .S2     0x1004,B4         ; |74| 
           MV      .L2X    A5,B5

   [!A0]   BNOP    .S1     $C$L45,5          ; |75| 
|| [ A0]   SUB     .L1     A0,1,A4

           ; BRANCHCC OCCURS {$C$L45}        ; |75| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\main.c
;*      Loop source line                 : 77
;*      Loop opening brace source line   : 77
;*      Loop closing brace source line   : 80
;*      Known Minimum Trip Count         : 1                    
;*      Known Maximum Trip Count         : 257                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 6
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     2*       0     
;*      .D units                     1        1     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             0        2*    
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          2        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1        0     
;*      Bound(.L .S .D .LS .LSD)     2*       1     
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
$C$L42:    ; PIPED LOOP PROLOG

           SPLOOPD 6       ;12               ; (P) 
||         MVC     .S2X    A4,ILC

;** --------------------------------------------------------------------------*
$C$L43:    ; PIPED LOOP KERNEL
           MVKL    .S1     0x5ffffffc,A3     ; (P) <0,0> 

           SPMASK          L1
||         MV      .L1X    B4,A4
||         MVKH    .S1     0x5ffffffc,A3     ; (P) <0,1> 

           SUB     .L1     A4,A3,A3          ; |79| (P) <0,2> 
           LDW     .D1T2   *A3,B4            ; |79| (P) <0,3>  ^ 
           NOP             3
           ADD     .L1     4,A4,A4           ; |78| <0,7> 

           SPKERNEL 0,0
||         STW     .D2T2   B4,*B5++          ; |79| <0,8>  ^ 

;** --------------------------------------------------------------------------*
$C$L44:    ; PIPED LOOP EPILOG
           NOP             3
;** --------------------------------------------------------------------------*
$C$L45:    
           LDW     .D1T1   *A5,A3            ; |119| 
           ADD     .L2X    4,A5,B4
           LDW     .D2T1   *B4,A6            ; |119| 
           NOP             2
           EXTU    .S1     A3,16,16,A4       ; |119| 
           SHRU    .S1     A3,16,A3          ; |119| 
           NOP             1

           MV      .L2X    A3,B4             ; |119| 
||         CALLP   .S2     _Stim_Trigger,B3

$C$RL12:   ; CALL OCCURS {_Stim_Trigger} {0}  ; |119| 
;** --------------------------------------------------------------------------*

           B       .S1     $C$L72            ; |120| 
||         ZERO    .L2     B4                ; |187| 

           STW     .D2T2   B4,*+DP(_ExectueCommand_flag) ; |187| 
           LDW     .D2T2   *++SP(8),B3       ; |188| 
           NOP             3
           ; BRANCH OCCURS {$C$L72}          ; |120| 
;** --------------------------------------------------------------------------*
$C$L46:    
           MVKL    .S1     0xa0001004,A3
           MVKH    .S1     0xa0001004,A3
           LDW     .D1T1   *A3,A0            ; |75| 
           MVKL    .S1     _MonitorData,A5
           MVKH    .S1     _MonitorData,A5
           MVK     .S2     0x1004,B4         ; |74| 
           MV      .L2X    A5,B5

   [!A0]   BNOP    .S1     $C$L50,5          ; |75| 
|| [ A0]   SUB     .L1     A0,1,A4

           ; BRANCHCC OCCURS {$C$L50}        ; |75| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\main.c
;*      Loop source line                 : 77
;*      Loop opening brace source line   : 77
;*      Loop closing brace source line   : 80
;*      Known Minimum Trip Count         : 1                    
;*      Known Maximum Trip Count         : 257                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 6
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     2*       0     
;*      .D units                     1        1     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             0        2*    
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          2        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1        0     
;*      Bound(.L .S .D .LS .LSD)     2*       1     
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
$C$L47:    ; PIPED LOOP PROLOG

           SPLOOPD 6       ;12               ; (P) 
||         MVC     .S2X    A4,ILC

;** --------------------------------------------------------------------------*
$C$L48:    ; PIPED LOOP KERNEL
           MVKL    .S1     0x5ffffffc,A3     ; (P) <0,0> 

           SPMASK          L1
||         MV      .L1X    B4,A4
||         MVKH    .S1     0x5ffffffc,A3     ; (P) <0,1> 

           SUB     .L1     A4,A3,A3          ; |79| (P) <0,2> 
           LDW     .D1T2   *A3,B4            ; |79| (P) <0,3>  ^ 
           NOP             3
           ADD     .L1     4,A4,A4           ; |78| <0,7> 

           SPKERNEL 0,0
||         STW     .D2T2   B4,*B5++          ; |79| <0,8>  ^ 

;** --------------------------------------------------------------------------*
$C$L49:    ; PIPED LOOP EPILOG
           NOP             3
;** --------------------------------------------------------------------------*
$C$L50:    
           MV      .L1     A5,A3             ; |114| 

           CALLP   .S2     _Stim_LoadElectrodeConfig,B3
||         LDW     .D1T1   *A3,A4            ; |114| 
||         ADD     .L2X    4,A5,B4

$C$RL13:   ; CALL OCCURS {_Stim_LoadElectrodeConfig} {0}  ; |114| 
;** --------------------------------------------------------------------------*

           B       .S1     $C$L72            ; |115| 
||         ZERO    .L2     B4                ; |187| 

           STW     .D2T2   B4,*+DP(_ExectueCommand_flag) ; |187| 
           LDW     .D2T2   *++SP(8),B3       ; |188| 
           NOP             3
           ; BRANCH OCCURS {$C$L72}          ; |115| 
;** --------------------------------------------------------------------------*
$C$L51:    
           MVKL    .S1     0xa0001004,A3
           MVKH    .S1     0xa0001004,A3
           LDW     .D1T1   *A3,A0            ; |75| 
           MVKL    .S1     _MonitorData,A5
           MVKH    .S1     _MonitorData,A5
           MVK     .S2     0x1004,B4         ; |74| 
           MV      .L2X    A5,B5

   [!A0]   BNOP    .S1     $C$L55,5          ; |75| 
|| [ A0]   SUB     .L1     A0,1,A4

           ; BRANCHCC OCCURS {$C$L55}        ; |75| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\main.c
;*      Loop source line                 : 77
;*      Loop opening brace source line   : 77
;*      Loop closing brace source line   : 80
;*      Known Minimum Trip Count         : 1                    
;*      Known Maximum Trip Count         : 257                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 6
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     2*       0     
;*      .D units                     1        1     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             0        2*    
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          2        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1        0     
;*      Bound(.L .S .D .LS .LSD)     2*       1     
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
$C$L52:    ; PIPED LOOP PROLOG

           SPLOOPD 6       ;12               ; (P) 
||         MVC     .S2X    A4,ILC

;** --------------------------------------------------------------------------*
$C$L53:    ; PIPED LOOP KERNEL
           MVKL    .S1     0x5ffffffc,A3     ; (P) <0,0> 

           SPMASK          L1
||         MV      .L1X    B4,A4
||         MVKH    .S1     0x5ffffffc,A3     ; (P) <0,1> 

           SUB     .L1     A4,A3,A3          ; |79| (P) <0,2> 
           LDW     .D1T2   *A3,B4            ; |79| (P) <0,3>  ^ 
           NOP             3
           ADD     .L1     4,A4,A4           ; |78| <0,7> 

           SPKERNEL 0,0
||         STW     .D2T2   B4,*B5++          ; |79| <0,8>  ^ 

;** --------------------------------------------------------------------------*
$C$L54:    ; PIPED LOOP EPILOG
           NOP             3
;** --------------------------------------------------------------------------*
$C$L55:    

           CALLP   .S2     _Stim_LoadPattern,B3
||         MV      .L1     A5,A4

$C$RL14:   ; CALL OCCURS {_Stim_LoadPattern} {0}  ; |110| 
;** --------------------------------------------------------------------------*

           B       .S1     $C$L72            ; |111| 
||         ZERO    .L2     B4                ; |187| 

           STW     .D2T2   B4,*+DP(_ExectueCommand_flag) ; |187| 
           LDW     .D2T2   *++SP(8),B3       ; |188| 
           NOP             3
           ; BRANCH OCCURS {$C$L72}          ; |111| 
;** --------------------------------------------------------------------------*
$C$L56:    
           MVKL    .S1     0xa0001004,A3
           MVKH    .S1     0xa0001004,A3
           LDW     .D1T1   *A3,A0            ; |75| 
           MVKL    .S2     _MonitorData,B6
           MVKH    .S2     _MonitorData,B6
           MVK     .S1     0x1004,A4         ; |74| 
           MV      .L2     B6,B5

   [!A0]   BNOP    .S1     $C$L60,5          ; |75| 
|| [ A0]   SUB     .L1     A0,1,A5

           ; BRANCHCC OCCURS {$C$L60}        ; |75| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\main.c
;*      Loop source line                 : 77
;*      Loop opening brace source line   : 77
;*      Loop closing brace source line   : 80
;*      Known Minimum Trip Count         : 1                    
;*      Known Maximum Trip Count         : 257                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 6
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     2*       0     
;*      .D units                     1        1     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             0        2*    
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          2        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1        0     
;*      Bound(.L .S .D .LS .LSD)     2*       1     
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
$C$L57:    ; PIPED LOOP PROLOG

           SPLOOPD 6       ;12               ; (P) 
||         MVC     .S2X    A5,ILC

;** --------------------------------------------------------------------------*
$C$L58:    ; PIPED LOOP KERNEL
           MVKL    .S1     0x5ffffffc,A3     ; (P) <0,0> 
           MVKH    .S1     0x5ffffffc,A3     ; (P) <0,1> 
           SUB     .L1     A4,A3,A3          ; |79| (P) <0,2> 
           LDW     .D1T2   *A3,B4            ; |79| (P) <0,3>  ^ 
           NOP             3
           ADD     .L1     4,A4,A4           ; |78| <0,7> 

           SPKERNEL 0,0
||         STW     .D2T2   B4,*B5++          ; |79| <0,8>  ^ 

;** --------------------------------------------------------------------------*
$C$L59:    ; PIPED LOOP EPILOG
           NOP             3
;** --------------------------------------------------------------------------*
$C$L60:    

           CALLP   .S2     _setThresholdParams,B3
||         MV      .L2X    A0,B4             ; |102| 
||         MV      .L1X    B6,A4

$C$RL15:   ; CALL OCCURS {_setThresholdParams} {0}  ; |102| 
;** --------------------------------------------------------------------------*

           B       .S1     $C$L72            ; |103| 
||         ZERO    .L2     B4                ; |187| 

           STW     .D2T2   B4,*+DP(_ExectueCommand_flag) ; |187| 
           LDW     .D2T2   *++SP(8),B3       ; |188| 
           NOP             3
           ; BRANCH OCCURS {$C$L72}          ; |103| 
;** --------------------------------------------------------------------------*
$C$L61:    
           CALLP   .S2     _load_command_data,B3
$C$RL16:   ; CALL OCCURS {_load_command_data} {0}  ; |178| 
;** --------------------------------------------------------------------------*
           MVKL    .S1     _MonitorData,A4

           CALLP   .S2     _StimTrain_Setup,B3
||         MVKH    .S1     _MonitorData,A4

$C$RL17:   ; CALL OCCURS {_StimTrain_Setup} {0}  ; |179| 
;** --------------------------------------------------------------------------*

           B       .S1     $C$L72            ; |180| 
||         ZERO    .L2     B4                ; |187| 

           STW     .D2T2   B4,*+DP(_ExectueCommand_flag) ; |187| 
           LDW     .D2T2   *++SP(8),B3       ; |188| 
           NOP             3
           ; BRANCH OCCURS {$C$L72}          ; |180| 
;** --------------------------------------------------------------------------*
$C$L62:    
           CALLP   .S2     _load_command_data,B3
$C$RL18:   ; CALL OCCURS {_load_command_data} {0}  ; |165| 
;** --------------------------------------------------------------------------*

           MVKL    .S1     _MonitorData,A3
||         ZERO    .L2     B4                ; |187| 

           MVKH    .S1     _MonitorData,A3

           BNOP    .S1     $C$L70,4          ; |167| 
||         LDBU    .D1T1   *A3,A3            ; |166| 

           STB     .D2T1   A3,*+DP(_EnableAmpBlanking) ; |166| 
           ; BRANCH OCCURS {$C$L70}          ; |167| 
;** --------------------------------------------------------------------------*
$C$L63:    
           CALLP   .S2     _load_command_data,B3
$C$RL19:   ; CALL OCCURS {_load_command_data} {0}  ; |161| 
;** --------------------------------------------------------------------------*

           MVKL    .S1     _MonitorData,A3
||         ZERO    .L2     B4                ; |187| 

           MVKH    .S1     _MonitorData,A3

           BNOP    .S1     $C$L70,4          ; |163| 
||         LDBU    .D1T1   *A3,A3            ; |162| 

           STB     .D2T1   A3,*+DP(_ADCDataShift) ; |162| 
           ; BRANCH OCCURS {$C$L70}          ; |163| 
;** --------------------------------------------------------------------------*
$C$L64:    
           CALLP   .S2     _load_command_data,B3
$C$RL20:   ; CALL OCCURS {_load_command_data} {0}  ; |157| 
;** --------------------------------------------------------------------------*
           MVKL    .S1     _MonitorData,A4

           CALLP   .S2     _setup_decoder_2,B3
||         MVKH    .S1     _MonitorData,A4

$C$RL21:   ; CALL OCCURS {_setup_decoder_2} {0}  ; |158| 
;** --------------------------------------------------------------------------*

           B       .S1     $C$L72            ; |159| 
||         ZERO    .L2     B4                ; |187| 

           STW     .D2T2   B4,*+DP(_ExectueCommand_flag) ; |187| 
           LDW     .D2T2   *++SP(8),B3       ; |188| 
           NOP             3
           ; BRANCH OCCURS {$C$L72}          ; |159| 
;** --------------------------------------------------------------------------*
$C$L65:    
           CALLP   .S2     _load_command_data,B3
$C$RL22:   ; CALL OCCURS {_load_command_data} {0}  ; |153| 
;** --------------------------------------------------------------------------*
           MVKL    .S1     _MonitorData,A4

           CALLP   .S2     _setup_decoder,B3
||         MVKH    .S1     _MonitorData,A4

$C$RL23:   ; CALL OCCURS {_setup_decoder} {0}  ; |154| 
;** --------------------------------------------------------------------------*

           B       .S1     $C$L72            ; |155| 
||         ZERO    .L2     B4                ; |187| 

           STW     .D2T2   B4,*+DP(_ExectueCommand_flag) ; |187| 
           LDW     .D2T2   *++SP(8),B3       ; |188| 
           NOP             3
           ; BRANCH OCCURS {$C$L72}          ; |155| 
;** --------------------------------------------------------------------------*
$C$L66:    
           CALLP   .S2     _Stim_StopSequence,B3
$C$RL24:   ; CALL OCCURS {_Stim_StopSequence} {0}  ; |134| 
;** --------------------------------------------------------------------------*

           B       .S1     $C$L72            ; |135| 
||         ZERO    .L2     B4                ; |187| 

           STW     .D2T2   B4,*+DP(_ExectueCommand_flag) ; |187| 
           LDW     .D2T2   *++SP(8),B3       ; |188| 
           NOP             3
           ; BRANCH OCCURS {$C$L72}          ; |135| 
;** --------------------------------------------------------------------------*
$C$L67:    

           MVKL    .S1     0xa0001004,A3
||         ZERO    .L2     B4                ; |187| 

           MVKH    .S1     0xa0001004,A3

           BNOP    .S1     $C$L71,4          ; |107| 
||         LDW     .D1T1   *A3,A3            ; |106| 
||         STW     .D2T2   B4,*+DP(_ExectueCommand_flag) ; |187| 

           STW     .D2T1   A3,*+DP(_DataMode) ; |106| 
           ; BRANCH OCCURS {$C$L71}          ; |107| 
;** --------------------------------------------------------------------------*
$C$L68:    
           MVKL    .S1     0xa0001004,A3
           MVKH    .S1     0xa0001004,A3
           LDW     .D1T1   *A3,A3            ; |97| 
           MVKL    .S2     _MonitorData,B4
           MVKH    .S2     _MonitorData,B4
           NOP             2

           STW     .D2T1   A3,*B4            ; |97| 
||         SHR     .S2X    A3,16,B4          ; |98| 

           CALLP   .S2     _setCommonThresholdParams,B3
||         EXT     .S1     A3,16,16,A4       ; |98| 

$C$RL25:   ; CALL OCCURS {_setCommonThresholdParams} {0}  ; |98| 
;** --------------------------------------------------------------------------*
$C$L69:    
           ZERO    .L2     B4                ; |187| 
;** --------------------------------------------------------------------------*
$C$L70:    
           STW     .D2T2   B4,*+DP(_ExectueCommand_flag) ; |187| 
;** --------------------------------------------------------------------------*
$C$L71:    
           LDW     .D2T2   *++SP(8),B3       ; |188| 
           NOP             3
;** --------------------------------------------------------------------------*
$C$L72:    
           NOP             1
           RETNOP  .S2     B3,5              ; |188| 
           ; BRANCH OCCURS {B3}              ; |188| 
	.sect	".text"
	.clink
	.global	_main

;******************************************************************************
;* FUNCTION NAME: main                                                        *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,B0,B1,B2,B3,B4,*
;*                           B5,B6,B7,B8,B9,B10,B11,SP,A16,A17,A18,A19,A20,   *
;*                           A21,A22,A23,A24,A25,A26,A27,A28,A29,A30,A31,B16, *
;*                           B17,B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28, *
;*                           B29,B30,B31                                      *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,B0,B1,B2,B3,B4,*
;*                           B5,B6,B7,B8,B9,B10,B11,B13,DP,SP,A16,A17,A18,A19,*
;*                           A20,A21,A22,A23,A24,A25,A26,A27,A28,A29,A30,A31, *
;*                           B16,B17,B18,B19,B20,B21,B22,B23,B24,B25,B26,B27, *
;*                           B28,B29,B30,B31                                  *
;*   Local Frame Size  : 0 Args + 0 Auto + 24 Save = 24 byte                  *
;******************************************************************************
_main:
;** --------------------------------------------------------------------------*
           STW     .D2T2   B13,*SP--(8)      ; |276| 
           STDW    .D2T2   B11:B10,*SP--     ; |276| 

           STDW    .D2T1   A11:A10,*SP--     ; |276| 
||         ZERO    .L1     A3                ; |290| 

           STW     .D2T1   A3,*+DP(_ExectueCommand_flag) ; |290| 
||         ZERO    .L2     B4                ; |290| 

           STW     .D2T2   B4,*+DP(_StimSequence_Enabled) ; |286| 
||         MVKL    .S2     _StimStatus,B5
||         MVK     .L1     -1,A4             ; |289| 

           STW     .D2T1   A3,*+DP(_StimCheck_flag) ; |293| 
||         MVKH    .S2     _StimStatus,B5
||         MV      .L1     A4,A5             ; |289| 

           STDW    .D2T1   A5:A4,*B5         ; |289| 
           STW     .D2T1   A3,*+DP(_DecoderOutputValid) ; |294| 
           STW     .D2T1   A3,*+DP(_RobotStimEnable) ; |295| 

           STW     .D2T2   B4,*+DP(_frame_sync) ; |296| 
||         MVK     .L1     2,A3              ; |285| 

           STW     .D2T1   A3,*+DP(_DataMode) ; |285| 

           STW     .D2T2   B4,*+DP(_ExecutionMode) ; |298| 
||         ADD     .L1     -3,A3,A3

           STW     .D2T1   A3,*+DP(_Stim_BlankingCounter) ; |287| 
||         ZERO    .L1     A3                ; |292| 

           STW     .D2T1   A3,*+DP(_last_timer_count) ; |292| 

           STB     .D2T2   B4,*+DP(_ADCDataShift) ; |300| 
||         MVK     .S2     3000,B4           ; |291| 

           STW     .D2T2   B4,*+DP(_current_time) ; |291| 
||         MVK     .L2     1,B4              ; |301| 

           CALLP   .S2     _SpikeDetect_Setup,B3
||         STB     .D2T2   B4,*+DP(_EnableAmpBlanking) ; |301| 

$C$RL26:   ; CALL OCCURS {_SpikeDetect_Setup} {0}  ; |302| 
;** --------------------------------------------------------------------------*
           CALLP   .S2     _init_decoder,B3
$C$RL27:   ; CALL OCCURS {_init_decoder} {0}  ; |303| 
           CALLP   .S2     _MEA21_init,B3
$C$RL28:   ; CALL OCCURS {_MEA21_init} {0}   ; |304| 

           CALLP   .S2     _init_SendDataDMA,B3
||         MVK     .S1     0x36,A4           ; |305| 

$C$RL29:   ; CALL OCCURS {_init_SendDataDMA} {0}  ; |305| 
           CALLP   .S2     _timer_setup,B3
$C$RL30:   ; CALL OCCURS {_timer_setup} {0}  ; |306| 
           CALLP   .S2     _filter_setup,B3
$C$RL31:   ; CALL OCCURS {_filter_setup} {0}  ; |309| 
           MVKL    .S1     0xa0000400,A3

           MVKH    .S1     0xa0000400,A3
||         MVK     .S2     232,B5

           MVK     .S2     16640,B4          ; |312| 
||         ZERO    .L1     A4

           STW     .D1T2   B4,*A3            ; |312| 
||         ZERO    .L2     B4                ; |312| 
||         SET     .S1     A4,0x1c,0x1e,A4
||         SUB     .S2X    A3,B5,B5

           STW     .D1T2   B4,*A4            ; |312| 
||         SUBAW   .D2     B5,2,B7

           LDW     .D1T1   *A4,A3            ; |312| 
||         STW     .D2T2   B4,*B5            ; |314| 
||         MV      .L2X    A4,B6             ; |312| 

           STW     .D2T2   B4,*B6            ; |314| 
||         MV      .L1     A4,A5             ; |312| 

           LDW     .D1T1   *A5,A3            ; |314| 
||         STW     .D2T2   B4,*B7            ; |315| 
||         MV      .L1     A4,A6             ; |312| 

           STW     .D1T2   B4,*A6            ; |315| 
||         MV      .L1     A4,A7             ; |312| 

           CALLP   .S2     _Stim_SetupStimGen,B3
||         LDW     .D1T1   *A7,A3            ; |315| 

$C$RL32:   ; CALL OCCURS {_Stim_SetupStimGen} {0}  ; |318| 
           CALLP   .S2     _Stim_SetupTrigger,B3
$C$RL33:   ; CALL OCCURS {_Stim_SetupTrigger} {0}  ; |319| 
           CALLP   .S2     _RobotComm_Setup,B3
$C$RL34:   ; CALL OCCURS {_RobotComm_Setup} {0}  ; |320| 
;** --------------------------------------------------------------------------*
           ZERO    .L1     A11

           SET     .S1     A11,0x0,0xf,A11
||         ZERO    .L1     A10               ; |325| 
||         MVK     .S2     0x64,B11

;** --------------------------------------------------------------------------*
           LDW     .D2T2   *+DP(_ExectueCommand_flag),B4 ; |328| 
;** --------------------------------------------------------------------------*
;**   BEGIN LOOP $C$L73
;** --------------------------------------------------------------------------*
$C$L73:    
           NOP             4
           CMPGT   .L2     B4,0,B0           ; |328| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*      Disqualified loop: Loop contains control code
;*----------------------------------------------------------------------------*
$C$L74:    

   [!B0]   B       .S1     $C$L75
|| [!B0]   LDW     .D2T2   *+DP(_StimCheck_flag),B4 ; |333| 

   [ B0]   CALL    .S1     _ExecuteCommand   ; |330| 
   [!B0]   LDW     .D2T2   *+DP(_current_time),B10
           NOP             2
   [!B0]   CMPEQ   .L2     B4,1,B0           ; |333| 
           ; BRANCHCC OCCURS {$C$L75}  
;** --------------------------------------------------------------------------*
           ADDKPC  .S2     $C$RL35,B3,0      ; |330| 
$C$RL35:   ; CALL OCCURS {_ExecuteCommand} {0}  ; |330| 
;** --------------------------------------------------------------------------*
           LDW     .D2T2   *+DP(_StimCheck_flag),B4 ; |333| 
           LDW     .D2T2   *+DP(_current_time),B10 ; |330| 
           NOP             3
           CMPEQ   .L2     B4,1,B0           ; |333| 
;** --------------------------------------------------------------------------*
$C$L75:    

   [!B0]   B       .S1     $C$L76            ; |333| 
|| [!B0]   LDW     .D2T2   *+DP(_DecoderCheck),B4 ; |340| 

   [ B0]   CALL    .S1     _StimPatternSequence_Check ; |335| 
           NOP             3
   [!B0]   CMPEQ   .L2     B4,1,B0           ; |340| 
           ; BRANCHCC OCCURS {$C$L76}        ; |333| 
;** --------------------------------------------------------------------------*

           MV      .L1X    B10,A4            ; |335| 
||         ADDKPC  .S2     $C$RL36,B3,0      ; |335| 

$C$RL36:   ; CALL OCCURS {_StimPatternSequence_Check} {0}  ; |335| 
;** --------------------------------------------------------------------------*
           ZERO    .L2     B4                ; |336| 
           STW     .D2T2   B4,*+DP(_StimCheck_flag) ; |336| 
           LDW     .D2T2   *+DP(_DecoderCheck),B4 ; |340| 
           NOP             4
           CMPEQ   .L2     B4,1,B0           ; |340| 
;** --------------------------------------------------------------------------*
$C$L76:    

   [!B0]   B       .S1     $C$L77            ; |340| 
|| [!B0]   LDW     .D2T2   *+DP(_ExecutionMode),B4 ; |345| 

   [ B0]   CALL    .S1     _calculate_decoder_output ; |341| 
           NOP             3
   [!B0]   CMPEQ   .L2     B4,1,B0           ; |345| 
           ; BRANCHCC OCCURS {$C$L77}        ; |340| 
;** --------------------------------------------------------------------------*
           ADDKPC  .S2     $C$RL37,B3,0      ; |341| 
$C$RL37:   ; CALL OCCURS {_calculate_decoder_output} {0}  ; |341| 
;** --------------------------------------------------------------------------*
           ZERO    .L2     B4                ; |342| 
           STW     .D2T2   B4,*+DP(_DecoderCheck) ; |342| 
           LDW     .D2T2   *+DP(_ExecutionMode),B4 ; |345| 
           NOP             4
           CMPEQ   .L2     B4,1,B0           ; |345| 
;** --------------------------------------------------------------------------*
$C$L77:    

   [ B0]   BNOP    .S1     $C$L79,4          ; |345| 
|| [!B0]   LDW     .D2T2   *+DP(_ExecutionMode),B4 ; |393| 
||         MV      .L2     B0,B1             ; branch predicate copy

           CMPEQ   .L2     B4,2,B0           ; |393| 
|| [ B1]   LDW     .D2T2   *+DP(_RobotComm_flag),B4 ; |346| 

           ; BRANCHCC OCCURS {$C$L79}        ; |345| 
;** --------------------------------------------------------------------------*

   [!B0]   BNOP    .S1     $C$L74,4          ; |393| 
|| [!B0]   LDW     .D2T2   *+DP(_ExectueCommand_flag),B4 ; |328| 

           CMPGT   .L2     B4,0,B0           ; |328| 
           ; BRANCHCC OCCURS {$C$L74}        ; |393| 
;** --------------------------------------------------------------------------*
           LDW     .D2T2   *+DP(_StimTrain_flag),B0 ; |395| 
           NOP             4

   [!B0]   BNOP    .S1     $C$L74,4          ; |395| 
|| [!B0]   LDW     .D2T2   *+DP(_ExectueCommand_flag),B4 ; |328| 

           CMPGT   .L2     B4,0,B0           ; |328| 
           ; BRANCHCC OCCURS {$C$L74}        ; |395| 
;** --------------------------------------------------------------------------*
           LDW     .D2T2   *+DP(_StimTrain_flag),B4 ; |396| 
           NOP             4
           CMPEQ   .L2     B4,1,B0           ; |396| 

   [!B0]   B       .S1     $C$L78            ; |396| 
|| [!B0]   ZERO    .L2     B4                ; |399| 

   [ B0]   CALL    .S1     _StimTrain_Step   ; |397| 
|| [!B0]   STW     .D2T2   B4,*+DP(_StimTrain_flag) ; |399| 

   [!B0]   BNOP    .S1     $C$L73,3          ; |399| 
           ; BRANCHCC OCCURS {$C$L78}        ; |396| 
;** --------------------------------------------------------------------------*
           ADDKPC  .S2     $C$RL38,B3,0      ; |397| 
$C$RL38:   ; CALL OCCURS {_StimTrain_Step} {0}  ; |397| 

           BNOP    .S1     $C$L73,2          ; |399| 
||         ZERO    .L2     B4                ; |399| 

           STW     .D2T2   B4,*+DP(_StimTrain_flag) ; |399| 
;** --------------------------------------------------------------------------*
$C$L78:    
           LDW     .D2T2   *+DP(_ExectueCommand_flag),B4 ; |328| 
           NOP             1
           ; BRANCH OCCURS {$C$L73}          ; |399| 
;** --------------------------------------------------------------------------*
$C$L79:    
           MVKL    .S1     _uDecoderOutput_compressed,A3
           MVKH    .S1     _uDecoderOutput_compressed,A3
           NOP             2
           CMPEQ   .L2     B4,1,B0           ; |346| 

   [!B0]   LDW     .D2T2   *+DP(_RobotComm_flag),B4 ; |376| 
|| [ B0]   B       .S1     $C$L82            ; |346| 

           MV      .L1X    B0,A1             ; |346| branch predicate copy
   [ A1]   LDW     .D1T1   *A3,A3            ; |350| 
           NOP             2
           CMPEQ   .L2     B4,2,B0           ; |376| 
           ; BRANCHCC OCCURS {$C$L82}        ; |346| 
;** --------------------------------------------------------------------------*

   [!B0]   LDW     .D2T2   *+DP(_RobotComm_flag),B4 ; |379| 
|| [ B0]   B       .S1     $C$L81            ; |376| 

           MV      .L1X    B0,A0             ; branch predicate copy
   [ A0]   CALL    .S1     _RobotComm_Sensor ; |377| 
           NOP             2
           CMPEQ   .L2     B4,3,B0           ; |379| 
           ; BRANCHCC OCCURS {$C$L81}        ; |376| 
;** --------------------------------------------------------------------------*

   [!B0]   LDW     .D2T2   *+DP(_RobotComm_flag),B4 ; |383| 
|| [ B0]   B       .S1     $C$L80            ; |379| 

           MV      .L1X    B0,A0             ; branch predicate copy
   [ A0]   CALL    .S1     _RobotComm_Sensor ; |380| 
           NOP             2
           CMPEQ   .L2     B4,4,B0           ; |383| 
           ; BRANCHCC OCCURS {$C$L80}        ; |379| 
;** --------------------------------------------------------------------------*

   [!B0]   BNOP    .S1     $C$L74,4          ; |383| 
|| [!B0]   LDW     .D2T2   *+DP(_ExectueCommand_flag),B4 ; |328| 

           CMPGT   .L2     B4,0,B0           ; |328| 
           ; BRANCHCC OCCURS {$C$L74}        ; |383| 
;** --------------------------------------------------------------------------*
           LDW     .D2T2   *+DP(_current_time),B4 ; |390| 
           ADD     .L1     1,A10,A3          ; |388| 
           AND     .L1     3,A3,A10          ; |388| 
           CALL    .S1     _StimPatternSequence_Start ; |390| 
           ADD     .L1     A10,A10,A4        ; |390| 
           ADD     .L2     B11,B4,B4         ; |390| 
           MVK     .L1     0x1,A6            ; |390| 

           MV      .L1X    B4,A8             ; |390| 
||         ADD     .L2X    1,A4,B4           ; |390| 

           MV      .L2X    A6,B6             ; |390| 
||         ADDKPC  .S2     $C$RL39,B3,0      ; |390| 

$C$RL39:   ; CALL OCCURS {_StimPatternSequence_Start} {0}  ; |390| 
;** --------------------------------------------------------------------------*

           BNOP    .S1     $C$L73,3          ; |391| 
||         ZERO    .L2     B4                ; |391| 

           STW     .D2T2   B4,*+DP(_RobotComm_flag) ; |391| 
           LDW     .D2T2   *+DP(_ExectueCommand_flag),B4 ; |328| 
           ; BRANCH OCCURS {$C$L73}          ; |391| 
;** --------------------------------------------------------------------------*
$C$L80:    
           ADDKPC  .S2     $C$RL40,B3,1      ; |380| 
$C$RL40:   ; CALL OCCURS {_RobotComm_Sensor} {0}  ; |380| 
;** --------------------------------------------------------------------------*

           BNOP    .S1     $C$L73,3          ; |382| 
||         ZERO    .L2     B4                ; |381| 

           STW     .D2T2   B4,*+DP(_RobotComm_flag) ; |381| 
           LDW     .D2T2   *+DP(_ExectueCommand_flag),B4 ; |328| 
           ; BRANCH OCCURS {$C$L73}          ; |382| 
;** --------------------------------------------------------------------------*
$C$L81:    
           ADDKPC  .S2     $C$RL41,B3,1      ; |377| 
$C$RL41:   ; CALL OCCURS {_RobotComm_Sensor} {0}  ; |377| 
;** --------------------------------------------------------------------------*

           BNOP    .S1     $C$L73,3          ; |379| 
||         ZERO    .L2     B4                ; |378| 

           STW     .D2T2   B4,*+DP(_RobotComm_flag) ; |378| 
           LDW     .D2T2   *+DP(_ExectueCommand_flag),B4 ; |328| 
           ; BRANCH OCCURS {$C$L73}          ; |379| 
;** --------------------------------------------------------------------------*
$C$L82:    
           MVKL    .S1     $C$SW5,A4
           SHR     .S1     A3,16,A3          ; |350| 

           AND     .L1     A11,A3,A3         ; |350| 
||         MVKH    .S1     $C$SW5,A4

           SUB     .L1     A3,1,A3           ; |350| 
           CMPGTU  .L1     A3,3,A0           ; |350| 

   [!A0]   LDW     .D1T1   *+A4[A3],A3       ; |350| 
|| [ A0]   B       .S1     $C$L88            ; |350| 
|| [ A0]   ZERO    .L2     B4                ; |375| 

   [ A0]   BNOP    .S1     $C$L73,3          ; |376| 
|| [ A0]   STW     .D2T2   B4,*+DP(_RobotComm_flag) ; |375| 

   [!A0]   B       .S2X    A3                ; |350| 
           ; BRANCHCC OCCURS {$C$L88} {-5}   ; |350| 
;** --------------------------------------------------------------------------*
           NOP             5
           ; BRANCH OCCURS {A3}              ; |350| 
	.sect	".switch:_main"
	.clink
$C$SW5:	.word	$C$L86	; 0
	.word	$C$L85	; 1
	.word	$C$L84	; 2
	.word	$C$L83	; 3
	.sect	".text"
;** --------------------------------------------------------------------------*
$C$L83:    
           MVK     .L1     0x1,A4            ; |361| 
           NOP             1

           CALLP   .S2     _RobotComm_Trigger,B3
||         MV      .L2X    A4,B4             ; |361| 

$C$RL42:   ; CALL OCCURS {_RobotComm_Trigger} {0}  ; |361| 
;** --------------------------------------------------------------------------*
           BNOP    .S1     $C$L87,5          ; |362| 
           ; BRANCH OCCURS {$C$L87}          ; |362| 
;** --------------------------------------------------------------------------*
$C$L84:    

           CALLP   .S2     _RobotComm_Trigger,B3
||         MVK     .L1     0x2,A4            ; |358| 
||         MVK     .L2     0x1,B4            ; |358| 

$C$RL43:   ; CALL OCCURS {_RobotComm_Trigger} {0}  ; |358| 
;** --------------------------------------------------------------------------*
           BNOP    .S1     $C$L87,5          ; |359| 
           ; BRANCH OCCURS {$C$L87}          ; |359| 
;** --------------------------------------------------------------------------*
$C$L85:    

           CALLP   .S2     _RobotComm_Trigger,B3
||         MVK     .L1     0x1,A4            ; |355| 
||         MVK     .L2     0x2,B4            ; |355| 

$C$RL44:   ; CALL OCCURS {_RobotComm_Trigger} {0}  ; |355| 
;** --------------------------------------------------------------------------*
           BNOP    .S1     $C$L87,5          ; |356| 
           ; BRANCH OCCURS {$C$L87}          ; |356| 
;** --------------------------------------------------------------------------*
$C$L86:    
           MVK     .L1     0x2,A4            ; |352| 
           NOP             1

           CALLP   .S2     _RobotComm_Trigger,B3
||         MV      .L2X    A4,B4             ; |352| 

$C$RL45:   ; CALL OCCURS {_RobotComm_Trigger} {0}  ; |352| 
;** --------------------------------------------------------------------------*
$C$L87:    

           BNOP    .S1     $C$L73,3          ; |376| 
||         ZERO    .L2     B4                ; |375| 

           STW     .D2T2   B4,*+DP(_RobotComm_flag) ; |375| 
;** --------------------------------------------------------------------------*
$C$L88:    
           LDW     .D2T2   *+DP(_ExectueCommand_flag),B4 ; |328| 
           ; BRANCH OCCURS {$C$L73}          ; |376| 
;*****************************************************************************
;* UNDEFINED EXTERNAL REFERENCES                                             *
;*****************************************************************************
	.global	_MEA21_init
	.global	_init_SendDataDMA
	.global	_SpikeDetect_Setup
	.global	_setThresholdParams
	.global	_setCommonThresholdParams
	.global	_Stim_LoadPattern
	.global	_Stim_SetupStimGen
	.global	_Stim_SetupTrigger
	.global	_Stim_Trigger
	.global	_Stim_LoadElectrodeConfig
	.global	_Stim_LoadStimSequenceList
	.global	_Stim_StartSequence
	.global	_Stim_StopSequence
	.global	_StimPatternSequence_Start
	.global	_StimPatternSequence_Check
	.global	_StimPatternSequence_LoadPatterBuffer
	.global	_StimPatternSequence_LoadPatternSequence
	.global	_timer_setup
	.global	_setup_decoder
	.global	_init_decoder
	.global	_calculate_decoder_output
	.global	_setup_decoder_2
	.global	_RobotComm_Setup
	.global	_RobotComm_Trigger
	.global	_RobotComm_Sensor
	.global	_StimTrain_Setup
	.global	_StimTrain_Trigger
	.global	_StimTrain_Step
	.global	_current_time
	.global	_last_timer_count
	.global	_DataMode
	.global	_StimSequence_Enabled
	.global	_Stim_BlankingCounter
	.global	_StimStatus
	.global	_ExectueCommand_flag
	.global	_StimCheck_flag
	.global	_RobotComm_flag
	.global	_RobotStimEnable
	.global	_ADCDataShift
	.global	_EnableAmpBlanking
	.global	_frame_sync
	.global	_ExecutionMode
	.global	_StimTrain_flag
	.global	_MonitorData
	.global	_uDecoderOutput_compressed
	.global	_DecoderOutputValid
	.global	_DecoderCheck

;******************************************************************************
;* BUILD ATTRIBUTES                                                           *
;******************************************************************************
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_needed(0)
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_preserved(0)
	.battr "TI", Tag_File, 1, Tag_Tramps_Use_SOC(1)
