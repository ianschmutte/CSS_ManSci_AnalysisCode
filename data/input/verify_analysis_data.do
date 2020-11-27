/*
verify_analysis_data.do

Verifies input data against a previously generated signature.

INSTRUCTIONS:
  This file should have been provided along with `CSS_ManSci_AnalysisCode.zip`, the analysis code archive associated with Cornwell, Schmutte, and Scur "Building a productive workforce: the role of structured management practices".

  - NOTE: These instructions use the term $TRUNK to refer to the path on your local filesystem that corresponds to the trunk of the analysis code archive .
  - This file should be located under `$TRUNK/data/inputs` along with a set of data signature files.
  - If you have received the confidential input data described in `$TRUNK/README.md`, unzip them into `$TRUNK/data/inputs` 
  -If necessary, edit the `vdate' macro variable to correspond to the suffix date in the filenames for the data signature files. 
  -Run this code to verify that the data signatures on the input data you received match the data signatures provided with the analysis code archive.
*/

/* date on which input files were verified (EDIT IF NEEDED)*/
local vdate "25_Nov_2020"

pause on
set more off
set linesize 120

/* Create a log file */
capture log close
local c_date = c(current_date)
local cdate = subinstr("`c_date'", " ", "_", .)
log using "./verify_analysis_data_`cdate'.log", replace text
di "`vdate'"

local datasets "WMS_RAIS_flow_plantdata WMS_plantyear_with_RAIS WMS_RAIS_linked_microdata WMS_RAIS_flow_microdata wmslong_forAnalysis"

foreach set in `datasets' {
  use "./`set'.dta", clear
  datasignature confirm using "${inpath}/datasig_`set'_`vdate'.txt"
  }
  
log close
