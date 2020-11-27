global filestub "CSS_ability_dist"
capture log close
do "config.do"

pause on
set more off
set linesize 120                                                                                                       

/* %*************************************************************************** */
use "${inpath}/WMS_RAIS_linked_microdata.dta", clear

*-----------------------------------------------------------------
* APPENDIX: PE KERNEL DENSITY PLOTS
*-----------------------------------------------------------------

sum akm_pe log_wage, detail
sum akm_pe log_wage if occ_labr == 1, detail
sum akm_pe log_wage if occ_mngr == 1, detail

sum occ_mngr if occ_labr==1 | occ_mngr==1
	
twoway  (kdensity akm_pe if occ_labr==1 , lcolor(navy) lwidth(thick) lpattern(dash)) ///
	(kdensity akm_pe if occ_mngr==1  , lcolor(maroon) lwidth(thick) lpattern(solid)), ///
	ytitle(Density) xtitle("Worker quality") graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ///
	legend(label(1 "Production workers") label(2 "Managers") col(1) ring(0) pos(2) symx(4) region(lcolor(white)))
	
* local figpath ./output/figures	
graph save "${figpath}/PE_histogram.gph", replace
graph export "${figpath}/PE_histogram.pdf", as(pdf) replace 

twoway  (kdensity log_wage if occ_labr==1 , lcolor(navy) lwidth(thick) lpattern(dash)) ///
	(kdensity log_wage if occ_mngr==1 , lcolor(maroon) lwidth(thick) lpattern(solid)), ///
	ytitle(Density) xtitle("Log Wage") graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ///
	legend(label(1 "Production workers") label(2 "Managers") col(1) ring(0) pos(2) symx(4) region(lcolor(white)))

graph save "${figpath}/logwage_histogram.gph", replace
graph export "${figpath}/logwage_histogram.pdf", as(pdf) replace 

cap log close