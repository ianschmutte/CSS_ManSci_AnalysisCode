global filestub "CSS_analysis_plant_panel"
capture log close
do "config.do"

pause on
set more off
set linesize 120                                                                                                       

/* %*************************************************************************** */
use "${inpath}/WMS_plantyear_with_RAIS.dta", clear


global ops "lean1 lean2 perf1 perf2 perf3 perf4 perf5 perf6 perf7 perf8 perf9 perf10"
global talent "ztalent1 ztalent2 ztalent3 ztalent4 ztalent5 ztalent6"
global ctrl_jole i.region i.year i.own_cat lfirmage female_share i.compet_cat mis_competition c.AKM_coverage##c.AKM_coverage##c.AKM_coverage
global noise i.year

*-----------------------------------------------------------------
* EXHIBIT: WORKER/MANAGER FE X MANAGEMENT
*-----------------------------------------------------------------


gen zops = zoperations

areg zpe_lab ${talent}  zops  lemp ${ctrl_jole}, cluster(cnpj) ab(sic2)
gen sample=e(sample)

preserve
keep if sample==1

factor ${ops} ${talent},  ml
predict f1 f2 f3
scoreplot


eststo l1: areg zpe_lab zpeople    zops lemp		${noise}, cluster(cnpj) ab(sic2)
eststo l2: areg zpe_lab zpeople    zops lemp ${ctrl_jole}, cluster(cnpj) ab(sic2)
eststo l3: areg zpe_lab ${talent}  zops lemp	 	${noise}, cluster(cnpj) ab(sic2)
eststo l4: areg zpe_lab ${talent}  zops lemp ${ctrl_jole}, cluster(cnpj) ab(sic2)
*eststo l4: areg zpe_labr f1 f2 f3 lemp ${ctrl_f}	${noise}, cluster(cnpj) ab(sic2)

eststo m1: areg zpe_mngr zpeople    zops  lemp		${noise}, cluster(cnpj) ab(sic2)
eststo m2: areg zpe_mngr zpeople    zops  lemp ${ctrl_jole}, cluster(cnpj) ab(sic2)
eststo m3: areg zpe_mngr ${talent}  zops  lemp		${noise}, cluster(cnpj) ab(sic2)
eststo m4: areg zpe_mngr ${talent}  zops  lemp ${ctrl_jole}, cluster(cnpj) ab(sic2)
eststo m5: areg zpe_mngr ${ops}  zpeople  lemp ${ctrl_jole}, cluster(cnpj) ab(sic2)
*eststo m6: areg zpe_mngr f1 f2 lemp ${ctrl_f}	${noise}, cluster(cnpj) ab(sic2)

eststo p1: areg zakm_pe zpeople 	 zops lemp			${noise}, cluster(cnpj) ab(sic2)
eststo p2: areg zakm_pe zpeople  	 zops lemp ${ctrl_jole}, cluster(cnpj) ab(sic2)
eststo p3: areg zakm_pe ${talent}  	 zops lemp			${noise}, cluster(cnpj) ab(sic2)
eststo p4: areg zakm_pe ${talent}    zops lemp ${ctrl_jole}, cluster(cnpj) ab(sic2)



matrix Au = J(3,4,.)
matrix rownames Au = b ll95 ul95
matrix colnames Au = "People - MANAGERS" "People - WORKERS" "Operations - MANAGERS"  "Operations - WORKERS" 

* managers
local sig=1.64
areg zpe_mngr zpeople zops lemp ${ctrl_jole}, cluster(cnpj) ab(sic2)
matrix Au[1,1] = _b[zpeople] \ _b[zpeople]-(`sig'*_se[zpeople]) \ _b[zpeople]+(`sig'*_se[zpeople])
matrix Au[1,3] = _b[zops] \ _b[zops]-(`sig'*_se[zops]) \ _b[zops]+(`sig'*_se[zops])

* laborers
areg zpe_lab zpeople zops lemp ${ctrl_jole}, cluster(cnpj) ab(sic2)
matrix Au[1,2] = _b[zpeople] \ _b[zpeople]-(`sig'*_se[zpeople]) \ _b[zpeople]+(`sig'*_se[zpeople])
matrix Au[1,4] = _b[zops] \ _b[zops]-(`sig'*_se[zops]) \ _b[zops]+(`sig'*_se[zops])

matrix list Au

coefplot (matrix(Au)), ///
		ci((2 3)) ///
		xline(0, lcolor(maroon) lwidth(medthick)) ///
	graphregion(${gregion}) plotregion(${pregion}) ///
	xscale(range(-.3 .3)) xlabel(-.2(.2).2) ///
	b1title("Structured management: coefficient and SE") 	///
	legend(off) ///
	grid(between glcolor(gs5) tstyle(none) ) ///
	title("Outcome: standardized person effect", span margin(0 0 5 0)) ///
	name(private_lac, replace) ///
	note("Note: Includes firm-level controls. Data from RAIS 2008-2013 and WMS 2008, 2013." ///
	, span)
	

esttab p1 p2 m1 m2 l1 l2

esttab p3 p4 m3 m4 l3 l4


esttab  p1 p2 m1 m2 l1 l2 using ${tabpath}/CSS_quality_correlates_panelA.tex, ///
	booktabs label replace ///
	keep( zops zpeople ) ///	
	order( zops zpeople) ///
	compress collabels(none) nodepvars nogap ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	starlevels( * 0.10 ** 0.05 *** 0.01) ///
	stats(N N_clust r2, fmt(0 0 3 3) ///
	layout("\multicolumn{1}{c}{@}") ///
	labels(`"\# Observations"' `"\# Firms"' `"\(R^{2}\)"')) 	///
	indicate("Controls = female_share" , labels("\cmark" "")) ///
	mtitle(	///
	"\textcolor{black}{z-pe FE}" ///
	"\textcolor{black}{z-pe FE}" ///
	"\textcolor{black}{z-pe mgr FE}" ///
	"\textcolor{black}{z-pe mgr FE}" ///
	"\textcolor{black}{z-pe labr FE}" ///
	"\textcolor{black}{z-pe labr FE}" ///
	"\textcolor{black}{z-pe FE}" ///
	"\textcolor{black}{z-pe FE}" ///
	"\textcolor{black}{z-pe mgr FE}" ///
	"\textcolor{black}{z-pe mgr FE}" ///
	"\textcolor{black}{z-pe labr FE}" ///
	"\textcolor{black}{z-pe labr FE}" ///
	)
	

esttab  p3 p4 m3 m4 l3 l4 using ${tabpath}/CSS_quality_correlates_panelB.tex, ///
	booktabs label replace ///
	keep( ztalent1 ztalent2 ztalent3 ztalent4 ztalent5 ztalent6 ) ///	
	order( ztalent1 ztalent2 ztalent3 ztalent4 ztalent5 ztalent6 ) ///
	compress collabels(none) nodepvars nogap ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	starlevels( * 0.10 ** 0.05 *** 0.01) ///
	stats(N N_clust r2, fmt(0 0 3 3) ///
	layout("\multicolumn{1}{c}{@}") ///
	labels(`"\# Observations"' `"\# Firms"' `"\(R^{2}\)"')) 	///
	indicate("Controls = female_share" , labels("\cmark" "")) ///
	mtitle(	///
	"\textcolor{black}{z-pe FE}" ///
	"\textcolor{black}{z-pe FE}" ///
	"\textcolor{black}{z-pe mgr FE}" ///
	"\textcolor{black}{z-pe mgr FE}" ///
	"\textcolor{black}{z-pe labr FE}" ///
	"\textcolor{black}{z-pe labr FE}" ///
	"\textcolor{black}{z-pe FE}" ///
	"\textcolor{black}{z-pe FE}" ///
	"\textcolor{black}{z-pe mgr FE}" ///
	"\textcolor{black}{z-pe mgr FE}" ///
	"\textcolor{black}{z-pe labr FE}" ///
	"\textcolor{black}{z-pe labr FE}" ///
	)	

	
//mgroups("\textbf{Reduced form results}", pattern(1 0 0 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///	



qui eststo m_ze1: areg zakm_fe 	zmanagement			,	cluster(cnpj) ab(sic2)	
qui eststo m_ze2: areg zakm_fe 	zmanagement		lemp,	cluster(cnpj) ab(sic2)	
qui eststo m_ze3: areg zakm_fe 	zmanagement		lemp ${ctrl_jole} ,	cluster(cnpj) ab(sic2)	

qui eststo o_ze1: areg zakm_fe	zops				,	cluster(cnpj) ab(sic2)	
qui eststo o_ze2: areg zakm_fe 	zops			lemp,	cluster(cnpj) ab(sic2)	
qui eststo o_ze3: areg zakm_fe 	zops			lemp ${ctrl_jole} ,	cluster(cnpj) ab(sic2)	

qui eststo p_ze1: areg zakm_fe 	zpeople				,	cluster(cnpj) ab(sic2)	
qui eststo p_ze2: areg zakm_fe 	zpeople			lemp,	cluster(cnpj) ab(sic2)	
qui eststo p_ze3: areg zakm_fe 	zpeople			lemp ${ctrl_jole} ,	cluster(cnpj) ab(sic2)	

qui eststo op_ze1: areg zakm_fe zops zpeople		,	cluster(cnpj) ab(sic2)	
qui eststo op_ze2: areg zakm_fe zops zpeople	lemp,	cluster(cnpj) ab(sic2)	
qui eststo op_ze3: areg zakm_fe zops zpeople	lemp ${ctrl_jole} ,	cluster(cnpj) ab(sic2)	

esttab m_ze1 m_ze2 m_ze3 o_ze1 o_ze2 o_ze3 p_ze1 p_ze2 p_ze3 op_ze1 op_ze2 op_ze3 using ${tabpath}/CSS_firmeffect_correlates.tex, ///
	booktabs label replace ///
	keep(zmanagement zops zpeople lemp ) ///	
	order(zmanagement zops zpeople lemp ) ///
	compress collabels(none) nodepvars nogap ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	starlevels( * 0.10 ** 0.05 *** 0.01) ///
	stats(N N_clust r2 F, fmt(0 0 3 3) ///
	layout("\multicolumn{1}{c}{@}") ///
	labels(`"\# Observations"' `"\# Firms"' `"\(R^{2}\)"' `"F-stat"')) 	///
	indicate("Controls = female_share" , labels("\cmark" "")) ///
	mtitle(	///
	"\textcolor{black}{z-firm FE}" ///
	"\textcolor{black}{z-firm FE}" ///
	"\textcolor{black}{z-firm FE}" ///
	"\textcolor{black}{z-firm FE}" ///
	"\textcolor{black}{z-firm FE}" ///
	"\textcolor{black}{z-firm FE}" ///
	"\textcolor{black}{z-firm FE}" ///
	"\textcolor{black}{z-firm FE}" ///
	"\textcolor{black}{z-firm FE}" ///
	"\textcolor{black}{z-firm FE}" ///
	"\textcolor{black}{z-firm FE}" ///
	"\textcolor{black}{z-firm FE}" )


qui eststo p1_zfe1: areg zakm_fe 	zpeople							,	cluster(cnpj) ab(sic2)	
qui eststo p1_zfe2: areg zakm_fe 	zpeople			lemp  ${ctrl_jole},	cluster(cnpj) ab(sic2)	


	

qui eststo p3_zfe1: areg zakm_fe 	ztalent1 ztalent2 ztalent3 ztalent4 ztalent5 ztalent6				,	cluster(cnpj) ab(sic2)	
qui eststo p3_zfe2: areg zakm_fe 	ztalent1 ztalent2 ztalent3 ztalent4 ztalent5 ztalent6 	lemp  ${ctrl_jole}, 	cluster(cnpj) ab(sic2)	
	

la var zpeople "z-people"
la var ztalent1 "z-talent mindset"
la var ztalent2 "z-appraisals"
la var ztalent3 "z-fixing/firing"
la var ztalent4 "z-promotions"
la var ztalent5 "z-EVP"
la var ztalent6 "z-retention"
	
esttab p1_zfe1 p1_zfe2  p3_zfe1 p3_zfe2 using ${tabpath}/CSS_firmeffect_people.tex, ///
	booktabs label replace ///
	keep(zpeople ztalent1 ztalent2 ztalent3 ztalent4 ztalent5 ztalent6 lemp) ///	
	order(zpeople ztalent1 ztalent2 ztalent3 ztalent4 ztalent5 ztalent6 lemp) ///
	compress collabels(none) nodepvars nogap ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	starlevels( * 0.10 ** 0.05 *** 0.01) ///
	stats(N N_clust r2 F, fmt(0 0 3 3) ///
	layout("\multicolumn{1}{c}{@}") ///
	labels(`"\# Observations"' `"\# Firms"' `"\(R^{2}\)"' `"F-stat"')) 	///
	indicate("Controls = female_share" , labels("\cmark" "")) ///
	mtitle(	///
	"\textcolor{black}{z-firm FE}" ///
	"\textcolor{black}{z-firm FE}" ///
	"\textcolor{black}{z-firm FE}" ///
	"\textcolor{black}{z-firm FE}" )
	

	
foreach var in zakm_pe zpe_lab zpe_mngr{		
qui eststo p1_zpe1: areg `var' 	zpeople			,	cluster(cnpj) ab(sic2)	
qui eststo p1_zpe2: areg `var' 	zpeople		lemp  ${ctrl_jole} ,	cluster(cnpj) ab(sic2)	



qui eststo p3_zpe1: areg `var' 	ztalent1 ztalent2 ztalent3 ztalent4 ztalent5 ztalent6				,	cluster(cnpj) ab(sic2)	
qui eststo p3_zpe2: areg `var' 	ztalent1 ztalent2 ztalent3 ztalent4 ztalent5 ztalent6			lemp  ${ctrl_jole} ,	cluster(cnpj) ab(sic2)	
	
esttab p1_zpe1 p1_zpe2  p3_zpe1 p3_zpe2 using ${tabpath}/CSS_`var'_people.tex, ///
	booktabs label replace ///
	keep(zpeople ztalent1 ztalent2 ztalent3 ztalent4 ztalent5 ztalent6 ln_emp mne_yn  union) ///	
	order(zpeople ztalent1 ztalent2 ztalent3 ztalent4 ztalent5 ztalent6 ln_emp mne_yn  union) ///
	compress collabels(none) nodepvars nogap ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	starlevels( * 0.10 ** 0.05 *** 0.01) ///
	stats(N N_clust r2 F, fmt(0 0 3 3) ///
	layout("\multicolumn{1}{c}{@}") ///
	labels(`"\# Observations"' `"\# Firms"' `"\(R^{2}\)"' `"F-stat"')) 	///
	indicate("Controls = female_share" , labels("Yes" "No")) ///
	mtitle(	///
	"\textcolor{black}{`var' FE}" ///
	"\textcolor{black}{`var' FE}" ///
	"\textcolor{black}{`var' FE}" ///
	"\textcolor{black}{`var' FE}" )
}
	


		


capture log close
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
