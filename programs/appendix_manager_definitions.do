global filestub "appendix_manager_definitions"
capture log close
do "config.do"

pause on
set more off
set linesize 120                                                                                                       

/* %*************************************************************************** */
/*code here compares occupational classifications against deciles of the person effect distribution*/
use "${inpath}/WMS_RAIS_linked_microdata.dta", clear
egen jole_mgr_quart = xtile(akm_pe) if sep~=1, by(cnpj year) nq(4)
/* gen jole_mgr = jole_mgr_quart == 4 */
/* egen jole_mgr_dec = xtile(akm_pe) if sep~=1, by(cnpj year) nq(10) */
gen occ = "    "
replace occ = "prod" if occ_prod == 1
replace occ = "tech" if occ_tech == 1
replace occ = "mngr" if occ_mngr == 1
replace occ = "su_p" if occ_prod == 1 & occ_supr == 1
replace occ = "su_t" if occ_tech == 1 & occ_supr == 1
replace occ = "othr" if occ == "    "

tab jole_mgr_quart occ if year==2008, col

tab jole_mgr_quart occ if year==2008, col nofreq

tab occ if year==2008

log close