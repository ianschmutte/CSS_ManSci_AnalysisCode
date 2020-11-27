global filestub "BBCVW_replication_flows"
capture log close
do "config.do"

pause on
set more off
set linesize 120                                                                                                        


use "${inpath}/WMS_RAIS_flow_plantdata.dta", clear

egen reg_num = group(region)

global ctrl_jole i.reg_num i.year i.own_cat lfirmage female_share i.compet_cat mis_competition c.AKM_coverage##c.AKM_coverage##c.AKM_coverage

global basis i.reg_num i.year i.own_cat lfirmage female_share c.AKM_coverage##c.AKM_coverage##c.AKM_coverage

la var zmanagement "z-management"
la var lemp 	   "ln(employment)"
la var age_fires   "Mean age (fired)" 
la var coll_fires  "\% college (fired)"
la var degree_t    "\% college"

/*TABLE 6*/
foreach num of numlist 10 25 50 75 90{
    qui eststo tab6_`num'_a: areg inflow_p`num' zmanagement degree_t ${ctrl_jole} if inflow_tot >= 3, cluster(cnpj) ab(sic2)
	gen samp = e(sample)
    qui eststo tab6_`num'_b: areg inflow_p`num' zmanagement degree_t lemp ${ctrl_jole} if samp==1, cluster(cnpj) ab(sic2)
    drop samp
}

esttab tab6_10_a tab6_25_a tab6_50_a tab6_75_a tab6_90_a using "${tabpath}/BBCVW_tab6a_rep.tex", ///
    f label replace 	keep(zmanagement degree_t) 	order (zmanagement degree_t) ///
    compress collabels(none) nodepvars nogap nonum noobs nomtitle ///
    cells(b(star fmt(3)) se(par fmt(3))) /// 
    mgroups("A. Not Including Size Control", pattern(1 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span ) 

esttab tab6_10_b tab6_25_b tab6_50_b tab6_75_b tab6_90_b using "${tabpath}/BBCVW_tab6b_rep.tex", ///
    f label replace 	keep(zmanagement degree_t lemp) 	order (zmanagement degree_t lemp) ///
    compress collabels(none) nodepvars nogap nomtitle nonum  ///
    cells(b(star fmt(3)) se(par fmt(3))) /// 
    scalar ("N_clust Firms")  ///
    mgroups("B. Including Size Control", pattern(1 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span ) 
    
/*Print to Stata log*/
esttab tab6_10_a tab6_25_a tab6_50_a tab6_75_a tab6_90_a ,  label replace 	keep(zmanagement degree_t) 	order (zmanagement degree_t) compress collabels(none) nodepvars nogap nomtitle cells(b(star fmt(3)) se(par fmt(3))) scalar ("N_clust Firms")

esttab tab6_10_b tab6_25_b tab6_50_b tab6_75_b tab6_90_b ,  label replace 	keep(zmanagement degree_t lemp) 	order (zmanagement degree_t lemp) compress collabels(none) nodepvars nogap nomtitle cells(b(star fmt(3)) se(par fmt(3))) scalar ("N_clust Firms")




/*TABLE 7*/
gen delta_peff_outflow = pe_fires - pe_stayers

cap eststo clear

replace coll_fires = coll_fires / 100
qui eststo tab7_4: areg delta_peff_outflow zmanagement age_fires coll_fires degree_t ${ctrl_jole} if fire_tot>=3, cluster(cnpj) absorb(sic2)
gen samp = e(sample)
qui eststo tab7_1: areg delta_peff_outflow zmanagement c.AKM_coverage##c.AKM_coverage##c.AKM_coverage if samp==1, cluster(cnpj) absorb(sic2)
qui eststo tab7_2: areg delta_peff_outflow zmanagement ${ctrl_jole} degree_t if samp==1, cluster(cnpj) absorb(sic2)
qui eststo tab7_3: areg delta_peff_outflow zmanagement age_fires ${ctrl_jole} degree_t if samp==1, cluster(cnpj) absorb(sic2)


esttab tab7_1 tab7_2 tab7_3 tab7_4 using "${tabpath}/BBCVW_tab7_rep.tex", booktabs label replace ///
 	keep(zmanagement age_fires coll_fires) 	order (zmanagement age_fires coll_fires) /// 
    compress collabels(none) nodepvars nogap nomtitle ///
    cells(b(star fmt(3)) se(par fmt(3))) scalar ("N_clust Firms") ///
     mgroups("Avg ability of fired - Avg ability of incumbents", pattern(1 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span  erepeat(\cmidrule(lr){@span}) ) 
   

esttab tab7_1 tab7_2 tab7_3 tab7_4, label replace 	keep(zmanagement age_fires coll_fires) 	order (zmanagement age_fires coll_fires) compress collabels(none) nodepvars nogap nomtitle cells(b(star fmt(3)) se(par fmt(3))) scalar ("N_clust Firms")


/*count number of flows*/
preserve
collapse (sum) inflow_tot fire_tot
sum inflow_tot fire_tot
restore

preserve

cap log close