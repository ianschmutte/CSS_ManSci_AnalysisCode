global filestub "CSS_individualqs_graph"
capture log close
do "config.do"

pause on
set more off
set linesize 120                                                                                                       

/* %*************************************************************************** */
use "${inpath}/wmslong_forAnalysis.dta", clear

keep if cnpj!=""

su management, d

gen sd=`r(sd)'
gen mmean=`r(mean)'
gen sd0 = mmean - (sd/2)
gen sd1 = mmean + (sd/2)

cap drop m0
gen m0 = 1 if management>= (sd0-0.05) & management<= (sd0+0.05)


cap drop m1
gen m1 = 1 if management>= (sd1-0.05) & management<= (sd1+0.05)


gen sdmarker = "l" if m0==1
replace sdmarker = "h" if m1==1

drop if sdmarker==""

cap drop N
gen N=_N

collapse N lean1 lean2 perf1 perf2 perf3 perf4 perf5 perf6 perf7 perf8 perf9 perf10 talent1 talent2 talent3 talent4 talent5 talent6 management, by(sdmarker)

local lstyle "color(black%0) lcolor(black)"

forvalues x=1(1)18{
  cap drop bl`x'
  gen bl`x'=`x'
}

local opbar 	fcolor(lavender*.6%80)  barwidth(.8) lcolor(lavender)  
local pbar 	fcolor(maroon%80) 	barwidth(.8) lcolor(maroon%100) 
local opline 	fcolor(none) 		barwidth(.8) lcolor(lavender) 	lwidth(thick) 
local pline 	fcolor(none) 		barwidth(.8) lcolor(maroon) 	lwidth(medthick) 
twoway  	(bar lean1   bl1 if sdmarker=="l", `opbar') ///
		(bar lean2   bl2 if sdmarker=="l", `opbar') ///
		(bar perf1   bl3 if sdmarker=="l", `opbar') ///
		(bar perf2   bl4 if sdmarker=="l", `opbar') ///
		(bar perf3   bl5 if sdmarker=="l", `opbar') ///
		(bar perf4   bl6 if sdmarker=="l", `opbar') ///
		(bar perf5   bl7 if sdmarker=="l", `opbar') ///
		(bar perf6   bl8 if sdmarker=="l", `opbar') ///
		(bar perf7   bl9 if sdmarker=="l", `opbar') ///
		(bar perf8   bl10 if sdmarker=="l", `opbar') ///
		(bar perf9   bl11 if sdmarker=="l", `opbar') ///
		(bar perf10  bl12 if sdmarker=="l", `opbar') ///
		(bar talent1 bl13 if sdmarker=="l", `pbar') ///
		(bar talent2 bl14 if sdmarker=="l", `pbar') ///
		(bar talent3 bl15 if sdmarker=="l", `pbar') ///
		(bar talent4 bl16 if sdmarker=="l", `pbar') ///
		(bar talent5 bl17 if sdmarker=="l", `pbar') ///
		(bar talent6 bl18 if sdmarker=="l", `pbar') ///
		(bar lean1   bl1  if sdmarker=="h", `opline') ///
		(bar lean2   bl2  if sdmarker=="h", `opline') ///
		(bar perf1   bl3  if sdmarker=="h", `opline') ///
		(bar perf2   bl4  if sdmarker=="h", `opline') ///
		(bar perf3   bl5  if sdmarker=="h", `opline') ///
		(bar perf4   bl6  if sdmarker=="h", `opline') ///
		(bar perf5   bl7  if sdmarker=="h", `opline') ///
		(bar perf6   bl8  if sdmarker=="h", `opline') ///
		(bar perf7   bl9  if sdmarker=="h", `opline') ///
		(bar perf8   bl10 if sdmarker=="h", `opline') ///
		(bar perf9   bl11 if sdmarker=="h", `opline') ///
		(bar perf10  bl12 if sdmarker=="h", `opline') ///
		(bar talent1 bl13 if sdmarker=="h", `pline') ///
		(bar talent2 bl14 if sdmarker=="h", `pline') ///
		(bar talent3 bl15 if sdmarker=="h", `pline') ///
		(bar talent4 bl16 if sdmarker=="h", `pline') ///
		(bar talent5 bl17 if sdmarker=="h", `pline') ///
		(bar talent6 bl18 if sdmarker=="h", `pline') ///
		, ///
		yline(2.683506) xlab(1 "O1" 2 "O2" 3 "O3" 4 "O4" 5 "O5" 6 "O6" 7 "O7" 8 "O8" 9 "O9" 10 "O10" 11 "O11" 12 "O12" 13 "P1" 14 "P2" 15 "P3" 16 "P4" 17 "P5" 18 "P6", noticks angle(vertical)) ///
		yscale(range(1 5)) ///
		ylabel(1 1.5 2 2.5 3 3.5 4 4.5 5, noticks grid glcolor(gs3) glpattern(dot) gmax labsize(medsmall))  ///
		legend(nobox region(fcolor(white) lcolor(white) lwidth(thin) lpattern(solid)) ///
		order(1 "Operations Q: {&mu} - 1/2{&sigma}" 13 "People Q: {&mu} - 1/2{&sigma}" 21 "Operations Q: {&mu} + 1/2{&sigma}"   36 "People Q: {&mu} + 1/2{&sigma}") col(2) pos(6) ring(1) symxsize(10) size(medlarge)) ///
		xtitle("Management questions", size(medlarge)) ytitle("Average management score", size(medlarge)) ///
		graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) 


graph save ${figpath}/fig_WMS_Qs.gph , replace
graph export ${figpath}/fig_WMS_Qs.pdf , as(pdf) replace


log close