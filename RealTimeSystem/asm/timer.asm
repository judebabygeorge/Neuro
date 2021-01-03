;******************************************************************************
;* TMS320C6x C/C++ Codegen                                          PC v7.4.2 *
;* Date/Time created: Sat May 31 10:53:24 2014                                *
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

;	opt6x C:\\Users\\45c\\AppData\\Local\\Temp\\102082 C:\\Users\\45c\\AppData\\Local\\Temp\\102084 
	.sect	".text"
	.clink
	.global	_timer_toc

;******************************************************************************
;* FUNCTION NAME: timer_toc                                                   *
;*                                                                            *
;*   Regs Modified     : A3,A4                                                *
;*   Regs Used         : A3,A4,B3                                             *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_timer_toc:
;** --------------------------------------------------------------------------*
           MVKL    .S1     0x2980010,A3

           MVKH    .S1     0x2980010,A3
||         RET     .S2     B3                ; |28| 

           LDW     .D1T1   *A3,A4            ; |25| 
           NOP             4
           ; BRANCH OCCURS {B3}              ; |28| 
	.sect	".text"
	.clink
	.global	_timer_tic

;******************************************************************************
;* FUNCTION NAME: timer_tic                                                   *
;*                                                                            *
;*   Regs Modified     : A3,A4,B4,B5,B6                                       *
;*   Regs Used         : A3,A4,B3,B4,B5,B6                                    *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_timer_tic:
;** --------------------------------------------------------------------------*
           MVKL    .S1     0x2980020,A3
           MVKH    .S1     0x2980020,A3
           LDW     .D1T1   *A3,A4            ; |15| 
           MV      .L2X    A3,B5             ; |15| 
           SUBAW   .D2     B5,4,B4
           ZERO    .L2     B6                ; |16| 
           NOP             1
           CLR     .S1     A4,6,7,A4         ; |15| 
           STW     .D2T1   A4,*B5            ; |15| 
           LDW     .D2T2   *B4,B5            ; |16| 
           STW     .D2T2   B6,*B4            ; |16| 
           LDW     .D1T1   *A3,A4            ; |17| 
           NOP             1
           RETNOP  .S2     B3,2              ; |19| 
           CLR     .S1     A4,7,7,A4         ; |17| 
           SET     .S1     A4,6,6,A4         ; |17| 
           STW     .D1T1   A4,*A3            ; |17| 
           ; BRANCH OCCURS {B3}              ; |19| 
	.sect	".text"
	.clink
	.global	_timer_setup

;******************************************************************************
;* FUNCTION NAME: timer_setup                                                 *
;*                                                                            *
;*   Regs Modified     : A3,A4,A5,A6,B4,B5,B6,B7                              *
;*   Regs Used         : A3,A4,A5,A6,B3,B4,B5,B6,B7,DP                        *
;*   Local Frame Size  : 0 Args + 0 Auto + 0 Save = 0 byte                    *
;******************************************************************************
_timer_setup:
;** --------------------------------------------------------------------------*
           MVKL    .S1     0x2980010,A4
           MVKH    .S1     0x2980010,A4

           ZERO    .L1     A5                ; |37| 
||         MVK     .S2     16,B4
||         LDW     .D1T1   *A4,A3            ; |37| 

           ADD     .L2X    A4,B4,B4
||         STW     .D1T1   A5,*A4            ; |37| 

           LDW     .D2T2   *B4,B5            ; |38| 
           ADD     .L2     4,B4,B6
           MV      .L2X    A4,B7             ; |37| 
           ADD     .L1X    4,B4,A3
           NOP             1
           CLR     .S2     B5,8,8,B5         ; |38| 
           STW     .D2T2   B5,*B4            ; |38| 
           LDW     .D2T2   *B6,B5            ; |40| 
           NOP             4
           AND     .L2     -9,B5,B5          ; |40| 
           NOP             1
           OR      .L1X    4,B5,A6           ; |40| 
           STW     .D1T1   A6,*A3            ; |40| 
           LDW     .D2T2   *B6,B5            ; |41| 
           MV      .L1X    B4,A3             ; |38| 
           NOP             3
           OR      .L2     1,B5,B5           ; |41| 
           STW     .D2T2   B5,*B6            ; |41| 
           LDW     .D1T1   *A3,A3            ; |44| 
           SUBAW   .D2     B6,3,B5
           MV      .L2X    A5,B6             ; |37| 
           STW     .D2T2   B6,*+DP(_last_timer_count) ; |48| 
           MVK     .L2     -1,B6             ; |45| 
           CLR     .S1     A3,6,7,A3         ; |44| 
           STW     .D2T1   A3,*B4            ; |44| 
           LDW     .D2T2   *B5,B4            ; |45| 

           RET     .S2     B3                ; |49| 
||         STW     .D2T2   B6,*B5            ; |45| 

           LDW     .D2T2   *B7,B4            ; |46| 
           STW     .D1T1   A5,*A4            ; |46| 
           NOP             3
           ; BRANCH OCCURS {B3}              ; |49| 
;*****************************************************************************
;* UNDEFINED EXTERNAL REFERENCES                                             *
;*****************************************************************************
	.global	_last_timer_count

;******************************************************************************
;* BUILD ATTRIBUTES                                                           *
;******************************************************************************
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_needed(0)
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_preserved(0)
	.battr "TI", Tag_File, 1, Tag_Tramps_Use_SOC(1)
