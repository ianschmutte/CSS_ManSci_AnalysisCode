global filestub "CSS_predict_retained_worker_quality"
capture log close
do "config.do"

pause on
set more off
set linesize 120                                                                                                       

/* %*************************************************************************** */
use "${inpath}/WMS_plantyear_with_RAIS.dta", clear

/*rename for legacy purposes*/
rename zoperations zops

/*plant-level regression to extract variation predicted by ops and residual variation*/
preserve

collapse zmanagement zops zpeople, by(cnpj)
qui reg zops zmanagement
predict zm_ops_signal, xb
predict zm_ops_resid, resid
qui reg zpeople zmanagement 
predict zm_peop_signal, xb
predict zm_peop_resid, resid
tempfile zm_ops_data
save `zm_ops_data', replace

restore

merge m:1 cnpj using "`zm_ops_data'"
drop _merge
sum zm_ops_signal zm_ops_resid zm_peop_signal zm_peop_resid
egen z_zm_ops_signal = std(zm_ops_signal)
egen z_zm_ops_resid = std(zm_ops_resid)
egen z_zm_peop_signal = std(zm_peop_signal)
egen z_zm_peop_resid = std(zm_peop_resid)
/******************************************************************/

global ctrl_jole lemp i.region i.year i.own_cat lfirmage female_share i.compet_cat mis_competition c.AKM_coverage##c.AKM_coverage##c.AKM_coverage

gen degree_share = degree_t/100

gen samp = .

la var zmanagement "z-management"
la var zops 	   "z-operations"
la var zpeople 	   "z-people"
la var z_zm_ops_signal "z-operations (signal)"
la var z_zm_ops_resid "z-operations (residual)"
la var z_zm_peop_signal "z-people (signal)"
la var z_zm_peop_resid "z-people (residual)"

foreach depvar in zakm_pe zpe_mngr zpe_lab{
    /*get common sample*/
    qui reg `depvar' z_zm_ops_signal z_zm_ops_resid ${ctrl_jole} degree_share
    replace samp = e(sample)

    /* qui eststo m2: reg zakm_pe formal i.year if samp==1, cluster(cnpj) */
    qui eststo m1: areg  `depvar' zmanagement i.year if samp==1, absorb(sic2) cluster(cnpj)
    qui eststo m2: areg  `depvar' zmanagement ${ctrl_jole}  if samp==1, absorb(sic2) cluster(cnpj)
    qui eststo m3: areg  `depvar' zmanagement ${ctrl_jole} degree_share if samp==1, absorb(sic2) cluster(cnpj)
    qui eststo m4: areg  `depvar' zpeople ${ctrl_jole} degree_share if samp==1, absorb(sic2) cluster(cnpj)
    qui eststo m5: areg  `depvar' zops ${ctrl_jole} degree_share if samp==1, absorb(sic2) cluster(cnpj)
    qui eststo m6: areg  `depvar' zops zpeople ${ctrl_jole} degree_share,  absorb(sic2) cluster(cnpj)
    qui eststo m7: areg  `depvar' z_zm_ops_signal z_zm_ops_resid ${ctrl_jole} degree_share,  absorb(sic2) cluster(cnpj)
    qui eststo m8: areg  `depvar' z_zm_peop_signal z_zm_peop_resid ${ctrl_jole} degree_share,  absorb(sic2) cluster(cnpj)

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

    esttab m1 m2 m3 m5 m4 m6, ///
        keep(zmanagement zops zpeople) ///	
        order(zmanagement zops zpeople) ///
        compress collabels(none) nodepvars nogap nomtitle ///
        cells(b(star fmt(3)) se(par fmt(3))) ///
        stats(N N_clust , fmt(0 0) ///
	labels(`"\# Observations"' `"\# Firms"')) 	///
	starlevels( * 0.10 ** 0.05 *** 0.01) ///
        indicate("Year controls = _cons" "Full controls = lemp" "College share = degree_share"  , labels("\cmark" "")) ///
	mgroups("`mt'", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))


    esttab m1 m2 m3 m5 m4 m6 using "${tabpath}/CSS_pred_`depvar'_1.tex", booktabs label replace ///
        keep(zmanagement zops zpeople) ///	
        order(zmanagement zops zpeople) ///
        compress collabels(none) nodepvars nogap nomtitle  ///
        cells(b(star fmt(3)) se(par fmt(3))) ///
         stats(N N_clust , fmt(0 0) ///
	labels(`"\# Observations"' `"\# Firms"')) 	///
	starlevels( * 0.10 ** 0.05 *** 0.01) ///
        indicate("Year controls = _cons" "Full controls = lemp" "College share = degree_share"  , labels("\cmark" "")) ///
	mgroups("`mt'", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))


    esttab m7 m8, ///
        keep(z_zm_ops_signal z_zm_ops_resid z_zm_peop_signal z_zm_peop_resid) ///	
        order(z_zm_ops_signal z_zm_ops_resid z_zm_peop_signal z_zm_peop_resid) ///
        compress collabels(none) nodepvars nogap  nomtitle ///
        cells(b(star fmt(3)) se(par fmt(3))) ///
         stats(N N_clust , fmt(0 0) ///
	labels(`"\# Observations"' `"\# Firms"')) 	///
	starlevels( * 0.10 ** 0.05 *** 0.01) ///
        indicate("Year controls = _cons" "Full controls = lemp" "College share = degree_share"  , labels("\cmark" "")) ///
	mgroups("`mt'", pattern(1) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))


    esttab m7 m8 using "${tabpath}/CSS_pred_`depvar'_2.tex", booktabs label replace ///
        keep(z_zm_ops_signal z_zm_ops_resid z_zm_peop_signal z_zm_peop_resid) ///	
        order(z_zm_ops_signal z_zm_ops_resid z_zm_peop_signal z_zm_peop_resid) ///
        compress collabels(none) nodepvars nogap  nomtitle ///
        cells(b(star fmt(3)) se(par fmt(3))) ///
         stats(N N_clust , fmt(0 0) ///
	labels(`"\# Observations"' `"\# Firms"')) 	///
	starlevels( * 0.10 ** 0.05 *** 0.01) ///
        indicate("Year controls = _cons" "Full controls = lemp" "College share = degree_share"  , labels("\cmark" "")) ///
	mgroups("`mt'", pattern(1) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))


}



log close
