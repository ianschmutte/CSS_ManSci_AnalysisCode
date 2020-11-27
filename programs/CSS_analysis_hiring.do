global filestub "CSS_analysis_hiring"
capture log close
do "config.do"

pause on
set more off
set linesize 120                                                                                                       

/* %*************************************************************************** */

*-----------------------------------------------------------------
* LORENZ CURVE (All)
*-----------------------------------------------------------------
{
use "${inpath}/WMS_RAIS_flow_microdata.dta", clear


local num_pe_quantiles = 100
local mgmt_group_type formal
foreach var in management {
	keep if hire==1 & sep==0
	cap drop formal
	gen formal = (`var' >= 3)
	xtile pe_q = akm_pe, nq(`num_pe_quantiles')
	}
pctile pct_formal = pe_q if formal==1, nq(100) genp(percent_formal)
pctile pct_informal = pe_q if formal==0, nq(100) genp(percent_informal) 
/*This ingenious hack is necessary to add (0,0) and (100,100) to the plotted data.
All credit (blame?) to Daniela.*/
/* drop if pct==. 
qui ta pct
set obs `=r(N)+2'
gen N = `r(N)'
replace pct=0 in `=r(N)+1'
replace percent=0 in `=r(N)+1'
replace pct=100 in `=r(N)+2'
replace percent=100 in `=r(N)+2'
sort percent */

twoway (line percent_formal pct_formal, lcolor(navy) lwidth(thick) lpattern(solid)) ///
       (line percent_informal pct_informal, lcolor(green) lwidth(thick) lpattern(longdash)) ///
       (line pct_formal pct_formal, lcolor(black)  lpattern(shortdash)), ///
	plotregion(margin(zero) fcolor(white) lcolor(black) ifcolor(white) ilcolor(black)) ///
	ylabel(, labsize(medium) tlcolor(white) nogrid)  ///
	xlabel(0(20)100, labsize(medsmall) tlcolor(white) nogrid) ///
	ytitle("Percentile rank of hired person ") ///
	xtitle("Percentile in hired person quality distribution") ///
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ///
	legend(off) xsize(4) ysize(4) ///
	text(80 40 "{bf:unstructured management }", color(green)) ///
	text(20 60 "{bf:structured management }", color(navy)) ///
	name(lorenz_all, replace)

graph save ${figpath}/fig_hiring_lorenz_all.gph , replace
graph export ${figpath}/fig_hiring_lorenz_all.pdf , as(pdf) replace

/*display data used in figures*/
list pct_formal percent_formal pct_informal percent_informal if pct_formal ~=.

}


*-----------------------------------------------------------------
* LORENZ CURVE (Production Workers)
*-----------------------------------------------------------------
{
use "${inpath}/WMS_RAIS_flow_microdata.dta", clear
keep if occ_labr == 1

local num_pe_quantiles = 100
local mgmt_group_type formal
foreach var in management{
	keep if hire==1 & sep==0
    cap drop formal
	gen formal = (`var' >= 3)
	xtile pe_q = akm_pe, nq(`num_pe_quantiles')
	}
pctile pct_formal = pe_q if formal==1, nq(100) genp(percent_formal)
pctile pct_informal = pe_q if formal==0, nq(100) genp(percent_informal) 

/*This ingenious hack is necessary to add (0,0) and (100,100) to the plotted data.
All credit to Daniela.*/
// drop if pct==. | percent==.
// qui ta pct
// set obs `=r(N)+2'
// gen N = `r(N)'
// replace pct=0 in `=r(N)+1'
// replace percent=0 in `=r(N)+1'
// replace pct=100 in `=r(N)+2'
// replace percent=100 in `=r(N)+2'
// sort percent

* line y x
* y: pct rank within firm type (percent_formal/informal)
* x: pct rank across full distribution (pct_formal/informal)
list percent_formal pct_formal percent_informal  pct_informal  if pct_formal ~=. & percent_formal==50 

twoway (line percent_formal pct_formal, lcolor(navy) lwidth(thick) lpattern(solid)) ///
       (line percent_informal pct_informal, lcolor(green) lwidth(thick) lpattern(longdash)) ///
       (line pct_formal pct_formal, lcolor(black)  lpattern(shortdash)) ///
	(pci 50 0 50 48, lwidth(.8) lcolor(green)) ///
	(pci 0  48 50 48, lwidth(.8) lcolor(green)) ///
	(pci 50 48 50 56, lwidth(.8) lcolor(navy)) ///
	(pci 0 56 50 56, lwidth(.8) lcolor(navy)) ///
	, ///
	plotregion(margin(zero) fcolor(white) lcolor(black) ifcolor(white) ilcolor(black)) ///
	ylabel(0(25)100, labsize(medium) tlcolor(white) nogrid)  ///
	xlabel(0(25)100, labsize(medsmall) tlcolor(white) nogrid) ///
	ytitle("Percentile rank of hired production worker"  "within firm type") ///
	xtitle("Percentile rank of hired production worker"  "in full distribution") ///
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ///
	legend(off) xsize(4) ysize(4) ///
	text(85 60 "{bf:unstructured}", color(green)) ///
	text(80 60 "{bf:management}", color(green)) ///
	text(60 85 "{bf:structured}", color(navy)) ///
	text(55 85 "{bf:management}", color(navy)) ///
name(lorenz_prod, replace)

graph save ${figpath}/fig_hiring_lorenz_labr.gph , replace
graph export ${figpath}/fig_hiring_lorenz_labr.pdf , as(pdf) replace
/*display data used in figures*/
}
*-----------------------------------------------------------------
* LORENZ CURVE (Managers)
*-----------------------------------------------------------------
{
// use "${inpath}/WMS_RAIS_linked_microdata.dta", clear
use "${inpath}/WMS_RAIS_flow_microdata.dta", clear
keep if occ_mngr == 1

local num_pe_quantiles = 100
local mgmt_group_type formal
foreach var in management {
	keep if hire==1 & sep==0
    cap drop formal
	gen formal = (`var' >= 3)
	xtile pe_q = akm_pe, nq(`num_pe_quantiles')
	}
pctile pct_formal = pe_q if formal==1, nq(100) genp(percent_formal)
pctile pct_informal = pe_q if formal==0, nq(100) genp(percent_informal) 

* line y x
* y: pct rank within firm type (percent_formal/informal)
* x: pct rank across full distribution (pct_formal/informal)
list percent_formal pct_formal percent_informal  pct_informal  if pct_formal ~=. & percent_formal==50 

/*This ingenious hack is necessary to add (0,0) and (100,100) to the plotted data.
All credit to Daniela.*/
// drop if pct==. | percent==.
// qui ta pct
// set obs `=r(N)+2'
// gen N = `r(N)'
// replace pct=0 in `=r(N)+1'
// replace percent=0 in `=r(N)+1'
// replace pct=100 in `=r(N)+2'
// replace percent=100 in `=r(N)+2'
// sort percent

twoway (line percent_formal pct_formal, lcolor(navy) lwidth(thick) lpattern(solid)) ///
       (line percent_informal pct_informal, lcolor(green) lwidth(thick) lpattern(longdash)) ///
       (line pct_formal pct_formal, lcolor(black)  lpattern(shortdash)) ///
	(pci 50 0 50 42, lwidth(.8) lcolor(green)) ///
	(pci 0  42 50 42, lwidth(.8) lcolor(green)) ///
	(pci 50 42 50 59, lwidth(.8) lcolor(navy)) ///
	(pci 0 59 50 59, lwidth(.8) lcolor(navy)) ///
	, ///
	plotregion(margin(zero) fcolor(white) lcolor(black) ifcolor(white) ilcolor(black)) ///
	ylabel(0(25)100, labsize(medium) tlcolor(white) nogrid)  ///
	xlabel(0(25)100, labsize(medsmall) tlcolor(white) nogrid) ///
	ytitle("Percentile rank of hired manager"  "within firm type") ///
	xtitle("Percentile rank of hired manager"  "in full distribution") ///
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ///
	legend(off) xsize(4) ysize(4) ///
	text(85 55 "{bf:unstructured}", color(green)) ///
	text(80 55 "{bf:management}", color(green)) ///
	text(60 85 "{bf:structured}", color(navy)) ///
	text(55 85 "{bf:management}", color(navy)) ///
	name(lorenz_mngr, replace)


graph save ${figpath}/fig_hiring_lorenz_mngr.gph , replace
graph export ${figpath}/fig_hiring_lorenz_mngr.pdf , as(pdf) replace
/*display data used in figures*/
 }


capture log close
