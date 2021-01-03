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

;*****************************************************************************
;* CINIT RECORDS                                                             *
;*****************************************************************************
	.sect	".cinit"
	.align	8
	.field  	4,32
	.field  	_timestamp$1+0,32
	.field	0,32			; _timestamp$1 @ 0

	.sect	".cinit"
	.align	8
	.field  	4,32
	.field  	_led$3+0,32
	.field	0,32			; _led$3 @ 0

	.bss	_timestamp$1,4,4
	.bss	_segment$2,4,4
	.bss	_led$3,4,4
;	opt6x C:\\Users\\45c\\AppData\\Local\\Temp\\096002 C:\\Users\\45c\\AppData\\Local\\Temp\\096004 
	.sect	".text:retain"
	.retain
	.retainrefs
	.global	_interrupt8

;******************************************************************************
;* FUNCTION NAME: interrupt8                                                  *
;*                                                                            *
;*   Regs Modified     : A0,A3,B0,SP                                          *
;*   Regs Used         : A0,A3,B0,DP,SP                                       *
;*   Local Frame Size  : 0 Args + 0 Auto + 12 Save = 12 byte                  *
;******************************************************************************
_interrupt8:
;** --------------------------------------------------------------------------*
           STW     .D2T2   B0,*SP--(16)      ; |33| 

           STW     .D2T1   A3,*+SP(12)       ; |33| 
||         MVKL    .S1     0xa0000428,A3

           MVKH    .S1     0xa0000428,A3
||         STW     .D2T1   A0,*+SP(8)        ; |33| 

           LDW     .D1T1   *A3,A0            ; |41| 
           MVKL    .S1     0x17fffc00,A3
           MVKH    .S1     0x17fffc00,A3
           NOP             2
           LDW     .D1T1   *-A0[A3],A3       ; |42| 
   [!A0]   LDW     .D2T2   *+DP(_ExectueCommand_flag),B0 ; |46| 
   [ A0]   MVK     .L2     0x1,B0            ; |46| 
           LDW     .D2T1   *+SP(8),A0        ; |52| 
           NOP             2
   [!B0]   STW     .D2T1   A3,*+DP(_ExectueCommand_flag) ; |47| 

           RET     .S2     IRP               ; |52| 
||         LDW     .D2T1   *+SP(12),A3       ; |52| 

           LDW     .D2T2   *++SP(16),B0      ; |52| 
           NOP             4
           ; BRANCH OCCURS {IRP}             ; |52| 
	.sect	".text:retain"
	.retain
	.retainrefs
	.global	_interrupt7

;******************************************************************************
;* FUNCTION NAME: interrupt7                                                  *
;*                                                                            *
;*   Regs Modified     : B4,B5,B6,B7,SP                                       *
;*   Regs Used         : B4,B5,B6,B7,DP,SP                                    *
;*   Local Frame Size  : 0 Args + 0 Auto + 16 Save = 16 byte                  *
;******************************************************************************
_interrupt7:
;** --------------------------------------------------------------------------*
           STW     .D2T2   B5,*SP--(16)      ; |178| 
           STW     .D2T2   B4,*+SP(4)        ; |178| 
           LDW     .D2T2   *+DP(_gpioRegs),B4 ; |180| 
           STDW    .D2T2   B7:B6,*+SP(8)     ; |178| 
           LDW     .D2T2   *+DP(_led$3),B5   ; |180| 
           NOP             2
           LDW     .D2T2   *+B4(20),B6       ; |180| 
           NOP             3
           SHL     .S2     B5,2,B7           ; |180| 

           AND     .L2     -5,B6,B6          ; |180| 
||         AND     .D2     4,B7,B7           ; |180| 
||         SUB     .S2     1,B5,B5           ; |181| 

           STW     .D2T2   B5,*+DP(_led$3)   ; |181| 
||         OR      .L2     B7,B6,B5          ; |180| 

           STW     .D2T2   B5,*+B4(20)       ; |180| 
           LDDW    .D2T2   *+SP(8),B7:B6     ; |182| 

           RET     .S2     IRP               ; |182| 
||         LDW     .D2T2   *+SP(4),B4        ; |182| 

           LDW     .D2T2   *++SP(16),B5      ; |182| 
           NOP             4
           ; BRANCH OCCURS {IRP}             ; |182| 
	.sect	".text:retain"
	.retain
	.retainrefs
	.global	_interrupt6

;******************************************************************************
;* FUNCTION NAME: interrupt6                                                  *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,SP,A16,A17,A18,A19,A20,A21,A22,A23,A24, *
;*                           A25,A26,A27,A28,A29,A30,A31,B16,B17,B18,B19,B20, *
;*                           B21,B22,B23,B24,B25,B26,B27,B28,B29,B30,B31      *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,DP,SP,A16,A17,A18,A19,A20,A21,A22,A23,  *
;*                           A24,A25,A26,A27,A28,A29,A30,A31,B16,B17,B18,B19, *
;*                           B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B30,B31  *
;*   Local Frame Size  : 0 Args + 0 Auto + 220 Save = 220 byte                *
;******************************************************************************
_interrupt6:
;** --------------------------------------------------------------------------*
           ADDK    .S2     -224,SP           ; |67| 
           STDW    .D2T2   B1:B0,*+SP(64)    ; |67| 
           STDW    .D2T1   A3:A2,*+SP(32)    ; |67| 

           MVC     .S2     ILC,B0            ; |67| 
||         STDW    .D2T2   B5:B4,*+SP(72)    ; |67| 

           STW     .D2T2   B0,*+SP(16)       ; |67| 
           STW     .D2T2   B3,*+SP(20)       ; |67| 
           STDW    .D2T2   B31:B30,*+SP(216) ; |67| 
           STDW    .D2T2   B29:B28,*+SP(208) ; |67| 
           STDW    .D2T2   B27:B26,*+SP(200) ; |67| 
           STDW    .D2T2   B25:B24,*+SP(192) ; |67| 
           STDW    .D2T2   B23:B22,*+SP(184) ; |67| 
           STDW    .D2T2   B21:B20,*+SP(176) ; |67| 
           STDW    .D2T2   B19:B18,*+SP(168) ; |67| 
           STDW    .D2T2   B17:B16,*+SP(160) ; |67| 
           STDW    .D2T1   A27:A26,*+SP(136) ; |67| 
           STDW    .D2T1   A25:A24,*+SP(128) ; |67| 
           STDW    .D2T1   A23:A22,*+SP(120) ; |67| 
           STDW    .D2T1   A21:A20,*+SP(112) ; |67| 
           STDW    .D2T1   A19:A18,*+SP(104) ; |67| 
           STDW    .D2T1   A17:A16,*+SP(96)  ; |67| 
           STDW    .D2T2   B9:B8,*+SP(88)    ; |67| 
           STDW    .D2T2   B7:B6,*+SP(80)    ; |67| 

           MVC     .S2     RILC,B0           ; |67| 
||         MVKL    .S1     0x2a01074,A3
||         STW     .D2T2   B2,*+SP(224)      ; |67| 

           STW     .D2T2   B0,*+SP(12)       ; |67| 
||         MVC     .S2     ITSR,B0           ; |67| 
||         MVKH    .S1     0x2a01074,A3

           LDW     .D1T2   *A3,B4            ; |78| 
||         STDW    .D2T1   A29:A28,*+SP(144) ; |67| 

           STDW    .D2T1   A9:A8,*+SP(56)    ; |67| 
           STDW    .D2T1   A7:A6,*+SP(48)    ; |67| 
           STDW    .D2T1   A5:A4,*+SP(40)    ; |67| 
           STDW    .D2T1   A1:A0,*+SP(24)    ; |67| 

           SET     .S2     B4,20,20,B4       ; |78| 
||         STW     .D2T2   B0,*+SP(8)        ; |67| 

           CALLP   .S2     _timer_tic,B3
||         STW     .D1T2   B4,*A3            ; |78| 
||         STDW    .D2T1   A31:A30,*+SP(152) ; |67| 

$C$RL0:    ; CALL OCCURS {_timer_tic} {0}    ; |80| 
;** --------------------------------------------------------------------------*

           CALLP   .S2     _CopyDataToInternal,B3
||         LDBU    .D2T1   *+DP(_ADCDataShift),A4 ; |84| 

$C$RL1:    ; CALL OCCURS {_CopyDataToInternal} {0}  ; |84| 
;** --------------------------------------------------------------------------*

           LDW     .D2T2   *+DP(_DecoderOutputValid),B9 ; |97| 
||         MVKL    .S1     _SpikeChannel,A4
||         MVKL    .S2     _StimStatus,B8

           MVKH    .S1     _SpikeChannel,A4
||         MVKH    .S2     _StimStatus,B8

           LDDW    .D1T1   *A4,A9:A8         ; |91| 
||         LDDW    .D2T2   *B8,B5:B4         ; |86| 
||         MVKL    .S2     _SendBuffer+256,B7
||         MVKL    .S1     _uDecoderOutput_compressed,A3

           LDDW    .D1T1   *+A4(8),A7:A6     ; |93| 
||         MVK     .L1     -1,A4             ; |87| 
||         MVKH    .S2     _SendBuffer+256,B7
||         MVKH    .S1     _uDecoderOutput_compressed,A3

           MV      .L1     A4,A5             ; |87| 
||         ADDAD   .D2     B7,3,B6

           CMPEQ   .L2     B9,1,B0           ; |97| 
||         STDW    .D2T1   A5:A4,*B8         ; |87| 
||         ZERO    .S2     B8                ; |104| 
||         MVK     .L1     0x5,A4            ; |99| 

   [!B0]   BNOP    .S1     $C$L4,2           ; |104| 
|| [ B0]   SUB     .L1     A4,2,A4
|| [!B0]   STW     .D2T2   B8,*B6            ; |104| 

           STDW    .D2T2   B5:B4,*B7         ; |86| 
           STDW    .D2T1   A9:A8,*+B7(8)     ; |91| 
           STDW    .D2T1   A7:A6,*+B7(16)    ; |93| 
           ; BRANCHCC OCCURS {$C$L4}         ; |104| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\irq.c
;*      Loop source line                 : 99
;*      Loop opening brace source line   : 99
;*      Loop closing brace source line   : 101
;*      Known Minimum Trip Count         : 5                    
;*      Known Maximum Trip Count         : 5                    
;*      Known Max Trip Count Factor      : 5
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
$C$L1:    ; PIPED LOOP PROLOG

           SPLOOPD 2       ;8                ; (P) 
||         MVC     .S2X    A4,ILC

;** --------------------------------------------------------------------------*
$C$L2:    ; PIPED LOOP KERNEL
           LDDW    .D1T1   *A3++,A5:A4       ; |100| (P) <0,0> 
           NOP             4
           MV      .L2X    A5,B5             ; |100| (P) <0,5> Define a twin register
           MV      .L2X    A4,B4             ; |100| <0,6> Define a twin register

           SPKERNEL 2,0
||         STDW    .D2T2   B5:B4,*B6++       ; |100| <0,7> 

;** --------------------------------------------------------------------------*
$C$L3:    ; PIPED LOOP EPILOG
           NOP             1
           ZERO    .L2     B4                ; |102| 
;** --------------------------------------------------------------------------*
           STW     .D2T2   B4,*+DP(_DecoderOutputValid) ; |102| 
;** --------------------------------------------------------------------------*
$C$L4:    
           CALLP   .S2     _SendDataDMA,B3
$C$RL2:    ; CALL OCCURS {_SendDataDMA} {0}  ; |114| 
;** --------------------------------------------------------------------------*
           CALLP   .S2     _SpikeDetect,B3
$C$RL3:    ; CALL OCCURS {_SpikeDetect} {0}  ; |117| 
           CALLP   .S2     _update_decoder_state,B3
$C$RL4:    ; CALL OCCURS {_update_decoder_state} {0}  ; |118| 
;** --------------------------------------------------------------------------*

           LDW     .D2T2   *+DP(_timestamp$1),B0 ; |128| 
||         MVK     .L2     1,B5              ; |125| 
||         MVKL    .S2     0xa000002c,B6
||         ZERO    .L1     A5
||         MVK     .S1     1028,A4           ; |130| 
||         ZERO    .D1     A3                ; |130| 

           SET     .S1     A5,0x1c,0x1e,A5
           MVKH    .S2     0xa000002c,B6
           STW     .D2T2   B5,*+DP(_StimCheck_flag) ; |125| 
           MVKL    .S2     0xc350,B4

   [!B0]   B       .S1     $C$L6             ; |128| 
|| [!B0]   STW     .D2T1   A4,*B6            ; |130| 

   [!B0]   STW     .D1T1   A3,*A5            ; |130| 

   [!B0]   LDW     .D1T1   *A5,A3            ; |130| 
|| [!B0]   LDW     .D2T2   *+DP(_frame_sync),B6 ; |146| 

   [!B0]   LDW     .D2T2   *+DP(_ExecutionMode),B5 ; |148| 
           MVKH    .S2     0xc350,B4
           CMPEQ   .L2     B0,B4,B1          ; |132| 
           ; BRANCHCC OCCURS {$C$L6}         ; |128| 
;** --------------------------------------------------------------------------*

           B       .S1     $C$L5             ; |138| 
||         MVKL    .S2     0x186a0,B4
||         MV      .L1X    B6,A3             ; |134| 
||         MV      .L2X    A5,B6             ; |134| 
||         ADD     .D1     -4,A4,A4
||         ZERO    .D2     B5                ; |134| 

   [ B1]   STW     .D1T1   A4,*A3            ; |134| 
|| [ B1]   STW     .D2T2   B5,*B6            ; |134| 
||         MVKH    .S2     0x186a0,B4

   [ B1]   LDW     .D1T1   *A5,A3            ; |134| 
||         CMPEQ   .L2     B0,B4,B2          ; |136| 

           LDW     .D2T2   *+DP(_frame_sync),B6 ; |146| 
|| [ B1]   ZERO    .L2     B2                ; |134| 

           LDW     .D2T2   *+DP(_ExecutionMode),B5 ; |148| 
   [ B2]   MVK     .L2     0xffffffff,B0     ; |138| 
           ; BRANCH OCCURS {$C$L5}           ; |138| 
;** --------------------------------------------------------------------------*
$C$L5:    
           NOP             1
;** --------------------------------------------------------------------------*
$C$L6:    

           LDW     .D2T2   *+DP(_current_time),B7 ; |145| 
||         ADD     .L2     1,B0,B4           ; |144| 

           SUB     .L2     B4,B6,B0          ; |146| 
||         STW     .D2T2   B4,*+DP(_timestamp$1) ; |144| 

           CMPEQ   .L2     B5,1,B1           ; |148| 
   [ B1]   BNOP    .S1     $C$L7,1           ; |148| 
           ADD     .L2     1,B7,B4           ; |145| 

   [ B1]   CALL    .S1     __remu            ; |149| 
||         STW     .D2T2   B4,*+DP(_current_time) ; |145| 
||         MVK     .S2     0x30d4,B4         ; |149| 

   [!B1]   LDW     .D2T2   *+DP(_ExecutionMode),B4 ; |162| 
           MV      .L1X    B0,A4             ; |149| 
           ; BRANCHCC OCCURS {$C$L7}         ; |148| 
;** --------------------------------------------------------------------------*
           NOP             3
           CMPEQ   .L2     B4,2,B1           ; |162| 
   [!B1]   B       .S1     $C$L10            ; |162| 
   [ B1]   CALL    .S1     __remu            ; |163| 
           MVK     .S2     0x30d4,B4         ; |163| 
   [!B1]   LDW     .D2T2   *+DP(_DecoderCheck),B4 ; |170| 
           NOP             2
           ; BRANCHCC OCCURS {$C$L10}        ; |162| 
;** --------------------------------------------------------------------------*
           ADDKPC  .S2     $C$RL5,B3,0       ; |163| 
$C$RL5:    ; CALL OCCURS {__remu} {0}        ; |163| 
;** --------------------------------------------------------------------------*

           BNOP    .S1     $C$L10,2          ; |165| 
||         MVK     .L2     1,B4              ; |165| 
||         MV      .L1     A4,A0             ; |163| 

   [!A0]   STW     .D2T2   B4,*+DP(_StimTrain_flag) ; |165| 
           LDW     .D2T2   *+DP(_DecoderCheck),B4 ; |170| 
           NOP             1
           ; BRANCH OCCURS {$C$L10}          ; |165| 
;** --------------------------------------------------------------------------*
$C$L7:    
           ADDKPC  .S2     $C$RL6,B3,2       ; |149| 
$C$RL6:    ; CALL OCCURS {__remu} {0}        ; |149| 
;** --------------------------------------------------------------------------*

           MVK     .S2     250,B4            ; |153| 
||         MV      .L2X    A4,B0             ; |149| 
||         MVK     .L1     1,A3              ; |151| 

   [!B0]   B       .S1     $C$L9             ; |149| 
||         CMPEQ   .L2X    A4,B4,B2          ; |153| 
|| [ B0]   MVK     .S2     750,B4            ; |156| 
|| [!B0]   STW     .D2T1   A3,*+DP(_RobotComm_flag) ; |151| 
|| [ B0]   MVK     .L1     2,A3              ; |154| 

   [!B0]   ZERO    .S2     B2                ; |154| nullify predicate
|| [ B0]   CMPEQ   .L2     B0,B4,B1          ; |156| 

   [ B2]   BNOP    .S1     $C$L8,3           ; |153| 
           ; BRANCHCC OCCURS {$C$L9}         ; |149| 
;** --------------------------------------------------------------------------*

   [!B2]   B       .S1     $C$L10            ; |160| 
|| [!B2]   MVK     .S2     1250,B4           ; |159| 
|| [ B2]   STW     .D2T1   A3,*+DP(_RobotComm_flag) ; |154| 

   [!B2]   CMPEQ   .L2     B0,B4,B0          ; |159| 
|| [!B2]   MVK     .S2     3,B4              ; |157| 
|| [ B2]   B       .S1     $C$L11            ; |155| 

           ; BRANCHCC OCCURS {$C$L8}         ; |153| 
;** --------------------------------------------------------------------------*

   [!B1]   MVK     .L1     4,A3              ; |160| 
|| [ B1]   ZERO    .L2     B0                ; |160| 
|| [ B1]   STW     .D2T2   B4,*+DP(_RobotComm_flag) ; |157| 

   [ B0]   STW     .D2T1   A3,*+DP(_RobotComm_flag) ; |160| 
           LDW     .D2T2   *+DP(_DecoderCheck),B4 ; |170| 
           NOP             1
           ; BRANCH OCCURS {$C$L10}          ; |160| 
;** --------------------------------------------------------------------------*
$C$L8:    
           LDW     .D2T2   *+DP(_DecoderCheck),B4 ; |170| 
           NOP             4
           ; BRANCH OCCURS {$C$L11}          ; |155| 
;** --------------------------------------------------------------------------*
$C$L9:    
           LDW     .D2T2   *+DP(_DecoderCheck),B4 ; |170| 
           NOP             1
;** --------------------------------------------------------------------------*
$C$L10:    
           NOP             3
;** --------------------------------------------------------------------------*
$C$L11:    
           CMPLT   .L2     B4,2,B0           ; |170| 
   [!B0]   LDW     .D2T2   *+DP(_DecoderCheck),B4 ; |170| 
           CALL    .S1     _timer_toc        ; |172| 
           ADDKPC  .S2     $C$RL7,B3,2       ; |172| 
   [!B0]   SUB     .L2     B4,1,B4           ; |170| 
   [!B0]   STW     .D2T2   B4,*+DP(_DecoderCheck) ; |170| 
$C$RL7:    ; CALL OCCURS {_timer_toc} {0}    ; |172| 
;** --------------------------------------------------------------------------*
           LDW     .D2T2   *+SP(16),B0       ; |173| 
           STW     .D2T1   A4,*+DP(_last_timer_count) ; |172| 
           LDW     .D2T2   *+SP(20),B3       ; |173| 
           LDDW    .D2T1   *+SP(24),A1:A0    ; |173| 
           LDDW    .D2T1   *+SP(32),A3:A2    ; |173| 

           MVC     .S2     B0,ILC            ; |173| 
||         LDW     .D2T2   *+SP(12),B0       ; |173| 

           LDDW    .D2T1   *+SP(48),A7:A6    ; |173| 
           LDDW    .D2T1   *+SP(56),A9:A8    ; |173| 
           LDDW    .D2T2   *+SP(72),B5:B4    ; |173| 
           LDDW    .D2T2   *+SP(80),B7:B6    ; |173| 
           LDDW    .D2T2   *+SP(88),B9:B8    ; |173| 
           LDDW    .D2T1   *+SP(96),A17:A16  ; |173| 
           LDDW    .D2T1   *+SP(104),A19:A18 ; |173| 
           LDDW    .D2T1   *+SP(112),A21:A20 ; |173| 
           LDDW    .D2T1   *+SP(120),A23:A22 ; |173| 
           LDDW    .D2T1   *+SP(128),A25:A24 ; |173| 
           LDDW    .D2T1   *+SP(136),A27:A26 ; |173| 
           LDDW    .D2T1   *+SP(144),A29:A28 ; |173| 
           LDDW    .D2T1   *+SP(152),A31:A30 ; |173| 
           LDDW    .D2T2   *+SP(160),B17:B16 ; |173| 
           LDDW    .D2T2   *+SP(168),B19:B18 ; |173| 
           LDDW    .D2T2   *+SP(176),B21:B20 ; |173| 
           LDDW    .D2T2   *+SP(184),B23:B22 ; |173| 
           LDDW    .D2T2   *+SP(192),B25:B24 ; |173| 
           LDDW    .D2T2   *+SP(200),B27:B26 ; |173| 
           MVC     .S2     B0,RILC           ; |173| 
           LDW     .D2T2   *+SP(8),B0        ; |173| 
           LDDW    .D2T2   *+SP(208),B29:B28 ; |173| 
           LDDW    .D2T2   *+SP(216),B31:B30 ; |173| 
           LDW     .D2T2   *+SP(224),B2      ; |173| 
           LDDW    .D2T1   *+SP(40),A5:A4    ; |173| 
           MVC     .S2     B0,ITSR           ; |173| 
           RET     .S2     IRP               ; |173| 
           LDDW    .D2T2   *+SP(64),B1:B0    ; |173| 
           ADDK    .S2     224,SP            ; |173| 
           NOP             3
           ; BRANCH OCCURS {IRP}             ; |173| 
	.sect	".text:retain"
	.retain
	.retainrefs
	.global	_interrupt5

;******************************************************************************
;* FUNCTION NAME: interrupt5                                                  *
;*                                                                            *
;*   Regs Modified     :                                                      *
;*   Regs Used         :                                                      *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_interrupt5:
;** --------------------------------------------------------------------------*
           RET     .S2     IRP               ; |63| 
           NOP             5
           ; BRANCH OCCURS {IRP}             ; |63| 
	.sect	".text:retain"
	.retain
	.retainrefs
	.global	_interrupt4

;******************************************************************************
;* FUNCTION NAME: interrupt4                                                  *
;*                                                                            *
;*   Regs Modified     :                                                      *
;*   Regs Used         :                                                      *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_interrupt4:
;** --------------------------------------------------------------------------*
           RET     .S2     IRP               ; |57| 
           NOP             5
           ; BRANCH OCCURS {IRP}             ; |57| 
;*****************************************************************************
;* UNDEFINED EXTERNAL REFERENCES                                             *
;*****************************************************************************
	.global	_timer_tic
	.global	_timer_toc
	.global	_CopyDataToInternal
	.global	_SendDataDMA
	.global	_SpikeDetect
	.global	_update_decoder_state
	.global	_current_time
	.global	_last_timer_count
	.global	_StimStatus
	.global	_SpikeChannel
	.global	_ExectueCommand_flag
	.global	_StimCheck_flag
	.global	_RobotComm_flag
	.global	_ADCDataShift
	.global	_frame_sync
	.global	_ExecutionMode
	.global	_StimTrain_flag
	.global	_gpioRegs
	.global	_uDecoderOutput_compressed
	.global	_DecoderOutputValid
	.global	_DecoderCheck
	.global	_SendBuffer
	.global	__remu

;******************************************************************************
;* BUILD ATTRIBUTES                                                           *
;******************************************************************************
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_needed(0)
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_preserved(0)
	.battr "TI", Tag_File, 1, Tag_Tramps_Use_SOC(1)
