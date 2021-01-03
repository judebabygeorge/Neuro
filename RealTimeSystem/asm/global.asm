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

	.global	_ddr_data
_ddr_data:	.usect	".dataddr",4000000,8
	.global	_adc_intern_0
_adc_intern_0:	.usect	".far",240,8
	.global	_adc_intern_1
_adc_intern_1:	.usect	".far",23040,8
	.global	_adc_intern_id
	.bss	_adc_intern_id,4,4
	.global	_threshold
	.bss	_threshold,4,4
	.global	_deadtime
	.bss	_deadtime,4,4
	.global	_StimulusEnable
_StimulusEnable:	.usect	".far",8,8
	.global	_DAC_select
_DAC_select:	.usect	".far",16,8
	.global	_elec_config
_elec_config:	.usect	".far",16,8
	.global	_current_time
	.bss	_current_time,4,4
	.global	_Debug_Data
_Debug_Data:	.usect	".far",32,8
	.global	_last_timer_count
	.bss	_last_timer_count,4,4
	.global	_DataMode
	.bss	_DataMode,4,4
	.global	_StimSequence_Enabled
	.bss	_StimSequence_Enabled,4,4
	.global	_StimPatternSequence_Enabled
	.bss	_StimPatternSequence_Enabled,4,4
	.global	_Stim_BlankingCounter
	.bss	_Stim_BlankingCounter,4,4
	.global	_StimStatus
_StimStatus:	.usect	".far",8,8
	.global	_SpikeChannel
_SpikeChannel:	.usect	".far",16,8
	.global	_ExectueCommand_flag
	.bss	_ExectueCommand_flag,4,4
	.global	_StimCheck_flag
	.bss	_StimCheck_flag,4,4
	.global	_RobotComm_flag
	.bss	_RobotComm_flag,4,4
	.global	_RobotStimEnable
	.bss	_RobotStimEnable,4,4
	.global	_ADCDataShift
	.bss	_ADCDataShift,1,1
	.global	_EnableAmpBlanking
	.bss	_EnableAmpBlanking,1,1
	.global	_frame_sync
	.bss	_frame_sync,4,4
	.global	_ExecutionMode
	.bss	_ExecutionMode,4,4
	.global	_StimTrain_flag
	.bss	_StimTrain_flag,4,4
;	opt6x C:\\Users\\45c\\AppData\\Local\\Temp\\102562 C:\\Users\\45c\\AppData\\Local\\Temp\\102564 

;******************************************************************************
;* BUILD ATTRIBUTES                                                           *
;******************************************************************************
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_needed(0)
	.battr "TI", Tag_File, 1, Tag_ABI_stack_align_preserved(0)
	.battr "TI", Tag_File, 1, Tag_Tramps_Use_SOC(1)
