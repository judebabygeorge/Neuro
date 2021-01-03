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

	.global	_SendData_DMAPARAMSET
_SendData_DMAPARAMSET:	.usect	".far",64,8
	.global	_SendData_EvId
	.bss	_SendData_EvId,4,4
	.global	_SendBuffer
_SendBuffer:	.usect	".far",320,8
	.global	_RecBuffer
_RecBuffer:	.usect	".far",640,8
	.global	_SendDataCount
	.bss	_SendDataCount,4,4
	.global	_uSendDataStore
_uSendDataStore:	.usect	".far",10256,4
;	opt6x C:\\Users\\45c\\AppData\\Local\\Temp\\078082 C:\\Users\\45c\\AppData\\Local\\Temp\\078084 
	.sect	".text"
	.clink
	.global	_init_SendDataDMA

;******************************************************************************
;* FUNCTION NAME: init_SendDataDMA                                            *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,B0,B1,B2,B3,B4,*
;*                           B5,B6,B7,B8,B9,B10,B11,SP,A16,A17,A18,A19,A20,   *
;*                           A21,A22,A23,A24,A25,A26,A27,A28,A29,A30,A31,B16, *
;*                           B17,B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28, *
;*                           B29,B30,B31                                      *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,B0,B1,B2,B3,B4,*
;*                           B5,B6,B7,B8,B9,B10,B11,DP,SP,A16,A17,A18,A19,A20,*
;*                           A21,A22,A23,A24,A25,A26,A27,A28,A29,A30,A31,B16, *
;*                           B17,B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28, *
;*                           B29,B30,B31                                      *
;*   Local Frame Size  : 0 Args + 0 Auto + 24 Save = 24 byte                  *
;******************************************************************************
_init_SendDataDMA:
;** --------------------------------------------------------------------------*
           MVKL    .S2     _SendBuffer,B8
           MVK     .S2     0x14,B4           ; |243| 

           MVKH    .S2     _SendBuffer,B8
||         MVK     .L2     0x1,B5
||         STW     .D2T1   A11,*SP--(8)      ; |239| 

           STDW    .D2T2   B11:B10,*SP--     ; |239| 
||         SUB     .L2     B4,2,B4
||         MVK     .S2     0x3,B7

           SUB     .L2     B8,12,B4
||         SUB     .L1X    B8,12,A3
||         MV      .D2     B3,B11            ; |239| 
||         MVC     .S2     B4,ILC

;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\SendData.c
;*      Loop source line                 : 243
;*      Loop opening brace source line   : 243
;*      Loop closing brace source line   : 243
;*      Loop Unroll Multiple             : 4x
;*      Known Minimum Trip Count         : 20                    
;*      Known Maximum Trip Count         : 20                    
;*      Known Max Trip Count Factor      : 20
;*      Loop Carried Dependency Bound(^) : 1
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
;*      Addition ops (.LSD)          2        2     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        0     
;*      Bound(.L .S .D .LS .LSD)     2*       2*    
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
$C$L1:    ; PIPED LOOP PROLOG

           SPLOOPD 2       ;4                ; (P) 
||         MVK     .L1     0x2,A5
||         SUB     .L2     B8,12,B6
||         STW     .D2T1   A10,*SP--(8)      ; |239| 
||         ADDK    .S2     24,B4
||         ADDK    .S1     20,A3

;** --------------------------------------------------------------------------*
$C$L2:    ; PIPED LOOP KERNEL

           SPMASK          L1,S1,L2,S2
||         MV      .L2X    A4,B10            ; |239| 
||         ZERO    .L1     A4                ; |243| 
||         MV      .S1X    B8,A6
||         ADDK    .S2     16,B6
||         STW     .D1T1   A5,*A3++(16)      ; |243| (P) <0,0>  ^ 
||         STW     .D2T2   B7,*B4++(16)      ; |243| (P) <0,0>  ^ 

           ADD     .L1     4,A5,A5           ; |243| (P) <0,1>  ^ 
||         ADD     .L2     4,B7,B7           ; |243| (P) <0,1>  ^ 
||         ADD     .S1     4,A4,A4           ; |243| (P) <0,1>  ^ 
||         STW     .D1T1   A4,*A6++(16)      ; |243| (P) <0,1>  ^ 
||         ADD     .S2     4,B5,B5           ; |243| (P) <0,1>  ^ 
||         STW     .D2T2   B5,*B6++(16)      ; |243| (P) <0,1>  ^ 

           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L3:    ; PIPED LOOP EPILOG

           STW     .D2T2   B10,*+DP(_SendData_EvId) ; |252| 
||         MVKL    .S1     0x55aa55aa,A3
||         CALL    .S2     _memset           ; |256| 

           MVK     .S2     100,B4            ; |244| 
||         MV      .L1X    B8,A11
||         MVKH    .S1     0x55aa55aa,A3

           ADDKPC  .S2     $C$RL0,B3,0       ; |256| 
||         MVKL    .S1     _SendData_DMAPARAMSET,A10
||         STW     .D1T1   A3,*A11           ; |247| 

           MVK     .L1     4,A3              ; |246| 
||         MVK     .S1     79,A4             ; |244| 
||         STW     .D1T1   A3,*+A11(12)      ; |248| 

           ZERO    .L2     B4                ; |256| 
||         STW     .D2T1   A3,*+DP(_SendDataCount) ; |246| 
||         STW     .D1T2   B4,*+A11[A4]      ; |244| 
||         MVKH    .S1     _SendData_DMAPARAMSET,A10

           MVK     .S1     0x40,A6           ; |256| 
||         MV      .L1     A10,A4            ; |256| 

$C$RL0:    ; CALL OCCURS {_memset} {0}       ; |256| 
;** --------------------------------------------------------------------------*
           MVKL    .S1     0x2a00240,A4
           MVKH    .S1     0x2a00240,A4
           SHL     .S2     B10,2,B5          ; |260| 

           ADD     .L2X    B5,A4,B4          ; |260| 
||         MVK     .S2     320,B6            ; |260| 

           SUB     .L2     B4,B6,B4          ; |260| 
           LDW     .D2T2   *B4,B6            ; |260| 
           EXTU    .S2     B10,23,18,B7      ; |260| 
           SHRU    .S1X    B10,3,A3          ; |263| 
           MVKL    .S2     0x10140,B9
           MVKH    .S2     0x10140,B9
           CLR     .S2     B6,5,13,B6        ; |260| 

           OR      .L2     B7,B6,B6          ; |260| 
||         LDW     .D2T2   *+DP(_SendData_EvId),B7 ; |266| 

           STW     .D2T2   B6,*B4            ; |260| 
           LDW     .D1T1   *+A4[A3],A5       ; |263| 
           MVK     .S2     28,B4             ; |263| 

           AND     .L2     B4,B5,B4          ; |263| 
||         MVK     .S2     7,B5              ; |263| 

           SHL     .S1X    B7,12,A6          ; |266| 
||         MVK     .L2     1,B7              ; |263| 
||         SHL     .S2     B5,B4,B8          ; |263| 

           SHL     .S2     B7,B4,B7          ; |263| 

           AND     .L1X    B8,A5,A5          ; |263| 
||         MV      .L2X    A10,B6            ; |266| 

           OR      .L1X    B7,A5,A5          ; |263| 
||         OR      .L2X    2,A6,B7           ; |266| 

           STW     .D1T1   A5,*+A4[A3]       ; |263| 
||         STW     .D2T2   B7,*B6            ; |266| 
||         ADD     .L2X    4,A10,B6

           STW     .D2T1   A11,*B6           ; |268| 
||         ADD     .L2X    8,A10,B6
||         ZERO    .S2     B5

           STW     .D2T2   B9,*B6            ; |269| 
||         ADD     .L1     12,A10,A4
||         MVKH    .S2     0xb0000000,B5

           STW     .D1T2   B5,*A4            ; |270| 
||         ADD     .L1     4,A4,A3
||         ZERO    .L2     B4
||         ZERO    .S1     A19               ; |273| 

           STW     .D1T1   A19,*A3           ; |273| 
||         ADD     .L1     8,A4,A3
||         SET     .S2     B4,0x0,0xf,B4

           STW     .D1T2   B4,*A3            ; |274| 
||         ADD     .L1     12,A4,A18

           STW     .D1T1   A19,*A18          ; |275| 
||         MVK     .L1     1,A3              ; |276| 
||         ADD     .S1     4,A18,A4

           STW     .D1T1   A3,*A4            ; |276| 
||         MV      .L1     A10,A16           ; |266| 

           LDNDW   .D1T1   *+A16(8),A9:A8    ; |278| 
           LDNDW   .D1T1   *+A16(16),A7:A6   ; |278| 
           LDNDW   .D1T1   *+A16(24),A5:A4   ; |278| 
           LDNDW   .D1T1   *A16,A17:A16      ; |278| 
           ADD     .L1     8,A18,A18
           STNDW   .D1T1   A9:A8,*+A18(8)    ; |278| 

           MVKL    .S1     _uSendDataStore,A3
||         STNDW   .D1T1   A7:A6,*+A18(16)   ; |278| 

           MVKH    .S1     _uSendDataStore,A3
||         STNDW   .D1T1   A5:A4,*+A18(24)   ; |278| 

           STNDW   .D1T1   A17:A16,*A18      ; |278| 
||         ADD     .L1     12,A3,A4

           STW     .D1T1   A19,*A4           ; |287| 

           ADD     .L1     8,A3,A4
||         STW     .D1T1   A19,*A3           ; |284| 

           STW     .D1T1   A19,*A4           ; |286| 
||         ADD     .L1     4,A3,A4

           STW     .D1T1   A19,*A4           ; |285| 

           LDW     .D2T1   *++SP(8),A10      ; |290| 
||         MV      .L2     B11,B3            ; |290| 

           LDDW    .D2T2   *++SP,B11:B10     ; |290| 
||         RET     .S2     B3                ; |290| 

           LDW     .D2T1   *++SP(8),A11      ; |290| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |290| 
	.sect	".text"
	.clink
	.global	_SendData_StoreToBuffer

;******************************************************************************
;* FUNCTION NAME: SendData_StoreToBuffer                                      *
;*                                                                            *
;*   Regs Modified     : A0,A3,A4,A5,A6,A7,A8,B0,B4,B5,B6,B7,B8,B9,A31        *
;*   Regs Used         : A0,A3,A4,A5,A6,A7,A8,B0,B3,B4,B5,B6,B7,B8,B9,DP,A31  *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_SendData_StoreToBuffer:
;** --------------------------------------------------------------------------*
           MVKL    .S1     _uSendDataStore,A8
           MVKH    .S1     _uSendDataStore,A8
           LDW     .D1T1   *A8,A5            ; |82| 
           MV      .L1     A6,A3             ; |80| 
           MVK     .S2     2560,B5           ; |82| 
           MVK     .S2     0xa00,B6          ; |98| 
           NOP             1
           ADD     .L1     A4,A5,A5          ; |82| 
           NOP             1

           CMPGTU  .L2X    A5,B5,B0          ; |82| 
||         ADD     .L1     4,A8,A5
||         LDW     .D2T2   *+DP(_current_time),B5 ; |82| 

   [ B0]   LDW     .D1T1   *A5,A6            ; |82| 
   [ B0]   BNOP    .S1     $C$L12,3          ; |82| 

   [ B0]   ADD     .L1     1,A6,A7           ; |82| 
||         MV      .S1     A4,A6             ; |80| 
||         MVK     .D1     0x1,A4            ; |82| 

   [ B0]   STW     .D1T1   A7,*A5            ; |82| 
||         ADD     .L1     8,A8,A7

           ; BRANCHCC OCCURS {$C$L12}        ; |82| 
;** --------------------------------------------------------------------------*
           LDW     .D1T1   *A7,A4            ; |98| 
           SET     .S2     B4,15,15,B8       ; |107| 
           MV      .L2     B5,B9             ; |107| 
           SHRU    .S1     A6,1,A6           ; |93| 
           ADDAD   .D1     A7,1,A5

           SUB     .L2X    B6,A4,B6          ; |98| 
||         ADDAW   .D1     A5,A4,A4          ; |102| 

           SHRU    .S2     B6,1,B7           ; |98| 
           MV      .L2     B7,B5             ; |98| 
           CMPLTU  .L1X    B7,A6,A0          ; |98| 
   [!A0]   MV      .L2X    A6,B5             ; |98| 

           SUB     .L2     B5,1,B0           ; |111| 
|| [!A0]   MV      .S2X    A6,B7             ; |98| 

   [!B0]   BNOP    .S1     $C$L7,1           ; |111| 
||         SUB     .L2     B7,1,B4           ; |112| 

   [ B0]   MVC     .S2     B4,ILC
           STDW    .D1T2   B9:B8,*A4         ; |107| 
           MV      .L2X    A4,B6             ; |102| Define a twin register
           SUB     .L1X    A6,B5,A0          ; |100| 
           ; BRANCHCC OCCURS {$C$L7}         ; |111| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\SendData.c
;*      Loop source line                 : 111
;*      Loop opening brace source line   : 111
;*      Loop closing brace source line   : 114
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
$C$L4:    ; PIPED LOOP PROLOG
           SPLOOP  2       ;8                ; (P) 
;** --------------------------------------------------------------------------*
$C$L5:    ; PIPED LOOP KERNEL
           LDDW    .D1T1   *A3++,A5:A4       ; |112| (P) <0,0> 
           NOP             4

           SPMASK          S2
||         ADD     .S2     8,B6,B6           ; |107| 
||         MV      .L2X    A5,B5             ; |112| (P) <0,5> Define a twin register

           MV      .L2X    A4,B4             ; |112| <0,6> Define a twin register

           SPKERNEL 3,0
||         STDW    .D2T2   B5:B4,*B6++       ; |112| <0,7> 

;** --------------------------------------------------------------------------*
$C$L6:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
$C$L7:    
   [!A0]   BNOP    .S1     $C$L11,1          ; |118| 
   [ A0]   MVC     .S2X    A0,ILC
           NOP             1
           MV      .L2X    A8,B7
           ADD     .D2     B7,16,B6          ; |116| 
           ; BRANCHCC OCCURS {$C$L11}        ; |118| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\SendData.c
;*      Loop source line                 : 118
;*      Loop opening brace source line   : 118
;*      Loop closing brace source line   : 121
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
$C$L8:    ; PIPED LOOP PROLOG
           SPLOOP  2       ;8                ; (P) 
;** --------------------------------------------------------------------------*
$C$L9:    ; PIPED LOOP KERNEL
           LDDW    .D1T1   *A3++,A5:A4       ; |119| (P) <0,0> 
           NOP             4
           MV      .L2X    A5,B5             ; |119| (P) <0,5> Define a twin register
           MV      .L2X    A4,B4             ; |119| <0,6> Define a twin register

           SPKERNEL 3,0
||         STDW    .D2T2   B5:B4,*B6++       ; |119| <0,7> 

;** --------------------------------------------------------------------------*
$C$L10:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
$C$L11:    
           LDW     .D1T1   *A7,A4            ; |125| 
           MVKL    .S1     0xcccccccd,A3
           ADD     .L1     A6,A6,A6          ; |124| 
           MVKH    .S1     0xcccccccd,A3
           MV      .L2     B7,B4             ; |124| 
           ADD     .L1     A6,A4,A8          ; |125| 
           MPY32U  .M1     A3,A8,A5:A4       ; |125| 
           MV      .L2     B7,B6             ; |124| 
           LDW     .D2T2   *B4,B7            ; |124| 
           MV      .L2X    A7,B5             ; |124| 
           SHRU    .S1     A5,11,A3          ; |125| 
           SHL     .S1     A3,11,A4          ; |125| 
           SHL     .S2X    A3,9,B4           ; |125| 

           ADD     .L2X    B4,A4,B4          ; |125| 
||         ADD     .L1X    A6,B7,A31         ; |124| 

           SUB     .L2X    A8,B4,B4          ; |125| 
||         STW     .D2T1   A31,*B6           ; |124| 

           STW     .D2T2   B4,*B5            ; |125| 
||         ZERO    .L1     A4                ; |127| 

;** --------------------------------------------------------------------------*
$C$L12:    
           RETNOP  .S2     B3,5              ; |128| 
           ; BRANCH OCCURS {B3}              ; |128| 
	.sect	".text"
	.clink
	.global	_SendData_GetAvailableSpace

;******************************************************************************
;* FUNCTION NAME: SendData_GetAvailableSpace                                  *
;*                                                                            *
;*   Regs Modified     : A3,A4,B4                                             *
;*   Regs Used         : A3,A4,B3,B4                                          *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_SendData_GetAvailableSpace:
;** --------------------------------------------------------------------------*
           MVKL    .S1     _uSendDataStore,A3
           MVKH    .S1     _uSendDataStore,A3

           RETNOP  .S2     B3,2              ; |185| 
||         LDW     .D1T1   *A3,A3            ; |184| 

           MVK     .S2     2560,B4           ; |184| 
           NOP             1
           SUB     .L1X    B4,A3,A4          ; |184| 
           ; BRANCH OCCURS {B3}              ; |185| 
	.sect	".text"
	.clink
	.global	_SendData_CopyDataFromStoreBuffer

;******************************************************************************
;* FUNCTION NAME: SendData_CopyDataFromStoreBuffer                            *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B4,B5,B6,B7,B8,A16, *
;*                           A17,A18,A19,A31                                  *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B3,B4,B5,B6,B7,B8,  *
;*                           DP,A16,A17,A18,A19,A31                           *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_SendData_CopyDataFromStoreBuffer:
;** --------------------------------------------------------------------------*

           MVKL    .S2     _uSendDataStore,B8
||         LDW     .D2T1   *+DP(_SendDataCount),A7 ; |135| 
||         MVKL    .S1     _SendBuffer,A3

           MVKH    .S2     _uSendDataStore,B8
||         MVKH    .S1     _SendBuffer,A3

           LDW     .D2T2   *B8,B0            ; |141| 
           MVK     .S1     0xa00,A8
           MVK     .S1     0x51,A16
           ADDAW   .D1     A3,A7,A3          ; |135| 
           MV      .L1X    B8,A9

   [!B0]   BNOP    .S1     $C$L22,5          ; |141| 
|| [ B0]   ADDAW   .D1     A9,3,A17
||         MV      .L1X    B0,A1
||         MV      .L2X    A3,B6             ; |135| Define a twin register

           ; BRANCHCC OCCURS {$C$L22}        ; |141| 
;** --------------------------------------------------------------------------*
;**   BEGIN LOOP $C$L13
;** --------------------------------------------------------------------------*
$C$L13:    
           LDW     .D1T1   *A17,A4           ; |146| 
           NOP             4
           ADDAW   .D1     A9,A4,A3          ; |146| 
           LDW     .D1T1   *+A3(16),A3       ; |146| 
           NOP             4
           SHRU    .S1     A3,18,A3          ; |146| 
           ADD     .L1     2,A3,A3           ; |146| 

           ADD     .L1     A3,A7,A5          ; |146| 
||         SHRU    .S1     A3,1,A6           ; |149| 
||         SUB     .D1     A8,A4,A3          ; |152| 

           CMPLTU  .L1     A5,A16,A0         ; |146| 
   [!A0]   B       .S1     $C$L22            ; |146| 

           MV      .L2X    A0,B0             ; guard predicate rewrite
||         SHRU    .S1     A3,1,A0           ; |152| 

   [ B0]   ADDAW   .D1     A9,A4,A31         ; |156| 
||         CMPGTU  .L1     A0,A6,A2          ; |153| 
|| [ B0]   MV      .L2X    A9,B4

   [ A2]   MV      .L1     A6,A0             ; |153| 
|| [ B0]   ADD     .D2     B4,16,B7

   [ B0]   MV      .L2X    A31,B5            ; |156| Define a twin register
|| [!B0]   MVK     .L1     0x1,A0            ; |153| nullify predicate
|| [ B0]   SUB     .S1     A6,A0,A2          ; |154| 

   [!A0]   B       .S1     $C$L17            ; |159| 
|| [ B0]   ADD     .D2     B5,16,B4          ; |156| 

           ; BRANCHCC OCCURS {$C$L22}        ; |146| 
;** --------------------------------------------------------------------------*
   [ A0]   MVC     .S2X    A0,ILC
           NOP             4
           ; BRANCHCC OCCURS {$C$L17}        ; |159| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\SendData.c
;*      Loop source line                 : 159
;*      Loop opening brace source line   : 159
;*      Loop closing brace source line   : 162
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
$C$L14:    ; PIPED LOOP PROLOG

           SPLOOP  2       ;8                ; (P) 
||         MV      .L1X    B4,A3

;** --------------------------------------------------------------------------*
$C$L15:    ; PIPED LOOP KERNEL
           LDDW    .D1T1   *A3++,A5:A4       ; |160| (P) <0,0> 
           NOP             4
           MV      .L2X    A5,B5             ; |160| (P) <0,5> Define a twin register
           MV      .L2X    A4,B4             ; |160| <0,6> Define a twin register

           SPKERNEL 3,0
||         STDW    .D2T2   B5:B4,*B6++       ; |160| <0,7> 

           NOP             1                 ; SDSCM00012367 HW bug workaround
;** --------------------------------------------------------------------------*
$C$L16:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
$C$L17:    

   [!A2]   BNOP    .S1     $C$L21,5          ; |166| 
|| [ A2]   MVC     .S2X    A2,ILC
||         MV      .L2     B7,B4             ; |164| 

           ; BRANCHCC OCCURS {$C$L21}        ; |166| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\SendData.c
;*      Loop source line                 : 166
;*      Loop opening brace source line   : 166
;*      Loop closing brace source line   : 169
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
$C$L18:    ; PIPED LOOP PROLOG

           SPLOOP  2       ;8                ; (P) 
||         MV      .L1X    B4,A3

;** --------------------------------------------------------------------------*
$C$L19:    ; PIPED LOOP KERNEL
           LDDW    .D1T1   *A3++,A5:A4       ; |167| (P) <0,0> 
           NOP             4
           MV      .L2X    A5,B5             ; |167| (P) <0,5> Define a twin register
           MV      .L2X    A4,B4             ; |167| <0,6> Define a twin register

           SPKERNEL 3,0
||         STDW    .D2T2   B5:B4,*B6++       ; |167| <0,7> 

;** --------------------------------------------------------------------------*
$C$L20:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
$C$L21:    

           ADD     .L1     A6,A6,A3          ; |172| 
||         MV      .L2X    A17,B5            ; |173| 
||         LDW     .D1T1   *A17,A4           ; |174| 

           MVKL    .S1     0xcccccccd,A5
           ADD     .L1     A3,A7,A7          ; |172| 
           SUB     .L1     A1,A3,A1          ; |173| 
           MVKH    .S1     0xcccccccd,A5
           ADD     .L1     A3,A4,A4          ; |174| 
           MPY32U  .M1     A5,A4,A19:A18     ; |174| 
           STW     .D2T1   A1,*B8            ; |173| 
   [ A1]   ADDAW   .D1     A9,3,A17
           STW     .D2T1   A7,*+DP(_SendDataCount) ; |172| 

           SHRU    .S1     A19,11,A5         ; |174| 
|| [ A1]   B       .S2     $C$L13            ; |141| 

           SHL     .S1     A5,11,A6          ; |174| 
           SHL     .S2X    A5,9,B4           ; |174| 
           ADD     .L2X    B4,A6,B4          ; |174| 
           SUB     .L2X    A4,B4,B4          ; |174| 
           STW     .D2T2   B4,*B5            ; |174| 
           ; BRANCHCC OCCURS {$C$L13}        ; |141| 
;** --------------------------------------------------------------------------*
$C$L22:    
           RETNOP  .S2     B3,4              ; |182| 
           ZERO    .L1     A4                ; |181| 
           ; BRANCH OCCURS {B3}              ; |182| 
	.sect	".text"
	.clink
	.global	_SendDataDMA

;******************************************************************************
;* FUNCTION NAME: SendDataDMA                                                 *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B3,B4,B5,B6,B7,  *
;*                           B8,B9,A16,A17,A18,A19,A30,A31,B30,B31            *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B3,B4,B5,B6,B7,  *
;*                           B8,B9,DP,SP,A16,A17,A18,A19,A30,A31,B30,B31      *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_SendDataDMA:
;** --------------------------------------------------------------------------*

           MV      .L2     B3,B1             ; |187| 
||         CALLP   .S2     _SendData_CopyDataFromStoreBuffer,B3

$C$RL1:    ; CALL OCCURS {_SendData_CopyDataFromStoreBuffer} {0}  ; |191| 
;** --------------------------------------------------------------------------*
           MVKL    .S1     _SendBuffer,A3
           MVKL    .S1     _SendData_DMAPARAMSET,A5
           MVKL    .S1     0x10140,A6
           MVKH    .S1     _SendBuffer,A3
           MVKH    .S1     _SendData_DMAPARAMSET,A5

           STW     .D1T1   A3,*+A5(4)        ; |202| 
||         MVKH    .S1     0x10140,A6
||         ZERO    .L1     A4
||         LDW     .D2T2   *+DP(_SendData_EvId),B8 ; |226| 

           STW     .D1T1   A6,*+A5(8)        ; |206| 
||         SET     .S1     A4,0x0,0xf,A4
||         LDW     .D2T2   *+DP(_last_timer_count),B6 ; |195| 

           STW     .D1T1   A4,*+A5(20)       ; |207| 
||         LDW     .D2T2   *+DP(_current_time),B5 ; |194| 

           LDW     .D1T1   *A5,A4            ; |209| 
||         LDW     .D2T2   *+DP(_SendDataCount),B4 ; |194| 

           ZERO    .L2     B7
           MVKH    .S2     0x2a00000,B7
           SHL     .S2     B8,5,B8           ; |226| 

           STW     .D1T2   B6,*+A3(12)       ; |195| 
||         ADD     .L2     B7,B8,B6          ; |226| 
||         MVK     .S1     16384,A6          ; |226| 

           STNDW   .D1T2   B5:B4,*+A3(4)     ; |194| 
||         CLR     .S1     A4,22,22,A3       ; |209| 

           CALLP   .S2     __strasgi_64plus,B3
||         STW     .D1T1   A3,*A5            ; |209| 
||         ADD     .L1X    A6,B6,A4          ; |226| 
||         MVK     .S1     0x40,A6           ; |226| 
||         MV      .L2X    A5,B4             ; |226| 

$C$RL2:    ; CALL OCCURS {__strasgi_64plus} {0}  ; |226| 
;** --------------------------------------------------------------------------*
           LDW     .D2T2   *+DP(_SendData_EvId),B4 ; |228| 
           MVK     .L1     1,A3              ; |229| 
           RET     .S2     B1                ; |236| 

           MVK     .S2     4112,B5           ; |229| 
||         MVK     .L1     4,A4              ; |234| 

           MVK     .S1     32,A5             ; |228| 
||         MV      .L2X    A3,B9             ; |231| 
||         MVK     .S2     4116,B6           ; |231| 
||         STW     .D2T1   A4,*+DP(_SendDataCount) ; |234| 

           SUBAW   .D2     B4,8,B8           ; |231| 
||         CMPLTU  .L1X    B4,A5,A0          ; |228| 
||         SHL     .S2X    A3,B4,B4          ; |229| 
||         ADD     .L2     B5,B7,B5          ; |229| 

   [ A0]   STW     .D2T2   B4,*B5            ; |229| 
||         SHL     .S2     B9,B8,B4          ; |231| 
||         ADD     .L2     B6,B7,B5          ; |231| 

   [!A0]   STW     .D2T2   B4,*B5            ; |231| 
           ; BRANCH OCCURS {B1}              ; |236| 
	.sect	".text"
	.clink
	.global	_CopyDataToSendBuffer

;******************************************************************************
;* FUNCTION NAME: CopyDataToSendBuffer                                        *
;*                                                                            *
;*   Regs Modified     : A0,A3,A4,A5,B4,B5,B6,B7                              *
;*   Regs Used         : A0,A3,A4,A5,A6,B3,B4,B5,B6,B7,DP                     *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_CopyDataToSendBuffer:
;** --------------------------------------------------------------------------*

           SHRU    .S1     A4,1,A5           ; |70| 
||         LDW     .D2T2   *+DP(_SendDataCount),B6 ; |56| 
||         MVKL    .S2     _SendBuffer,B7
||         MV      .L1     A6,A3             ; |53| 

           SUB     .L1     A5,1,A0           ; |70| 
||         LDW     .D2T2   *+DP(_current_time),B5 ; |67| 
||         MVKH    .S2     _SendBuffer,B7

   [!A0]   BNOP    .S1     $C$L26,1          ; |70| 
   [ A0]   MVC     .S2X    A0,ILC

           ADDAW   .D2     B7,B6,B6          ; |56| 
||         ADD     .L2X    A4,B6,B7          ; |63| 

           STW     .D2T2   B7,*+DP(_SendDataCount) ; |63| 
           STDW    .D2T2   B5:B4,*B6         ; |67| 
           ; BRANCHCC OCCURS {$C$L26}        ; |70| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\SendData.c
;*      Loop source line                 : 70
;*      Loop opening brace source line   : 70
;*      Loop closing brace source line   : 73
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
$C$L23:    ; PIPED LOOP PROLOG
           SPLOOP  2       ;8                ; (P) 
;** --------------------------------------------------------------------------*
$C$L24:    ; PIPED LOOP KERNEL
           LDDW    .D1T1   *A3++,A5:A4       ; |71| (P) <0,0> 
           NOP             4

           SPMASK          S2
||         ADD     .S2     8,B6,B6           ; |67| 
||         MV      .L2X    A5,B5             ; |71| (P) <0,5> Define a twin register

           MV      .L2X    A4,B4             ; |71| <0,6> Define a twin register

           SPKERNEL 3,0
||         STDW    .D2T2   B5:B4,*B6++       ; |71| <0,7> 

;** --------------------------------------------------------------------------*
$C$L25:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
$C$L26:    
           RETNOP  .S2     B3,4              ; |77| 
           ZERO    .L1     A4                ; |75| 
           ; BRANCH OCCURS {B3}              ; |77| 
	.sect	".text"
	.clink
	.global	_SendDataBuffer

;******************************************************************************
;* FUNCTION NAME: SendDataBuffer                                              *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B3,B4,B5,B6,B7,B8,  *
;*                           B9,A31,B31                                       *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B3,B4,B5,B6,B7,B8,  *
;*                           B9,DP,SP,A31,B31                                 *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_SendDataBuffer:
;** --------------------------------------------------------------------------*

           MVK     .S1     296,A7            ; |30| 
||         MV      .L1     A4,A5             ; |30| 
||         MVK     .D1     0x2,A4            ; |35| 

           CMPGTU  .L1     A6,A7,A1          ; |30| 
||         AND     .D1     7,A6,A0           ; |39| 
||         PACK2   .S1     A6,A5,A8          ; |37| 

   [ A1]   BNOP    .S1     $C$L32,1          ; |35| 
||         MV      .L1X    B4,A3             ; |30| 
||         LDW     .D2T2   *+DP(_SendDataCount),B4 ; |47| 
|| [!A1]   AND     .D1     -8,A6,A4          ; |40| 

   [ A0]   ADD     .L1     8,A4,A6           ; |40| 
   [!A1]   SHRU    .S1     A6,2,A4           ; |43| 
           MV      .L1X    B3,A2             ; |30| 
           ADD     .L2X    B4,A4,B5          ; |47| 
           ; BRANCHCC OCCURS {$C$L32}        ; |35| 
;** --------------------------------------------------------------------------*

           ADD     .L1     2,A4,A4           ; |43| 
||         MVK     .S2     80,B31            ; |47| 
||         ADD     .L2     2,B5,B7           ; |47| 
||         LDW     .D2T1   *+DP(_current_time),A9 ; |47| 
||         MV      .S1     A3,A6             ; |47| 

           SHRU    .S1     A4,1,A5           ; |70| 
||         CMPGTU  .L2     B7,B31,B0         ; |47| 
||         MVKL    .S2     _SendBuffer,B6

           SUB     .L1     A5,1,A0           ; |70| 
|| [!B0]   B       .S1     $C$L27            ; |47| 
||         MVKH    .S2     _SendBuffer,B6
||         ADD     .D1X    A4,B4,A5          ; |63| 

   [ B0]   MVK     .L1     0x1,A0            ; |67| nullify predicate
|| [!B0]   SHRU    .S1     A4,1,A4           ; |71| 
||         ADDAW   .D2     B6,B4,B6          ; |56| 
||         MV      .L2X    A8,B4             ; |47| 

   [!B0]   STW     .D2T1   A5,*+DP(_SendDataCount) ; |63| 
|| [!A0]   B       .S1     $C$L31            ; |70| 

   [ B0]   CALL    .S1     _SendData_StoreToBuffer ; |47| 
   [!B0]   SUB     .L1     A4,1,A4           ; |71| 
   [!B0]   STDW    .D2T1   A9:A8,*B6         ; |67| 
           ; BRANCHCC OCCURS {$C$L27}        ; |47| 
;** --------------------------------------------------------------------------*
           ADDKPC  .S2     $C$RL3,B3,2       ; |47| 
$C$RL3:    ; CALL OCCURS {_SendData_StoreToBuffer} {0}  ; |47| 
;** --------------------------------------------------------------------------*
           RETNOP  .S2X    A2,5              ; |50| 
           ; BRANCH OCCURS {A2}              ; |50| 
;** --------------------------------------------------------------------------*
$C$L27:    
   [ A0]   MVC     .S2X    A4,ILC
           NOP             1
           ; BRANCHCC OCCURS {$C$L31}        ; |70| 
;** --------------------------------------------------------------------------*
           NOP             2
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\SendData.c
;*      Loop source line                 : 70
;*      Loop opening brace source line   : 70
;*      Loop closing brace source line   : 73
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
           LDDW    .D1T1   *A3++,A5:A4       ; |71| (P) <0,0> 
           NOP             4

           SPMASK          S2
||         ADD     .S2     8,B6,B6           ; |67| 
||         MV      .L2X    A5,B5             ; |71| (P) <0,5> Define a twin register

           MV      .L2X    A4,B4             ; |71| <0,6> Define a twin register

           SPKERNEL 3,0
||         STDW    .D2T2   B5:B4,*B6++       ; |71| <0,7> 

;** --------------------------------------------------------------------------*
$C$L30:    ; PIPED LOOP EPILOG
;** --------------------------------------------------------------------------*
$C$L31:    
           ZERO    .L1     A4                ; |48| 
;** --------------------------------------------------------------------------*
$C$L32:    
           RETNOP  .S2X    A2,5              ; |50| 
           ; BRANCH OCCURS {A2}              ; |50| 
;*****************************************************************************
;* UNDEFINED EXTERNAL REFERENCES                                             *
;*****************************************************************************
	.global	_memset
	.global	_current_time
	.global	_last_timer_count
	.global	__strasgi_64plus

;******************************************************************************
;* BUILD ATTRIBUTES                                                           *
;******************************************************************************
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_needed(0)
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_preserved(0)
	.battr "TI", Tag_File, 1, Tag_Tramps_Use_SOC(1)
