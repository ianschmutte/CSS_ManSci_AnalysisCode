global filestub "appendix_plant_panel"
capture log close
do "config.do"

pause on
set more off
set linesize 120                                                                                                       


/* %*************************************************************************** */
use "${inpath}/WMS_plantyear_with_RAIS.dta", clear


/* Correlation among management scores */
estpost corr zmanagement zpeople zoperations zmonitor ztarget, matrix
estimates save ${tabpath}/appendix/WMS_zmgmt_corr_table.ster, replace

estimates use ${tabpath}/appendix/WMS_zmgmt_corr_table.ster
eststo m1:
esttab m1 using "${tabpath}/appendix/WMS_mngscores_corr.tex", booktabs replace ///
  unstack compress not noobs  nodepvars nonum no nogap b(2) nostar label 
  
esttab m1 , booktabs  ///
  unstack compress not noobs  no

***********
* Figure 3*
***********

binscatter zpeople zakm_pe, xtitle("Av employee FE") ytitle("Peoplel management z-Score") ///
 yscale(r(-.6 .6)) ylabel(-.6(.2).6) graphregion(color(white)) line(none) mcol(gs3) 
graph save "${figpath}/appendix/app_zpeople_v_pe.gph", replace
graph export "${figpath}/appendix/app_zpeople_v_pe.pdf", as(pdf) replace 

***********
* Figure 7*
***********

binscatter zpeople zakm_fe, controls(lemp) line(none)  ytitle("Management Z-score") xtitle("Firm FE") mcol(gs3) 
graph save "${figpath}/appendix/app_zpeople_v_fe.gph", replace
graph export "${figpath}/appendix/app_zpeople_v_fe.pdf", as(pdf) replace 



/* %*************************************************************************** */
***********
* Models of management score *
***********
la var lemp "Ln of firm employment (WMS)"

gen multisites = 0
replace multisites = 1 if xsite1 > 1

global ctrl_jole lemp i.region i.year i.own_cat lfirmage female_share i.compet_cat mis_competition c.AKM_coverage##c.AKM_coverage##c.AKM_coverage 

global ctrl_add mne_yn multisites

replace degree_t = degree_t/100

qui eststo app1: areg zmanagement zakm_pe zpe_mngr_jole degree_t ${ctrl_jole} ${ctrl_add} if has_akm==1, cluster(cnpj) ab(sic2)
qui eststo app2: areg zmanagement zpe_lab  zpe_mngr degree_t ${ctrl_jole} ${ctrl_add} if has_akm==1, cluster(cnpj) ab(sic2)
qui eststo app3: areg zpeople zakm_pe zpe_mngr_jole degree_t ${ctrl_jole} ${ctrl_add} if has_akm==1, cluster(cnpj) ab(sic2)
qui eststo app4: areg zpeople zpe_lab  zpe_mngr degree_t ${ctrl_jole} ${ctrl_add} if has_akm==1, cluster(cnpj) ab(sic2)


esttab app1 app2 app3 app4 using "${tabpath}/appendix/appendix_BBCVW_tab2_altspecs.tex", booktabs label replace ///
	keep(zakm_pe	zpe_mngr_jole zpe_lab zpe_mngr lemp degree_t) ///
	order(zakm_pe	zpe_mngr_jole zpe_lab zpe_mngr lemp degree_t ) ///
	compress collabels(none) nodepvars nogap nomtitle ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	scalars("N_clust Firms") ///
	mgroups("Management z-score", pattern(1) prefix(\multicolumn{@span}{c}{) suffix(}) span)



replace degree_t = degree_t*100

/*
DISPLAY IN STATA LOG
*/
esttab app1 app2 app3 app4 , label replace ///
	keep(zakm_pe	zpe_mngr_jole zpe_lab zpe_mngr lemp degree_t) ///
	order(zakm_pe	zpe_mngr_jole zpe_lab zpe_mngr lemp degree_t ) ///
	compress collabels(none) nodepvars nogap nomtitle ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	scalars("N_clust Firms")

/* %*************************************************************************** */
/**********	
* TABLE 8 *
***********/	
la var zmanagement "z-management"
la var zpeople "z-people"

 qui eststo jole8_e1: areg w9010 zmanagement  ${ctrl_jole} ${ctrl_add} if has_akm==1, cluster(cnpj) ab(sic2)
 qui eststo jole8_e2: areg w_sd zmanagement  ${ctrl_jole} ${ctrl_add} if has_akm==1, cluster(cnpj) ab(sic2)
 qui eststo jole8_e3: areg pe9010 zmanagement  ${ctrl_jole} ${ctrl_add} if has_akm==1, cluster(cnpj) ab(sic2)
 qui eststo jole8_e4: areg pe_sd zmanagement  ${ctrl_jole} ${ctrl_add} if has_akm==1, cluster(cnpj) ab(sic2)
 qui eststo jole8_e5: areg w9010 zpeople  ${ctrl_jole}  if has_akm==1, cluster(cnpj) ab(sic2)
 qui eststo jole8_e6: areg w_sd zpeople  ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)
 qui eststo jole8_e7: areg pe9010 zpeople  ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)
 qui eststo jole8_e8: areg pe_sd zpeople  ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)

 
 esttab jole8* using "${tabpath}/appendix/app_ineq_altspecs.tex", booktabs label replace ///
	keep(zmanagement zpeople) ///
	compress collabels(none) nodepvars nogap nomtitle ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	scalars("N_clust Firms") ///
	indicate("General Controls = lemp" , labels("\cmark" "")) 
    /* mgroups("\specialcell{90-10 \\ Log Wages}" ///
	"\specialcell{Coefficient of \\ Variation in \\ Log Wages}" ///
	"\specialcell{90-10 \\ Abilty}" ///
	"\specialcell{Coefficient of \\ Variation in \\ Ability}", ///
	pattern(1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) */

 esttab jole8* , label replace ///
	keep(zmanagement zpeople) ///
	compress collabels(none) nodepvars nogap nomtitle ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	scalars("N_clust Firms") indicate("General Controls = lemp") 
eststo clear
/* %***************************************************************************
predict stayers
 */
gen degree_share = degree_t/100

gen samp = .

gen zops = zoperations

la var zmanagement "z-management"
la var zops 	   "z-operations"
la var zpeople 	   "z-people"

foreach depvar in zakm_pe zpe_mngr zpe_lab{
    /*get common sample*/
    qui reg `depvar'  ${ctrl_jole} degree_share
    replace samp = e(sample)

    /* qui eststo m2: reg zakm_pe formal i.y*/
    qui eststo m3: reg  `depvar' zmanagement ${ctrl_jole} ${ctrl_add} degree_share if samp==1, cluster(cnpj)
    qui eststo m4: reg  `depvar' zpeople ${ctrl_jole} ${ctrl_add} degree_share if samp==1, cluster(cnpj)
    qui eststo m5: reg  `depvar' zops ${ctrl_jole} ${ctrl_add} degree_share if samp==1, cluster(cnpj)
    qui eststo m6: reg  `depvar' zops zpeople ${ctrl_jole} ${ctrl_add} degree_share if samp==1,  cluster(cnpj)

if "`depvar'" == "zakm_pe" {
	local mt "Outcome variable: Worker FE"
	di "`mt'"
	}
else if "`depvar'" == "zpe_mngr" {
	local mt "Outcome variable: Manager FE"
	di "`mt'"
	}
else if "`depvar'" == "zpe_lab" {
	local mt "Outcome variable: Production worker FE"
	di "`mt'"
	}

    esttab m3 m5 m4 m6, ///
        keep(zmanagement zops zpeople) ///	
        order(zmanagement zops zpeople) ///
        compress collabels(none) nodepvars nogap nomtitle ///
        cells(b(star fmt(3)) se(par fmt(3))) ///
        stats(N N_clust , fmt(0 0) ///
	labels(`"\# Observations"' `"\# Firms"')) 	///
	starlevels( * 0.10 ** 0.05 *** 0.01) ///
        indicate("Year controls = _cons" "Full controls = lemp" "College share = degree_share"  , labels("\cmark" "")) ///
	mgroups("`mt'", pattern(1 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))


    esttab m3 m5 m4 m6 using "${tabpath}/appendix/app_`depvar'_pred_add_ctrls.tex", booktabs label replace ///
        keep(zmanagement zops zpeople) ///	
        order(zmanagement zops zpeople) ///
        compress collabels(none) nodepvars nogap nomtitle  ///
        cells(b(star fmt(3)) se(par fmt(3))) ///
         stats(N N_clust , fmt(0 0) ///
	labels(`"\# Observations"' `"\# Firms"')) 	///
	starlevels( * 0.10 ** 0.05 *** 0.01) ///
        indicate("Year controls = _cons" "Full controls = lemp" "College share = degree_share"  , labels("\cmark" "")) ///
	mgroups("`mt'", pattern(1 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))

	eststo clear
}




/* %*************************************************************************** 
PANEL STUFF
*/
egen plantid = group(cnpj)
drop if plantid == .
sort plantid year
xtset plantid year
xtdescribe
by plantid: gen numobs = _N
by plantid: gen l_zmanagement = zmanagement[_n-1] if numobs==2 & year==2013
by plantid: gen l_management = management[_n-1] if numobs==2 & year==2013
by plantid: gen l_zpeople = zpeople[_n-1] if numobs==2 & year==2013
by plantid: gen l_zops = zops[_n-1] if numobs==2 & year==2013

xtsum management 
xtsum management if numobs==2

corr management l_management if numobs==2 & year==2013

scatter management l_management if numobs==2 & year==2013 , xtitle("2008 management score") ytitle("2013 management score") ///
 graphregion(color(white)) mcol(gs3) 
graph save "${figpath}/appendix/app_management_scatter.gph", replace
graph export "${figpath}/appendix/app_management_scatter.pdf", as(pdf) replace 

global ctrl_small i.year i.own_cat female_share i.compet_cat mis_competition c.AKM_coverage##c.AKM_coverage##c.AKM_coverage 
 qui eststo jole8_e1: areg lemp zmanagement   if has_akm==1 & numobs==2 , cluster(cnpj) ab(cnpj)
 qui eststo jole8_e2: areg lemp zmanagement  ${ctrl_jole}  if has_akm==1 & numobs==2 , cluster(cnpj) ab(cnpj)
  qui eststo jole8_e3: areg degree_share zmanagement   if has_akm==1 & numobs==2 , cluster(cnpj) ab(cnpj)
 qui eststo jole8_e4: areg degree_share zmanagement  ${ctrl_jole}  if has_akm==1 & numobs==2 , cluster(cnpj) ab(cnpj)
   qui eststo jole8_e5: areg zakm_pe zmanagement   if has_akm==1 & numobs==2 , cluster(cnpj) ab(cnpj)
 qui eststo jole8_e6: areg zakm_pe zmanagement  ${ctrl_jole}  if has_akm==1 & numobs==2 , cluster(cnpj) ab(cnpj)

     esttab jole8*, ///
        keep(zmanagement) ///	
        order(zmanagement) ///
        compress collabels(none) nodepvars nogap nomtitle ///
        cells(b(star fmt(3)) se(par fmt(3))) ///
        stats(N N_clust , fmt(0 0) ///
	labels(`"\# Observations"' `"\# Firms"')) 	///
	starlevels( * 0.10 ** 0.05 *** 0.01)

eststo clear

egen sicnum = group(sic2)

foreach v in w9010 w_sd pe9010 pe_sd{
	qui eststo e1: areg `v' zmanagement  ${ctrl_jole}  if has_akm==1 & numobs==2, cluster(cnpj) ab(sic2)
	qui eststo e2: areg `v' zmanagement  ${ctrl_jole}  if has_akm==1 & numobs==2, cluster(cnpj) ab(cnpj)
	qui eststo e3: areg `v' zmanagement  ${ctrl_jole}  if has_akm==1 & numobs==2 & year==2013, cluster(cnpj) ab(sic2)
	qui eststo e4: ivreg2 `v' ${ctrl_jole} i.sicnum (zmanagement = l_zmanagement) if has_akm==1 & numobs ==2 & year==2013, cluster(cnpj) 

	esttab e1 e2 e3 e4, ///
	        title(Models for `v') ///
			keep(zmanagement) ///	
			order(zmanagement) ///
			compress collabels(none) nodepvars nogap nomtitle ///
			cells(b(star fmt(3)) se(par fmt(3))) ///
			stats(N N_clust , fmt(0 0) ///
		labels(`"\# Observations"' `"\# Firms"')) 	///
		starlevels( * 0.10 ** 0.05 *** 0.01)

	eststo clear
}

foreach depvar in zakm_pe zpe_mngr zpe_lab{
    /*get common sample*/

    qui eststo m3: areg  `depvar' zmanagement ${ctrl_jole}  degree_share if has_akm==1 & numobs==2 , absorb(sic2) cluster(cnpj)
    qui eststo m4: areg  `depvar' zpeople ${ctrl_jole}  degree_share if has_akm==1 & numobs==2 , absorb(sic2) cluster(cnpj)
    qui eststo m5: areg  `depvar' zops ${ctrl_jole}  degree_share if has_akm==1 & numobs==2 , absorb(sic2) cluster(cnpj)
    qui eststo m6: areg  `depvar' zops zpeople ${ctrl_jole} degree_share if has_akm==1 & numobs==2 , absorb(sic2) cluster(cnpj)

    esttab m3 m5 m4 m6, ///
		title(Pooled OLS Estimates for 2008 and 2013: `depvar') ///
        keep(zmanagement zops zpeople) ///	
        order(zmanagement zops zpeople) ///
        compress collabels(none) nodepvars nogap nomtitle ///
        cells(b(star fmt(3)) se(par fmt(3))) ///
        stats(N N_clust , fmt(0 0) ///
	labels(`"\# Observations"' `"\# Firms"')) 	///
	starlevels( * 0.10 ** 0.05 *** 0.01) 

    eststo clear

    qui eststo m3: areg  `depvar' zmanagement ${ctrl_jole}  degree_share if has_akm==1 & numobs==2 , absorb(cnpj) cluster(cnpj)
    qui eststo m4: areg  `depvar' zpeople ${ctrl_jole}  degree_share if has_akm==1 & numobs==2 , absorb(cnpj) cluster(cnpj)
    qui eststo m5: areg  `depvar' zops ${ctrl_jole}  degree_share if has_akm==1 & numobs==2 , absorb(cnpj) cluster(cnpj)
    qui eststo m6: areg  `depvar' zops zpeople ${ctrl_jole} degree_share if has_akm==1 & numobs==2 , absorb(cnpj) cluster(cnpj)

    esttab m3 m5 m4 m6, ///
	    title(FE Estimates for 2008 and 2013: `depvar') ///
        keep(zmanagement zops zpeople) ///	
        order(zmanagement zops zpeople) ///
        compress collabels(none) nodepvars nogap nomtitle ///
        cells(b(star fmt(3)) se(par fmt(3))) ///
        stats(N N_clust , fmt(0 0) ///
	labels(`"\# Observations"' `"\# Firms"')) 	///
	starlevels( * 0.10 ** 0.05 *** 0.01) 

    eststo clear

/* qui eststo m2: reg zakm_pe formal i.y*/
    qui eststo m3: areg  `depvar' zmanagement ${ctrl_jole}  degree_share if has_akm==1 & numobs==2 & year==2013, absorb(sic2) cluster(cnpj)
    qui eststo m4: areg  `depvar' zpeople ${ctrl_jole}  degree_share if has_akm==1 & numobs==2 & year==2013, absorb(sic2) cluster(cnpj)
    qui eststo m5: areg  `depvar' zops ${ctrl_jole}  degree_share if has_akm==1 & numobs==2 & year==2013, absorb(sic2) cluster(cnpj)
    qui eststo m6: areg  `depvar' zops zpeople ${ctrl_jole} degree_share if has_akm==1 & numobs==2 & year==2013, absorb(sic2) cluster(cnpj)

    esttab m3 m5 m4 m6, ///
	    title(Cross-section OLS Estimates for 2013: `depvar') ///
        keep(zmanagement zops zpeople) ///	
        order(zmanagement zops zpeople) ///
        compress collabels(none) nodepvars nogap nomtitle ///
        cells(b(star fmt(3)) se(par fmt(3))) ///
        stats(N N_clust , fmt(0 0) ///
	labels(`"\# Observations"' `"\# Firms"')) 	///
	starlevels( * 0.10 ** 0.05 *** 0.01) 

    eststo clear


    qui eststo m3: ivreg2  `depvar'  (zmanagement = l_zmanagement) ${ctrl_jole} degree_share i.sicnum if has_akm==1 & numobs==2 & year==2013, cluster(cnpj)
    qui eststo m4: ivreg2  `depvar' (zpeople = l_zpeople)  ${ctrl_jole} degree_share i.sicnum if has_akm==1 & numobs==2 & year==2013, cluster(cnpj)
    qui eststo m5: ivreg2  `depvar' (zops = l_zops)  ${ctrl_jole}  degree_share i.sicnum if has_akm==1 & numobs==2 & year==2013, cluster(cnpj)
    qui eststo m6: ivreg2  `depvar' (zops zpeople = l_zops l_zpeople ) ${ctrl_jole}  degree_share i.sicnum if has_akm==1 & numobs==2 & year==2013,  cluster(cnpj)

	esttab m3 m5 m4 m6, ///
	    title(IV Estimates for 2013: `depvar') ///
        keep(zmanagement zops zpeople) ///	
        order(zmanagement zops zpeople) ///
        compress collabels(none) nodepvars nogap nomtitle ///
        cells(b(star fmt(3)) se(par fmt(3))) ///
        stats(N N_clust , fmt(0 0) ///
	labels(`"\# Observations"' `"\# Firms"')) 	///
	starlevels( * 0.10 ** 0.05 *** 0.01) 

eststo clear
}




capture log close

