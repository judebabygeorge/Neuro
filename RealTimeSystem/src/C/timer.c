
#include "global.h"
#include "timer.h"


#include <cslr_tmr.h>
#include <soc.h>
#include <c6x.h>

void timer_tic(){
  //Clear timer
   CSL_TmrRegsOvly tmr1Regs = (CSL_TmrRegsOvly)CSL_TMR_1_REGS;

   //last_timer_count = current_time ;
   CSL_FINST(tmr1Regs->TCR, TMR_TCR_ENAMODE_LO, DISABLE);//Disable
   CSL_FINST(tmr1Regs->TIMLO,TMR_TIMLO_TIMLO,RESETVAL);//Rwset
   CSL_FINS(tmr1Regs->TCR, TMR_TCR_ENAMODE_LO, 1); //One time pulse

}

Uint32 timer_toc(){
  Uint32 y ;
  CSL_TmrRegsOvly tmr1Regs = (CSL_TmrRegsOvly)CSL_TMR_1_REGS;

  y = tmr1Regs->TIMLO;

  return y ;
}

void timer_setup(){

	CSL_TmrRegsOvly tmr1Regs = (CSL_TmrRegsOvly)CSL_TMR_1_REGS;

	//Setup Timer

 	// clear TIM12 register
	CSL_FINST(tmr1Regs->TIMLO,TMR_TIMLO_TIMLO,RESETVAL);
	CSL_FINS(tmr1Regs->TCR, TMR_TCR_CLKSRC_LO, 0);
	// select 32 bit unchained mode and take the timer out of reset
	CSL_FINS(tmr1Regs->TGCR, TMR_TGCR_TIMMODE, 1);  // 32bit unchained
	CSL_FINST(tmr1Regs->TGCR, TMR_TGCR_TIMLORS, RESET_OFF);

	//Set period
	CSL_FINST(tmr1Regs->TCR, TMR_TCR_ENAMODE_LO, DISABLE);
	CSL_FINS(tmr1Regs->PRDLO,TMR_PRDLO_PRDLO, 0xFFFFFFFF);//period
	CSL_FINST(tmr1Regs->TIMLO,TMR_TIMLO_TIMLO,RESETVAL);

    last_timer_count = 0 ;
}
