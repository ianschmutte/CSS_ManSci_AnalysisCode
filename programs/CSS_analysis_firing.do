global filestub "CSS_analysis_firing"
capture log close
do "config.do"

pause on
set more off
set linesize 120                                                                                                       

/* %*************************************************************************** */
*-----------------------------------------------------------------
* "FIRING" RATES -- BINSCATTER
*-----------------------------------------------------------------
{
// use "${inpath}/WMS_RAIS_linked_microdata.dta", clear
use "${inpath}/WMS_RAIS_flow_microdata.dta", clear

/*standardize the worker effects relative to the WMS-attached stayer sample*/
egen std_pe = std(akm_pe)
replace akm_pe = std_pe
drop std_pe

gen reg_grp = real(substr(state,1,1))

// global ctrl i.year male race_* i.educ_best
global ctrl i.year tenure_months male race_* i.educ_best lemp lfirmage i.compet_cat i.own_cat i.reg_grp




binscatter fire akm_pe if occ_labr ==1, ///
	controls(${ctrl}) absorb(sic2) by(formal) nq(50) line(none) ///
	msymbols(Th O) xlab(-2(1)6) ylab(.05(.05).2)  ytitle("Firing rate") xtitle("Worker quality") ///
	legend(ring(0) pos(4) col(1) label(1 "Unstructured management") label(2 "Structured management") region(lcolor(white))) ///
	title("Non-managers") name(bs_labr, replace)
	
binscatter fire akm_pe if occ_mngr ==1, ///
	controls(${ctrl}) absorb(sic2) by(formal) nq(50) line(none) ///
	msymbols(Th O) xlab(-2(1)6) ylab()  ytitle("Firing rate") xtitle("Worker quality") ///
	legend(ring(0) pos(4) col(1) label(1 "Unstructured management") label(2 "Structured management") region(lcolor(white))) ///
	title("Managers") name(bs_mngr, replace)
	
	
graph combine bs_mngr bs_labr, ycommon  ///
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 

graph save ${figpath}/fig_firing_binscatter.gph, replace
graph export ${figpath}/fig_firing_binscatter.pdf, as(pdf) replace

}

log close