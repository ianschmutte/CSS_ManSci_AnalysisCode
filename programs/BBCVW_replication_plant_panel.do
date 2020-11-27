global filestub "BBCVW_replication_plant_panel"
capture log close
do "config.do"

pause on
set more off
set linesize 120                                                                                                       

/* %*************************************************************************** */
use "${inpath}/WMS_plantyear_with_RAIS.dta", clear

sum pe_mngr pe_mngr_jole pe_lab

***********
* Figure 3*
***********

binscatter zmanagement zakm_pe, xtitle("Average worker quality (standardized)") ytitle("Management z-score") ///
 yscale(r(-.6 .6)) ylabel(-.6(.2).6) graphregion(color(white)) line(none) mcol(gs3) 
graph save "${figpath}/BBCVW_fig_3.gph", replace
graph export "${figpath}/BBCVW_fig_3.pdf", as(pdf) replace 


***********
* Figure 4*
***********

binscatter zmanagement zakm_pe , controls(lemp) xtitle("Average worker quality (standardized)") ytitle("Management z-score") ///
  yscale(r(-.6 .6)) ylabel(-.6(.2).6) xscale(r(-2 3)) xlabel(-2(1)3) graphregion(color(white)) line(none) mcol(gs3) savedata(${figpath}/BBCVW_fig4_data) replace
  
preserve
clear

insheet using ${figpath}/BBCVW_fig4_data.csv

gen _mgmtGE=.
gen _peGE=.
replace _mgmtGE =0.03 if  _n==1
replace _mgmtGE =-0.28 if  _n ==2
replace _mgmtGE =-0.21 if  _n==3
replace _mgmtGE =-0.09 if  _n==4
replace _mgmtGE =-0.28 if  _n==5
replace _mgmtGE =-0.085 if  _n==6
replace _mgmtGE =0.195 if  _n==7
replace _mgmtGE =0.03 if  _n==8
replace _mgmtGE =0.11 if  _n==9
replace _mgmtGE =-0.28 if  _n==10
replace _mgmtGE =-0.3 if  _n==11
replace _mgmtGE =-0.18 if  _n==12
replace _mgmtGE =-0.21 if  _n==13
replace _mgmtGE =0.05 if  _n==14
replace _mgmtGE =-0.05 if  _n==15
replace _mgmtGE =0.39 if  _n==16
replace _mgmtGE =0.21 if  _n==17
replace _mgmtGE =0.18 if  _n==18
replace _mgmtGE =0.05 if  _n==19
replace _mgmtGE =0.62 if  _n==20

replace _peGE =-1.95 if _n==1
replace _peGE =-1.1 if _n==2
replace _peGE =-0.9 if _n==3
replace _peGE =-0.8 if _n==4
replace _peGE =-0.7 if _n==5
replace _peGE =-0.6 if _n==6
replace _peGE =-0.5 if _n==7
replace _peGE =-0.4 if _n==8
replace _peGE =-0.3 if _n==9
replace _peGE =-0.2 if _n==10
replace _peGE =-0.1 if _n==11
replace _peGE =0 if _n==12
replace _peGE =0.1 if _n==13
replace _peGE =0.2 if _n==14
replace _peGE =0.4 if _n==15
replace _peGE =0.6 if _n==16
replace _peGE =0.7 if _n==17
replace _peGE =1.1 if _n==18
replace _peGE =1.5 if _n==19
replace _peGE =2.2 if _n==20

twoway (scatter _mgmtGE _peGE , msymbol(Th) mcolor(cranberry)) ///
	(scatter zmanagement zakm_pe , mcolor(forest_green) ///
	ytitle("Management z-score", size(medium)) ylabel(-.6(.2).6, noticks labsize(medium)) ///
	xtitle("Average worker quality (standardized)", size(medium)) xlabel(,noticks labsize(medium)) ///
	graphregion(${gregion}) plotregion(${pregion}) ///
	legend(label(1 "Germany (replication)") label(2 "Brazil") order(2 1) ring(0) pos(10) col(1) region(lcolor(white))))
graph save "${figpath}/BBCVW_fig_4.gph", replace
graph export "${figpath}/BBCVW_fig_4.pdf", as(pdf) replace 


restore
***********
* Figure 7*
***********


binscatter zmanagement zakm_fe , controls(lemp) xtitle("Average firm FE") ytitle("Management z-score") ///
  yscale(r(-.6 .6)) ylabel(-.6(.2).6) xscale(r(-2 3)) xlabel(-2(1)3) graphregion(color(white)) line(none) mcol(gs3) savedata(${figpath}/BBCVW_fig7_data) replace
  
preserve
clear

insheet using ${figpath}/BBCVW_fig7_data.csv

gen _mgmtGE=.
gen _peGE=.
replace _mgmtGE =-.5 if  _n==1
replace _mgmtGE =-.22 if  _n==2
replace _mgmtGE =-.12 if  _n==3
replace _mgmtGE =0 if  _n==4
replace _mgmtGE =-.22 if  _n==5
replace _mgmtGE =.35 if  _n==6
replace _mgmtGE =-.05 if  _n==7
replace _mgmtGE =-.19 if  _n==8
replace _mgmtGE =.18 if  _n==9
replace _mgmtGE =-.395 if  _n==10
replace _mgmtGE =-.19 if  _n==11
replace _mgmtGE =-.1 if  _n==12
replace _mgmtGE =.11 if  _n==13
replace _mgmtGE =.05 if  _n==14
replace _mgmtGE =.08 if  _n==15
replace _mgmtGE =.21 if  _n==16
replace _mgmtGE =.01 if  _n==17
replace _mgmtGE =.35 if  _n==18
replace _mgmtGE =.25 if  _n==19
replace _mgmtGE =.39 if  _n==20

replace _peGE =-2.2 if _n==1
replace _peGE =-1.2 if _n==2
replace _peGE =-0.8 if _n==3
replace _peGE =-0.6 if _n==4
replace _peGE =-0.5 if _n==5
replace _peGE =-0.3 if _n==6
replace _peGE =-0.1 if _n==7
replace _peGE =-0.05 if _n==8
replace _peGE =0 if _n==9
replace _peGE =0.05 if _n==10
replace _peGE =0.1 if _n==11
replace _peGE =0.15 if _n==12
replace _peGE =0.3 if _n==13
replace _peGE =0.42 if _n==14
replace _peGE =0.55 if _n==15
replace _peGE =0.7 if _n==16
replace _peGE =0.85 if _n==17
replace _peGE =1.3 if _n==18
replace _peGE =1.5 if _n==19
replace _peGE =2 if _n==20
	
twoway (scatter _mgmtGE _peGE , msymbol(Th) mcolor(cranberry)) ///
	(scatter zmanagement zakm_fe , mcolor(forest_green) ///
	ytitle("Management z-score", size(medium)) ylabel(-.6(.2).4, noticks labsize(medium)) ///
	xtitle("Firm FE", size(medium)) xlabel(,noticks labsize(medium)) ///
	graphregion(${gregion}) plotregion(${pregion}) ///
	legend(label(1 "Germany (replication)") label(2 "Brazil") order(2 1) ring(0) pos(10) col(1) region(lcolor(white))))
graph save "${figpath}/BBCVW_fig_7.gph", replace
graph export "${figpath}/BBCVW_fig_7.pdf", as(pdf) replace 


***********
* Table 1 *
***********

restore

label define ownl ///
  1 "Family owned" /// 
  2 "Founder owned" ///
  3 "Manager owned" ///
  4 "Nonfamily private owned" ///
  5 "Institutionally owned" ///
  6 "Government owned" 

label define compl ///
  1 "No competitors" ///
  2 "Less than five competitors" ///
  3 "Five or more competitors"

label values own_cat ownl
label values compet_cat compl

tabulate own_cat, gen(ownerc)
la var ownerc1 "Family owned" 
la var ownerc2 "Founder owned"
la var ownerc3 "Manager owned" 
la var ownerc4 "Nonfamily private owned"
la var ownerc5 "Institutionally owned"
la var ownerc6 "Government ownership" 

tabulate compet_cat, gen(competc)
la var competc1 "Zero competitors" 
la var competc2 "Fewer than five competitors"
la var competc3 "Five or more competitors" 

label var firmage "Firm age (years)"
label var zmanagement "Management score (standardized)"
label var female_t "\% of female employees (WMS)"
label var degree_t "\% of employees with college degree (WMS)"
label var num_workers "Number of workers"
label var median_wage "Median hourly wage"
label var female_share "\% of female employees (RAIS)"
label var coll_share "\% of employees with college degree (RAIS)"
label var AKM_coverage "AKM coverage (\% empl with worker effects)"
label var zakm_pe "Average employee quality (AKM worker effects)"
label var zpe_mngr "Average managerial quality (occupation-based)"
label var zpe_mngr_jole "Average managerial quality (top quartile)"
label var zakm_fe "Firm wage premium (AKM employer effect)"
la var percent_m "\% of managers"

tabstat  firmage competc? ownerc? zmanagement female_t degree_t percent_m num_workers median_wage female_share coll_share mngr_share ///
    AKM_coverage zakm_pe zpe_mngr zpe_mngr_jole zakm_fe if has_akm ==1, ///
        statistics(mean median min max  sd n)
 

estpost sum competc? ownerc? firmage zmanagement female_t degree_t percent_m num_workers median_wage female_share coll_share mngr_share ///
    AKM_coverage zakm_pe zpe_mngr zpe_mngr_jole zakm_fe if has_akm==1 , d

est store sumstats

esttab sumstats, replace ///
		refcat(competc1 "\textbf{Number of competitors}" ///
		    ownerc1 "\textbf{Ownership}" ///
			firmage "\textbf{Other WMS variables}" ///
			num_workers "\textbf{RAIS variables}" ///
			AKM_coverage "\textbf{RAIS/AKM variables}" ///
			, nolabel ) ///
		cells("mean(label(\textbf{Mean}) fmt(2)) p50(label(\textbf{Median}) fmt(1)) min(label(\textbf{Min}) fmt(1)) max(label(\textbf{Max}) fmt(1)) sd(label(\textbf{SD}) par) count(label(\textbf{N}) fmt(0))") label nonotes nonumber noobs 

esttab sumstats using ${tabpath}/BBCVW_sumstats.tex, booktabs  replace ///
		refcat(competc1 "\textbf{Number of competitors}" ///
		    ownerc1 "\textbf{Ownership}" ///
			firmage "\textbf{Other WMS variables}" ///
			num_workers "\textbf{RAIS variables}" ///
			AKM_coverage "\textbf{RAIS/AKM variables}" ///
			, nolabel ) ///
		cells("mean(label(\textbf{Mean}) fmt(2)) p50(label(\textbf{Median}) fmt(1)) min(label(\textbf{Min}) fmt(1)) max (label(\textbf{Max}) fmt(1)) sd(label(\textbf{SD}) par) count(label(\textbf{N}) fmt(0))") label nonotes nonumber noobs 

drop competc? ownerc?






***********
* Table 2 *
***********
la var lemp "Ln of firm employment (WMS)"

global ctrl_jole lemp i.region i.year i.own_cat lfirmage female_share i.compet_cat mis_competition c.AKM_coverage##c.AKM_coverage##c.AKM_coverage
replace degree_t = degree_t/100

qui eststo jole1: areg zmanagement 			 ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)
qui eststo jole2: areg zmanagement zakm_pe			 ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)
qui eststo jole3: areg zmanagement zpe_mngr_jole 	 ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)
qui eststo jole4: areg zmanagement zakm_pe	zpe_mngr_jole	    	 ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)
qui eststo jole5: areg zmanagement zakm_pe zpe_mngr_jole degree_t ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)

esttab jole2 jole3 jole4 jole5 using "${tabpath}/BBCVW_tab2_rep.tex", booktabs label replace ///
	keep(zakm_pe	zpe_mngr_jole lemp degree_t) ///
	order(zakm_pe	zpe_mngr_jole lemp degree_t ) ///
	compress collabels(none) nodepvars nogap nomtitle ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	scalars("N_clust Firms") ///
	mgroups("Management z-score", pattern(1) prefix(\multicolumn{@span}{c}{) suffix(}) span)

qui eststo jole1b: areg zmanagement 			  ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)
qui eststo jole2b: areg zmanagement zakm_pe			  ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)
qui eststo jole3b: areg zmanagement zpe_mngr_jole 	  ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)
qui eststo jole4b: areg zmanagement zpe_lab_jole	zpe_mngr_jole	  ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)
qui eststo jole5b: areg zmanagement zpe_lab_jole   zpe_mngr_jole degree_t ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)

esttab jole2b jole3 jole4b jole5b using "${tabpath}/BBCVW_tab2_rep2.tex", booktabs label replace ///
	keep(zakm_pe zpe_mngr_jole zpe_lab_jole lemp degree_t ) ///
	order(zakm_pe zpe_mngr_jole zpe_lab_jole lemp degree_t ) ///
	compress collabels(none) nodepvars nogap nomtitle ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	scalars("N_clust Firms") ///
	mgroups("Management z-score", pattern(1) prefix(\multicolumn{@span}{c}{) suffix(}) span)

qui eststo jole1_e: areg zmanagement 			   ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)
qui eststo jole2_e: areg zmanagement zakm_pe		   ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)
qui eststo jole3_e: areg zmanagement 	  zpe_mngr	   ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)
qui eststo jole4_e: areg zmanagement zakm_pe  zpe_mngr	   ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)
qui eststo jole5_e: areg zmanagement zakm_pe  zpe_mngr degree_t ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)

esttab jole4_e jole5_e using "${tabpath}/BBCVW_tab2_ext1.tex", booktabs label replace ///
	keep(zakm_pe zpe_mngr lemp degree_t ) ///
	order(zakm_pe zpe_mngr lemp degree_t ) ///
	compress collabels(none) nodepvars nogap nomtitle ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	scalars("N_clust Firms") ///
	mgroups("Management z-score", pattern(1) prefix(\multicolumn{@span}{c}{) suffix(}) span)

qui eststo jole1_e2: areg zmanagement 			   ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)
qui eststo jole2_e2: areg zmanagement zpe_lab		   ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)
qui eststo jole3_e2: areg zmanagement 	  zpe_mngr	   ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)
qui eststo jole4_e2: areg zmanagement zpe_lab  zpe_mngr	   ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)
qui eststo jole5_e2: areg zmanagement zpe_lab  zpe_mngr degree_t ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)

esttab jole2_e2 jole3_e2 jole4_e2 jole5_e2 using "${tabpath}/BBCVW_tab2_ext2.tex", booktabs label replace ///
	keep(zpe_lab zpe_mngr lemp degree_t ) ///
	order(zpe_lab zpe_mngr lemp degree_t ) ///
	compress collabels(none) nodepvars nogap nomtitle ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	scalars("N_clust Firms") ///
	mgroups("Management z-score", pattern(1) prefix(\multicolumn{@span}{c}{) suffix(}) span)

replace degree_t = degree_t*100

/*
DISPLAY IN STATA LOG
*/
esttab jole2 jole3 jole4 jole5 , label replace ///
	keep(zakm_pe	zpe_mngr_jole lemp degree_t) ///
	order(zakm_pe	zpe_mngr_jole lemp degree_t ) ///
	compress collabels(none) nodepvars nogap nomtitle ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	scalars("N_clust Firms")


esttab jole1b jole2b jole3 jole4b jole5b , label replace ///
	keep(zakm_pe zpe_mngr_jole zpe_lab_jole lemp degree_t ) ///
	order(zakm_pe zpe_mngr_jole zpe_lab_jole lemp degree_t ) ///
	compress collabels(none) nodepvars nogap nomtitle ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	scalars("N_clust Firms") 

esttab jole1_e jole2_e jole3_e jole4_e jole5_e ,  label replace ///
	keep(zakm_pe zpe_mngr lemp degree_t ) ///
	order(zakm_pe zpe_mngr lemp degree_t ) ///
	compress collabels(none) nodepvars nogap nomtitle ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	scalars("N_clust Firms") 


esttab jole2_e2 jole3_e2 jole4_e2 jole5_e2 ,  label replace ///
	keep(zpe_lab zpe_mngr lemp degree_t ) ///
	order(zpe_lab zpe_mngr lemp degree_t ) ///
	compress collabels(none) nodepvars nogap nomtitle ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	scalars("N_clust Firms") 


	
/**********	
* TABLE 8 *
***********/	
la var zmanagement "z-management"

 qui eststo jole8_e1: areg w9010 zmanagement   		if has_akm==1, cluster(cnpj) ab(sic2)
 qui eststo jole8_e2: areg w9010 zmanagement  ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)
 qui eststo jole8_e3: areg cv_w zmanagement   		if has_akm==1, cluster(cnpj) ab(sic2)
 qui eststo jole8_e4: areg cv_w zmanagement  ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)
 qui eststo jole8_e5: areg pe9010 zmanagement   		if has_akm==1, cluster(cnpj) ab(sic2)
 qui eststo jole8_e6: areg pe9010 zmanagement  ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)
 qui eststo jole8_e7: areg cv_pe zmanagement   		if has_akm==1, cluster(cnpj) ab(sic2)
 qui eststo jole8_e8: areg cv_pe zmanagement  ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)
 
 esttab jole8* using "${tabpath}/BBCVW_tab8_rep_cv.tex", booktabs label replace ///
	keep(zmanagement) ///
	compress collabels(none) nodepvars nogap nomtitle ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	scalars("N_clust Firms") ///
	indicate("General Controls = lemp" , labels("\cmark" "")) ///
	mgroups("\specialcell{90-10 \\ Log Wages}" ///
	"\specialcell{Coefficient of \\ Variation in \\ Log Wages}" ///
	"\specialcell{90-10 \\ Abilty}" ///
	"\specialcell{Coefficient of \\ Variation in \\ Ability}", ///
	pattern(1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))

 esttab jole8* , label replace ///
	keep(zmanagement) ///
	compress collabels(none) nodepvars nogap nomtitle ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	scalars("N_clust Firms") indicate("General Controls = lemp") 

 qui eststo jole8_e3: areg w_sd zmanagement   		if has_akm==1, cluster(cnpj) ab(sic2)
 qui eststo jole8_e4: areg w_sd zmanagement  ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)
 qui eststo jole8_e7: areg pe_sd zmanagement   		if has_akm==1, cluster(cnpj) ab(sic2)
 qui eststo jole8_e8: areg pe_sd zmanagement  ${ctrl_jole} if has_akm==1, cluster(cnpj) ab(sic2)

 esttab jole8* using "${tabpath}/BBCVW_tab8_rep_sd.tex", booktabs label replace ///
	keep(zmanagement) ///
	compress collabels(none) nodepvars nogap nomtitle ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	scalars("N_clust Firms") ///
	indicate("General Controls = lemp" , labels("\cmark" "")) ///
	mgroups("\specialcell{90-10 \\ Log Wages}" ///
	"\specialcell{Standard\\ Deviation in \\ Log Wages}" ///
	"\specialcell{90-10 \\ Abilty}" ///
	"\specialcellStandard \\ Deviation  in \\ Ability}", ///
	pattern(1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))

 esttab jole8* , label replace ///
	keep(zmanagement) ///
	compress collabels(none) nodepvars nogap nomtitle ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	scalars("N_clust Firms") indicate("General Controls = lemp") 

capture log close