/* runall.do */

/* STEP 1: CONFIGURE PATHS */
    do "./paths.do"                                            // defines macro vars with path names
    capture mkdir "$adobase"                                   // make directory to hold ado files
    capture mkdir "${trunk}/output"                            // make directory to receive outputs
    capture mkdir "${trunk}/output/figures"                    // make directory to receive figures
	capture mkdir "${trunk}/output/figures/appendix"           // make directory to receive figures
    capture mkdir "${trunk}/output/tables"                     // make directory to receive tables
	capture mkdir "${trunk}/output/tables/appendix"            // make directory to receive figures
    capture mkdir "${trunk}/data/interwrk"                     // make temporary / working directory

/* STEP 2: INSTALL SSC PACKAGES */
    local ssc_packages "binscatter estout coefplot genstack egenmore ivreg2 ranktest"

    if !missing("`ssc_packages'") {
        foreach pkg in `ssc_packages' {
        * install using ssc, but avoid re-installing if already present
            capture which `pkg'
            if _rc == 111 {                 
               dis "Installing `pkg'"
               quietly ssc install `pkg', replace
               }
        }
    }

/* STEP 3: RUN ANALYSIS CODE */
	local filenames "BBCVW_replication_ability_dist BBCVW_replication_flows BBCVW_replication_plant_panel CSS_ability_dist CSS_analysis_firing_regression  CSS_analysis_firing CSS_analysis_hiring_regressions CSS_analysis_hiring CSS_analysis_plant_panel CSS_analysis_stayers CSS_emp_shares CSS_individualqs_graph CSS_predict_retained_worker_quality appendix_manager_definitions appendix_plant_panel"
	
	
    foreach file in `filenames' {
        do "./`file'.do"
    }
