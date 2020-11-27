global filestub "BBCVW_replication_ability_dist"
capture log close
do "config.do"

pause on
set more off
set linesize 120                                                                                                        


/**************************************************************************** */
use "${inpath}/WMS_RAIS_linked_microdata.dta", clear

xtile wage_q = log_wage, nq(5)
xtile ability_q = akm_pe, nq(5)
*-----------------------------------------------------------------
* FIGURE 1, JOLE
*-----------------------------------------------------------------
{
use "${inpath}/WMS_RAIS_linked_microdata.dta", clear

xtile wage_q = log_wage, nq(5)
xtile ability_q = akm_pe, nq(5)

gen count = 1

collapse (sum) count  , by(wage_q formal)
drop if wage_q==.

bysort formal: egen numobs = sum(count)


gen share = count / numobs

bysort formal: egen sumshare = sum(share)
sum sumshare



*----- EXTENSION FIG 
graph bar (mean) share if formal==1, over(wage_q, label(labsize(large))) ///
	bar(1, fcolor(forest_green%50) lpattern(solid) lalign(center)) ///
	b1title("Structured Management", size(large)) ///
	yscale(range(0 .4)) ylabel(0(.1).4, labsize(large)) ytitle("Share of employees", size(large))  ///
	graphregion(${gregion}) plotregion(${gregion}) ///
	legend(off) ///
	name(highmgmte, replace)
	
graph bar (mean) share if formal==0, over(wage_q, label(labsize(large))) ///
	bar(1, fcolor(forest_green%50) lpattern(solid) lalign(center)) ///
	b1title("Unstructured Management", size(large)) ///
	yscale(range(0 .4)) ylabel(0(.1).4, labsize(large)) ytitle("Share of employees", size(large))  ///
	graphregion(${gregion}) plotregion(${gregion}) ///
	legend(on label(1 "Brazil") ring(0) pos(11) col(1) size(medium) region(lcolor(white))) ///
	name(lowmgmte, replace)
	 

graph combine lowmgmte highmgmte, ycommon b1title("Quintile of wage distribution" ) graphregion(${gregion}) plotregion(${gregion})
graph save "${figpath}/BBCVW_fig1_ext.gph", replace
graph export "${figpath}/BBCVW_fig1_ext.pdf", as(pdf) replace 



use "${inpath}/WMS_RAIS_linked_microdata.dta", replace

xtile wage_q = log_wage, nq(5)
xtile ability_q = akm_pe, nq(5)
gen count=1

bysort high_manag_p90: egen numobs = sum(count)

collapse (sum) count  , by(wage_q high_manag_p90)

drop if wage_q==.

bysort high_manag_p90: egen numobs = sum(count)

gen share = count / numobs



rename share shareBR
g shareGE = .


replace shareGE = .215 if high_manag_p90==0 & wage_q==1 // Q1, LM
replace shareGE = .134 if high_manag_p90==1 & wage_q==1 // Q2, HM
replace shareGE = .198 if high_manag_p90==0 & wage_q==2 // Q2, LM
replace shareGE = .202 if high_manag_p90==1 & wage_q==2 // Q2, HM
replace shareGE = .2   if high_manag_p90==0 & wage_q==3 // Q3, LM
replace shareGE = .19  if high_manag_p90==1 & wage_q==3 // Q3, HM
replace shareGE = .195 if high_manag_p90==0 & wage_q==4 // Q4, LM
replace shareGE = .21  if high_manag_p90==1 & wage_q==4 // Q4, HM
replace shareGE = .18  if high_manag_p90==0 & wage_q==5 // Q5, LM
replace shareGE = .255 if high_manag_p90==1 & wage_q==5 // Q5, HM

graph bar (mean) shareBR (mean) shareGE if high_manag_p90==1, over(wage_q, label(labsize(large))) ///
	bar(1, fcolor(forest_green%50) lpattern(solid) lalign(center)) ///
	bar(2, fcolor(%10) lcolor(black) lwidth(medium) lpattern(dash) lalign(center)) ///
	bargap(-100) ///
	b1title("High Management Score", size(large)) ///
	yscale(range(0 .4)) ylabel(0(.1).4, labsize(large)) ytitle("Share of employees", size(large))  ///
	graphregion(${gregion}) plotregion(${gregion}) ///
	legend(off) ///
	name(highmgmt, replace)

graph bar (mean) shareBR (mean) shareGE if high_manag_p90==0, over(wage_q, label(labsize(large))) ///
	bar(1, fcolor(forest_green%50) lpattern(solid) lalign(center)) ///
	bar(2, fcolor(%10) lcolor(black) lwidth(medium) lpattern(dash) lalign(center)) ///
	bargap(-100) ///
	b1title("Low Management Score", size(large)) ///
	yscale(range(0 .4)) ylabel(0(.1).4, labsize(large)) ytitle("Share of employees", size(large))  ///
	graphregion(${gregion}) plotregion(${gregion}) ///
	legend(on order(1 "Brazil" 2 "Germany (replication)") ring(0) pos(11) col(1) size(medium) region(lcolor(white))) ///
	name(lowmgmt, replace)

graph combine lowmgmt highmgmt , graphregion(${gregion}) plotregion(${gregion}) b1title("Quintile of wage distribution" )
graph save "${figpath}/BBCVW_fig1_rep.gph", replace
graph export "${figpath}/BBCVW_fig1_rep.pdf", as(pdf) replace 

}
*-----------------------------------------------------------------
* FIGURE 2, JOLE
*-----------------------------------------------------------------
{
use "${inpath}/WMS_RAIS_linked_microdata.dta", replace

xtile wage_q = log_wage, nq(5)
xtile ability_q = akm_pe, nq(5)

cap drop count
g count=1
collapse (sum) count  , by(ability_q formal)

drop if ability_q==.

bysort formal: egen numobs = sum(count)

gen share = count / numobs


*----- EXTENSION FIG 
graph bar (mean) share if formal==1, over(ability_q, label(labsize(large))) ///
	bar(1, fcolor(forest_green%50) lpattern(solid) lalign(center)) ///
	b1title("Structured Management", size(large)) ///
	yscale(range(0 .4)) ylabel(0(.1).4, labsize(large)) ytitle("Share of employees", size(large))  ///
	graphregion(${gregion}) plotregion(${gregion}) ///
	legend(off) ///
	name(highmgmt2e, replace)
	
graph bar (mean) share if formal==0, over(ability_q, label(labsize(large))) ///
	bar(1, fcolor(forest_green%50) lpattern(solid) lalign(center)) ///
	b1title("Unstructured Management", size(large)) ///
	yscale(range(0 .4)) ylabel(0(.1).4, labsize(large)) ytitle("Share of employees", size(large))  ///
	graphregion(${gregion}) plotregion(${gregion}) ///
	legend(on label(1 "Brazil") ring(0) pos(11) col(1) size(medium) region(lcolor(white))) ///
	name(lowmgmt2e, replace)

graph combine lowmgmt2e highmgmt2e, ycommon b1title("Quintile of ability distribution" ) graphregion(${gregion}) plotregion(${gregion})
graph save "${figpath}/BBCVW_fig2_ext.gph", replace
graph export "${figpath}/BBCVW_fig2_ext.pdf", as(pdf) replace 



use "${inpath}/WMS_RAIS_linked_microdata.dta", replace

xtile wage_q = log_wage, nq(5)
xtile ability_q = akm_pe, nq(5)

cap drop count
g count=1
collapse (sum) count  , by(ability_q high_manag_p90)

drop if ability_q==.

bysort high_manag_p90: egen numobs = sum(count)

gen share = count / numobs


rename share shareBR
g shareGE = .


replace shareGE = .198 if high_manag_p90==0 & ability_q==1 // Q1, LM
replace shareGE = .215 if high_manag_p90==1 & ability_q==1 // Q2, HM
replace shareGE = .21 if high_manag_p90==0 & ability_q==2 // Q2, LM
replace shareGE = .16 if high_manag_p90==1 & ability_q==2 // Q2, HM
replace shareGE = .21   if high_manag_p90==0 & ability_q==3 // Q3, LM
replace shareGE = .175  if high_manag_p90==1 & ability_q==3 // Q3, HM
replace shareGE = .19 if high_manag_p90==0 & ability_q==4 // Q4, LM
replace shareGE = .23  if high_manag_p90==1 & ability_q==4 // Q4, HM
replace shareGE = .193  if high_manag_p90==0 & ability_q==5 // Q5, LM
replace shareGE = .22 if high_manag_p90==1 & ability_q==5 // Q5, HM

graph bar (mean) shareBR (mean) shareGE if high_manag_p90==1, over(ability_q, label(labsize(large))) ///
	bar(1, fcolor(forest_green%50) lpattern(solid) lalign(center)) ///
	bar(2, fcolor(%10) lcolor(black) lwidth(medium) lpattern(dash) lalign(center)) ///
	bargap(-100) ///
	b1title("High Management Score", size(large)) ///
	yscale(range(0 .4)) ylabel(0(.1).4, labsize(large)) ytitle("Share of employees", size(large))  ///
	graphregion(${gregion}) plotregion(${gregion}) ///
	legend(off) ///
	name(highmgmt, replace)

graph bar (mean) shareBR (mean) shareGE if high_manag_p90==0, over(ability_q, label(labsize(large))) ///
	bar(1, fcolor(forest_green%50) lpattern(solid) lalign(center)) ///
	bar(2, fcolor(%10) lcolor(black) lwidth(medium) lpattern(dash) lalign(center)) ///
	bargap(-100) ///
	b1title("Low Management Score", size(large)) ///
	yscale(range(0 .4)) ylabel(0(.1).4, labsize(large)) ytitle("Share of employees", size(large))  ///
	graphregion(${gregion}) plotregion(${gregion}) ///
	legend(on order(1 "Brazil" 2 "Germany (replication)") ring(0) pos(11) col(1) size(medium) region(lcolor(white))) ///
	name(lowmgmt, replace)

graph combine lowmgmt highmgmt , graphregion(${gregion}) plotregion(${gregion}) b1title("Quintile of ability distribution" )
graph save "${figpath}/BBCVW_fig2_rep.gph", replace
graph export "${figpath}/BBCVW_fig2_rep.pdf", as(pdf) replace 


}

cap log close