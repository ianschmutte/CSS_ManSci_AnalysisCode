global filestub "CSS_analysis_stayers"
capture log close
do "config.do"

pause on
set more off
set linesize 120                                                                                                       

/* %*************************************************************************** */
*-----------------------------------------------------------------
* STAYERS OVER TIME, BY THETA-HAT AND MANAGEMENT (All)
*-----------------------------------------------------------------
{
use "${inpath}/WMS_RAIS_flow_microdata.dta", clear

local num_pe_quantiles = 5

	keep if hire==0 & sep==0
	forvalues yr = 2008/2013{
		xtile pe_`yr' = akm_pe if year==`yr', nq(`num_pe_quantiles')
		gen pe_high`yr' = pe_`yr'==`num_pe_quantiles'
		replace pe_high`yr' = . if year~=`yr'
		gen pe_low`yr' = pe_`yr'==1
		replace pe_low`yr' = . if year~=`yr'
		gen pe_mid`yr' = (pe_`yr'~=1 & pe_`yr'~=`num_pe_quantiles')
		replace pe_mid`yr' = . if year~=`yr'
	}

collapse (mean) pe_high* pe_low* pe_mid*, by(formal)
reshape long pe_high pe_low pe_mid, i(formal) j(year)

genstack pe_low pe_mid pe_high, generate(c_) double 

lab define formal 0 "Unstructured management" 1 "Structured management" 
la val formal formal


graph twoway 	(area c_pe_high year, color(navy*.7)) ///
		(area c_pe_mid year, color(navy*.1)) ///
		(area c_pe_low year, color(navy*.4)), by(formal) ///
	plotregion(margin(medium) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ///
	yscale(noline) ylabel(, labsize(medium) tlcolor(white) nogrid)  ///
	xlabel(2008(1)2013, labsize(medsmall) tlcolor(white) nogrid) ///
	ytitle("Employment stock share (annual)") ///
	subtitle(, box bexpand size(medium) fcolor(white) lcolor(black)) ///
	text(.1 2011 "{bf:low quality}") ///
	text(.92 2011 "{bf:high quality}") ///
	by(formal, col(3) legend(off) ///
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ///
	note("") ///
	) /// * end of the "by" command
	name(e3pA, replace)
	
	* local figpath ./output/figures
    graph save ${figpath}/fig_stayer_shares_all.gph, replace
	graph export ${figpath}/fig_stayer_shares_all.pdf , as(pdf) replace
}
*-----------------------------------------------------------------
* STAYERS OVER TIME, BY THETA-HAT AND MANAGEMENT (Production)
*-----------------------------------------------------------------
{
use "${inpath}/WMS_RAIS_flow_microdata.dta", clear

local num_pe_quantiles = 5
local mgmt_group_type formal

keep if hire==0 & sep==0 & occ_labr == 1
forvalues yr = 2008/2013{
	xtile pe_`yr' = akm_pe if year==`yr', nq(`num_pe_quantiles')
	gen pe_high`yr' = pe_`yr'==`num_pe_quantiles'
	replace pe_high`yr' = . if year~=`yr'
	gen pe_low`yr' = pe_`yr'==1
	replace pe_low`yr' = . if year~=`yr'
	gen pe_mid`yr' = (pe_`yr'~=1 & pe_`yr'~=`num_pe_quantiles')
	replace pe_mid`yr' = . if year~=`yr'
}

collapse (mean) pe_high* pe_low* pe_mid*, by(`mgmt_group_type')
reshape long pe_high pe_low pe_mid, i(`mgmt_group_type') j(year)

genstack pe_low pe_mid pe_high, generate(c_) double 

lab define formal 0 "Unstructured management" 1 "Structured management" 
la val formal formal


local mgmt_group_type formal
graph twoway 	(area c_pe_high year, color(navy*.7)) ///
		(area c_pe_mid year, color(navy*.1)) ///
		(area c_pe_low year, color(navy*.4)), ///
	plotregion(margin(medium) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ///
	yscale(noline) ylabel(0(.5)1, labsize(medium) tlcolor(white) nogrid)  ///
	xlabel(2008(1)2013, labsize(medsmall) tlcolor(white) nogrid) ///
	ytitle("Employment stock share (annual)") ///
	subtitle(, box bexpand size(medium) fcolor(white) lcolor(black)) ///
	text(.1 2011 "{bf:low quality}") ///
	text(.92 2011 "{bf:high quality}") ///
	by(`mgmt_group_type', col(3) legend(off) ///
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ///
	note("") ///
	) /// * end of the "by" command
	name(e3pA, replace)
	
    graph save ${figpath}/fig_stayer_shares_labr.gph, replace
	graph export ${figpath}/fig_stayer_shares_labr.pdf , as(pdf) replace

}
*-----------------------------------------------------------------
* STAYERS OVER TIME, BY THETA-HAT AND MANAGEMENT (Manager)
*-----------------------------------------------------------------
{
use "${inpath}/WMS_RAIS_flow_microdata.dta", clear

local num_pe_quantiles = 5
local mgmt_group_type formal

foreach var in management {
	keep if hire==0 & sep==0 & occ_mngr == 1
	forvalues yr = 2008/2013{
		xtile pe_`yr' = akm_pe if year==`yr', nq(`num_pe_quantiles')
		gen pe_high`yr' = pe_`yr'==`num_pe_quantiles'
		replace pe_high`yr' = . if year~=`yr'
		gen pe_low`yr' = pe_`yr'==1
		replace pe_low`yr' = . if year~=`yr'
		gen pe_mid`yr' = (pe_`yr'~=1 & pe_`yr'~=`num_pe_quantiles')
		replace pe_mid`yr' = . if year~=`yr'
	}
}
collapse (mean) pe_high* pe_low* pe_mid*, by(`mgmt_group_type')
reshape long pe_high pe_low pe_mid, i(`mgmt_group_type') j(year)

genstack pe_low pe_mid pe_high, generate(c_) double 

lab define formal 0 "Unstructured management" 1 "Structured management" 
la val formal formal


local mgmt_group_type formal
graph twoway 	(area c_pe_high year, color(navy*.7)) ///
		(area c_pe_mid year, color(navy*.1)) ///
		(area c_pe_low year, color(navy*.4)), ///
	plotregion(margin(medium) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ///
	yscale(noline) ylabel(, labsize(medium) tlcolor(white) nogrid)  ///
	xlabel(2008(1)2013, labsize(medsmall) tlcolor(white) nogrid) ///
	ytitle("Employment stock share (annual)") ///
	subtitle(, box bexpand size(medium) fcolor(white) lcolor(black)) ///
	text(.1 2011 "{bf:low quality}") ///
	text(.92 2011 "{bf:high quality}") ///
	by(`mgmt_group_type', col(3) legend(off) ///
	graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ///
	note("") ///
	) /// * end of the "by" command
	name(e3pA, replace)
	
	
    graph save ${figpath}/fig_stayer_shares_mngr.gph, replace
	graph export ${figpath}/fig_stayer_shares_mngr.pdf , as(pdf) replace

}