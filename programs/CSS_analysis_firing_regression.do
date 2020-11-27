global filestub "CSS_analysis_firing_regression"
capture log close
do "config.do"

pause on
set more off
set linesize 120                                                                                                       

/* %*************************************************************************** */
use "${inpath}/WMS_RAIS_flow_microdata.dta", clear

/*standardize the worker effects relative to the WMS-attached stayer sample*/
egen std_pe = std(akm_pe)
replace akm_pe = std_pe
drop std_pe

gen reg_grp = real(substr(state,1,1))

*-----------------------------------------------------------------
* "FIRING" probability -- regression models
*-----------------------------------------------------------------

    global ctrl c.tenure_months i.male i.race_* i.educ_best c.lemp c.lfirmage  i.compet_cat i.own_cat i.reg_grp    

/* Regression table version */


foreach type in mngr labr{
	qui reg fire c.akm_pe##c.akm_pe i.year if occ_`type'==1 & formal==1, cluster(cnpj)
    est save ${tabpath}/appendix/CSS_firing_reg_`type'_struc_base.ster, replace

    qui reg fire c.akm_pe##c.akm_pe i.year if occ_`type'==1 & formal==0, cluster(cnpj)
    est save ${tabpath}/appendix/CSS_firing_reg_`type'_unstruc_base.ster, replace

    qui reg fire i.formal##(c.akm_pe##c.akm_pe i.year) if occ_`type'==1 , cluster(cnpj)
    est save ${tabpath}/appendix/CSS_firing_reg_`type'_both_base.ster, replace

    qui areg fire c.akm_pe##c.akm_pe i.year ${ctrl} if occ_`type'==1 & formal==1, cluster(cnpj) ab(sic2)
    est save ${tabpath}/appendix/CSS_firing_reg_`type'_struc_ctrl.ster, replace

    qui areg fire c.akm_pe##c.akm_pe i.year ${ctrl} if occ_`type'==1 & formal==0, cluster(cnpj) ab(sic2)
    est save ${tabpath}/appendix/CSS_firing_reg_`type'_unstruc_ctrl.ster, replace

    qui areg fire i.formal##(c.akm_pe##c.akm_pe i.year ${ctrl}) if occ_`type'==1 , cluster(cnpj) ab(sic2)
    est save ${tabpath}/appendix/CSS_firing_reg_`type'_both_ctrl.ster, replace

} 

/*logit models*/

      gen pe_sq = akm_pe*akm_pe
      gen f_pe  = formal*akm_pe
      gen f_pe_sq = formal*pe_sq


 foreach type in mngr labr{
 	eststo: logit fire akm_pe pe_sq i.year if occ_`type'==1 & formal==1, cluster(cnpj)
     estadd margins, dydx(*) atmeans 
     estimates save ${tabpath}/appendix/CSS_firing_logit_`type'_struc_base.ster, replace
     eststo clear

     eststo: logit fire akm_pe pe_sq i.year if occ_`type'==1 & formal==0, cluster(cnpj)
     estadd margins, dydx(*) atmeans
     estimates save ${tabpath}/appendix/CSS_firing_logit_`type'_unstruc_base.ster, replace
     eststo clear
 }

	/*Tables of regression model estimates*/
 foreach type in mngr labr{
	estimates use ${tabpath}/appendix/CSS_firing_reg_`type'_struc_base.ster
	eststo ns1: 
	estimates use ${tabpath}/appendix/CSS_firing_reg_`type'_unstruc_base.ster
	eststo nu1:
	estimates use ${tabpath}/appendix/CSS_firing_reg_`type'_both_base.ster
	eststo nb1:
    estimates use ${tabpath}/appendix/CSS_firing_reg_`type'_struc_ctrl.ster
	eststo ns2: 
	estimates use ${tabpath}/appendix/CSS_firing_reg_`type'_unstruc_ctrl.ster
	eststo nu2:
	estimates use ${tabpath}/appendix/CSS_firing_reg_`type'_both_ctrl.ster
	eststo nb2:


	esttab nu1 ns1 nb1 nu2 ns2 nb2 using "${tabpath}/appendix/app_firing_regs_`type'.tex", booktabs replace ///
		keep(1.formal akm_pe c.akm_pe#c.akm_pe 1.formal#c.akm_pe* _cons)  ///
		order(1.formal akm_pe c.akm_pe#c.akm_pe 1.formal#c.akm_pe* _cons) ///
		compress collabels(none) nodepvars nogap  ///
		mtitles("Structured = 0" "Structured = 1" "Combined" "Structured = 0" "Structured = 1" "Combined") ///
		coef(akm_pe "Quality" c.akm_pe#c.akm_pe "Qual.\ Sq." 1.formal "Struc.\ Mgmt." ///
		1.formal#c.akm_pe "Struc.\ X Qual." 1.formal#c.akm_pe#c.akm_pe "Struc.\ X Qual.\ Sq." _cons "Constant") ///
		cells(b(star fmt(3)) se(par fmt(3))) ///
		scalars("N_clust Firms") ///
		indicate("Year controls = 2010.year" "Firm \& Worker controls = lemp", labels("\cmark" ""))

	esttab nu1 ns1 nb1 nu2 ns2 nb2 , ///
		keep(1.formal akm_pe c.akm_pe#c.akm_pe 1.formal#c.akm_pe* _cons)  ///
		order(1.formal akm_pe c.akm_pe#c.akm_pe 1.formal#c.akm_pe* _cons) ///
		compress collabels(none) nodepvars nogap  ///
		mtitles("Structured = 0" "Structured = 1" "Combined" "Structured = 0" "Structured = 1" "Combined") ///
		coef(akm_pe "Quality" c.akm_pe#c.akm_pe "Qual.\ Sq." 1.formal "Struc.\ Mgmt." ///
		1.formal#c.akm_pe "Struc.\ X Qual." 1.formal#c.akm_pe#c.akm_pe "Struc.\ X Qual.\ Sq." _cons "Constant") ///
		cells(b(star fmt(3)) se(par fmt(3))) ///
		scalars("N_clust Firms") ///
		indicate("Year controls = 2010.year" "Firm \& Worker controls = lemp", labels("\cmark" ""))
}


/*Tables of logit model estimates*/
	estimates use ${tabpath}/appendix/CSS_firing_logit_labr_struc_base.ster
	eststo ls1: 
	estimates use ${tabpath}/appendix/CSS_firing_logit_labr_unstruc_base.ster
	eststo lu1:

    estimates use ${tabpath}/appendix/CSS_firing_logit_mngr_struc_base.ster
	eststo ms1: 
	estimates use ${tabpath}/appendix/CSS_firing_logit_mngr_unstruc_base.ster
	eststo mu1:




	esttab mu1 ms1 lu1 ls1 using "${tabpath}/appendix/app_firing_logit_all_base.tex", booktabs replace ///
		keep(akm_pe pe_sq )  ///
		order(akm_pe pe_sq ) ///
		compress collabels(none) nodepvars nogap  ///
        mgroups("Managers" "Non-managers", ///
	    pattern(1 0 1 0  ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
		mtitles("Structured = 0" "Structured = 1" "Structured = 0" "Structured = 1"  ) ///
		coef(akm_pe "Quality" pe_2 "Qual.\ Sq."  ) ///
		cells(margins_b(star fmt(3))  margins_se(par fmt(3))) ///
		scalars("N_clust Firms") ///
		indicate("Year controls = 2010.year" , labels("\cmark" ""))

	esttab mu1 ms1 lu1 ls1  ,   ///
		keep(akm_pe pe_sq )  ///
		order(akm_pe pe_sq ) ///
		compress collabels(none) nodepvars nogap  ///
        mgroups("Managers" "Non-managers", ///
	    pattern(1 0 1 0  ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
		mtitles("Structured = 0" "Structured = 1" "Structured = 0" "Structured = 1"  ) ///
		coef(akm_pe "Quality" pe_2 "Qual.\ Sq."  ) ///
		cells(margins_b(star fmt(3))  margins_se(par fmt(3))) ///
		scalars("N_clust Firms") ///
		indicate("Year controls = 2010.year" , labels("\cmark" ""))


cap log close

