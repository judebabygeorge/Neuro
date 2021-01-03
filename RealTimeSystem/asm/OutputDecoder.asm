;******************************************************************************
;* TMS320C6x C/C++ Codegen                                          PC v7.4.2 *
;* Date/Time created: Sat May 31 10:51:05 2014                                *
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

	.global	_DecoderState
_DecoderState:	.usect	".far",1920,8
	.global	_nDecoders
	.bss	_nDecoders,4,4
	.global	_ChannelWeights
_ChannelWeights:	.usect	".far",30976,8
	.global	_uDecoderOutput
_uDecoderOutput:	.usect	".far",256,8
	.global	_uDecoderOutput_compressed
_uDecoderOutput_compressed:	.usect	".far",40,8
	.global	_DecoderOutputValid
	.bss	_DecoderOutputValid,4,4
	.global	_DecoderCheck
	.bss	_DecoderCheck,4,4
	.global	_DecoderCheckWindow
	.bss	_DecoderCheckWindow,4,4
	.global	_Decoder_SynapseWeights
_Decoder_SynapseWeights:	.usect	".far",30976,8
	.global	_Decoder_V
_Decoder_V:	.usect	".far",256,8
	.global	_Decoder_Iex
_Decoder_Iex:	.usect	".far",256,8
	.global	_Decoder_Iinh
_Decoder_Iinh:	.usect	".far",256,8
	.global	_Decoder_d_tau
_Decoder_d_tau:	.usect	".far",12,8
;	opt6x C:\\Users\\45c\\AppData\\Local\\Temp\\097082 C:\\Users\\45c\\AppData\\Local\\Temp\\097084 
	.sect	".text"
	.clink
	.global	_scale_array

;******************************************************************************
;* FUNCTION NAME: scale_array                                                 *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,B0,*
;*                           B1,B2,B3,B4,B5,B6,B7,B8,B9,B13,SP,A16,A17,A18,   *
;*                           A19,A20,A21,A22,A23,A24,A25,A26,A27,A28,A29,A30, *
;*                           A31,B16,B17,B18,B19,B20,B21,B22,B23,B24,B25,B26, *
;*                           B27,B28,B29,B30,B31                              *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,B0,*
;*                           B1,B2,B3,B4,B5,B6,B7,B8,B9,B13,DP,SP,A16,A17,A18,*
;*                           A19,A20,A21,A22,A23,A24,A25,A26,A27,A28,A29,A30, *
;*                           A31,B16,B17,B18,B19,B20,B21,B22,B23,B24,B25,B26, *
;*                           B27,B28,B29,B30,B31                              *
;*   Local Frame Size  : 0 Args + 0 Auto + 32 Save = 32 byte                  *
;******************************************************************************
_scale_array:
;** --------------------------------------------------------------------------*

           SHRU    .S1     A6,1,A0           ; |249| 
||         STW     .D2T2   B13,*SP--(8)      ; |241| 
||         MV      .L2     B3,B13            ; |241| 

   [!A0]   BNOP    .S1     $C$L2,2           ; |249| 
||         STDW    .D2T1   A13:A12,*SP--     ; |241| 
||         MV      .L1     A4,A12            ; |241| 
||         MV      .D1X    B4,A13            ; |241| 

           STDW    .D2T1   A11:A10,*SP--     ; |241| 
           STW     .D2T1   A14,*SP--(8)      ; |241| 
           MV      .L1     A0,A14            ; |251| 
           ; BRANCHCC OCCURS {$C$L2}         ; |249| 
;** --------------------------------------------------------------------------*

           CALL    .S1     __mpyf            ; |253| 
||         LDDW    .D1T1   *A12,A11:A10      ; |253| 

           MV      .L2X    A13,B4            ; |253| 
           NOP             3
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*      Disqualified loop: Loop contains a call
;*      Disqualified loop: Loop contains non-pipelinable instructions
;*      Disqualified loop: Loop contains a call
;*      Disqualified loop: Loop contains non-pipelinable instructions
;*----------------------------------------------------------------------------*
$C$L1:    

           ADDKPC  .S2     $C$RL1,B3,0       ; |253| 
||         MV      .L1     A10,A4            ; |253| 

$C$RL1:    ; CALL OCCURS {__mpyf} {0}        ; |253| 
;** --------------------------------------------------------------------------*

           CALLP   .S2     __mpyf,B3
||         MV      .L2X    A13,B4            ; |253| 
||         MV      .L1     A4,A10            ; |253| 
||         MV      .S1     A11,A4            ; |253| 

$C$RL0:    ; CALL OCCURS {__mpyf} {0}        ; |253| 
;** --------------------------------------------------------------------------*

           MV      .L1     A4,A11            ; |253| 
||         SUB     .S1     A14,1,A0          ; |249| 

           STDW    .D1T1   A11:A10,*A12++    ; |253| 
|| [ A0]   B       .S1     $C$L1             ; |249| 

   [ A0]   CALL    .S1     __mpyf            ; |253| 
|| [ A0]   LDDW    .D1T1   *A12,A11:A10      ; |253| 

   [ A0]   MV      .L2X    A13,B4            ; |253| 
           SUB     .L1     A14,1,A14         ; |249| 
           NOP             2
           ; BRANCHCC OCCURS {$C$L1}         ; |249| 
;** --------------------------------------------------------------------------*
$C$L2:    
           LDW     .D2T1   *++SP(8),A14      ; |256| 

           LDDW    .D2T1   *++SP,A11:A10     ; |256| 
||         MV      .L2     B13,B3            ; |256| 

           LDDW    .D2T1   *++SP,A13:A12     ; |256| 
||         RET     .S2     B3                ; |256| 

           LDW     .D2T2   *++SP(8),B13      ; |256| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |256| 
	.sect	".text"
	.clink
	.global	_update_decoder_state_2

;******************************************************************************
;* FUNCTION NAME: update_decoder_state_2                                      *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,   *
;*                           A15,B0,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,   *
;*                           B13,SP,A16,A17,A18,A19,A20,A21,A22,A23,A24,A25,  *
;*                           A26,A27,A28,A29,A30,A31,B16,B17,B18,B19,B20,B21, *
;*                           B22,B23,B24,B25,B26,B27,B28,B29,B30,B31          *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,   *
;*                           A15,B0,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,   *
;*                           B13,DP,SP,A16,A17,A18,A19,A20,A21,A22,A23,A24,   *
;*                           A25,A26,A27,A28,A29,A30,A31,B16,B17,B18,B19,B20, *
;*                           B21,B22,B23,B24,B25,B26,B27,B28,B29,B30,B31      *
;*   Local Frame Size  : 0 Args + 4 Auto + 56 Save = 60 byte                  *
;******************************************************************************
_update_decoder_state_2:
;** --------------------------------------------------------------------------*
           STW     .D2T1   A11,*SP--(8)      ; |209| 
           STW     .D2T1   A10,*SP--(8)      ; |209| 
           STDW    .D2T2   B13:B12,*SP--     ; |209| 
           STDW    .D2T2   B11:B10,*SP--     ; |209| 
           STDW    .D2T1   A15:A14,*SP--     ; |209| 
           STDW    .D2T1   A13:A12,*SP--     ; |209| 
           STW     .D2T2   B3,*SP--(16)      ; |209| 
           LDW     .D2T2   *+DP(_nSpikes),B0 ; |214| 
           LDW     .D2T1   *+DP(_nDecoders),A3
           MVKL    .S1     _SpikeData,A11
           MVKH    .S1     _SpikeData,A11
           NOP             1
   [!B0]   B       .S1     $C$L8
           STW     .D2T1   A3,*+SP(4)
           LDW     .D2T1   *+DP(_nDecoders),A3
           MV      .L2     B0,B12
           NOP             2
           ; BRANCHCC OCCURS {$C$L8}  
;** --------------------------------------------------------------------------*
           ZERO    .L2     B13
           STW     .D2T1   A3,*+SP(4)
           LDW     .D2T1   *+SP(4),A0
           NOP             4
;** --------------------------------------------------------------------------*
;**   BEGIN LOOP $C$L3
;** --------------------------------------------------------------------------*
$C$L3:    

   [!A0]   BNOP    .S1     $C$L7,1
|| [ A0]   LDW     .D1T1   *A11,A6
|| [ A0]   MV      .L1     A0,A3
|| [ A0]   MVKL    .S2     _Decoder_Iex,B4
|| [!A0]   ZERO    .L2     B11               ; |217| 

   [ A0]   MVKH    .S2     _Decoder_Iex,B4
   [ A0]   MVKL    .S1     _Decoder_SynapseWeights,A5
   [ A0]   MVKH    .S1     _Decoder_SynapseWeights,A5
           MPY32   .M1     A3,A6,A6
           ; BRANCHCC OCCURS {$C$L7}  
;** --------------------------------------------------------------------------*

           ZERO    .L1     A12
||         MV      .L2X    A0,B11

           MV      .L1X    B4,A15
           MV      .L2X    A0,B10
           ADDAW   .D1     A5,A6,A14
;** --------------------------------------------------------------------------*

           CALL    .S1     __cmpf            ; |219| 
||         LDW     .D1T1   *A14++,A13        ; |218| 

;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*      Disqualified loop: Loop contains a call
;*      Disqualified loop: Loop contains non-pipelinable instructions
;*      Disqualified loop: Loop contains control code
;*----------------------------------------------------------------------------*
$C$L4:    
           ADDKPC  .S2     $C$RL2,B3,3       ; |219| 

           MV      .L2     B13,B4            ; |219| 
||         MV      .L1     A13,A4            ; |219| 

$C$RL2:    ; CALL OCCURS {__cmpf} {0}        ; |219| 
;** --------------------------------------------------------------------------*

           CMPGT   .L1     A4,0,A0           ; |219| 
||         MVKL    .S1     _Decoder_Iinh,A3

   [ A0]   B       .S2     $C$L5             ; |219| 
||         MVKH    .S1     _Decoder_Iinh,A3

   [!A0]   CALL    .S1     __addf            ; |223| 
||         ADD     .L1     A12,A3,A10        ; |223| 

   [ A0]   CALL    .S1     __addf            ; |220| 
|| [!A0]   LDW     .D1T1   *A10,A4           ; |223| 
|| [ A0]   ADD     .L1     A12,A15,A10       ; |220| 

   [ A0]   LDW     .D1T1   *A10,A4           ; |220| 
           NOP             2
           ; BRANCHCC OCCURS {$C$L5}         ; |219| 
;** --------------------------------------------------------------------------*

           MV      .L2X    A13,B4            ; |223| 
||         ADDKPC  .S2     $C$RL3,B3,0       ; |223| 

$C$RL3:    ; CALL OCCURS {__addf} {0}        ; |223| 
;** --------------------------------------------------------------------------*

           B       .S2     $C$L6             ; |223| 
||         SUB     .L1X    B10,1,A0          ; |217| 
||         ADD     .S1     4,A12,A12         ; |217| 
||         STW     .D1T1   A4,*A10           ; |223| 
||         SUB     .L2     B10,1,B10         ; |217| 

   [ A0]   BNOP    .S1     $C$L4,4           ; |217| 
           ; BRANCH OCCURS {$C$L6}           ; |223| 
;** --------------------------------------------------------------------------*
$C$L5:    
           MV      .L2X    A13,B4            ; |220| 
           ADDKPC  .S2     $C$RL4,B3,0       ; |220| 
$C$RL4:    ; CALL OCCURS {__addf} {0}        ; |220| 
;** --------------------------------------------------------------------------*
           SUB     .L1X    B10,1,A0          ; |217| 
   [ A0]   BNOP    .S1     $C$L4,3           ; |217| 

           ADD     .L1     4,A12,A12         ; |217| 
||         STW     .D1T1   A4,*A10           ; |220| 
||         SUB     .L2     B10,1,B10         ; |217| 

;** --------------------------------------------------------------------------*
$C$L6:    

   [ A0]   CALL    .S1     __cmpf            ; |219| 
|| [ A0]   LDW     .D1T1   *A14++,A13        ; |218| 

           ; BRANCHCC OCCURS {$C$L4}         ; |217| 
;** --------------------------------------------------------------------------*
$C$L7:    

           SUB     .L1X    B12,1,A0          ; |214| 
||         SUB     .L2     B12,1,B12         ; |214| 
||         ADD     .S1     8,A11,A11         ; |214| 

   [ A0]   BNOP    .S1     $C$L3,5           ; |214| 
||         LDW     .D2T1   *+SP(4),A0

           ; BRANCHCC OCCURS {$C$L3}         ; |214| 
;** --------------------------------------------------------------------------*
$C$L8:    
           LDW     .D2T1   *+SP(4),A0
           MVKL    .S1     _Decoder_Iex,A11
           MVKH    .S1     _Decoder_Iex,A11
           MV      .L1     A11,A12
           MVKL    .S1     _Decoder_V,A10

   [!A0]   B       .S1     $C$L10            ; |229| 
||         MV      .L2X    A12,B4

   [ A0]   LDW     .D2T2   *+B4[B11],B10
           MV      .L1     A11,A15
           MVKH    .S1     _Decoder_V,A10
           MV      .L1     A10,A14
           MV      .L1     A0,A13            ; |230| 
           ; BRANCHCC OCCURS {$C$L10}        ; |229| 
;** --------------------------------------------------------------------------*
           CALL    .S1     __addf            ; |230| 
           LDW     .D1T1   *A15++,A4         ; |230| 
           MV      .L2     B10,B4            ; |230| 
           NOP             2
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*      Disqualified loop: Loop contains a call
;*      Disqualified loop: Loop contains non-pipelinable instructions
;*----------------------------------------------------------------------------*
$C$L9:    
           ADDKPC  .S2     $C$RL5,B3,0       ; |230| 
$C$RL5:    ; CALL OCCURS {__addf} {0}        ; |230| 
;** --------------------------------------------------------------------------*
           SUB     .L1     A13,1,A0          ; |229| 
   [ A0]   B       .S1     $C$L9             ; |229| 

   [ A0]   CALL    .S1     __addf            ; |230| 
||         STW     .D1T1   A4,*A14++         ; |230| 

   [ A0]   LDW     .D1T1   *A15++,A4         ; |230| 
   [ A0]   MV      .L2     B10,B4            ; |230| 
           SUB     .L1     A13,1,A13         ; |229| 
           NOP             1
           ; BRANCHCC OCCURS {$C$L9}         ; |229| 
;** --------------------------------------------------------------------------*
$C$L10:    
           LDW     .D2T1   *+SP(4),A3
           MVKL    .S2     _Decoder_d_tau,B11
           MVKH    .S2     _Decoder_d_tau,B11
           LDW     .D2T2   *B11,B10          ; |235| 
           NOP             1
           SHRU    .S1     A3,1,A0           ; |249| 

   [!A0]   BNOP    .S1     $C$L12,5          ; |249| 
||         MV      .L1     A0,A14            ; |235| 
||         MV      .D1     A0,A15            ; |251| 

           ; BRANCHCC OCCURS {$C$L12}        ; |249| 
;** --------------------------------------------------------------------------*

           CALL    .S1     __mpyf            ; |253| 
||         LDDW    .D1T1   *A10,A13:A12      ; |253| 

           MV      .L2     B10,B4            ; |253| 
           NOP             3
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*      Disqualified loop: Loop contains a call
;*      Disqualified loop: Loop contains non-pipelinable instructions
;*      Disqualified loop: Loop contains a call
;*      Disqualified loop: Loop contains non-pipelinable instructions
;*----------------------------------------------------------------------------*
$C$L11:    

           ADDKPC  .S2     $C$RL7,B3,0       ; |253| 
||         MV      .L1     A12,A4            ; |253| 

$C$RL7:    ; CALL OCCURS {__mpyf} {0}        ; |253| 
;** --------------------------------------------------------------------------*

           CALLP   .S2     __mpyf,B3
||         MV      .L2     B10,B4            ; |253| 
||         MV      .L1     A4,A12            ; |253| 
||         MV      .S1     A13,A4            ; |253| 

$C$RL6:    ; CALL OCCURS {__mpyf} {0}        ; |253| 
;** --------------------------------------------------------------------------*

           MV      .L1     A4,A13            ; |253| 
||         SUB     .S1     A15,1,A0          ; |249| 

           STDW    .D1T1   A13:A12,*A10++    ; |253| 
|| [ A0]   B       .S1     $C$L11            ; |249| 

   [ A0]   CALL    .S1     __mpyf            ; |253| 
|| [ A0]   LDDW    .D1T1   *A10,A13:A12      ; |253| 

   [ A0]   MV      .L2     B10,B4            ; |253| 
           SUB     .L1     A15,1,A15         ; |249| 
           NOP             2
           ; BRANCHCC OCCURS {$C$L11}        ; |249| 
;** --------------------------------------------------------------------------*
$C$L12:    

           MV      .L1     A14,A0            ; |236| 
||         ADD     .L2     4,B11,B11
||         LDW     .D2T1   *+SP(4),A3
||         MV      .S1     A11,A12           ; |236| 

   [!A0]   BNOP    .S1     $C$L14,4          ; |249| 
||         LDW     .D2T2   *B11,B10          ; |236| 

           SHRU    .S1     A3,1,A13          ; |251| 
           ; BRANCHCC OCCURS {$C$L14}        ; |249| 
;** --------------------------------------------------------------------------*

           CALL    .S1     __mpyf            ; |253| 
||         LDDW    .D1T1   *A12,A11:A10      ; |253| 

           MV      .L2     B10,B4            ; |253| 
           NOP             3
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*      Disqualified loop: Loop contains a call
;*      Disqualified loop: Loop contains non-pipelinable instructions
;*      Disqualified loop: Loop contains a call
;*      Disqualified loop: Loop contains non-pipelinable instructions
;*----------------------------------------------------------------------------*
$C$L13:    

           ADDKPC  .S2     $C$RL9,B3,0       ; |253| 
||         MV      .L1     A10,A4            ; |253| 

$C$RL9:    ; CALL OCCURS {__mpyf} {0}        ; |253| 
;** --------------------------------------------------------------------------*

           CALLP   .S2     __mpyf,B3
||         MV      .L2     B10,B4            ; |253| 
||         MV      .L1     A4,A10            ; |253| 
||         MV      .S1     A11,A4            ; |253| 

$C$RL8:    ; CALL OCCURS {__mpyf} {0}        ; |253| 
;** --------------------------------------------------------------------------*

           MV      .L1     A4,A11            ; |253| 
||         SUB     .S1     A13,1,A0          ; |249| 

           STDW    .D1T1   A11:A10,*A12++    ; |253| 
|| [ A0]   B       .S1     $C$L13            ; |249| 

   [ A0]   CALL    .S1     __mpyf            ; |253| 
|| [ A0]   LDDW    .D1T1   *A12,A11:A10      ; |253| 

   [ A0]   MV      .L2     B10,B4            ; |253| 
           SUB     .L1     A13,1,A13         ; |249| 
           NOP             2
           ; BRANCHCC OCCURS {$C$L13}        ; |249| 
;** --------------------------------------------------------------------------*
$C$L14:    

           MV      .L1     A14,A0
||         LDW     .D2T1   *+SP(4),A3
||         ADD     .L2     4,B11,B4
||         MVKL    .S1     _Decoder_Iinh,A12

   [!A0]   BNOP    .S2     $C$L16,4          ; |249| 
||         LDW     .D2T2   *B4,B10           ; |237| 
||         MVKH    .S1     _Decoder_Iinh,A12

           SHRU    .S1     A3,1,A13          ; |251| 
           ; BRANCHCC OCCURS {$C$L16}        ; |249| 
;** --------------------------------------------------------------------------*

           CALL    .S1     __mpyf            ; |253| 
||         LDDW    .D1T1   *A12,A11:A10      ; |253| 

           MV      .L2     B10,B4            ; |253| 
           NOP             3
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*      Disqualified loop: Loop contains a call
;*      Disqualified loop: Loop contains non-pipelinable instructions
;*      Disqualified loop: Loop contains a call
;*      Disqualified loop: Loop contains non-pipelinable instructions
;*----------------------------------------------------------------------------*
$C$L15:    

           ADDKPC  .S2     $C$RL11,B3,0      ; |253| 
||         MV      .L1     A10,A4            ; |253| 

$C$RL11:   ; CALL OCCURS {__mpyf} {0}        ; |253| 
;** --------------------------------------------------------------------------*

           CALLP   .S2     __mpyf,B3
||         MV      .L2     B10,B4            ; |253| 
||         MV      .L1     A4,A10            ; |253| 
||         MV      .S1     A11,A4            ; |253| 

$C$RL10:   ; CALL OCCURS {__mpyf} {0}        ; |253| 
;** --------------------------------------------------------------------------*

           MV      .L1     A4,A11            ; |253| 
||         SUB     .S1     A13,1,A0          ; |249| 

           STDW    .D1T1   A11:A10,*A12++    ; |253| 
|| [ A0]   B       .S1     $C$L15            ; |249| 

   [ A0]   CALL    .S1     __mpyf            ; |253| 
|| [ A0]   LDDW    .D1T1   *A12,A11:A10      ; |253| 

   [ A0]   MV      .L2     B10,B4            ; |253| 
           SUB     .L1     A13,1,A13         ; |249| 
           NOP             2
           ; BRANCHCC OCCURS {$C$L15}        ; |249| 
;** --------------------------------------------------------------------------*
$C$L16:    
           LDW     .D2T2   *++SP(16),B3      ; |238| 
           LDDW    .D2T1   *++SP,A13:A12     ; |238| 
           LDDW    .D2T1   *++SP,A15:A14     ; |238| 
           LDDW    .D2T2   *++SP,B11:B10     ; |238| 
           LDDW    .D2T2   *++SP,B13:B12     ; |238| 

           LDW     .D2T1   *++SP(8),A10      ; |238| 
||         RET     .S2     B3                ; |238| 

           LDW     .D2T1   *++SP(8),A11      ; |238| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |238| 
	.sect	".text"
	.clink
	.global	_update_decoder_state

;******************************************************************************
;* FUNCTION NAME: update_decoder_state                                        *
;*                                                                            *
;*   Regs Modified     : A3,A4,A5,A6,A7,B0,B1,B4,B5,B6,B7                     *
;*   Regs Used         : A3,A4,A5,A6,A7,B0,B1,B3,B4,B5,B6,B7,DP               *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_update_decoder_state:
;** --------------------------------------------------------------------------*
           LDW     .D2T2   *+DP(_DecoderCheckWindow),B4 ; |124| 
           LDW     .D2T2   *+DP(_DecoderCheck),B5 ; |124| 
           LDW     .D2T2   *+DP(_nSpikes),B0 ; |125| 
           NOP             2
           ADDK    .S2     -250,B4           ; |124| 
           CMPLTU  .L2     B5,B4,B1          ; |124| 

   [!B1]   MVK     .L2     0x1,B0            ; nullify predicate
|| [!B1]   B       .S1     $C$L20            ; |124| 
|| [ B1]   MVKL    .S2     _DecoderState,B5
|| [ B1]   LDW     .D2T2   *+DP(_current_time),B4
|| [ B1]   MVK     .L1     0xffffffff,A3

   [!B0]   BNOP    .S1     $C$L20,1          ; |125| 
|| [ B1]   MVKH    .S2     _DecoderState,B5

   [ B1]   MVKL    .S1     _SpikeData,A6
   [ B1]   MVKH    .S1     _SpikeData,A6
   [ B1]   MV      .L1X    B5,A7
           ; BRANCHCC OCCURS {$C$L20}        ; |124| 
;** --------------------------------------------------------------------------*
   [ B0]   SUB     .L2     B0,1,B5
           ; BRANCHCC OCCURS {$C$L20}        ; |125| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\OutputDecoder.c
;*      Loop source line                 : 125
;*      Loop opening brace source line   : 125
;*      Loop closing brace source line   : 131
;*      Known Minimum Trip Count         : 1                    
;*      Known Maximum Trip Count         : 121                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 7
;*      Unpartitioned Resource Bound     : 3
;*      Partitioned Resource Bound(*)    : 3
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        1     
;*      .S units                     1        1     
;*      .D units                     3*       2     
;*      .M units                     0        0     
;*      .X cross paths               0        2     
;*      .T address paths             3*       2     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          2        1     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1        1     
;*      Bound(.L .S .D .LS .LSD)     2        2     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 7  Schedule found with 3 iterations in parallel
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

           SPLOOPD 7       ;21               ; (P) 
||         MVC     .S2     B5,ILC

;** --------------------------------------------------------------------------*
$C$L18:    ; PIPED LOOP KERNEL
           LDW     .D1T1   *A6++(8),A5       ; |126| (P) <0,0> 
           NOP             5

           SPMASK          L2
||         MV      .L2X    A3,B5

           SHL     .S1     A5,4,A3           ; |130| (P) <0,7> 
||         SHL     .S2X    A5,4,B7           ; |127| (P) <0,7> 

           ADD     .L1     A7,A3,A4          ; |130| (P) <0,8> 
||         ADD     .L2X    A7,B7,B6          ; |127| (P) <0,8> 

           LDW     .D1T1   *+A4(4),A3        ; |130| (P) <0,9>  ^ 
||         LDW     .D2T2   *B6,B7            ; |127| (P) <0,9>  ^ 

           NOP             4

           ADD     .L1     1,A3,A5           ; |130| <0,14>  ^ 
||         CMPEQ   .L2     B7,B5,B0          ; |127| <0,14>  ^ 

           SPKERNEL 1,0
||         STW     .D1T1   A5,*+A4(4)        ; |130| <0,15>  ^ 
|| [ B0]   STW     .D2T2   B4,*B6            ; |128| <0,15>  ^ 

;** --------------------------------------------------------------------------*
$C$L19:    ; PIPED LOOP EPILOG
           NOP             2
;** --------------------------------------------------------------------------*
$C$L20:    
           RETNOP  .S2     B3,5              ; |134| 
           ; BRANCH OCCURS {B3}              ; |134| 
	.sect	".text"
	.clink
	.global	_sort_id

;******************************************************************************
;* FUNCTION NAME: sort_id                                                     *
;*                                                                            *
;*   Regs Modified     : A0,A1,A3,A4,A5,A6,A7,A8,A9,B0,B1,B4,B5,B6,B7,B8,B9,  *
;*                           SP,A16,A17,B16,B17,B18,B19,B31                   *
;*   Regs Used         : A0,A1,A3,A4,A5,A6,A7,A8,A9,B0,B1,B3,B4,B5,B6,B7,B8,  *
;*                           B9,SP,A16,A17,B16,B17,B18,B19,B31                *
;*   Local Frame Size  : 0 Args + 260 Auto + 0 Save = 260 byte                *
;******************************************************************************
_sort_id:
;** --------------------------------------------------------------------------*

           MV      .L1     A4,A9             ; |173| 
||         MV      .S1X    B4,A7             ; |173| 
||         MV      .L2X    A6,B0             ; |173| 

   [!B0]   BNOP    .S1     $C$L24,1          ; |181| 
||         MV      .L2X    A6,B6             ; |173| 

   [ B0]   MVC     .S2     B6,ILC
           ZERO    .L1     A3                ; |181| 
           ADDK    .S2     -264,SP           ; |173| 
           ADD     .L2     8,SP,B5
           ; BRANCHCC OCCURS {$C$L24}        ; |181| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\OutputDecoder.c
;*      Loop source line                 : 181
;*      Loop opening brace source line   : 181
;*      Loop closing brace source line   : 184
;*      Known Minimum Trip Count         : 1                    
;*      Known Maximum Trip Count         : 65                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 1
;*      Unpartitioned Resource Bound     : 2
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     0        0     
;*      .D units                     2*       1     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             2*       1     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          0        1     (.L or .S or .D unit)
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
$C$L21:    ; PIPED LOOP PROLOG

           SPLOOP  2       ;8                ; (P) 
||         MV      .L1     A4,A5
||         MV      .S1X    B5,A4
||         MV      .L2     B4,B5
||         MV      .S2X    A3,B4

;** --------------------------------------------------------------------------*
$C$L22:    ; PIPED LOOP KERNEL
           STW     .D2T2   B4,*B5++          ; |182| (P) <0,0>  ^ 

           ADD     .L2     1,B4,B4           ; |181| (P) <0,1>  ^ 
||         LDW     .D1T1   *A5++,A3          ; |183| (P) <0,1>  ^ 

           NOP             3
           NOP             1

           SPKERNEL 2,0
||         STW     .D1T1   A3,*A4++          ; |183| <0,6> 

;** --------------------------------------------------------------------------*
$C$L23:    ; PIPED LOOP EPILOG
           NOP             1
;** --------------------------------------------------------------------------*
$C$L24:    

           CMPEQ   .L1X    B0,1,A0           ; |186| 
||         MVK     .L2     0xffffffff,B17
||         ZERO    .S2     B9                ; |186| 
||         SUB     .S1     A7,4,A17
||         ADD     .D2     8,SP,B16

   [ A0]   BNOP    .S1     $C$L30,1          ; |186| 
||         ADD     .L2     B17,B0,B4
|| [!A0]   ADD     .S2     1,B9,B5           ; |190| 
|| [!A0]   SUB     .D2     B0,B9,B6          ; |191| 

   [!A0]   ZERO    .L2     B19               ; |189| 
   [!A0]   ADD     .L2     B17,B6,B31        ; |191| 
   [!A0]   CMPLTU  .L2     B5,B0,B1          ; |190| 
           MV      .L1X    B4,A1             ; Define a twin register
           ; BRANCHCC OCCURS {$C$L30}        ; |186| 
;** --------------------------------------------------------------------------*
;**   BEGIN LOOP $C$L25
;** --------------------------------------------------------------------------*
$C$L25:    

           LDW     .D1T1   *++A17,A16        ; |187| 
|| [ B1]   MVC     .S2     B31,ILC
|| [ B1]   ADDAW   .D2     SP,B5,B6

   [!B1]   BNOP    .S1     $C$L29,3          ; |190| 
           MV      .L1     A16,A8            ; |188| 
           LDW     .D1T2   *+A9[A8],B18      ; |188| 
           ; BRANCHCC OCCURS {$C$L29}        ; |190| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\OutputDecoder.c
;*      Loop source line                 : 190
;*      Loop opening brace source line   : 190
;*      Loop closing brace source line   : 197
;*      Known Minimum Trip Count         : 1                    
;*      Known Maximum Trip Count         : 65                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 2
;*      Unpartitioned Resource Bound     : 2
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     1        0     
;*      .S units                     0        0     
;*      .D units                     1        1     
;*      .M units                     0        0     
;*      .X cross paths               1        0     
;*      .T address paths             1        1     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          2        3     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1        0     
;*      Bound(.L .S .D .LS .LSD)     2*       2*    
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
$C$L26:    ; PIPED LOOP PROLOG

           SPLOOP  2       ;8                ; (P) 
||         ADD     .L1X    8,B6,A6

;** --------------------------------------------------------------------------*
$C$L27:    ; PIPED LOOP KERNEL
           LDW     .D1T1   *A6++,A3          ; |192| (P) <0,0>  ^ 
           NOP             3

           SPMASK          L1,L2,S2
||         SHL     .S2     B5,2,B7
||         MV      .L2X    A7,B6
||         MV      .L1X    B18,A5

           SPMASK          S1,S2
||         MV      .S2X    A16,B8
||         MV      .S1X    B19,A4
||         ADD     .L2     B6,B7,B4          ; |193| (P) <0,5> 
||         CMPLT   .L1     A5,A3,A0          ; |192| (P) <0,5>  ^ 

           ADD     .L2     4,B7,B7           ; |190| <0,6> 
|| [ A0]   MV      .L1     A3,A5             ; |195| <0,6>  ^ 

           SPKERNEL 0,0
|| [ A0]   LDW     .D2T2   *B4,B8            ; |193| <0,7> 
|| [ A0]   MV      .S1X    B5,A4             ; |194| <0,7>  ^ 
||         ADD     .S2     1,B5,B5           ; |190| <0,7>  ^ 

;** --------------------------------------------------------------------------*
$C$L28:    ; PIPED LOOP EPILOG
           NOP             2
           MV      .S1X    B6,A7
           NOP             3
;** --------------------------------------------------------------------------*
           MV      .L2X    A5,B18
           MV      .L2X    A4,B19
           NOP             2
           MV      .L1X    B8,A16
;** --------------------------------------------------------------------------*
$C$L29:    

           CMPEQ   .L1     A16,A8,A0         ; |199| 
||         SUB     .S1     A1,1,A1           ; |186| 
||         ADD     .L2     1,B9,B9           ; |186| 
||         MV      .D1X    B19,A4
||         ADDAW   .D2     SP,B19,B5         ; |200| 

   [!A0]   LDW     .D1T1   *A17,A3           ; |202| 
|| [!A0]   LDW     .D2T2   *B16,B4           ; |200| 
|| [ A1]   SUB     .L2     B0,B9,B6          ; |191| 
|| [ A1]   ZERO    .S2     B19               ; |189| 

   [ A1]   BNOP    .S1     $C$L25,3          ; |186| 
|| [ A1]   ADD     .L2     B17,B6,B31        ; |191| 

   [!A0]   STW     .D2T2   B4,*+B5(8)        ; |200| 
|| [!A0]   STW     .D1T1   A3,*+A7[A4]       ; |202| 
|| [ A1]   ADD     .L2     1,B9,B5           ; |190| 

   [!A0]   STW     .D1T1   A16,*A17          ; |203| 
|| [!A0]   STW     .D2T2   B18,*B16          ; |201| 
||         ADD     .S2     4,B16,B16         ; |186| 
|| [ A1]   CMPLTU  .L2     B5,B0,B1          ; |190| 

           ; BRANCHCC OCCURS {$C$L25}        ; |186| 
;** --------------------------------------------------------------------------*
$C$L30:    
           RETNOP  .S2     B3,4              ; |206| 
           ADDK    .S2     264,SP            ; |206| 
           ; BRANCH OCCURS {B3}              ; |206| 
	.sect	".text"
	.clink
	.global	_setup_decoder_2

;******************************************************************************
;* FUNCTION NAME: setup_decoder_2                                             *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,B0,B1, *
;*                           B2,B3,B4,B5,B6,B7,B8,B9,SP,A16,A17,A18,A19,A20,  *
;*                           A21,A22,A23,A24,A25,A26,A27,A28,A29,A30,A31,B16, *
;*                           B17,B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28, *
;*                           B29,B30,B31                                      *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,B0,B1, *
;*                           B2,B3,B4,B5,B6,B7,B8,B9,DP,SP,A16,A17,A18,A19,   *
;*                           A20,A21,A22,A23,A24,A25,A26,A27,A28,A29,A30,A31, *
;*                           B16,B17,B18,B19,B20,B21,B22,B23,B24,B25,B26,B27, *
;*                           B28,B29,B30,B31                                  *
;*   Local Frame Size  : 0 Args + 0 Auto + 24 Save = 24 byte                  *
;******************************************************************************
_setup_decoder_2:
;** --------------------------------------------------------------------------*
           STW     .D2T1   A11,*SP--(8)      ; |54| 
           STDW    .D2T1   A13:A12,*SP--     ; |54| 
           STW     .D2T1   A10,*SP--(8)      ; |54| 
           LDW     .D1T1   *A4,A3            ; |65| 
           MVK     .L2     0x3,B4            ; |68| 
           MV      .L1     A4,A12            ; |54| 
           MV      .L1X    B4,A11            ; |65| 
           ADD     .L1     4,A4,A4           ; |62| 

           CMPEQ   .L1     A3,1,A0           ; |65| 
||         CMPEQ   .L2X    A3,2,B0           ; |65| 

   [ A0]   B       .S1     $C$L34            ; |65| 
|| [ A0]   LDW     .D1T1   *A4,A3            ; |67| 

   [!A0]   LDW     .D2T2   *+DP(_nDecoders),B4 ; |75| 
           MV      .L1X    B3,A13            ; |54| 
           MVKL    .S1     _Decoder_d_tau,A10
           MVKH    .S1     _Decoder_d_tau,A10
           NOP             1
           ; BRANCHCC OCCURS {$C$L34}        ; |65| 
;** --------------------------------------------------------------------------*

   [!B0]   BNOP    .S2     $C$L36,2          ; |65| 
||         MPY32   .M1X    B4,A3,A3          ; |75| 
||         MVKL    .S1     _Decoder_SynapseWeights,A4

           MVKH    .S1     _Decoder_SynapseWeights,A4
           ADDAW   .D1     A4,A3,A3          ; |75| 
   [ B0]   LDW     .D1T1   *++A12,A4         ; |76| 
           ; BRANCHCC OCCURS {$C$L36}        ; |65| 
;** --------------------------------------------------------------------------*
           NOP             4
           MPY32   .M2X    B4,A4,B0          ; |76| 
           NOP             3

   [!B0]   BNOP    .S1     $C$L36,5          ; |76| 
|| [ B0]   MVC     .S2     B0,ILC

           ; BRANCHCC OCCURS {$C$L36}        ; |76| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\OutputDecoder.c
;*      Loop source line                 : 76
;*      Loop opening brace source line   : 76
;*      Loop closing brace source line   : 78
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 0
;*      Unpartitioned Resource Bound     : 1
;*      Partitioned Resource Bound(*)    : 1
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     0        0     
;*      .D units                     1*       1*    
;*      .M units                     0        0     
;*      .X cross paths               0        1*    
;*      .T address paths             1*       1*    
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          0        1     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        0     
;*      Bound(.L .S .D .LS .LSD)     1*       1*    
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 1  Schedule found with 7 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 0
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L31:    ; PIPED LOOP PROLOG

           SPLOOP  1       ;7                ; (P) 
||         ADD     .L1     4,A12,A4          ; |73| 

;** --------------------------------------------------------------------------*
$C$L32:    ; PIPED LOOP KERNEL

           SPMASK          L2
||         MV      .L2X    A3,B5
||         LDW     .D1T1   *A4++,A3          ; |77| (P) <0,0> 

           NOP             4
           MV      .L2X    A3,B4             ; |77| (P) <0,5> Define a twin register

           SPKERNEL 4,0
||         STW     .D2T2   B4,*B5++          ; |77| <0,6> 

;** --------------------------------------------------------------------------*
$C$L33:    ; PIPED LOOP EPILOG
           NOP             1
           MV      .L2X    A13,B3            ; |83| 
;** --------------------------------------------------------------------------*
           LDW     .D2T1   *++SP(8),A10      ; |83| 

           LDDW    .D2T1   *++SP,A13:A12     ; |83| 
||         RET     .S2     B3                ; |83| 

           LDW     .D2T1   *++SP(8),A11      ; |83| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |83| 
;** --------------------------------------------------------------------------*
$C$L34:    

           CALL    .S1     __fltuf           ; |69| 
||         STW     .D2T1   A3,*+DP(_nDecoders) ; |67| 

           LDW     .D1T1   *A12++,A4         ; |69| 
           NOP             3
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*      Disqualified loop: Loop contains a call
;*      Disqualified loop: Loop contains non-pipelinable instructions
;*----------------------------------------------------------------------------*
$C$L35:    
           ADDKPC  .S2     $C$RL12,B3,0      ; |69| 
$C$RL12:   ; CALL OCCURS {__fltuf} {0}       ; |69| 
;** --------------------------------------------------------------------------*
           SUB     .L1     A11,1,A0          ; |68| 
   [ A0]   B       .S1     $C$L35            ; |68| 

   [ A0]   CALL    .S1     __fltuf           ; |69| 
||         STW     .D1T1   A4,*A10++         ; |69| 

   [ A0]   LDW     .D1T1   *A12++,A4         ; |69| 
           SUB     .L1     A11,1,A11         ; |68| 
           NOP             2
           ; BRANCHCC OCCURS {$C$L35}        ; |68| 
;** --------------------------------------------------------------------------*
$C$L36:    

           LDW     .D2T1   *++SP(8),A10      ; |83| 
||         MV      .L2X    A13,B3            ; |83| 

           LDDW    .D2T1   *++SP,A13:A12     ; |83| 
||         RET     .S2     B3                ; |83| 

           LDW     .D2T1   *++SP(8),A11      ; |83| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |83| 
	.sect	".text"
	.clink
	.global	_setup_decoder

;******************************************************************************
;* FUNCTION NAME: setup_decoder                                               *
;*                                                                            *
;*   Regs Modified     : A0,A1,A3,A4,A5,A6,A7,A8,B0,B4,B5                     *
;*   Regs Used         : A0,A1,A3,A4,A5,A6,A7,A8,B0,B3,B4,B5,DP,SP            *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_setup_decoder:
;** --------------------------------------------------------------------------*
           MV      .L1     A4,A6             ; |33| 
           LDW     .D1T1   *A6++,A4          ; |38| 
           LDW     .D1T1   *A6++,A3          ; |39| 
           LDW     .D1T1   *A6++,A5          ; |40| 
           LDW     .D1T1   *A6,A7            ; |41| 
           MVK     .S2     484,B4            ; |43| 
           MVK     .S1     121,A8            ; |46| 
           STW     .D2T1   A4,*+DP(_nDecoders) ; |38| 
           MPYLI   .M2X    B4,A5,B5:B4       ; |43| 
           MPY32   .M1     A8,A7,A0          ; |46| 
           STW     .D2T1   A3,*+DP(_DecoderCheckWindow) ; |39| 
           NOP             1
           MVKL    .S2     _ChannelWeights,B5

   [!A0]   B       .S2     $C$L41            ; |46| 
||         SHRU    .S1     A0,1,A1           ; |47| 
|| [ A0]   ADD     .L1     4,A6,A6           ; |41| 

   [!A0]   MVK     .L1     0x1,A1            ; nullify predicate
||         MVKH    .S2     _ChannelWeights,B5

           ADD     .L2     B5,B4,B5          ; |43| 
|| [ A0]   SHRU    .S2X    A0,1,B4

   [!A1]   BNOP    .S1     $C$L40,2          ; |47| 
           ; BRANCHCC OCCURS {$C$L41}        ; |46| 
;** --------------------------------------------------------------------------*
           NOP             3
           ; BRANCHCC OCCURS {$C$L40}        ; |47| 
;** --------------------------------------------------------------------------*

           MVK     .L1     0x1,A0            ; init prolog collapse predicate
||         ZERO    .L2     B0                ; init loop condition
||         SUB     .D2     B4,3,B4
||         MV      .S1X    B5,A3
||         DINT                              ; interrupts off

;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\OutputDecoder.c
;*      Loop source line                 : 46
;*      Loop opening brace source line   : 46
;*      Loop closing brace source line   : 48
;*      Loop Unroll Multiple             : 6x
;*      Known Minimum Trip Count         : 20                    
;*      Known Max Trip Count Factor      : 20
;*      Loop Carried Dependency Bound(^) : 0
;*      Unpartitioned Resource Bound     : 3
;*      Partitioned Resource Bound(*)    : 6
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        1     
;*      .S units                     1        0     
;*      .D units                     3        3     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             6*       6*    
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          0        1     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1        1     
;*      Bound(.L .S .D .LS .LSD)     2        2     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 6  Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Epilog not removed
;*      Collapsed epilog stages       : 0
;*      Collapsed prolog stages       : 1
;*      Minimum required memory pad   : 0 bytes
;*
;*      For further improvement on this loop, try option -mh24
;*
;*      Minimum safe trip count       : 1 (after unrolling)
;*----------------------------------------------------------------------------*
$C$L37:    ; PIPED LOOP PROLOG
;** --------------------------------------------------------------------------*
$C$L38:    ; PIPED LOOP KERNEL

   [!B0]   B       .S2     $C$L38            ; |46| <0,4> 
|| [!A0]   LDNDW   .D1T1   *-A6(16),A5:A4    ; |47| <0,4> 

   [!A0]   STNDW   .D1T1   A5:A4,*A3++(24)   ; |47| <0,5> 
           LDNDW   .D1T1   *A6++(24),A5:A4   ; |47| <1,0> 
           LDNDW   .D1T1   *-A6(8),A5:A4     ; |47| <1,1> 

   [!A0]   STNDW   .D1T1   A5:A4,*-A3(8)     ; |47| <0,8> 
||         SUB     .L2     B4,3,B4           ; |46| <1,2> 

   [ A0]   SUB     .L1     A0,1,A0           ; <0,9> 
|| [!A0]   STNDW   .D1T1   A5:A4,*-A3(16)    ; |47| <0,9> 
|| [!B0]   CMPLTU  .L2     B4,3,B0           ; |46| <1,3> 

;** --------------------------------------------------------------------------*
$C$L39:    ; PIPED LOOP EPILOG
           LDNDW   .D1T1   *-A6(16),A5:A4    ; |47| (E) <1,4> 
           STNDW   .D1T1   A5:A4,*A3++(24)   ; |47| (E) <1,5> 
           NOP             1
           MV      .L2X    A3,B5

           RINT                              ; interrupts on
||         STNDW   .D1T1   A5:A4,*-A3(8)     ; |47| (E) <1,8> 

;** --------------------------------------------------------------------------*
           STNDW   .D1T1   A5:A4,*-A3(16)    ; |47| (E) <1,9> 
;** --------------------------------------------------------------------------*
$C$L40:    
; Peeled loop iterations for unrolled loop:
           AND     .L1     1,A7,A0
   [ A0]   LDW     .D1T1   *A6,A3            ; |47| 
           NOP             4
   [ A0]   STW     .D2T1   A3,*B5            ; |47| 
;** --------------------------------------------------------------------------*
$C$L41:    
           RETNOP  .S2     B3,3              ; |52| 
           ZERO    .L2     B4                ; |51| 
           STW     .D2T2   B4,*+DP(_DecoderCheck) ; |51| 
           ; BRANCH OCCURS {B3}              ; |52| 
	.sect	".text"
	.clink
	.global	_scale_array_2

;******************************************************************************
;* FUNCTION NAME: scale_array_2                                               *
;*                                                                            *
;*   Regs Modified     : A0,A3,A4,A5,A6,A7,A8,A9,B4,B5,B6,B7,B8,B9,A16,A17,   *
;*                           B16,B17                                          *
;*   Regs Used         : A0,A3,A4,A5,A6,A7,A8,A9,B3,B4,B5,B6,B7,B8,B9,A16,A17,*
;*                           B16,B17                                          *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_scale_array_2:
;** --------------------------------------------------------------------------*
           SHRU    .S1     A6,3,A0           ; |264| 
   [!A0]   BNOP    .S1     $C$L45,1          ; |264| 
   [ A0]   MVC     .S2X    A0,ILC
           PACK2   .L2     B4,B4,B4          ; |262| 
           ADD     .L1     8,A4,A3
           NOP             1
           ; BRANCHCC OCCURS {$C$L45}        ; |264| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\OutputDecoder.c
;*      Loop source line                 : 264
;*      Loop opening brace source line   : 264
;*      Loop closing brace source line   : 271
;*      Known Minimum Trip Count         : 1                    
;*      Known Max Trip Count Factor      : 1
;*      Loop Carried Dependency Bound(^) : 0
;*      Unpartitioned Resource Bound     : 2
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     0        0     
;*      .D units                     2*       2*    
;*      .M units                     2*       2*    
;*      .X cross paths               0        2*    
;*      .T address paths             2*       2*    
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           2        2     (.L or .S unit)
;*      Addition ops (.LSD)          0        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1        1     
;*      Bound(.L .S .D .LS .LSD)     2*       2*    
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 2  Schedule found with 7 iterations in parallel
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

           SPLOOP  2       ;14               ; (P) 
||         MV      .L2X    A4,B7

;** --------------------------------------------------------------------------*
$C$L43:    ; PIPED LOOP KERNEL

           SPMASK          L1
||         MV      .L1     A3,A16
||         LDDW    .D2T2   *B7++(16),B17:B16 ; |269| (P) <0,0> 

           LDDW    .D1T1   *A16++(16),A9:A8  ; |267| (P) <0,1> 
           NOP             1

           SPMASK          L1
||         MV      .L1X    B4,A17

           SPMASK          L2
||         MV      .L2X    A4,B6

           SMPY2   .M2X    B16,A17,B9:B8     ; |269| (P) <0,5> 

           SMPY2   .M1     A8,A17,A7:A6      ; |267| (P) <0,6> 
||         SMPY2   .M2X    B17,A17,B9:B8     ; |269| (P) <0,6> 

           SMPY2   .M1     A9,A17,A7:A6      ; |268| (P) <0,7> 
           NOP             1
           PACK2   .L2     B8,B9,B4          ; |269| (P) <0,9> 

           PACK2   .L1     A6,A7,A4          ; |270| (P) <0,10> 
||         PACK2   .L2     B8,B9,B5          ; |269| (P) <0,10> 

           PACK2   .L1     A6,A7,A5          ; |270| (P) <0,11> 
||         STDW    .D2T2   B5:B4,*B6++(16)   ; |269| (P) <0,11> 

           SPKERNEL 5,0
||         STDW    .D1T1   A5:A4,*A3++(16)   ; |270| <0,12> 

;** --------------------------------------------------------------------------*
$C$L44:    ; PIPED LOOP EPILOG
           NOP             1
;** --------------------------------------------------------------------------*
$C$L45:    
           RETNOP  .S2     B3,5              ; |272| 
           ; BRANCH OCCURS {B3}              ; |272| 
	.sect	".text"
	.clink
	.global	_reset_decoder_state

;******************************************************************************
;* FUNCTION NAME: reset_decoder_state                                         *
;*                                                                            *
;*   Regs Modified     : A3,A4,A5,A6,A7,B0,B4,B5,B6,B7,B8                     *
;*   Regs Used         : A3,A4,A5,A6,A7,B0,B3,B4,B5,B6,B7,B8,DP               *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_reset_decoder_state:
;** --------------------------------------------------------------------------*
           MVKL    .S2     _DecoderState,B6
           MVKH    .S2     _DecoderState,B6
           MVK     .S1     0x3c,A3           ; |110| 
           MV      .L1X    B6,A6

           SUB     .L1     A3,2,A4
||         MV      .S1X    B6,A3
||         ADD     .L2     4,B6,B7
||         MVK     .S2     0xffffffff,B5

;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\OutputDecoder.c
;*      Loop source line                 : 110
;*      Loop opening brace source line   : 110
;*      Loop closing brace source line   : 114
;*      Loop Unroll Multiple             : 2x
;*      Known Minimum Trip Count         : 60                    
;*      Known Maximum Trip Count         : 60                    
;*      Known Max Trip Count Factor      : 60
;*      Loop Carried Dependency Bound(^) : 2
;*      Unpartitioned Resource Bound     : 3
;*      Partitioned Resource Bound(*)    : 3
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     0        0     
;*      .D units                     3*       3*    
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
$C$L46:    ; PIPED LOOP PROLOG

           SPLOOPD 3       ;6                ; (P) 
||         ZERO    .L1     A4                ; |111| 
||         MV      .L2     B6,B8
||         MV      .S1X    B6,A7
||         MVC     .S2X    A4,ILC
||         ADD     .D2     8,B6,B6

;** --------------------------------------------------------------------------*
$C$L47:    ; PIPED LOOP KERNEL

           SPMASK          S1,L2
||         ZERO    .L2     B4                ; |111| 
||         ADDK    .S1     24,A6
||         STW     .D2T1   A4,*B6++(32)      ; |111| (P) <0,0>  ^ 
||         STW     .D1T2   B5,*A3++(32)      ; |112| (P) <0,0>  ^ 

           SPMASK          L1,S1,S2
||         MV      .L1X    B5,A5
||         ADDK    .S2     16,B8
||         ADDK    .S1     20,A7
||         STW     .D2T1   A4,*B7++(32)      ; |113| (P) <0,1>  ^ 
||         STW     .D1T2   B4,*A6++(32)      ; |111| (P) <0,1>  ^ 

           STW     .D2T1   A5,*B8++(32)      ; |112| (P) <0,2>  ^ 
||         STW     .D1T2   B4,*A7++(32)      ; |113| (P) <0,2>  ^ 

           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L48:    ; PIPED LOOP EPILOG
           LDW     .D2T2   *+DP(_DecoderCheckWindow),B4 ; |116| 
;** --------------------------------------------------------------------------*

           RETNOP  .S2     B3,4              ; |119| 
||         LDW     .D2T2   *+DP(_nDecoders),B0 ; |115| 

   [ B0]   STW     .D2T2   B4,*+DP(_DecoderCheck) ; |116| 
           ; BRANCH OCCURS {B3}              ; |119| 
	.sect	".text"
	.clink
	.global	_init_decoder

;******************************************************************************
;* FUNCTION NAME: init_decoder                                                *
;*                                                                            *
;*   Regs Modified     : A3,A4,A5,A6,A7,A8,B4,B5,B6,B7,B8,B30,B31             *
;*   Regs Used         : A3,A4,A5,A6,A7,A8,B3,B4,B5,B6,B7,B8,DP,B30,B31       *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_init_decoder:
;** --------------------------------------------------------------------------*
           MVKL    .S2     _DecoderState,B4
           MVKH    .S2     _DecoderState,B4
           MVK     .S2     118,B5            ; |87| 
           MV      .L1X    B4,A3
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\OutputDecoder.c
;*      Loop source line                 : 87
;*      Loop opening brace source line   : 87
;*      Loop closing brace source line   : 92
;*      Known Minimum Trip Count         : 120                    
;*      Known Maximum Trip Count         : 120                    
;*      Known Max Trip Count Factor      : 120
;*      Loop Carried Dependency Bound(^) : 1
;*      Unpartitioned Resource Bound     : 3
;*      Partitioned Resource Bound(*)    : 3
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     0        0     
;*      .D units                     3*       2     
;*      .M units                     0        0     
;*      .X cross paths               0        0     
;*      .T address paths             3*       1     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          1        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        0     
;*      Bound(.L .S .D .LS .LSD)     2        1     
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
;*      Minimum safe trip count       : 1
;*----------------------------------------------------------------------------*
$C$L49:    ; PIPED LOOP PROLOG

           SPLOOPD 3       ;6                ; (P) 
||         ZERO    .L1     A5                ; |88| 
||         MVC     .S2     B5,ILC

;** --------------------------------------------------------------------------*
$C$L50:    ; PIPED LOOP KERNEL

           SPMASK          L2,S2
||         MV      .L2     B4,B5
||         ADD     .S2X    8,A3,B4
||         STW     .D1T1   A5,*+A3(4)        ; |90| (P) <0,0>  ^ 

           SPMASK          S1,L2
||         MVK     .L2     0xffffffff,B6
||         ZERO    .S1     A6                ; |88| 
||         STW     .D2T1   A5,*B4++(16)      ; |88| (P) <0,1> 
||         ADD     .D1     A3,16,A3          ; |91| (P) <0,1>  ^ 
||         MV      .L1     A3,A4             ; |91| (P) <0,1>  ^ 

           STW     .D2T2   B6,*B5++(16)      ; |89| (P) <0,2> 
||         STW     .D1T1   A6,*+A4(12)       ; |91| (P) <0,2> 

           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L51:    ; PIPED LOOP EPILOG

           ZERO    .L1     A5
||         MV      .D1     A6,A8
||         MVKL    .S1     _uDecoderOutput_compressed,A3
||         MVK     .L2     1,B4              ; |93| 

;** --------------------------------------------------------------------------*
           MVC     .S2     B4,ILC
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\OutputDecoder.c
;*      Loop source line                 : 93
;*      Loop opening brace source line   : 93
;*      Loop closing brace source line   : 95
;*      Loop Unroll Multiple             : 2x
;*      Known Minimum Trip Count         : 5                    
;*      Known Maximum Trip Count         : 5                    
;*      Known Max Trip Count Factor      : 5
;*      Loop Carried Dependency Bound(^) : 0
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
;*      Addition ops (.LSD)          0        0     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             0        0     
;*      Bound(.L .S .D .LS .LSD)     1*       0     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 1  Schedule found with 2 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 0
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1 (after unrolling)
;*----------------------------------------------------------------------------*
$C$L52:    ; PIPED LOOP PROLOG

           SPLOOPD 1       ;2                ; (P) 
||         ZERO    .L1     A4
||         MVKH    .S1     _uDecoderOutput_compressed,A3

;** --------------------------------------------------------------------------*
$C$L53:    ; PIPED LOOP KERNEL
           STDW    .D1T1   A5:A4,*A3++       ; |94| (P) <0,0> 
           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L54:    ; PIPED LOOP EPILOG

           MV      .L1     A8,A4
||         MV      .D1     A8,A5
||         ZERO    .L2     B31               ; |96| 
||         MVKL    .S1     _Decoder_V,A3
||         MVK     .S2     0x10,B30          ; |99| 

;** --------------------------------------------------------------------------*
           MVKL    .S2     _Decoder_Iinh,B7

           MVK     .S2     10000,B6          ; |97| 
||         MV      .L2X    A8,B4
||         SUB     .D2     B30,2,B8
||         MVKL    .S1     _Decoder_Iex,A7

           MVKH    .S1     _Decoder_Iex,A7
||         MVKH    .S2     _Decoder_Iinh,B7
||         MV      .L2X    A8,B5
||         STW     .D2T2   B31,*+DP(_nDecoders) ; |96| 

;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\OutputDecoder.c
;*      Loop source line                 : 99
;*      Loop opening brace source line   : 99
;*      Loop closing brace source line   : 103
;*      Loop Unroll Multiple             : 4x
;*      Known Minimum Trip Count         : 16                    
;*      Known Maximum Trip Count         : 16                    
;*      Known Max Trip Count Factor      : 16
;*      Loop Carried Dependency Bound(^) : 0
;*      Unpartitioned Resource Bound     : 3
;*      Partitioned Resource Bound(*)    : 3
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     0        0     
;*      .D units                     3*       3*    
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
$C$L55:    ; PIPED LOOP PROLOG

           SPLOOPD 3       ;6                ; (P) 
||         MVKH    .S1     _Decoder_V,A3
||         MVC     .S2     B8,ILC
||         STW     .D2T2   B6,*+DP(_DecoderCheckWindow) ; |97| 
||         MV      .L2X    A7,B8
||         ADD     .L1     8,A7,A7

;** --------------------------------------------------------------------------*
$C$L56:    ; PIPED LOOP KERNEL

           SPMASK          L1
||         ADD     .L1X    8,B7,A6
||         STDW    .D2T2   B5:B4,*B8++(16)   ; |100| (P) <0,0> 
||         STDW    .D1T1   A5:A4,*A7++(16)   ; |100| (P) <0,0> 

           SPMASK          L1,L2
||         MV      .L2X    A3,B6
||         ADD     .L1     8,A3,A3
||         STDW    .D2T2   B5:B4,*B7++(16)   ; |101| (P) <0,1> 
||         STDW    .D1T1   A5:A4,*A6++(16)   ; |101| (P) <0,1> 

           STDW    .D2T2   B5:B4,*B6++(16)   ; |102| (P) <0,2> 
||         STDW    .D1T1   A5:A4,*A3++(16)   ; |102| (P) <0,2> 

           SPKERNEL 0,0
;** --------------------------------------------------------------------------*
$C$L57:    ; PIPED LOOP EPILOG

           MVKL    .S1     _Decoder_d_tau,A3
||         RET     .S2     B3                ; |107| 

           MVKH    .S1     _Decoder_d_tau,A3
           STDW    .D1T1   A5:A4,*A3         ; |105| 
           STW     .D1T1   A8,*+A3(8)        ; |106| 
           NOP             2
           ; BRANCH OCCURS {B3}              ; |107| 
	.sect	".text"
	.clink
	.global	_compress_decoder_out

;******************************************************************************
;* FUNCTION NAME: compress_decoder_out                                        *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B3,B4,B5,B6,B7,  *
;*                           B8,B9,SP,A16,A17,A18,B16,B17,B18,B19,B31         *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B3,B4,B5,B6,B7,  *
;*                           B8,B9,DP,SP,A16,A17,A18,B16,B17,B18,B19,B31      *
;*   Local Frame Size  : 0 Args + 260 Auto + 0 Save = 260 byte                *
;******************************************************************************
_compress_decoder_out:
;** --------------------------------------------------------------------------*
           MVKL    .S1     _uDecoderOutput,A18

           LDW     .D2T1   *+DP(_nDecoders),A6 ; |165| 
||         MVKH    .S1     _uDecoderOutput,A18
||         ADDK    .S2     -264,SP           ; |162| 

           MV      .L1X    B3,A2             ; |162| 
||         CALLP   .S2     _sort_id,B3
||         MV      .S1     A18,A4            ; |165| 
||         ADD     .L2     8,SP,B4           ; |165| 

$C$RL13:   ; CALL OCCURS {_sort_id} {0}      ; |165| 
;** --------------------------------------------------------------------------*
           MVK     .L1     4,A3              ; |168| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\OutputDecoder.c
;*      Loop source line                 : 168
;*      Loop opening brace source line   : 168
;*      Loop closing brace source line   : 170
;*      Loop Unroll Multiple             : 2x
;*      Known Minimum Trip Count         : 5                    
;*      Known Maximum Trip Count         : 5                    
;*      Known Max Trip Count Factor      : 5
;*      Loop Carried Dependency Bound(^) : 0
;*      Unpartitioned Resource Bound     : 5
;*      Partitioned Resource Bound(*)    : 5
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     0        0     
;*      .S units                     1        1     
;*      .D units                     5*       4     
;*      .M units                     0        0     
;*      .X cross paths               3        2     
;*      .T address paths             4        3     
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          2        3     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1        1     
;*      Bound(.L .S .D .LS .LSD)     3        3     
;*
;*      Searching for software pipeline schedule at ...
;*         ii = 5  Schedule found with 4 iterations in parallel
;*      Done
;*
;*      Loop will be splooped
;*      Collapsed epilog stages       : 0
;*      Collapsed prolog stages       : 0
;*      Minimum required memory pad   : 0 bytes
;*
;*      Minimum safe trip count       : 1 (after unrolling)
;*----------------------------------------------------------------------------*
$C$L58:    ; PIPED LOOP PROLOG

           SPLOOPD 5       ;20               ; (P) 
||         ADD     .L1X    8,SP,A4
||         MVC     .S2X    A3,ILC

;** --------------------------------------------------------------------------*
$C$L59:    ; PIPED LOOP KERNEL
           LDW     .D1T1   *A4++(8),A6       ; |169| (P) <0,0> 
           NOP             2

           SPMASK          L1
||         ADD     .L1X    12,SP,A3

           LDW     .D1T1   *A3++(8),A8       ; |169| (P) <0,4> 
           NOP             2

           SPMASK          L1
||         MV      .L1     A18,A7            ; |165| 

           ADDAW   .D1     A7,A6,A5          ; |169| (P) <0,8> 

           SPMASK          L2
||         ADD     .L2     8,SP,B6

           LDDW    .D2T2   *B6++,B17:B16     ; |169| (P) <0,10> 
||         MV      .L2X    A5,B4             ; |169| (P) <0,10> Define a twin register

           ADDAW   .D1     A7,A8,A8          ; |169| (P) <0,11> 
||         LDHU    .D2T2   *B4,B9            ; |169| (P) <0,11> 

           SPMASK          S2
||         MVKL    .S2     _uDecoderOutput_compressed-8,B5
||         LDHU    .D1T1   *A8,A5            ; |169| (P) <0,12> 

           SPMASK          L2,S2
||         ZERO    .L2     B7
||         MVKH    .S2     _uDecoderOutput_compressed-8,B5

           SPMASK          L2,S2,D2
||         SET     .S2     B7,0x10,0x10,B7
||         ADD     .L2     8,B5,B8
||         ADD     .D2     12,B5,B5

           SHL     .S2     B17,16,B16        ; |169| <0,15> 
||         SHL     .S1X    B16,16,A5         ; |169| <0,15> 

           ADD     .L1X    B9,A5,A9          ; |169| <0,16> 

           ADD     .L1X    B7,A9,A5          ; |169| <0,17> 
||         ADD     .L2X    A5,B16,B4         ; |169| <0,17> 

           STW     .D2T1   A5,*B8++(8)       ; |169| <0,18> 
||         ADD     .L2     B7,B4,B4          ; |169| <0,18> 

           SPKERNEL 1,0
||         STW     .D2T2   B4,*B5++(8)       ; |169| <0,19> 

;** --------------------------------------------------------------------------*
$C$L60:    ; PIPED LOOP EPILOG
           NOP             2
           ADDK    .S2     264,SP            ; |171| 
           NOP             1
           RETNOP  .S2X    A2,5              ; |171| 
           ; BRANCH OCCURS {A2}              ; |171| 
	.sect	".text"
	.clink
	.global	_calculate_decoder_output

;******************************************************************************
;* FUNCTION NAME: calculate_decoder_output                                    *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,A16,A17,A18,B16,B17,B18,B19,B31         *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,DP,SP,A16,A17,A18,B16,B17,B18,B19,B31   *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_calculate_decoder_output:
;** --------------------------------------------------------------------------*

           LDW     .D2T2   *+DP(_nDecoders),B1 ; |146| 
||         MVKL    .S2     _uDecoderOutput,B4
||         MVKL    .S1     _ChannelWeights,A8
||         MVK     .L2     0xffffffff,B6

           MV      .L2     B3,B2             ; |138| 
||         MVKH    .S2     _uDecoderOutput,B4

           MVKH    .S1     _ChannelWeights,A8

           MV      .L1X    B4,A9
||         MVKL    .S2     _DecoderState,B4

           MVKH    .S2     _DecoderState,B4

   [!B1]   B       .S1     $C$L64            ; |146| 
|| [ B1]   MVK     .S2     0x3c,B7           ; |149| 

   [ B1]   MVC     .S2     B7,RILC
   [ B1]   SUB     .L2     B7,2,B31
           MV      .L1X    B4,A3
   [ B1]   MVC     .S2     B31,ILC
           MV      .L2X    A3,B4
           ; BRANCHCC OCCURS {$C$L64}        ; |146| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*
;*      Loop found in file               : C:\Users\45c\Firmware\RealTimeSystem\src\C\OutputDecoder.c
;*      Loop source line                 : 149
;*      Loop opening brace source line   : 149
;*      Loop closing brace source line   : 152
;*      Loop Unroll Multiple             : 2x
;*      Known Minimum Trip Count         : 60                    
;*      Known Maximum Trip Count         : 60                    
;*      Known Max Trip Count Factor      : 60
;*      Loop Carried Dependency Bound(^) : 1
;*      Unpartitioned Resource Bound     : 2
;*      Partitioned Resource Bound(*)    : 2
;*      Resource Partition:
;*                                A-side   B-side
;*      .L units                     1        1     
;*      .S units                     0        0     
;*      .D units                     2*       1     
;*      .M units                     0        0     
;*      .X cross paths               1        1     
;*      .T address paths             2*       2*    
;*      Long read paths              0        0     
;*      Long write paths             0        0     
;*      Logical  ops (.LS)           0        0     (.L or .S unit)
;*      Addition ops (.LSD)          3        3     (.L or .S or .D unit)
;*      Bound(.L .S .LS)             1        1     
;*      Bound(.L .S .D .LS .LSD)     2*       2*    
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
;*      For further improvement on this loop, try option -mh32
;*
;*      Minimum safe trip count       : 1 (after unrolling)
;*----------------------------------------------------------------------------*
$C$L61:    ; PIPED LOOP PROLOG

           SPLOOPD 2       ;8                ; (P) 
||         ADDK    .S2     16,B4

;** --------------------------------------------------------------------------*
$C$L62:    ; PIPED LOOP KERNEL

           SPMASK          L1
||         MV      .L1     A8,A6             ; |148| 
||         LDW     .D1T1   *A3++(32),A4      ; |151| (P) <0,0> 
||         LDW     .D2T2   *B4++(32),B8      ; |151| (P) <0,0> 

           LDNDW   .D1T1   *A6++(8),A5:A4    ; |151| (P) <0,1> 
           NOP             3

           SPMASK          S1,S2
||         ZERO    .S1     A7                ; |149| 
||         ZERO    .S2     B5                ; |149| 
||         CMPEQ   .L1X    A4,B6,A0          ; |151| (P) <0,5> 
||         CMPEQ   .L2     B8,B6,B0          ; |151| (P) <0,5> 

   [ A0]   ZERO    .L2     B7                ; |151| <0,6>  ^ 
|| [!A0]   MV      .S2X    A4,B7             ; |151| <0,6>  ^ 
|| [ B0]   ZERO    .L1     A5                ; |151| <0,6>  ^ 

           SPKERNEL 0,0
||         ADD     .S2     B7,B5,B5          ; |151| <0,7> 
||         ADD     .S1     A5,A7,A7          ; |151| <0,7> 

;** --------------------------------------------------------------------------*
$C$L63:    ; PIPED LOOP EPILOG

           SUB     .D2     B1,1,B1           ; |146| 
||         LDW     .D1T1   *A6,A3            ; |154| 

           NOP             5
;** --------------------------------------------------------------------------*

   [ B1]   MVKL    .S2     _DecoderState,B4
|| [ B1]   B       .S1     $C$L61            ; |146| 

           ADD     .L1X    B5,A3,A3          ; |154| 
|| [ B1]   MVKH    .S2     _DecoderState,B4
||         ADDK    .S1     484,A8            ; |146| 

           ADD     .L1     A7,A3,A3          ; |154| 
|| [ B1]   MVK     .S2     0x3c,B7           ; |149| 

           STW     .D1T1   A3,*A9++          ; |154| 
|| [ B1]   MV      .L1X    B4,A3
|| [ B1]   MVC     .S2     B7,RILC
|| [ B1]   SUB     .L2     B7,2,B31

   [ B1]   MVC     .S2     B31,ILC
   [ B1]   MV      .L2X    A3,B4
           ; BRANCHCC OCCURS {$C$L61}        ; |146| 
;** --------------------------------------------------------------------------*
$C$L64:    
           CALLP   .S2     _compress_decoder_out,B3
$C$RL14:   ; CALL OCCURS {_compress_decoder_out} {0}  ; |157| 
;** --------------------------------------------------------------------------*
           RETNOP  .S2     B2,3              ; |160| 
           MVK     .L2     1,B4              ; |158| 
           STW     .D2T2   B4,*+DP(_DecoderOutputValid) ; |158| 
           ; BRANCH OCCURS {B2}              ; |160| 
;*****************************************************************************
;* UNDEFINED EXTERNAL REFERENCES                                             *
;*****************************************************************************
	.global	_current_time
	.global	_SpikeData
	.global	_nSpikes
	.global	__mpyf
	.global	__cmpf
	.global	__addf
	.global	__fltuf

;******************************************************************************
;* BUILD ATTRIBUTES                                                           *
;******************************************************************************
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_needed(0)
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_preserved(0)
	.battr "TI", Tag_File, 1, Tag_Tramps_Use_SOC(1)
