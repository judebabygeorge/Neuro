;******************************************************************************
;* TMS320C6x C/C++ Codegen                                          PC v7.4.2 *
;* Date/Time created: Sat May 31 10:51:01 2014                                *
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
	.field  	_devRegs+0,32
	.field	44564480,32			; _devRegs @ 0

	.global	_MeaData
_MeaData:	.usect	".far",520,8
	.global	_MonitorData
_MonitorData:	.usect	".far",1024,8
	.global	_devRegs
	.bss	_devRegs,4,4
;	opt6x C:\\Users\\45c\\AppData\\Local\\Temp\\053003 C:\\Users\\45c\\AppData\\Local\\Temp\\053005 
	.sect	".text"
	.clink
	.global	_init_timer

;******************************************************************************
;* FUNCTION NAME: init_timer                                                  *
;*                                                                            *
;*   Regs Modified     : A0,A3,A4,A5,A6,B4,B5,B6                              *
;*   Regs Used         : A0,A3,A4,A5,A6,B3,B4,B5,B6                           *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_init_timer:
;** --------------------------------------------------------------------------*
           MVKL    .S1     0x2ac0004,A3
           MVKH    .S1     0x2ac0004,A3
           MVKL    .S2     0xf0a0b00,B4

           MV      .L2X    A3,B5             ; |75| 
||         MVKH    .S2     0xf0a0b00,B4

           ADD     .L1     4,A3,A6
||         LDW     .D1T1   *A3,A3            ; |75| 
||         STW     .D2T2   B4,*B5            ; |75| 

           LDW     .D1T1   *A6,A4            ; |76| 
           ZERO    .L1     A0
           NOP             3
           SET     .S1     A4,6,6,A3         ; |76| 
           STW     .D1T1   A3,*A6            ; |76| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\MEA21_lib.c
;*      Loop source line                 : 77
;*      Loop opening brace source line   : 77
;*      Loop closing brace source line   : 79
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 1
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 1
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     1*       0     
;*      .D units                     1*       0     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             1*       0     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          1        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1*       0     
;*      Bound(.L .S .D .LS .LSD)     1*       0     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 4  Unsafe schedule for irregular loop
;*         ii = 4  Unsafe schedule for irregular loop
;*         ii = 4  Unsafe schedule for irregular loop
;*         ii = 4  Did not find schedule
;*         ii = 5  Unsafe schedule for irregular loop
;*         ii = 5  Unsafe schedule for irregular loop
;*         ii = 5  Unsafe schedule for irregular loop
;*         ii = 5  Did not find schedule
;*         ii = 6  Unsafe schedule for irregular loop
;*         ii = 6  Unsafe schedule for irregular loop
;*         ii = 6  Unsafe schedule for irregular loop
;*         ii = 6  Did not find schedule
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
$C$L1:    ; PIPED LOOP PROLOG
   [!A0]   SPLOOPW 7       ;14               ; (P) 
;** --------------------------------------------------------------------------*
$C$L2:    ; PIPED LOOP KERNEL
           NOP             2

           SPMASK          D1
||         ADDAW   .D1     A6,3,A5

   [!A0]   LDW     .D1T1   *A5,A4            ; |78| (P) <0,3>  ^ 
           NOP             4
           EXTU    .S1     A4,20,29,A3       ; |78| <0,8>  ^ 
           MV      .L1     A3,A0             ; |78| <0,9>  ^ 
           NOP             2
           NOP             1
           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L3:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
           MV      .L2     B5,B6
           LDW     .D2T2   *B6,B6            ; |83| 
           STW     .D2T2   B4,*B5            ; |83| 
           LDW     .D1T1   *A6,A3            ; |84| 
           ZERO    .L1     A0
           NOP             3
           SET     .S1     A3,8,8,A3         ; |84| 
           STW     .D1T1   A3,*A6            ; |84| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\MEA21_lib.c
;*      Loop source line                 : 85
;*      Loop opening brace source line   : 85
;*      Loop closing brace source line   : 87
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 1
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 1
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     1*       0     
;*      .D units                     1*       0     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             1*       0     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          1        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1*       0     
;*      Bound(.L .S .D .LS .LSD)     1*       0     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 4  Unsafe schedule for irregular loop
;*         ii = 4  Unsafe schedule for irregular loop
;*         ii = 4  Unsafe schedule for irregular loop
;*         ii = 4  Did not find schedule
;*         ii = 5  Unsafe schedule for irregular loop
;*         ii = 5  Unsafe schedule for irregular loop
;*         ii = 5  Unsafe schedule for irregular loop
;*         ii = 5  Did not find schedule
;*         ii = 6  Unsafe schedule for irregular loop
;*         ii = 6  Unsafe schedule for irregular loop
;*         ii = 6  Unsafe schedule for irregular loop
;*         ii = 6  Did not find schedule
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
$C$L4:    ; PIPED LOOP PROLOG
   [!A0]   SPLOOPW 7       ;14               ; (P) 
;** --------------------------------------------------------------------------*
$C$L5:    ; PIPED LOOP KERNEL
           NOP             3
   [!A0]   LDW     .D1T1   *A5,A4            ; |86| (P) <0,3>  ^ 
           NOP             4
           EXTU    .S1     A4,17,29,A3       ; |86| <0,8>  ^ 
           MV      .L1     A3,A0             ; |86| <0,9>  ^ 
           NOP             2
           NOP             1
           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L6:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
           RETNOP  .S2     B3,5              ; |88| 
           ; BRANCH OCCURS {B3}              ; |88| 
	.sect	".text"
	.clink
	.global	_init_qdma

;******************************************************************************
;* FUNCTION NAME: init_qdma                                                   *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,B10,B11,SP,A16,A17,A18,A19,A20,A21,A22, *
;*                           A23,A24,A25,A26,A27,A28,A29,A30,A31,B16,B17,B18, *
;*                           B19,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B30, *
;*                           B31                                              *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,B10,B11,DP,SP,A16,A17,A18,A19,A20,A21,  *
;*                           A22,A23,A24,A25,A26,A27,A28,A29,A30,A31,B16,B17, *
;*                           B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29, *
;*                           B30,B31                                          *
;*   Local Frame Size  : 0 Args + 0 Auto + 8 Save = 8 byte                    *
;******************************************************************************
_init_qdma:
;** --------------------------------------------------------------------------*
           MVKL    .S1     0x2a00200,A4

           MVKH    .S1     0x2a00200,A4
||         STW     .D2T2   B11,*SP--(8)      ; |389| 

           LDW     .D1T1   *A4,A3            ; |394| 
           MVK     .S1     320,A5            ; |394| 
           MV      .L2X    A4,B4             ; |394| 
           MVKL    .S2     0x2a01088,B6
           MVKH    .S2     0x2a01088,B6
           CLR     .S1     A3,5,13,A3        ; |394| 
           OR      .L1     A5,A3,A3          ; |394| 
           STW     .D2T1   A3,*B4            ; |394| 
           LDW     .D1T1   *A4,A3            ; |395| 
           MVK     .S2     96,B4
           ADD     .L2X    A4,B4,B4
           STW     .D2T2   B10,*+SP(4)       ; |389| 
           MVKL    .S2     0x2a04140,B10
           CLR     .S1     A3,4,4,A3         ; |395| 
           OR      .L1     12,A3,A3          ; |395| 
           STW     .D1T1   A3,*A4            ; |395| 
           LDW     .D2T2   *B4,B5            ; |396| 
           MVKH    .S2     0x2a04140,B10
           MV      .L2     B3,B11            ; |389| 
           MV      .L1X    B10,A4            ; |400| 
           MVK     .S1     0x20,A6           ; |400| 
           AND     .L2     -8,B5,B5          ; |396| 
           STW     .D2T2   B5,*B4            ; |396| 
           LDW     .D2T2   *B6,B4            ; |398| 
           NOP             4
           OR      .L2     1,B4,B4           ; |398| 

           CALLP   .S2     _memset,B3
||         STW     .D2T2   B4,*B6            ; |398| 
||         ZERO    .L2     B4                ; |400| 

$C$RL0:    ; CALL OCCURS {_memset} {0}       ; |400| 
;** --------------------------------------------------------------------------*
           LDW     .D2T1   *B10,A3           ; |401| 
           MVKL    .S1     0xa000,A4
           MVKH    .S1     0xa000,A4
           MVKL    .S1     _MeaData+4,A5
           MVKH    .S1     _MeaData+4,A5
           SET     .S1     A3,20,20,A3       ; |401| 
           STW     .D2T1   A3,*B10           ; |401| 
           LDW     .D2T2   *B10,B4           ; |402| 
           ZERO    .L2     B5
           MVKH    .S2     0x2a00000,B5
           MVK     .S2     788,B6            ; |413| 
           MVK     .S2     4208,B7           ; |416| 
           OR      .L2     8,B4,B4           ; |402| 
           STW     .D2T2   B4,*B10           ; |402| 
           LDW     .D2T2   *B10,B4           ; |403| 
           MV      .L2     B11,B3            ; |422| 
           NOP             3
           OR      .L2     4,B4,B4           ; |403| 
           STW     .D2T2   B4,*B10           ; |403| 
           LDW     .D2T1   *B10,A3           ; |404| 
           NOP             4
           CLR     .S1     A3,12,17,A3       ; |404| 
           OR      .L1     A4,A3,A3          ; |404| 
           STW     .D2T1   A3,*B10           ; |404| 
           LDW     .D2T2   *+B10(4),B4       ; |405| 
           STW     .D2T1   A5,*+B10(4)       ; |405| 
           LDW     .D2T1   *+B10(8),A3       ; |406| 
           MVK     .S1     488,A4            ; |406| 
           NOP             3
           PACKHL2 .L1     A3,A4,A3          ; |406| 
           STW     .D2T1   A3,*+B10(8)       ; |406| 
           LDW     .D2T1   *+B10(8),A3       ; |407| 
           MVK     .S2     788,B4            ; |413| 
           ADD     .L2     B4,B5,B4          ; |413| 
           NOP             2
           EXTU    .S1     A3,16,16,A3       ; |407| 
           SET     .S1     A3,16,16,A3       ; |407| 
           STW     .D2T1   A3,*+B10(8)       ; |407| 
           LDW     .D2T1   *+B10(16),A4      ; |408| 
           ZERO    .L1     A3
           MVKH    .S1     0x1e80000,A3
           NOP             2
           EXTU    .S1     A4,16,16,A4       ; |408| 
           OR      .L1     A3,A4,A4          ; |408| 
           STW     .D2T1   A4,*+B10(16)      ; |408| 
           LDW     .D2T1   *+B10(16),A4      ; |409| 
           NOP             4
           EXTU    .S1     A4,16,16,A4       ; |409| 
           OR      .L1     A3,A4,A3          ; |409| 
           STW     .D2T1   A3,*+B10(16)      ; |409| 
           LDW     .D2T1   *+B10(20),A3      ; |410| 
           MVK     .L1     1,A4              ; |411| 
           NOP             3
           SET     .S1     A3,0,15,A3        ; |410| 
           STW     .D2T1   A3,*+B10(20)      ; |410| 
           LDW     .D2T1   *+B10(28),A3      ; |411| 
           NOP             4
           PACKHL2 .L1     A3,A4,A3          ; |411| 
           STW     .D2T1   A3,*+B10(28)      ; |411| 
           LDW     .D2T2   *B4,B4            ; |413| 
           LDW     .D2T2   *+SP(4),B10       ; |422| 
           NOP             3

           OR      .L1X    1,B4,A3           ; |413| 
||         ADD     .L2     B6,B5,B4          ; |413| 
||         MVK     .S2     4244,B6           ; |414| 

           STW     .D2T1   A3,*B4            ; |413| 
||         ADD     .L2     B6,B5,B4          ; |414| 

           LDW     .D2T2   *B4,B6            ; |414| 
           MVK     .S2     4244,B4           ; |414| 
           NOP             3

           OR      .L2     1,B6,B4           ; |414| 
||         ADD     .S2     B4,B5,B6          ; |414| 

           STW     .D2T2   B4,*B6            ; |414| 
||         ADD     .L2     B7,B5,B4          ; |416| 

           LDW     .D2T2   *B4,B4            ; |416| 
           MV      .L2     B7,B6             ; |416| 
           MVK     .S2     4236,B7           ; |417| 
           NOP             2

           SET     .S2     B4,10,10,B6       ; |416| 
||         ADD     .L2     B6,B5,B4          ; |416| 

           STW     .D2T2   B6,*B4            ; |416| 
||         ADD     .L2     B7,B5,B4          ; |417| 

           LDW     .D2T2   *B4,B4            ; |417| 
           MV      .L1X    B7,A3             ; |417| 
           ADD     .L1X    A3,B5,A3          ; |417| 
           NOP             2
           OR      .L2     1,B4,B4           ; |417| 

           STW     .D1T2   B4,*A3            ; |417| 
||         RET     .S2     B3                ; |422| 

           LDW     .D2T2   *++SP(8),B11      ; |422| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |422| 
	.sect	".text"
	.clink
	.global	_init_pll2

;******************************************************************************
;* FUNCTION NAME: init_pll2                                                   *
;*                                                                            *
;*   Regs Modified     :                                                      *
;*   Regs Used         : B3                                                   *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_init_pll2:
;** --------------------------------------------------------------------------*
           RETNOP  .S2     B3,5              ; |181| 
           ; BRANCH OCCURS {B3}              ; |181| 
	.sect	".text"
	.clink
	.global	_init_pll1

;******************************************************************************
;* FUNCTION NAME: init_pll1                                                   *
;*                                                                            *
;*   Regs Modified     : A0,A3,A4,A5,A6,A7,B0,B4,B5,B6,SP,A22,A23,A24,A25,A26,*
;*                           A27,A28,A29,A30,A31,B31                          *
;*   Regs Used         : A0,A3,A4,A5,A6,A7,B0,B3,B4,B5,B6,SP,A22,A23,A24,A25, *
;*                           A26,A27,A28,A29,A30,A31,B31                      *
;*   Local Frame Size  : 0 Args + 4 Auto + 0 Save = 4 byte                    *
;******************************************************************************
_init_pll1:
;** --------------------------------------------------------------------------*
           MVKL    .S1     0x29a0100,A3
           MVKH    .S1     0x29a0100,A3
           LDW     .D1T1   *A3,A4            ; |145| 
           MV      .L2X    A3,B4             ; |145| 
           SUB     .L2     SP,8,SP           ; |138| 
           NOP             2
           CLR     .S1     A4,5,5,A4         ; |145| 
           STW     .D2T1   A4,*B4            ; |145| 
           LDW     .D1T1   *A3,A4            ; |146| 
           ZERO    .L2     B4                ; |149| 
           NOP             3
           AND     .L1     -2,A4,A4          ; |146| 

           STW     .D1T1   A4,*A3            ; |146| 
||         STW     .D2T2   B4,*+SP(4)        ; |149| 

           LDW     .D2T2   *+SP(4),B4        ; |149| 
           NOP             4
           CMPLT   .L2     B4,4,B0           ; |149| 

   [!B0]   BNOP    .S1     $C$L10,5          ; |149| 
|| [ B0]   MVK     .L2     0x1,B0

           ; BRANCHCC OCCURS {$C$L10}        ; |149| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\MEA21_lib.c
;*      Loop source line                 : 149
;*      Loop closing brace source line   : 149
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 8
;*      Unpartitioned Resource Bound     : 2
;*      Partitioned Resource Bound(*)    : 3
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        1     
;*      .S units                     0        0     
;*      .D units                     0        3*    
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             2        1     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          1        1     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        1     
;*      Bound(.L .S .D .LS .LSD)     1        2     
;*
;*      Searching for software pipeline schedule at ...
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
;*         ii = 11 Unsafe schedule for irregular loop
;*         ii = 11 Unsafe schedule for irregular loop
;*         ii = 11 Did not find schedule
;*         ii = 12 Unsafe schedule for irregular loop
;*         ii = 12 Unsafe schedule for irregular loop
;*         ii = 12 Unsafe schedule for irregular loop
;*         ii = 12 Did not find schedule
;*         ii = 13 Unsafe schedule for irregular loop
;*         ii = 13 Unsafe schedule for irregular loop
;*         ii = 13 Unsafe schedule for irregular loop
;*         ii = 13 Did not find schedule
;*         ii = 14 Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 1
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L7:    ; PIPED LOOP PROLOG
   [ B0]   SPLOOPW 14      ;28               ; (P) 
;** --------------------------------------------------------------------------*
$C$L8:    ; PIPED LOOP KERNEL
           NOP             9
           NOP             1
   [ B0]   LDW     .D2T2   *+SP(4),B5        ; |149| (P) <0,10>  ^ 
           NOP             4
           ADD     .L1X    1,B5,A3           ; |149| <0,15>  ^ Define a twin register
           STW     .D2T1   A3,*+SP(4)        ; |149| <0,16>  ^ 
           LDW     .D2T2   *+SP(4),B4        ; |149| <0,17>  ^ 
           NOP             4
           CMPLT   .L2     B4,4,B4           ; |149| <0,22> 
           MV      .L2     B4,B0             ; |149| <0,23> 
           NOP             2
           NOP             1
           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L9:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
$C$L10:    

           ZERO    .L1     A5
||         MVK     .S1     256,A4            ; |151| 

           MVKH    .S1     0x29a0000,A5
           ADD     .L1     A4,A5,A4          ; |151| 
           LDW     .D1T1   *A4,A4            ; |151| 
           MVK     .S1     256,A6            ; |151| 
           MVK     .S1     276,A7            ; |153| 
           ADD     .L1     A6,A5,A6          ; |151| 
           ADD     .L1     A7,A5,A31         ; |153| 
           OR      .L1     8,A4,A4           ; |151| 
           STW     .D1T1   A4,*A6            ; |151| 
           LDW     .D1T1   *A31,A4           ; |153| 
           ADD     .L1     -4,A7,A28
           ADD     .L1     A7,A5,A30         ; |153| 
           ADD     .L1     -4,A7,A29
           MVK     .S1     352,A7            ; |156| 
           CLR     .S1     A4,0,4,A4         ; |153| 

           STW     .D1T1   A4,*A30           ; |153| 
||         ADD     .L1     A28,A5,A4         ; |154| 

           LDW     .D1T1   *A4,A4            ; |154| 
           ADD     .L1     A7,A5,A27         ; |156| 
           MV      .L1     A7,A26            ; |156| 
           ADD     .L2X    4,A7,B4
           ADD     .L2X    B4,A5,B4          ; |157| 
           CLR     .S1     A4,0,5,A4         ; |154| 

           OR      .L1     15,A4,A6          ; |154| 
||         ADD     .S1     A29,A5,A4         ; |154| 

           STW     .D1T1   A6,*A4            ; |154| 
           LDW     .D1T1   *A27,A4           ; |156| 
           MVK     .S1     312,A25           ; |160| 
           ADD     .L2X    4,A7,B31
           ADD     .L1     A25,A5,A24        ; |160| 
           MVK     .S1     316,A23           ; |161| 
           CLR     .S1     A4,0,4,A4         ; |156| 

           OR      .L1     7,A4,A6           ; |156| 
||         ADD     .S1     A26,A5,A4         ; |156| 

           STW     .D1T1   A6,*A4            ; |156| 
           LDW     .D2T2   *B4,B6            ; |157| 
           ADD     .L1X    B31,A5,A4         ; |157| 
           ADD     .L1     A23,A5,A22        ; |161| 
           NOP             2
           CLR     .S2     B6,0,4,B6         ; |157| 
           OR      .L2     2,B6,B4           ; |157| 
           STW     .D1T2   B4,*A4            ; |157| 
           LDW     .D1T1   *A24,A4           ; |160| 
           NOP             4

           OR      .L1     1,A4,A6           ; |160| 
||         ADD     .S1     A25,A5,A4         ; |160| 

           STW     .D1T1   A6,*A4            ; |160| 
           LDW     .D1T1   *A22,A4           ; |161| 
           NOP             4
           AND     .L1     1,A4,A0           ; |161| 

   [!A0]   BNOP    .S1     $C$L14,5          ; |161| 
|| [ A0]   MVK     .L2     0x1,B0

           ; BRANCHCC OCCURS {$C$L14}        ; |161| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\MEA21_lib.c
;*      Loop source line                 : 161
;*      Loop closing brace source line   : 161
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 1
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 1
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     1*       0     
;*      .D units                     1*       0     
;*      .M units                     0        0     
;*      .X cross paths               0        1*    
;*      .T address paths             1*       0     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          1        2     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1*       0     
;*      Bound(.L .S .D .LS .LSD)     1*       1*    
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 4  Unsafe schedule for irregular loop
;*         ii = 4  Unsafe schedule for irregular loop
;*         ii = 4  Unsafe schedule for irregular loop
;*         ii = 4  Did not find schedule
;*         ii = 5  Unsafe schedule for irregular loop
;*         ii = 5  Unsafe schedule for irregular loop
;*         ii = 5  Unsafe schedule for irregular loop
;*         ii = 5  Did not find schedule
;*         ii = 6  Unsafe schedule for irregular loop
;*         ii = 6  Unsafe schedule for irregular loop
;*         ii = 6  Unsafe schedule for irregular loop
;*         ii = 6  Did not find schedule
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
$C$L11:    ; PIPED LOOP PROLOG
   [ B0]   SPLOOPW 7       ;14               ; (P) 
;** --------------------------------------------------------------------------*
$C$L12:    ; PIPED LOOP KERNEL
           NOP             1
           MVK     .S1     316,A4            ; |161| (P) <0,1>  ^ 
           ADD     .L1     A4,A5,A4          ; |161| (P) <0,2>  ^ 
   [ B0]   LDW     .D1T1   *A4,A3            ; |161| (P) <0,3>  ^ 
           NOP             4
           AND     .L2X    1,A3,B4           ; |161| <0,8>  ^ 
           MV      .L2     B4,B0             ; |161| <0,9>  ^ 
           NOP             2
           NOP             1
           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L13:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
$C$L14:    
           ZERO    .L2     B4                ; |164| 
           STW     .D2T2   B4,*+SP(4)        ; |164| 
           LDW     .D2T2   *+SP(4),B4        ; |164| 
           MVK     .S2     2000,B6           ; |164| 
           MVK     .S1     0x7d0,A3          ; |164| 
           NOP             2
           CMPLT   .L2     B4,B6,B0          ; |164| 

   [!B0]   BNOP    .S1     $C$L18,5          ; |164| 
|| [ B0]   MVK     .L2     0x1,B0

           ; BRANCHCC OCCURS {$C$L18}        ; |164| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\MEA21_lib.c
;*      Loop source line                 : 164
;*      Loop closing brace source line   : 164
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 8
;*      Unpartitioned Resource Bound     : 2
;*      Partitioned Resource Bound(*)    : 3
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        1     
;*      .S units                     0        0     
;*      .D units                     0        3*    
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             2        1     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          1        1     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        1     
;*      Bound(.L .S .D .LS .LSD)     1        2     
;*
;*      Searching for software pipeline schedule at ...
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
;*         ii = 11 Unsafe schedule for irregular loop
;*         ii = 11 Unsafe schedule for irregular loop
;*         ii = 11 Did not find schedule
;*         ii = 12 Unsafe schedule for irregular loop
;*         ii = 12 Unsafe schedule for irregular loop
;*         ii = 12 Unsafe schedule for irregular loop
;*         ii = 12 Did not find schedule
;*         ii = 13 Unsafe schedule for irregular loop
;*         ii = 13 Unsafe schedule for irregular loop
;*         ii = 13 Unsafe schedule for irregular loop
;*         ii = 13 Did not find schedule
;*         ii = 14 Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 1
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L15:    ; PIPED LOOP PROLOG
   [ B0]   SPLOOPW 14      ;28               ; (P) 
;** --------------------------------------------------------------------------*
$C$L16:    ; PIPED LOOP KERNEL
           NOP             9
           NOP             1
   [ B0]   LDW     .D2T2   *+SP(4),B5        ; |164| (P) <0,10>  ^ 
           NOP             2

           SPMASK          L2
||         MV      .L2X    A3,B6

           NOP             1
           ADD     .L1X    1,B5,A3           ; |164| <0,15>  ^ Define a twin register
           STW     .D2T1   A3,*+SP(4)        ; |164| <0,16>  ^ 
           LDW     .D2T2   *+SP(4),B4        ; |164| <0,17>  ^ 
           NOP             4
           CMPLT   .L2     B4,B6,B4          ; |164| <0,22> 
           MV      .L2     B4,B0             ; |164| <0,23> 
           NOP             2
           NOP             1
           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L17:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
$C$L18:    
           MVK     .S1     256,A3            ; |166| 
           ADD     .L1     A3,A5,A3          ; |166| 
           LDW     .D1T1   *A3,A3            ; |166| 
           MVK     .S2     256,B4            ; |166| 
           ZERO    .L2     B31               ; |169| 
           ADD     .L1X    B4,A5,A31         ; |166| 
           MVK     .S2     20000,B6          ; |169| 
           AND     .L1     -9,A3,A4          ; |166| 

           STW     .D1T1   A4,*A31           ; |166| 
||         STW     .D2T2   B31,*+SP(4)       ; |169| 

           LDW     .D2T2   *+SP(4),B4        ; |169| 
           NOP             4

           CMPLT   .L2     B4,B6,B0          ; |169| 
||         MVK     .S2     0x4e20,B6         ; |169| 

   [!B0]   BNOP    .S1     $C$L22,5          ; |169| 
|| [ B0]   MVK     .L2     0x1,B0

           ; BRANCHCC OCCURS {$C$L22}        ; |169| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\MEA21_lib.c
;*      Loop source line                 : 169
;*      Loop closing brace source line   : 169
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 8
;*      Unpartitioned Resource Bound     : 2
;*      Partitioned Resource Bound(*)    : 3
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        1     
;*      .S units                     0        0     
;*      .D units                     0        3*    
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             2        1     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          1        1     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        1     
;*      Bound(.L .S .D .LS .LSD)     1        2     
;*
;*      Searching for software pipeline schedule at ...
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
;*         ii = 11 Unsafe schedule for irregular loop
;*         ii = 11 Unsafe schedule for irregular loop
;*         ii = 11 Did not find schedule
;*         ii = 12 Unsafe schedule for irregular loop
;*         ii = 12 Unsafe schedule for irregular loop
;*         ii = 12 Unsafe schedule for irregular loop
;*         ii = 12 Did not find schedule
;*         ii = 13 Unsafe schedule for irregular loop
;*         ii = 13 Unsafe schedule for irregular loop
;*         ii = 13 Unsafe schedule for irregular loop
;*         ii = 13 Did not find schedule
;*         ii = 14 Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 1
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L19:    ; PIPED LOOP PROLOG
   [ B0]   SPLOOPW 14      ;28               ; (P) 
;** --------------------------------------------------------------------------*
$C$L20:    ; PIPED LOOP KERNEL
           NOP             9
           NOP             1
   [ B0]   LDW     .D2T2   *+SP(4),B5        ; |169| (P) <0,10>  ^ 
           NOP             4
           ADD     .L1X    1,B5,A3           ; |169| <0,15>  ^ Define a twin register
           STW     .D2T1   A3,*+SP(4)        ; |169| <0,16>  ^ 
           LDW     .D2T2   *+SP(4),B4        ; |169| <0,17>  ^ 
           NOP             4
           CMPLT   .L2     B4,B6,B4          ; |169| <0,22> 
           MV      .L2     B4,B0             ; |169| <0,23> 
           NOP             2
           NOP             1
           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L21:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
$C$L22:    
           MVK     .S1     256,A3            ; |171| 
           ADD     .L1     A3,A5,A3          ; |171| 
           LDW     .D1T1   *A3,A3            ; |171| 
           RETNOP  .S2     B3,1              ; |172| 
           MVK     .S2     256,B4            ; |171| 
           ADD     .L2     8,SP,SP           ; |172| 

           OR      .L1     1,A3,A3           ; |171| 
||         ADD     .S1X    B4,A5,A4          ; |171| 

           STW     .D1T1   A3,*A4            ; |171| 
           ; BRANCH OCCURS {B3}              ; |172| 
	.sect	".text"
	.clink
	.global	_init_irq

;******************************************************************************
;* FUNCTION NAME: init_irq                                                    *
;*                                                                            *
;*   Regs Modified     : A3,A4,A5,B4,B5                                       *
;*   Regs Used         : A3,A4,A5,B3,B4,B5                                    *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_init_irq:
;** --------------------------------------------------------------------------*
           MVKL    .S1     0x1800104,A3
           MVKH    .S1     0x1800104,A3
           LDW     .D1T1   *A3,A4            ; |281| 
           MVK     .S2     55,B4             ; |281| 
           MV      .L1     A3,A5             ; |281| 
           NOP             2
           CLR     .S1     A4,0,6,A4         ; |281| 
           NOP             1
           OR      .L2X    B4,A4,B4          ; |281| 
           STW     .D1T2   B4,*A3            ; |281| 
           LDW     .D1T1   *A5,A4            ; |284| 
           MV      .L2X    A3,B4             ; |281| 
           MVKL    .S1     _intcVectorTable,A5
           MVKH    .S1     _intcVectorTable,A5
           NOP             1
           CLR     .S1     A4,8,14,A4        ; |284| 
           SET     .S1     A4,12,12,A4       ; |284| 
           STW     .D1T1   A4,*A3            ; |284| 
           LDW     .D2T2   *B4,B4            ; |287| 
           ZERO    .L1     A4
           MVKH    .S1     0x45000000,A4
           NOP             2
           CLR     .S2     B4,25,29,B5       ; |287| 
           MV      .L2X    A3,B4             ; |281| 
           OR      .L1X    A4,B5,A4          ; |287| 

           STW     .D2T1   A4,*B4            ; |287| 
||         ADD     .L1     4,A3,A3

           LDW     .D1T1   *A3,A4            ; |290| 
           MVK     .S2     57,B4             ; |290| 
           NOP             3
           CLR     .S1     A4,0,6,A4         ; |290| 
           NOP             1
           OR      .L2X    B4,A4,B4          ; |290| 
           STW     .D1T2   B4,*A3            ; |290| 
           MVC     .S2X    A5,ISTP           ; |293| 
           ZERO    .L1     A3
           SET     .S1     A3,0x4,0xf,A3
           NOP             1
           MVC     .S2X    A3,ICR            ; |296| 
           MVC     .S2     IER,B4            ; |299| 
           OR      .L2     2,B4,B4           ; |299| 
           MVC     .S2     B4,IER            ; |299| 
           MVC     .S2     IER,B4            ; |300| 
           SET     .S2     B4,6,6,B4         ; |300| 
           MVC     .S2     B4,IER            ; |300| 
           MVC     .S2     IER,B4            ; |302| 
           SET     .S2     B4,8,8,B4         ; |302| 
           MVC     .S2     B4,IER            ; |302| 
           MVC     .S2     CSR,B4            ; |306| 
           OR      .L2     1,B4,B4           ; |306| 
           MVC     .S2     B4,CSR            ; |306| 
           RETNOP  .S2     B3,5              ; |307| 
           ; BRANCH OCCURS {B3}              ; |307| 
	.sect	".text"
	.clink
	.global	_init_gpio

;******************************************************************************
;* FUNCTION NAME: init_gpio                                                   *
;*                                                                            *
;*   Regs Modified     : A0,A3,A4,A5,B0,B4,B5,B6                              *
;*   Regs Used         : A0,A3,A4,A5,B0,B3,B4,B5,B6                           *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_init_gpio:
;** --------------------------------------------------------------------------*
           MVKL    .S1     0x2ac0004,A3
           MVKH    .S1     0x2ac0004,A3
           MVKL    .S2     0xf0a0b00,B5

           MV      .L2X    A3,B4             ; |96| 
||         MVKH    .S2     0xf0a0b00,B5

           ADD     .L1     4,A3,A4
||         LDW     .D1T1   *A3,A3            ; |96| 
||         STW     .D2T2   B5,*B4            ; |96| 

           LDW     .D1T1   *A4,A5            ; |100| 
           MVK     .L1     0x1,A0
           NOP             3
           SET     .S1     A5,10,10,A3       ; |100| 
           STW     .D1T1   A3,*A4            ; |100| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\MEA21_lib.c
;*      Loop source line                 : 103
;*      Loop opening brace source line   : 103
;*      Loop closing brace source line   : 106
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 9
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        1     
;*      .S units                     0        2*    
;*      .D units                     0        1     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             0        1     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          1        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        2*    
;*      Bound(.L .S .D .LS .LSD)     1        2*    
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 9  Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 1
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L23:    ; PIPED LOOP PROLOG
   [ A0]   SPLOOPW 9       ;18               ; (P) 
;** --------------------------------------------------------------------------*
$C$L24:    ; PIPED LOOP KERNEL
           NOP             3

           SPMASK          S2
||         MVK     .S2     12,B5

           SPMASK          L2
||         ADD     .L2X    A4,B5,B5

   [ A0]   LDW     .D2T2   *B5,B4            ; |104| (P) <0,5>  ^ 
           NOP             4
           EXTU    .S2     B4,14,29,B6       ; |104| <0,10>  ^ 
           EXTU    .S2     B6,16,16,B6       ; |104| <0,11>  ^ 
           CMPEQ   .L2     B6,1,B0           ; |110| <0,12>  ^ 
   [ B0]   ZERO    .L1     A0                ; |110| <0,13>  ^ 
           NOP             2
           NOP             1
           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L25:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
           ZERO    .L1     A4
           MVKH    .S1     0x2b00000,A4
           LDW     .D1T1   *+A4(16),A3       ; |114| 
           NOP             4
           AND     .L1     -5,A3,A3          ; |114| 
           STW     .D1T1   A3,*+A4(16)       ; |114| 
           LDW     .D1T1   *+A4(16),A3       ; |115| 
           NOP             4
           CLR     .S1     A3,15,15,A3       ; |115| 
           STW     .D1T1   A3,*+A4(16)       ; |115| 
           LDW     .D1T1   *+A4(20),A3       ; |117| 
           NOP             4
           OR      .L1     4,A3,A3           ; |117| 
           STW     .D1T1   A3,*+A4(20)       ; |117| 
           LDW     .D1T1   *+A4(20),A3       ; |118| 
           NOP             4
           CLR     .S1     A3,15,15,A3       ; |118| 
           STW     .D1T1   A3,*+A4(20)       ; |118| 
           LDW     .D1T1   *+A4(16),A3       ; |121| 
           NOP             4
           SET     .S1     A3,4,4,A3         ; |121| 
           STW     .D1T1   A3,*+A4(16)       ; |121| 
           LDW     .D1T1   *+A4(16),A3       ; |122| 
           NOP             4
           SET     .S1     A3,6,6,A3         ; |122| 
           STW     .D1T1   A3,*+A4(16)       ; |122| 
           LDW     .D1T1   *+A4(36),A3       ; |125| 
           NOP             4
           SET     .S1     A3,4,4,A3         ; |125| 
           STW     .D1T1   A3,*+A4(36)       ; |125| 
           LDW     .D1T1   *+A4(36),A3       ; |127| 
           NOP             4
           SET     .S1     A3,6,6,A3         ; |127| 
           STW     .D1T1   A3,*+A4(36)       ; |127| 
           LDW     .D1T1   *+A4(8),A3        ; |128| 
           RETNOP  .S2     B3,3              ; |129| 
           OR      .L1     1,A3,A3           ; |128| 
           STW     .D1T1   A3,*+A4(8)        ; |128| 
           ; BRANCH OCCURS {B3}              ; |129| 
	.sect	".text"
	.clink
	.global	_init_emifa

;******************************************************************************
;* FUNCTION NAME: init_emifa                                                  *
;*                                                                            *
;*   Regs Modified     : A3,A4,A5,B4,B5,B6                                    *
;*   Regs Used         : A3,A4,A5,B3,B4,B5,B6,DP                              *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_init_emifa:
;** --------------------------------------------------------------------------*
           LDW     .D2T2   *+DP(_devRegs),B4 ; |195| 
           MVKL    .S2     0x4002c,B6
           MVKH    .S2     0x4002c,B6
           MVKL    .S1     0x70000020,A3
           MVKH    .S1     0x70000020,A3
           ADD     .L2     B6,B4,B5          ; |195| 
           LDW     .D2T2   *B5,B5            ; |195| 
           ADD     .L2     B6,B4,B4          ; |195| 
           NOP             3
           OR      .L2     1,B5,B5           ; |195| 
           STW     .D2T2   B5,*B4            ; |195| 
           LDW     .D1T1   *A3,A4            ; |196| 
           MVK     .S2     96,B4
           ADD     .L2X    A3,B4,B5
           ADD     .L2X    A3,B4,B4
           NOP             1
           CLR     .S1     A4,0,7,A4         ; |196| 
           SET     .S1     A4,1,7,A4         ; |196| 
           STW     .D1T1   A4,*A3            ; |196| 
           LDW     .D2T1   *B4,A4            ; |198| 
           MV      .L1X    B4,A3             ; |198| 
           NOP             3
           EXTU    .S1     A4,1,1,A4         ; |198| 
           STW     .D2T1   A4,*B4            ; |198| 
           LDW     .D1T1   *A3,A3            ; |199| 
           MV      .L1X    B4,A4             ; |198| 
           NOP             3
           CLR     .S1     A3,30,30,A3       ; |199| 
           STW     .D2T1   A3,*B5            ; |199| 
           LDW     .D2T2   *B4,B5            ; |200| 
           MV      .L1X    B4,A3             ; |198| 
           NOP             3
           CLR     .S2     B5,29,29,B5       ; |200| 
           STW     .D1T2   B5,*A3            ; |200| 
           LDW     .D1T1   *A4,A4            ; |201| 
           NOP             4
           SET     .S1     A4,28,28,A4       ; |201| 
           STW     .D2T1   A4,*B4            ; |201| 
           LDW     .D1T2   *A3,B5            ; |202| 
           NOP             4
           CLR     .S2     B5,24,27,B5       ; |202| 
           SET     .S2     B5,25,25,B5       ; |202| 
           STW     .D1T2   B5,*A3            ; |202| 
           LDW     .D2T1   *B4,A3            ; |203| 
           MV      .L2     B4,B5             ; |198| 
           NOP             3
           CLR     .S1     A3,19,23,A3       ; |203| 
           SET     .S1     A3,18,18,A3       ; |203| 
           STW     .D2T1   A3,*B4            ; |203| 
           LDW     .D2T2   *B5,B5            ; |204| 
           MV      .L1X    B4,A3             ; |198| 
           NOP             3
           CLR     .S2     B5,15,17,B5       ; |204| 
           STW     .D2T2   B5,*B4            ; |204| 
           LDW     .D1T2   *A3,B5            ; |205| 
           NOP             4
           CLR     .S2     B5,11,14,B5       ; |205| 
           SET     .S2     B5,12,12,B5       ; |205| 
           STW     .D1T2   B5,*A3            ; |205| 
           LDW     .D2T1   *B4,A4            ; |206| 
           NOP             4
           CLR     .S1     A4,6,10,A4        ; |206| 
           SET     .S1     A4,5,5,A4         ; |206| 
           STW     .D2T1   A4,*B4            ; |206| 
           LDW     .D1T2   *A3,B5            ; |207| 
           MV      .L1X    B4,A4             ; |198| 
           NOP             3
           CLR     .S2     B5,2,4,B5         ; |207| 
           STW     .D1T2   B5,*A3            ; |207| 
           LDW     .D1T2   *A4,B5            ; |208| 
           ADD     .L1X    4,B4,A3
           NOP             3
           AND     .L2     -2,B5,B5          ; |208| 
           OR      .L2     2,B5,B5           ; |208| 
           STW     .D2T2   B5,*B4            ; |208| 
           LDW     .D1T1   *A3,A4            ; |210| 
           ADD     .L2     4,B4,B5
           NOP             3
           SET     .S1     A4,31,31,A4       ; |210| 
           STW     .D1T1   A4,*A3            ; |210| 
           LDW     .D2T1   *B5,A5            ; |211| 
           MV      .L1     A3,A4             ; |210| 
           MV      .L2X    A3,B5             ; |210| 
           NOP             2
           SET     .S1     A5,10,10,A5       ; |211| 
           STW     .D1T1   A5,*A4            ; |211| 
           LDW     .D1T1   *A3,A4            ; |212| 
           MV      .L1     A3,A5             ; |210| 
           NOP             3
           CLR     .S1     A4,9,9,A4         ; |212| 
           STW     .D2T1   A4,*B5            ; |212| 
           LDW     .D1T1   *A3,A4            ; |213| 
           NOP             4
           SET     .S1     A4,8,8,A4         ; |213| 
           STW     .D1T1   A4,*A3            ; |213| 
           LDW     .D2T2   *B5,B5            ; |214| 
           MV      .L1     A3,A4             ; |210| 
           NOP             3
           CLR     .S2     B5,7,7,B5         ; |214| 
           SET     .S2     B5,6,6,B5         ; |214| 
           STW     .D1T2   B5,*A3            ; |214| 
           LDW     .D1T1   *A4,A4            ; |215| 
           ADD     .L2     8,B4,B5
           NOP             3
           OR      .L1     12,A4,A4          ; |215| 
           STW     .D1T1   A4,*A3            ; |215| 
           LDW     .D1T1   *A5,A4            ; |216| 
           NOP             4
           AND     .L1     -2,A4,A4          ; |216| 
           OR      .L1     2,A4,A4           ; |216| 

           ADD     .L2     8,B4,B4
||         STW     .D1T1   A4,*A3            ; |216| 
||         ADD     .L1X    8,B4,A4

           LDW     .D2T1   *B4,A3            ; |218| 
           NOP             4
           SET     .S1     A3,31,31,A3       ; |218| 
           STW     .D2T1   A3,*B5            ; |218| 
           LDW     .D2T2   *B4,B6            ; |219| 
           MV      .L1X    B4,A3             ; |218| 
           MV      .L2     B4,B5             ; |218| 
           NOP             2
           SET     .S2     B6,10,10,B6       ; |219| 
           STW     .D1T2   B6,*A3            ; |219| 
           LDW     .D2T2   *B5,B6            ; |220| 
           NOP             4
           CLR     .S2     B6,9,9,B6         ; |220| 
           STW     .D2T2   B6,*B4            ; |220| 
           LDW     .D2T2   *B5,B6            ; |221| 
           NOP             4
           SET     .S2     B6,8,8,B6         ; |221| 
           STW     .D2T2   B6,*B5            ; |221| 
           LDW     .D1T1   *A3,A5            ; |222| 
           NOP             4
           CLR     .S1     A5,7,7,A5         ; |222| 
           SET     .S1     A5,6,6,A5         ; |222| 
           STW     .D1T1   A5,*A3            ; |222| 
           LDW     .D1T1   *A4,A3            ; |223| 
           NOP             4
           OR      .L1     12,A3,A3          ; |223| 
           STW     .D2T1   A3,*B5            ; |223| 
           LDW     .D2T2   *B4,B5            ; |224| 
           NOP             4
           AND     .L2     -2,B5,B5          ; |224| 

           OR      .L2     2,B5,B6           ; |224| 
||         ADDAD   .D2     B4,3,B5

           STW     .D2T2   B6,*B4            ; |224| 
           LDW     .D2T2   *B5,B4            ; |226| 
           MV      .L1X    B5,A3             ; |226| 
           MV      .L1X    B5,A4             ; |226| 
           NOP             2
           CLR     .S2     B4,30,30,B6       ; |226| 
           STW     .D2T2   B6,*B5            ; |226| 
           LDW     .D1T1   *A3,A3            ; |227| 
           MV      .L2     B5,B4             ; |226| 
           NOP             3
           SET     .S1     A3,8,10,A3        ; |227| 
           STW     .D1T1   A3,*A4            ; |227| 
           LDW     .D2T2   *B4,B4            ; |228| 
           RETNOP  .S2     B3,3              ; |229| 
           SET     .S2     B4,0,7,B4         ; |228| 
           STW     .D2T2   B4,*B5            ; |228| 
           ; BRANCH OCCURS {B3}              ; |229| 
	.sect	".text"
	.clink
	.global	_init_dma

;******************************************************************************
;* FUNCTION NAME: init_dma                                                    *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,B0,B1,B2,B3,B4,*
;*                           B5,B6,B7,B8,B9,B10,SP,A16,A17,A18,A19,A20,A21,   *
;*                           A22,A23,A24,A25,A26,A27,A28,A29,A30,A31,B16,B17, *
;*                           B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29, *
;*                           B30,B31                                          *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,B0,B1,B2,B3,B4,*
;*                           B5,B6,B7,B8,B9,B10,DP,SP,A16,A17,A18,A19,A20,A21,*
;*                           A22,A23,A24,A25,A26,A27,A28,A29,A30,A31,B16,B17, *
;*                           B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29, *
;*                           B30,B31                                          *
;*   Local Frame Size  : 0 Args + 0 Auto + 16 Save = 16 byte                  *
;******************************************************************************
_init_dma:
;** --------------------------------------------------------------------------*

           MVKL    .S1     0x2a001d0,A3
||         STW     .D2T2   B10,*SP--(8)      ; |311| 

           MVKH    .S1     0x2a001d0,A3
||         STDW    .D2T1   A11:A10,*SP--     ; |311| 

           LDW     .D1T2   *A3,B5            ; |320| 
           MVK     .S2     1664,B4           ; |320| 
           MVKL    .S2     0x2a04660,B10
           MVKH    .S2     0x2a04660,B10
           MV      .L1X    B3,A11            ; |311| 
           CLR     .S2     B5,5,13,B5        ; |320| 

           OR      .L2     B4,B5,B5          ; |320| 
||         MVK     .S2     136,B4

           STW     .D1T2   B5,*A3            ; |320| 
||         ADD     .L2X    A3,B4,B4

           LDW     .D2T1   *B4,A4            ; |321| 
           ADD     .L1     4,A3,A3
           MVK     .S2     1696,B5           ; |327| 
           MVK     .S1     0x20,A6           ; |330| 
           NOP             1
           CLR     .S1     A4,16,18,A4       ; |321| 
           STW     .D2T1   A4,*B4            ; |321| 
           LDW     .D1T1   *A3,A4            ; |327| 
           NOP             4
           CLR     .S1     A4,6,13,A4        ; |327| 
           NOP             1
           OR      .L2X    B5,A4,B5          ; |327| 
           STW     .D1T2   B5,*A3            ; |327| 
           LDW     .D2T2   *B4,B5            ; |328| 
           MV      .L1X    B10,A4            ; |330| 
           NOP             3
           CLR     .S2     B5,20,22,B5       ; |328| 

           CALLP   .S2     _memset,B3
||         STW     .D2T2   B5,*B4            ; |328| 
||         ZERO    .L2     B4                ; |330| 

$C$RL1:    ; CALL OCCURS {_memset} {0}       ; |330| 
;** --------------------------------------------------------------------------*
           MVK     .S1     64,A10
           ADD     .L1X    B10,A10,A4

           CALLP   .S2     _memset,B3
||         ADD     .L1X    B10,A10,A10
||         ZERO    .L2     B4                ; |331| 
||         MVK     .S1     0x20,A6           ; |331| 

$C$RL2:    ; CALL OCCURS {_memset} {0}       ; |331| 
;** --------------------------------------------------------------------------*
           LDW     .D2T1   *B10,A3           ; |333| 
           MVKL    .S2     0x34000,B5
           MVKH    .S2     0x34000,B5
           ZERO    .L2     B6
           MVKH    .S2     0xb0000000,B6
           SET     .S1     A3,20,20,A3       ; |333| 
           STW     .D2T1   A3,*B10           ; |333| 
           LDW     .D2T2   *B10,B4           ; |334| 
           MVK     .S1     488,A3            ; |343| 
           MVKL    .S1     _MeaData+4,A4
           MVKH    .S1     _MeaData+4,A4
           MVK     .S1     4196,A5           ; |382| 
           AND     .L2     -9,B4,B4          ; |334| 
           STW     .D2T2   B4,*B10           ; |334| 
           LDW     .D2T2   *B10,B4           ; |335| 
           MV      .L2X    A5,B7             ; |312| 
           MV      .L2X    A11,B3            ; |386| 
           NOP             2
           CLR     .S2     B4,12,15,B4       ; |335| 
           OR      .L2     B5,B4,B4          ; |335| 
           STW     .D2T2   B4,*B10           ; |335| 
           LDW     .D2T2   *+B10(4),B4       ; |337| 
           STW     .D2T2   B6,*+B10(4)       ; |337| 
           LDW     .D2T2   *B10,B4           ; |341| 
           MVK     .S2     1632,B5           ; |347| 
           NOP             3
           CLR     .S2     B4,8,10,B4        ; |341| 
           SET     .S2     B4,9,9,B4         ; |341| 
           STW     .D2T2   B4,*B10           ; |341| 
           LDW     .D2T2   *B10,B4           ; |342| 
           NOP             4
           OR      .L2     1,B4,B4           ; |342| 
           STW     .D2T2   B4,*B10           ; |342| 
           LDW     .D2T2   *+B10(8),B4       ; |343| 
           NOP             4
           PACKHL2 .L2X    B4,A3,B4          ; |343| 
           STW     .D2T2   B4,*+B10(8)       ; |343| 
           LDW     .D2T1   *+B10(8),A3       ; |344| 
           ZERO    .L2     B4
           MVKH    .S2     0x1e80000,B4
           NOP             2
           EXTU    .S1     A3,16,16,A3       ; |344| 
           SET     .S1     A3,16,16,A3       ; |344| 
           STW     .D2T1   A3,*+B10(8)       ; |344| 
           LDW     .D2T1   *+B10(16),A3      ; |345| 
           NOP             4
           EXTU    .S1     A3,16,16,A3       ; |345| 
           OR      .L1X    B4,A3,A3          ; |345| 
           STW     .D2T1   A3,*+B10(16)      ; |345| 
           LDW     .D2T2   *+B10(12),B4      ; |346| 
           STW     .D2T1   A4,*+B10(12)      ; |346| 
           LDW     .D2T2   *+B10(20),B4      ; |347| 
           SUBAW   .D1     A10,8,A3
           MVKL    .S1     0x35000,A4
           MVKH    .S1     0x35000,A4
           NOP             1
           PACKHL2 .L2     B4,B5,B4          ; |347| 
           STW     .D2T2   B4,*+B10(20)      ; |347| 
           LDW     .D2T2   *+B10(28),B4      ; |349| 
           MVK     .L2     1,B5              ; |349| 
           NOP             3
           PACKHL2 .L2     B4,B5,B4          ; |349| 
           STW     .D2T2   B4,*+B10(28)      ; |349| 
           LDNDW   .D2T2   *B10,B19:B18      ; |351| 
           LDNDW   .D2T2   *+B10(16),B17:B16 ; |351| 
           LDNDW   .D2T2   *+B10(24),B9:B8   ; |351| 
           LDNDW   .D2T2   *+B10(8),B5:B4    ; |351| 
           NOP             1
           STNDW   .D1T2   B19:B18,*A3       ; |351| 
           STNDW   .D1T2   B17:B16,*+A3(16)  ; |351| 
           STNDW   .D1T2   B9:B8,*+A3(24)    ; |351| 
           STNDW   .D1T2   B5:B4,*+A3(8)     ; |351| 
           LDW     .D1T2   *A10,B4           ; |353| 
           MVKL    .S2     _MonitorData,B5
           MVKH    .S2     _MonitorData,B5
           NOP             2
           SET     .S2     B4,20,20,B4       ; |353| 
           STW     .D1T2   B4,*A10           ; |353| 
           LDW     .D1T2   *A10,B4           ; |354| 
           NOP             4
           OR      .L2     8,B4,B4           ; |354| 
           STW     .D1T2   B4,*A10           ; |354| 
           LDW     .D1T1   *A10,A3           ; |355| 
           NOP             4
           CLR     .S1     A3,13,15,A3       ; |355| 
           OR      .L1     A4,A3,A3          ; |355| 
           STW     .D1T1   A3,*A10           ; |355| 
           LDW     .D1T2   *+A10(4),B4       ; |356| 
           STW     .D1T2   B5,*+A10(4)       ; |356| 
           LDW     .D1T2   *+A10(8),B4       ; |357| 
           MVK     .L1     1,A4              ; |361| 
           NOP             3
           CLR     .S2     B4,0,15,B4        ; |357| 
           STW     .D1T2   B4,*+A10(8)       ; |357| 
           LDW     .D1T2   *+A10(8),B4       ; |358| 
           NOP             4
           EXTU    .S2     B4,16,16,B4       ; |358| 
           SET     .S2     B4,16,16,B4       ; |358| 
           STW     .D1T2   B4,*+A10(8)       ; |358| 
           LDW     .D1T2   *+A10(12),B4      ; |359| 
           STW     .D1T2   B6,*+A10(12)      ; |359| 
           LDW     .D1T1   *+A10(20),A3      ; |360| 
           MVK     .S2     4212,B6           ; |381| 
           NOP             3
           SET     .S1     A3,0,15,A3        ; |360| 
           STW     .D1T1   A3,*+A10(20)      ; |360| 
           LDW     .D1T1   *+A10(28),A3      ; |361| 
           ZERO    .L2     B4
           MVKH    .S2     0x2a00000,B4
           NOP             2

           PACKHL2 .L1     A3,A4,A3          ; |361| 
||         MVK     .S1     780,A4            ; |366| 

           STW     .D1T1   A3,*+A10(28)      ; |361| 
||         ADD     .L1X    A4,B4,A3          ; |366| 

           LDW     .D1T1   *A3,A3            ; |366| 
           ADD     .L2X    A4,B4,B5          ; |366| 
           NOP             3
           SET     .S1     A3,20,20,A3       ; |366| 

           STW     .D2T1   A3,*B5            ; |366| 
||         ADD     .L1X    A4,B4,A3          ; |367| 

           LDW     .D1T1   *A3,A3            ; |367| 
           MVK     .S2     780,B5            ; |367| 
           MVK     .S1     4164,A4           ; |372| 
           ADD     .L2     B5,B4,B5          ; |367| 
           NOP             1
           SET     .S1     A3,21,21,A3       ; |367| 

           STW     .D2T1   A3,*B5            ; |367| 
||         ADD     .L1X    A4,B4,A3          ; |372| 

           LDW     .D1T1   *A3,A3            ; |372| 
           ADD     .L2X    A4,B4,B5          ; |372| 
           NOP             3
           SET     .S1     A3,20,20,A3       ; |372| 

           STW     .D2T1   A3,*B5            ; |372| 
||         ADD     .L1X    A4,B4,A3          ; |373| 

           LDW     .D1T1   *A3,A3            ; |373| 
           MVK     .S2     4164,B5           ; |373| 
           MVK     .S1     4148,A4           ; |377| 
           ADD     .L2     B5,B4,B5          ; |373| 
           NOP             1
           SET     .S1     A3,21,21,A3       ; |373| 

           STW     .D2T1   A3,*B5            ; |373| 
||         ADD     .L1X    A4,B4,A3          ; |377| 

           LDW     .D1T1   *A3,A3            ; |377| 
           ADD     .L2X    A4,B4,B5          ; |377| 
           MV      .L1X    B6,A4             ; |381| 
           NOP             2
           SET     .S1     A3,20,20,A3       ; |377| 

           STW     .D2T1   A3,*B5            ; |377| 
||         ADD     .L2     B6,B4,B5          ; |381| 

           LDW     .D2T1   *B5,A3            ; |381| 
           ADD     .L2X    A5,B4,B5          ; |382| 
           NOP             3

           SET     .S1     A3,20,20,A4       ; |381| 
||         ADD     .L1X    A4,B4,A3          ; |381| 

           STW     .D1T1   A4,*A3            ; |381| 
           LDW     .D2T2   *B5,B6            ; |382| 
           ZERO    .L2     B5
           SET     .S2     B5,0x17,0x18,B5
           MVK     .S1     260,A3            ; |385| 
           ADD     .L1X    A3,B5,A3          ; |385| 

           SET     .S2     B6,20,20,B4       ; |382| 
||         ADD     .L2     B7,B4,B6          ; |382| 

           STW     .D2T2   B4,*B6            ; |382| 
           LDW     .D1T1   *A3,A3            ; |385| 
           MVK     .S1     260,A4            ; |385| 
           ADD     .L1X    A4,B5,A4          ; |385| 
           NOP             2
           CLR     .S1     A3,16,22,A3       ; |385| 
           SET     .S1     A3,19,20,A3       ; |385| 
           STW     .D1T1   A3,*A4            ; |385| 

           LDDW    .D2T1   *++SP,A11:A10     ; |386| 
||         RET     .S2     B3                ; |386| 

           LDW     .D2T2   *++SP(8),B10      ; |386| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |386| 
	.sect	".text"
	.clink
	.global	_init_ddr2

;******************************************************************************
;* FUNCTION NAME: init_ddr2                                                   *
;*                                                                            *
;*   Regs Modified     : A3,A4,A5,A6,A7,B4,B5,B6,B7                           *
;*   Regs Used         : A3,A4,A5,A6,A7,B3,B4,B5,B6,B7,DP                     *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_init_ddr2:
;** --------------------------------------------------------------------------*
           LDW     .D2T2   *+DP(_devRegs),B4 ; |235| 
           MVKL    .S1     0x4002c,A4
           MVKH    .S1     0x4002c,A4
           MVKL    .S1     0x7800000c,A6
           MVKH    .S1     0x7800000c,A6
           ADD     .L1X    A4,B4,A3          ; |235| 
           LDW     .D1T1   *A3,A3            ; |235| 
           ADD     .L1X    A4,B4,A4          ; |235| 
           MV      .L2X    A6,B7             ; |237| 
           MVK     .S1     3200,A5           ; |241| 
           ADD     .L1     4,A6,A7
           OR      .L1     2,A3,A3           ; |235| 
           STW     .D1T1   A3,*A4            ; |235| 
           LDW     .D1T2   *A6,B4            ; |237| 
           MVK     .S1     3200,A4           ; |237| 
           MV      .L1     A6,A3             ; |237| 
           NOP             2

           PACKHL2 .L2X    B4,A4,B5          ; |237| 
||         MVK     .S2     216,B4

           STW     .D1T2   B5,*A3            ; |237| 
||         ADD     .L2X    A6,B4,B4

           LDW     .D2T2   *B4,B6            ; |238| 
           MVK     .S2     196,B5
           SUB     .L2     B4,B5,B5
           NOP             2
           CLR     .S2     B6,5,5,B6         ; |238| 
           STW     .D2T2   B6,*B4            ; |238| 
           LDW     .D2T2   *B5,B6            ; |240| 
           NOP             4
           CLR     .S2     B6,0,7,B6         ; |240| 
           SET     .S2     B6,1,7,B6         ; |240| 
           STW     .D2T2   B6,*B5            ; |240| 
           LDW     .D2T1   *B7,A4            ; |241| 
           ADD     .L2X    -4,A6,B5
           ADD     .L2X    -4,A6,B6
           ADD     .L2X    4,A6,B7
           NOP             1
           PACKHL2 .L1     A4,A5,A4          ; |241| 

           STW     .D1T1   A4,*A3            ; |241| 
||         ADD     .L1     -4,A6,A3

           LDW     .D1T1   *A3,A5            ; |243| 
           ADD     .L1     -4,A6,A4
           NOP             3
           SET     .S1     A5,23,23,A5       ; |243| 
           STW     .D2T1   A5,*B5            ; |243| 
           LDW     .D2T1   *B6,A5            ; |244| 
           MV      .L2X    A3,B5             ; |243| 
           NOP             3
           CLR     .S1     A5,18,18,A5       ; |244| 
           STW     .D2T1   A5,*B5            ; |244| 
           LDW     .D1T2   *A3,B5            ; |245| 
           MV      .L1     A3,A5             ; |243| 
           NOP             3
           CLR     .S2     B5,23,23,B5       ; |245| 
           STW     .D1T2   B5,*A4            ; |245| 
           LDW     .D1T2   *A3,B6            ; |247| 
           MV      .L2X    A3,B5             ; |243| 
           NOP             3
           SET     .S2     B6,15,15,B6       ; |247| 
           STW     .D1T2   B6,*A3            ; |247| 
           LDW     .D2T2   *B5,B6            ; |248| 
           NOP             4
           SET     .S2     B6,14,14,B6       ; |248| 
           STW     .D1T2   B6,*A3            ; |248| 
           LDW     .D2T1   *B5,A4            ; |249| 
           MVK     .S2     2560,B5           ; |249| 
           ZERO    .L2     B6
           MVKH    .S2     0x62000000,B6
           NOP             1
           CLR     .S1     A4,10,10,A4       ; |249| 
           NOP             1
           OR      .L2X    B5,A4,B5          ; |249| 
           STW     .D1T2   B5,*A3            ; |249| 
           LDW     .D1T1   *A5,A4            ; |250| 
           MV      .L2X    A3,B5             ; |243| 
           NOP             3
           CLR     .S1     A4,6,6,A4         ; |250| 
           SET     .S1     A4,4,5,A4         ; |250| 
           STW     .D1T1   A4,*A3            ; |250| 
           LDW     .D1T1   *A5,A4            ; |251| 
           NOP             4
           AND     .L1     -8,A4,A4          ; |251| 
           OR      .L1     2,A4,A4           ; |251| 

           STW     .D2T1   A4,*B5            ; |251| 
||         ADD     .L2X    4,A6,B5

           LDW     .D2T1   *B5,A5            ; |253| 
           ADD     .L1     4,A6,A4
           NOP             3
           EXTU    .S1     A5,7,7,A5         ; |253| 
           NOP             1
           OR      .L2X    B6,A5,B6          ; |253| 
           STW     .D1T2   B6,*A4            ; |253| 
           LDW     .D1T1   *A7,A5            ; |254| 
           MV      .L1X    B5,A4             ; |253| 
           MV      .L2     B5,B6             ; |253| 
           NOP             2
           CLR     .S1     A5,24,24,A5       ; |254| 
           SET     .S1     A5,22,23,A5       ; |254| 
           STW     .D2T1   A5,*B5            ; |254| 
           LDW     .D1T1   *A4,A4            ; |255| 
           NOP             4
           CLR     .S1     A4,21,21,A4       ; |255| 
           SET     .S1     A4,19,20,A4       ; |255| 
           STW     .D2T1   A4,*B5            ; |255| 
           LDW     .D2T1   *B6,A5            ; |256| 
           MV      .L1X    B5,A4             ; |253| 
           NOP             3
           CLR     .S1     A5,18,18,A5       ; |256| 
           SET     .S1     A5,16,17,A5       ; |256| 
           STW     .D1T1   A5,*A4            ; |256| 
           LDW     .D2T2   *B5,B6            ; |257| 
           MVK     .S1     22528,A4          ; |257| 
           NOP             3
           CLR     .S2     B6,13,15,B6       ; |257| 
           NOP             1
           OR      .L1X    A4,B6,A4          ; |257| 
           STW     .D2T1   A4,*B5            ; |257| 
           LDW     .D2T2   *B7,B6            ; |258| 
           MV      .L1X    B5,A4             ; |253| 
           NOP             3
           CLR     .S2     B6,6,10,B6        ; |258| 
           SET     .S2     B6,7,9,B6         ; |258| 
           STW     .D1T2   B6,*A4            ; |258| 
           LDW     .D2T2   *B5,B6            ; |259| 
           NOP             4
           CLR     .S2     B6,5,5,B6         ; |259| 
           SET     .S2     B6,3,4,B6         ; |259| 
           STW     .D2T2   B6,*B5            ; |259| 
           LDW     .D1T2   *A4,B6            ; |260| 
           ADD     .L1     8,A6,A4
           NOP             3
           OR      .L2     3,B6,B6           ; |260| 
           STW     .D2T2   B6,*B5            ; |260| 
           LDW     .D1T1   *A4,A5            ; |262| 
           ADD     .L2X    8,A6,B5
           NOP             3
           CLR     .S1     A5,23,23,A5       ; |262| 
           SET     .S1     A5,24,24,A5       ; |262| 
           STW     .D1T1   A5,*A4            ; |262| 
           LDW     .D2T2   *B5,B6            ; |263| 
           ZERO    .L2     B5
           MVKH    .S2     0x340000,B5
           MV      .L1     A4,A5             ; |262| 
           NOP             1
           CLR     .S2     B6,16,22,B6       ; |263| 
           OR      .L2     B5,B6,B5          ; |263| 
           STW     .D1T2   B5,*A4            ; |263| 
           LDW     .D1T2   *A5,B6            ; |264| 
           MVKL    .S2     0xc700,B5
           MVKH    .S2     0xc700,B5
           NOP             2
           CLR     .S2     B6,8,15,B6        ; |264| 
           OR      .L2     B5,B6,B5          ; |264| 
           STW     .D1T2   B5,*A4            ; |264| 
           LDW     .D1T2   *A5,B5            ; |265| 
           NOP             4
           CLR     .S2     B5,6,7,B5         ; |265| 
           SET     .S2     B5,5,5,B5         ; |265| 
           STW     .D1T2   B5,*A4            ; |265| 
           LDW     .D1T1   *A5,A5            ; |266| 
           MVK     .S2     1997,B5           ; |268| 
           NOP             3
           CLR     .S1     A5,0,4,A5         ; |266| 
           OR      .L1     2,A5,A5           ; |266| 
           STW     .D1T1   A5,*A4            ; |266| 
           LDW     .D1T1   *A6,A4            ; |268| 
           NOP             4
           PACKHL2 .L1X    A4,B5,A4          ; |268| 
           STW     .D1T1   A4,*A6            ; |268| 
           LDW     .D2T2   *B4,B6            ; |270| 
           MV      .L2X    A3,B5             ; |243| 
           NOP             3
           AND     .L2     -2,B6,B6          ; |270| 
           OR      .L2     6,B6,B6           ; |270| 
           STW     .D2T2   B6,*B4            ; |270| 
           LDW     .D2T2   *B5,B4            ; |272| 
           RETNOP  .S2     B3,3              ; |273| 
           CLR     .S2     B4,15,15,B4       ; |272| 
           STW     .D2T2   B4,*B5            ; |272| 
           ; BRANCH OCCURS {B3}              ; |273| 
	.sect	".text"
	.clink
	.global	_init_cache

;******************************************************************************
;* FUNCTION NAME: init_cache                                                  *
;*                                                                            *
;*   Regs Modified     : A3,B4,B5                                             *
;*   Regs Used         : A3,B3,B4,B5                                          *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_init_cache:
;** --------------------------------------------------------------------------*
           RET     .S2     B3                ; |135| 
           MVKL    .S1     0x1840020,A3
           MVKH    .S1     0x1840020,A3

           MVK     .S2     32,B4
||         MVK     .L2     0x4,B5            ; |133| 

           ADD     .L2X    A3,B4,B4
||         STW     .D1T2   B5,*A3            ; |133| 

           STW     .D2T2   B5,*B4            ; |134| 
           ; BRANCH OCCURS {B3}              ; |135| 
	.sect	".text"
	.clink
	.global	_SetMonitorSize

;******************************************************************************
;* FUNCTION NAME: SetMonitorSize                                              *
;*                                                                            *
;*   Regs Modified     : A3,A4,B4,B5,B6,B7,B8,B9,B16                          *
;*   Regs Used         : A3,A4,B3,B4,B5,B6,B7,B8,B9,B16                       *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_SetMonitorSize:
;** --------------------------------------------------------------------------*

           MV      .L2X    A4,B4             ; |427| 
||         MVKL    .S1     0x2a046a8,A4

           MVKH    .S1     0x2a046a8,A4
           LDW     .D1T1   *A4,A3            ; |431| 
           MVKL    .S2     0xa0000414,B7
           MVKH    .S2     0xa0000414,B7
           MV      .L2X    A4,B5             ; |431| 
           SUBAW   .D2     B7,4,B8
           CLR     .S1     A3,0,15,A3        ; |431| 

           ZERO    .L2     B6
||         STW     .D2T1   A3,*B5            ; |431| 

           STW     .D2T2   B4,*B7            ; |432| 
||         ZERO    .L2     B5                ; |432| 
||         SET     .S2     B6,0x1c,0x1e,B6

           STW     .D2T2   B5,*B6            ; |432| 

           MVK     .L1     3,A3              ; |433| 
||         LDW     .D2T2   *B6,B7            ; |432| 

           MV      .L2     B6,B9             ; |432| 
||         STW     .D2T1   A3,*B8            ; |433| 

           STW     .D2T2   B5,*B9            ; |433| 
||         MV      .L2     B6,B16            ; |432| 

           LDW     .D2T2   *B16,B5           ; |433| 
           LDW     .D1T1   *A4,A3            ; |434| 
           EXTU    .S2     B4,18,16,B4       ; |434| 
           NOP             1
           RETNOP  .S2     B3,1              ; |435| 
           CLR     .S1     A3,0,15,A3        ; |434| 
           NOP             1
           OR      .L2X    B4,A3,B4          ; |434| 
           STW     .D1T2   B4,*A4            ; |434| 
           ; BRANCH OCCURS {B3}              ; |435| 
	.sect	".text"
	.clink
	.global	_MEA21_init

;******************************************************************************
;* FUNCTION NAME: MEA21_init                                                  *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,B0,B1,B2,B3,B4,*
;*                           B5,B6,B7,B8,B9,B10,B11,B12,B13,SP,A16,A17,A18,   *
;*                           A19,A20,A21,A22,A23,A24,A25,A26,A27,A28,A29,A30, *
;*                           A31,B16,B17,B18,B19,B20,B21,B22,B23,B24,B25,B26, *
;*                           B27,B28,B29,B30,B31                              *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,B0,B1,B2,B3,B4,*
;*                           B5,B6,B7,B8,B9,B10,B11,B12,B13,DP,SP,A16,A17,A18,*
;*                           A19,A20,A21,A22,A23,A24,A25,A26,A27,A28,A29,A30, *
;*                           A31,B16,B17,B18,B19,B20,B21,B22,B23,B24,B25,B26, *
;*                           B27,B28,B29,B30,B31                              *
;*   Local Frame Size  : 0 Args + 0 Auto + 32 Save = 32 byte                  *
;******************************************************************************
_MEA21_init:
;** --------------------------------------------------------------------------*

           STW     .D2T1   A11,*SP--(8)      ; |49| 
||         MVKL    .S1     0x2ac0004,A3

           STDW    .D2T2   B13:B12,*SP--     ; |49| 
||         MVKH    .S1     0x2ac0004,A3

           STDW    .D2T2   B11:B10,*SP--     ; |49| 
||         MVKL    .S2     0xf0a0b00,B9

           STW     .D2T1   A10,*SP--(8)      ; |49| 
||         MV      .L2X    A3,B16            ; |96| 
||         MVKH    .S2     0xf0a0b00,B9

           ADD     .L1     4,A3,A8
||         LDW     .D1T1   *A3,A3            ; |96| 
||         STW     .D2T2   B9,*B16           ; |96| 

           LDW     .D1T1   *A8,A4            ; |100| 
           MVK     .L1     0x1,A0
           NOP             3
           SET     .S1     A4,10,10,A3       ; |100| 
           STW     .D1T1   A3,*A8            ; |100| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\MEA21_lib.c
;*      Loop source line                 : 103
;*      Loop opening brace source line   : 103
;*      Loop closing brace source line   : 106
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 9
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        1     
;*      .S units                     0        2*    
;*      .D units                     0        1     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             0        1     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          1        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        2*    
;*      Bound(.L .S .D .LS .LSD)     1        2*    
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 9  Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 1
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L26:    ; PIPED LOOP PROLOG
   [ A0]   SPLOOPW 9       ;18               ; (P) 
;** --------------------------------------------------------------------------*
$C$L27:    ; PIPED LOOP KERNEL
           NOP             3

           SPMASK          S2
||         MVK     .S2     12,B8

           SPMASK          L2
||         ADD     .L2X    A8,B8,B5

   [ A0]   LDW     .D2T2   *B5,B4            ; |104| (P) <0,5>  ^ 
           NOP             2

           SPMASK          L1
||         MV      .L1X    B3,A11            ; |49| 

           NOP             1
           EXTU    .S2     B4,14,29,B6       ; |104| <0,10>  ^ 
           EXTU    .S2     B6,16,16,B6       ; |104| <0,11>  ^ 
           CMPEQ   .L2     B6,1,B0           ; |110| <0,12>  ^ 
   [ B0]   ZERO    .L1     A0                ; |110| <0,13>  ^ 
           NOP             2
           NOP             1
           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L28:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
           MV      .L2     B5,B8
           ZERO    .L2     B4
           MVKH    .S2     0x2b00000,B4
           LDW     .D2T2   *+B4(16),B5       ; |114| 
           NOP             4
           AND     .L2     -5,B5,B5          ; |114| 
           STW     .D2T2   B5,*+B4(16)       ; |114| 
           LDW     .D2T1   *+B4(16),A3       ; |115| 
           NOP             4
           CLR     .S1     A3,15,15,A3       ; |115| 
           STW     .D2T1   A3,*+B4(16)       ; |115| 
           LDW     .D2T2   *+B4(20),B5       ; |117| 
           NOP             4
           OR      .L2     4,B5,B5           ; |117| 
           STW     .D2T2   B5,*+B4(20)       ; |117| 
           LDW     .D2T1   *+B4(20),A3       ; |118| 
           NOP             4
           CLR     .S1     A3,15,15,A3       ; |118| 
           STW     .D2T1   A3,*+B4(20)       ; |118| 
           LDW     .D2T1   *+B4(16),A3       ; |121| 
           NOP             4
           SET     .S1     A3,4,4,A3         ; |121| 
           STW     .D2T1   A3,*+B4(16)       ; |121| 
           LDW     .D2T1   *+B4(16),A3       ; |122| 
           NOP             4
           SET     .S1     A3,6,6,A3         ; |122| 
           STW     .D2T1   A3,*+B4(16)       ; |122| 
           LDW     .D2T1   *+B4(36),A3       ; |125| 
           NOP             4
           SET     .S1     A3,4,4,A3         ; |125| 
           STW     .D2T1   A3,*+B4(36)       ; |125| 
           LDW     .D2T1   *+B4(36),A3       ; |127| 
           NOP             4
           SET     .S1     A3,6,6,A3         ; |127| 
           STW     .D2T1   A3,*+B4(36)       ; |127| 
           LDW     .D2T2   *+B4(8),B5        ; |128| 
           NOP             4
           OR      .L2     1,B5,B5           ; |128| 

           CALLP   .S2     _init_pll1,B3
||         STW     .D2T2   B5,*+B4(8)        ; |128| 

$C$RL3:    ; CALL OCCURS {_init_pll1} {0}    ; |51| 
;** --------------------------------------------------------------------------*
           CALLP   .S2     _init_ddr2,B3
$C$RL4:    ; CALL OCCURS {_init_ddr2} {0}    ; |52| 
           CALLP   .S2     _init_emifa,B3
$C$RL5:    ; CALL OCCURS {_init_emifa} {0}   ; |53| 
;** --------------------------------------------------------------------------*
           MVKL    .S2     0x1840020,B6
           MVKH    .S2     0x1840020,B6

           MVK     .L2     0x4,B5            ; |133| 
||         ADDAD   .D2     B6,4,B4
||         MVKL    .S2     0xa0000400,B11

           STW     .D2T2   B5,*B6            ; |133| 
||         MVKH    .S2     0xa0000400,B11

           ADDAW   .D2     B11,9,B13

           STW     .D2T2   B5,*B4            ; |134| 
||         MVK     .L2     0x3,B12           ; |56| 
||         ZERO    .S2     B10

           STW     .D2T2   B12,*B11          ; |56| 
||         SET     .S2     B10,0x1c,0x1e,B10
||         ZERO    .L1     A10               ; |56| 

           STW     .D2T1   A10,*B10          ; |56| 
||         MV      .L2     B10,B6            ; |56| 

           MVK     .S1     256,A4            ; |57| 
||         LDW     .D2T2   *B6,B4            ; |56| 

           STW     .D2T1   A4,*B13           ; |57| 
||         MV      .L2     B10,B7            ; |56| 

           STW     .D2T1   A10,*B7           ; |57| 
||         MVKL    .S1     0x1800104,A3

           LDW     .D2T2   *B10,B4           ; |57| 
||         MVKH    .S1     0x1800104,A3

           LDW     .D1T1   *A3,A4            ; |281| 
           MVK     .S2     55,B30            ; |281| 
           MV      .L1     A3,A5             ; |281| 
           MV      .L2X    A3,B29            ; |281| 
           ZERO    .L1     A21
           CLR     .S1     A4,0,6,A4         ; |281| 
           MVKH    .S1     0x45000000,A21
           OR      .L2X    B30,A4,B4         ; |281| 
           STW     .D1T2   B4,*A3            ; |281| 
           LDW     .D1T1   *A5,A4            ; |284| 
           MV      .L2X    A3,B28            ; |281| 
           ADD     .L1     4,A3,A20
           MVKL    .S1     _intcVectorTable,A19
           MVK     .S2     57,B27            ; |290| 
           CLR     .S1     A4,8,14,A4        ; |284| 
           SET     .S1     A4,12,12,A4       ; |284| 
           STW     .D1T1   A4,*A3            ; |284| 
           LDW     .D2T2   *B29,B4           ; |287| 
           MVKH    .S1     _intcVectorTable,A19
           NOP             3
           CLR     .S2     B4,25,29,B5       ; |287| 
           NOP             1
           OR      .L1X    A21,B5,A4         ; |287| 
           STW     .D2T1   A4,*B28           ; |287| 
           LDW     .D1T1   *A20,A4           ; |290| 
           NOP             4
           CLR     .S1     A4,0,6,A4         ; |290| 
           NOP             1
           OR      .L2X    B27,A4,B4         ; |290| 
           STW     .D1T2   B4,*A20           ; |290| 
           MVC     .S2X    A19,ISTP          ; |293| 
           ZERO    .L1     A3
           SET     .S1     A3,0x4,0xf,A3
           NOP             1
           MVC     .S2X    A3,ICR            ; |296| 
           MVC     .S2     IER,B4            ; |299| 
           OR      .L2     2,B4,B4           ; |299| 
           MVC     .S2     B4,IER            ; |299| 
           MVC     .S2     IER,B4            ; |300| 
           SET     .S2     B4,6,6,B4         ; |300| 
           MVC     .S2     B4,IER            ; |300| 
           MVC     .S2     IER,B4            ; |302| 
           SET     .S2     B4,8,8,B4         ; |302| 
           MVC     .S2     B4,IER            ; |302| 
           MVC     .S2     CSR,B4            ; |306| 
           OR      .L2     1,B4,B4           ; |306| 
           MVC     .S2     B4,CSR            ; |306| 

           MV      .L2     B16,B4            ; |306| 
||         LDW     .D2T2   *B16,B5           ; |75| 

           STW     .D2T2   B9,*B4            ; |75| 
           LDW     .D1T1   *A8,A3            ; |76| 
           MV      .L1     A10,A0            ; |76| 
           NOP             3
           SET     .S1     A3,6,6,A3         ; |76| 
           STW     .D1T1   A3,*A8            ; |76| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\MEA21_lib.c
;*      Loop source line                 : 77
;*      Loop opening brace source line   : 77
;*      Loop closing brace source line   : 79
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 1
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 1
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     1*       0     
;*      .D units                     1*       0     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             1*       0     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          1        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1*       0     
;*      Bound(.L .S .D .LS .LSD)     1*       0     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 4  Unsafe schedule for irregular loop
;*         ii = 4  Unsafe schedule for irregular loop
;*         ii = 4  Unsafe schedule for irregular loop
;*         ii = 4  Did not find schedule
;*         ii = 5  Unsafe schedule for irregular loop
;*         ii = 5  Unsafe schedule for irregular loop
;*         ii = 5  Unsafe schedule for irregular loop
;*         ii = 5  Did not find schedule
;*         ii = 6  Unsafe schedule for irregular loop
;*         ii = 6  Unsafe schedule for irregular loop
;*         ii = 6  Unsafe schedule for irregular loop
;*         ii = 6  Did not find schedule
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
$C$L29:    ; PIPED LOOP PROLOG
   [!A0]   SPLOOPW 7       ;14               ; (P) 
;** --------------------------------------------------------------------------*
$C$L30:    ; PIPED LOOP KERNEL
           NOP             2

           SPMASK          L1
||         MV      .L1X    B8,A5             ; |76| 

   [!A0]   LDW     .D1T1   *A5,A4            ; |78| (P) <0,3>  ^ 
           NOP             4
           EXTU    .S1     A4,20,29,A3       ; |78| <0,8>  ^ 
           MV      .L1     A3,A0             ; |78| <0,9>  ^ 
           NOP             2
           NOP             1
           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L31:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*

           MV      .L2     B4,B16
||         LDW     .D2T2   *B4,B5            ; |83| 

           STW     .D2T2   B9,*B16           ; |83| 
           LDW     .D1T1   *A8,A3            ; |84| 
           ZERO    .L1     A0
           NOP             3
           SET     .S1     A3,8,8,A3         ; |84| 
           STW     .D1T1   A3,*A8            ; |84| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\MEA21_lib.c
;*      Loop source line                 : 85
;*      Loop opening brace source line   : 85
;*      Loop closing brace source line   : 87
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 1
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 1
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     1*       0     
;*      .D units                     1*       0     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             1*       0     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          1        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1*       0     
;*      Bound(.L .S .D .LS .LSD)     1*       0     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 4  Unsafe schedule for irregular loop
;*         ii = 4  Unsafe schedule for irregular loop
;*         ii = 4  Unsafe schedule for irregular loop
;*         ii = 4  Did not find schedule
;*         ii = 5  Unsafe schedule for irregular loop
;*         ii = 5  Unsafe schedule for irregular loop
;*         ii = 5  Unsafe schedule for irregular loop
;*         ii = 5  Did not find schedule
;*         ii = 6  Unsafe schedule for irregular loop
;*         ii = 6  Unsafe schedule for irregular loop
;*         ii = 6  Unsafe schedule for irregular loop
;*         ii = 6  Did not find schedule
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
$C$L32:    ; PIPED LOOP PROLOG
   [!A0]   SPLOOPW 7       ;14               ; (P) 
;** --------------------------------------------------------------------------*
$C$L33:    ; PIPED LOOP KERNEL
           NOP             3
   [!A0]   LDW     .D1T1   *A5,A4            ; |86| (P) <0,3>  ^ 
           NOP             4
           EXTU    .S1     A4,17,29,A3       ; |86| <0,8>  ^ 
           MV      .L1     A3,A0             ; |86| <0,9>  ^ 
           NOP             2
           NOP             1
           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L34:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
           CALLP   .S2     _init_dma,B3
$C$RL6:    ; CALL OCCURS {_init_dma} {0}     ; |63| 
;** --------------------------------------------------------------------------*
           CALLP   .S2     _init_qdma,B3
$C$RL7:    ; CALL OCCURS {_init_qdma} {0}    ; |64| 
;** --------------------------------------------------------------------------*
           MVKL    .S1     0x2a046a8,A5
           MVKH    .S1     0x2a046a8,A5
           LDW     .D1T1   *A5,A3            ; |431| 
           MV      .L2X    A5,B4             ; |431| 
           SUBAW   .D2     B13,4,B5
           MV      .L2     B10,B6            ; |432| 
           MV      .L1X    B10,A6            ; |432| 
           CLR     .S1     A3,0,15,A4        ; |431| 

           STW     .D2T1   A4,*B4            ; |431| 
||         MVK     .S2     80,B4             ; |432| 

           STW     .D2T2   B4,*B5            ; |432| 

           STW     .D2T1   A10,*B6           ; |432| 
||         ADD     .L2     4,B11,B4

           LDW     .D1T1   *A6,A4            ; |432| 
||         STW     .D2T2   B12,*B4           ; |433| 
||         MV      .L1X    B10,A7            ; |432| 

           STW     .D1T1   A10,*A7           ; |433| 
           LDW     .D2T2   *B10,B4           ; |433| 
           MV      .L1     A5,A3             ; |431| 
           LDW     .D1T1   *A3,A4            ; |434| 
           MV      .L2X    A11,B3            ; |67| 
           NOP             1
           MVK     .S2     320,B4            ; |434| 
           NOP             1
           PACKHL2 .L1X    A4,B4,A3          ; |434| 
           STW     .D1T1   A3,*A5            ; |434| 
           LDW     .D2T1   *++SP(8),A10      ; |67| 
           LDDW    .D2T2   *++SP,B11:B10     ; |67| 

           LDDW    .D2T2   *++SP,B13:B12     ; |67| 
||         RET     .S2     B3                ; |67| 

           LDW     .D2T1   *++SP(8),A11      ; |67| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |67| 
;*****************************************************************************
;* UNDEFINED EXTERNAL REFERENCES                                             *
;*****************************************************************************
	.global	_memset
	.global	_intcVectorTable

;******************************************************************************
;* BUILD ATTRIBUTES                                                           *
;******************************************************************************
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_needed(0)
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_preserved(0)
	.battr "TI", Tag_File, 1, Tag_Tramps_Use_SOC(1)
