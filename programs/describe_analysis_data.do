/*
describe_analysis_data.do

Describes all input data sources for Cornwell, Schmutte, and Scur "Building a productive workforce: the role of structured management practices"

*/

pause on
set more off
set linesize 120

local datasets "WMS_RAIS_flow_plantdata WMS_plantyear_with_RAIS WMS_RAIS_linked_microdata WMS_RAIS_flow_microdata wmslong_forAnalysis"

foreach set in `datasets' {
  capture log close
  local c_date = c(current_date)
  local cdate = subinstr("`c_date'", " ", "_", .)
  do "./paths.do"
  log using "${inpath}/describe_`set'_`cdate'.log", replace text
  use "${inpath}/`set'.dta", clear
  datasignature set, saving(${inpath}/datasig_`set'_`cdate'.txt) 
  describe
  log close
  }
  
