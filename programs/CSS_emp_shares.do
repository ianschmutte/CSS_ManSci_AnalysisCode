global filestub "CSS_emp_shares"
capture log close
do "config.do"

pause on
set more off
set linesize 120                                                                                                       

/* %*************************************************************************** */
*-----------------------------------------------------------------
* Appendix: EMPLOYMENT SHARES 
*-----------------------------------------------------------------
use "${inpath}/WMS_RAIS_flow_microdata.dta", clear

	collapse formal, by(year)

    format %4.0g formal
	
	graph bar formal, over(year) ///
		ylabel(0(.25)1) ytitle("Employment share") ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	graph save "${figpath}/fig_emp_shares.gph", replace
        graph export "${figpath}/fig_emp_shares.pdf", as(pdf) replace 

cap log close