global filestub "CSS_analysis_hiring_regressions"
capture log close
do "config.do"

pause on
set more off
set linesize 120                                                                                                       

/* %*************************************************************************** */
    global firm_ctrl c.lemp c.lfirmage i.compet_cat i.own_cat i.reg_grp
    global wrk_ctrl i.male i.race_* i.educ_best
*-----------------------------------------------------------------
* RANK-RANK REGRESSIONS
*-----------------------------------------------------------------

foreach type in labr mngr{
    use "${inpath}/WMS_RAIS_flow_microdata.dta", clear
    gen reg_grp = real(substr(state,1,1))
	keep if occ_`type' == 1
	local num_pe_quantiles = 100
	keep if hire==1 & sep==0
	xtile pe_q = akm_pe, nq(`num_pe_quantiles')
	preserve
	keep if formal==1
	xtile pe_q_formal = akm_pe, nq(100)
	keep pis pe_q_formal
	tempfile pe_rank
	save `pe_rank'
	collapse pe_q_formal , by(pis)
	save `pe_rank', replace
	restore
	merge m:1 pis using "`pe_rank'"
	preserve
	keep if formal==0
	xtile pe_q_informal = akm_pe, nq(100)
	keep pe_q_informal pis
	collapse pe_q_informal, by(pis)
	save `pe_rank', replace
	restore
	drop _merge
	merge m:1 pis using "`pe_rank'"
	gen pe_rank_by_type = pe_q_formal
	replace pe_rank_by_type = pe_q_informal if formal == 0

	* Models*
	qui eststo base_unstruc_`type': reg pe_rank_by_type c.pe_q##c.pe_q i.year if formal==0, cluster(cnpj)
        estimates save ${tabpath}/appendix/CSS_hiring_reg_unstruc_`type'_base.ster, replace

	qui eststo base_struc_`type': reg pe_rank_by_type c.pe_q##c.pe_q i.year if formal==1, cluster(cnpj)
        estimates save ${tabpath}/appendix/CSS_hiring_reg_struc_`type'_base.ster, replace
    
        qui eststo base_both_`type': reg  pe_rank_by_type i.formal##(c.pe_q##c.pe_q i.year), cluster(cnpj)
        estimates save ${tabpath}/appendix/CSS_hiring_reg_both_`type'_base.ster, replace

	binscatter pe_rank_by_type pe_q, line(none) controls(i.year) by(formal) ///
	savedata(${figpath}/appendix/CSS_hirereg_fig_data_`type'_base) replace

        qui eststo firm_unstruc_`type': areg pe_rank_by_type c.pe_q##c.pe_q ${firm_ctrl} i.year if formal==0, cluster(cnpj) ab(sic2)
        estimates save ${tabpath}/appendix/CSS_hiring_reg_unstruc_`type'_firm.ster, replace

	qui eststo firm_struc_`type': areg pe_rank_by_type c.pe_q##c.pe_q ${firm_ctrl} i.year if formal==1, cluster(cnpj) ab(sic2)
        estimates save ${tabpath}/appendix/CSS_hiring_reg_struc_`type'_firm.ster, replace
	
	qui eststo firm_both_`type': areg pe_rank_by_type i.formal##(c.pe_q##c.pe_q ${firm_ctrl} i.year) , cluster(cnpj) ab(sic2)
        estimates save ${tabpath}/appendix/CSS_hiring_reg_both_`type'_firm.ster, replace

	binscatter pe_rank_by_type pe_q, line(none) controls(i.year $firm_ctrl) by(formal) absorb(sic2) ///
	savedata(${figpath}/appendix/CSS_hirereg_fig_data_`type'_firm) replace

        qui eststo firmwrk_unstruc_`type': areg pe_rank_by_type c.pe_q##c.pe_q ${firm_ctrl} ${wrk_ctrl} i.year ///
	    if formal==0, cluster(cnpj) ab(sic2)
        estimates save ${tabpath}/appendix/CSS_hiring_reg_unstruc_`type'_firmwrk.ster, replace

	qui eststo firmwrk_struc_`type': areg pe_rank_by_type c.pe_q##c.pe_q ${firm_ctrl} ${wrk_ctrl} i.year ///
	    if formal==1, cluster(cnpj) ab(sic2)
        estimates save ${tabpath}/appendix/CSS_hiring_reg_struc_`type'_firmwrk.ster, replace
	
	qui eststo firmwrk_both_`type': areg pe_rank_by_type i.formal##(c.pe_q##c.pe_q ${firm_ctrl} ${wrk_ctrl} i.year) ///
	    , cluster(cnpj) ab(sic2)
        estimates save ${tabpath}/appendix/CSS_hiring_reg_both_`type'_firmwrk.ster, replace

	binscatter pe_rank_by_type pe_q, line(none) controls(i.year ${firm_ctrl} ${wrk_ctrl}) by(formal) absorb(sic2) ///
	savedata(${figpath}/appendix/CSS_hirereg_fig_data_`type'_firmwrk) replace

}

/* %*************************************************************************** */
/* Make graphs and tables */ 
/* %*************************************************************************** */

/*Binscatter figures comparing models for production worker hiring*/

foreach type in labr mngr{
	clear
	tempfile binsct1 binsct2
	insheet using ${figpath}/appendix/CSS_hirereg_fig_data_`type'_firm.csv
	save `binsct1', replace
	clear
	insheet using ${figpath}/appendix/CSS_hirereg_fig_data_`type'_firmwrk.csv
	save `binsct2', replace
	clear
	insheet using ${figpath}/appendix/CSS_hirereg_fig_data_`type'_base.csv
	append using `binsct1' `binsct2', gen(model)

	twoway (scatter pe_rank_by_type_by1 pe_q_by1 if model==0, msymbol(Th) mcolor(green)) ///
		(scatter pe_rank_by_type_by2 pe_q_by2 if model==0 , msymbol(Oh) mcolor(navy)) ///
		(scatter pe_rank_by_type_by1 pe_q_by1 if model==2, msymbol(T) mcolor(green)) ///
		(scatter pe_rank_by_type_by2 pe_q_by2 if model==2 , msymbol(O) mcolor(navy)) ///
		, ///
		plotregion(margin(zero) fcolor(white) lcolor(black) ifcolor(white) ilcolor(black)) ///
		ylabel(0(25)100, labsize(medium) tlcolor(white) nogrid)  ///
		xlabel(0(25)100, labsize(medsmall) tlcolor(white) nogrid) ///
		ytitle("Percentile rank of hired worker"  "within firm type") ///
		xtitle("Percentile rank of hired worker"  "in full distribution") ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ///
		xsize(5) ysize(5) name(`type', replace) ///
		legend(label(1 "Unstructured (base model)") /// 
			label(2 "Structured (base model)") /// 
			label(3 "Unstructured (incl. controls)") /// 
			label(4 "Structured (incl. controls)") ///
			order(1 3 2 4) ring(0) pos(10) col(1) region(lcolor(white)))
			
	graph save "${figpath}/appendix/CSS_hirereg_fig_`type'.gph", replace
	graph export "${figpath}/appendix/CSS_hirereg_fig_`type'.pdf", as(pdf) replace 
}

	/*Tables of model estimates*/
foreach type in labr mngr{
	estimates use ${tabpath}/appendix/CSS_hiring_reg_unstruc_`type'_base
	eststo nu1: 
	estimates use ${tabpath}/appendix/CSS_hiring_reg_unstruc_`type'_firm
	eststo nu2:
	estimates use ${tabpath}/appendix/CSS_hiring_reg_unstruc_`type'_firmwrk
	eststo nu3:
	estimates use ${tabpath}/appendix/CSS_hiring_reg_struc_`type'_base
	eststo ns1: 
	estimates use ${tabpath}/appendix/CSS_hiring_reg_struc_`type'_firm
	eststo ns2:
	estimates use ${tabpath}/appendix/CSS_hiring_reg_struc_`type'_firmwrk
	eststo ns3:
	estimates use ${tabpath}/appendix/CSS_hiring_reg_both_`type'_base
	eststo nb1:
	estimates use ${tabpath}/appendix/CSS_hiring_reg_both_`type'_firm
	eststo nb2:
	estimates use ${tabpath}/appendix/CSS_hiring_reg_both_`type'_firmwrk
	eststo nb3:

	esttab ns1 nu1 nb1 ns3 nu3 nb3 using "${tabpath}/appendix/app_hiring_rank_regs_`type'.tex", booktabs replace ///
		keep(1.formal pe_q* c.pe_q* 1.formal#c.p* _cons)  ///
		order(1.formal pe_q* c.pe_q* 1.formal#c.p* _cons) ///
		compress collabels(none) nodepvars nogap  ///
		mtitles("Structured = 1" "Structured = 1" "Combined" "Structured = 0" "Structured = 1" "Combined") ///
		coef(pe_q "Rank" c.pe_q#c.pe_q "Rank Sq." 1.formal "Struc. Mgmt." ///
		1.formal#c.pe_q "Struc. X Rank" 1.formal#c.pe_q#c.pe_q "Struc. X Rank Sq." _cons "Constant") ///
		cells(b(star fmt(3)) se(par fmt(3))) ///
		scalars("N_clust Firms") ///
		indicate("Year controls = 2010.year" "Firm \& Worker controls = lemp", labels("\cmark" ""))


	esttab ns1 nu1 nb1 ns3 nu3 nb3 ,  ///
		keep(1.formal pe_q* c.pe_q* 1.formal#c.p* _cons)  ///
		order(1.formal pe_q* c.pe_q* 1.formal#c.p* _cons) ///
		compress collabels(none) nodepvars nogap  ///
		mtitles("Structured = 0" "Structured = 1" "Combined" "Structured = 0" "Structured = 1" "Combined") ///
		coef(pe_q "Rank" c.pe_q#c.pe_q "Rank Sq." 1.formal "Struc. Mgmt." ///
		1.formal#c.pe_q "Struc. X Rank" 1.formal#c.pe_q#c.pe_q "Struc. X Rank Sq." _cons "Constant") ///
		cells(b(star fmt(3)) se(par fmt(3))) ///
		scalars("N_clust Firms") ///
		indicate("Year controls = 2010.year" "Firm \& Worker controls = lemp", labels("\cmark" ""))
} 




capture log close