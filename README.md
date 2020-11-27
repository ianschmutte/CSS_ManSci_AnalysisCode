# Analysis Code Archive for: Building a productive workforce: the role of structured management practices

This archive contains code used to replicate the analysis that appears in Cornwell, Schmutte, and Scur "Building a productive workforce: the role of structured management practices" as accepted for publication in Management Science in November 2020.

This is one of three archives associated with this manuscript:

1. Analysis Code Archive: `CSS_ManSci_AnalysisCode.zip` (**this archive**)
2. Analysis Data Archive: `CSS_ManSci_AnalysisData.zip`
3. Data Preparation Code Archive: `CSS_ManSci_PreparationCode.zip`

The Analysis Data Archive contains the analysis data used as inputs for the code in this archive. Those analysis data files are derived from restricted-access sources described below, and therefore cannot be made publicly available. Access procedures are described below.

The Data Preparation Code Archive includes code that transforms the raw confidential input files into the analysis data. That archive should be included with this replication package.

Please direct all questions to `schmutte@uga.edu`

## Data Availability Statement

This archive uses analysis data that are derived from several primary input data sources, most of which include confidential information and to which access is restricted. An accompanying archive describes the process of data preparation.

The primary input data sources are

* Brazil's RAIS (Relação Anual de Informações Sociais)
* The identified World Management Survey (WMS) for Brazil.

The RAIS data are available to approved researchers by application to the Brazilian Labor Ministry via `observatoriotrabalho@mte.gov.br`. To obtain access to the identified WMS, interested researchers should submit an application through [their portal](https://worldmanagementsurvey.org/request-special-data-access/).

The authors will make all reasonable efforts to facilitate access to the raw data for purposes of replication for up to two years. During that period, we will also maintain the intermediate analysis files that are the main inputs to the analysis code contained in this archive. We will also work with researchers to facilitate access use the analysis data files for purposes of verifying replicability of the published results.

Code for cleaning and preparing the analysis files from raw input data are included as part of this replication package, but in a separate standalone archive.

## Dataset list

This archive contains code used for the analysis that appears in the manuscript and online appendices. The analysis code uses the following prepared data as inputs

* "${inpath}/WMS_plantyear_with_RAIS.dta"
* "${inpath}/WMS_RAIS_linked_microdata.dta"
* "${inpath}/WMS_RAIS_flow_plantdata.dta"
* "${inpath}/WMS_RAIS_flow_microdata.dta"
* "${inpath}/wmslong_forAnalysis.dta"

| Data file | Source | Notes    |Provided |
|-----------|--------|----------|---------|
| `WMS_plantyear_with_RAIS.dta` | RAIS and WMS | Confidential | No |
| `WMS_RAIS_linked_microdata.dta` | RAIS and WMS | Confidential | No |
| `WMS_RAIS_flow_plantdata.dta` | RAIS and WMS | Confidential | No |
| `WMS_RAIS_flow_microdata.dta` | RAIS and WMS | Confidential | No |
| `wmslong_forAnalysis.dta` |  WMS | Confidential | No |

### Data descriptions

This archive should include two sets of log files that describe each of the input data sets. For each dataset, `$SET`, the folder `$TRUNK/data/input` should contain

* `describe_$SET_$date.txt`: a log file with output from running `describe $SET` on `$date`
* `datasig_$SET_$date.txt`: a data signature for `$SET` generated on `$date`

### For replicators: validating input data

Follow these instructions to validate the confidential input data for purposes of replicating or reproducing results from the manuscript.

## Computational requirements

### Software Requirements

* Stata (code was last run with version 16)
  * `estout` (as of 2018-05-12)
  * `binscatter` (as of 2019-01-05)
  * `coefplot`
  * `genstack`
  * `egenmore`
  * `ivreg2`
  * `ranktest`
  * the program `$TRUNK/programs/runall.do` installs all dependencies, generates necessary folders, and executes all code.

### Description of programs

All programs are together in subfolder `$TRUNK/programs` where `$TRUNK` is the location where you have unpacked this archive.

* `$TRUNK/programs/runall.do` will set up the computing environment, install relevant dependencies, and create folders to receive temporary files and output.
* `$TRUNK/programs/paths.do` includes all relevant paths. It may be necessary to change line 2 to refer to the location `$TRUNK` on your local system. However, if your current working directory is `$TRUNK/programs`, everything should run without modification by executing `do runall.do`
* `$TRUNK/programs/config.do`: a configuration file that defines paths, starts log files for each analysis program and writes run-specific details to that log.
* Remaining programs in `$TRUNK/programs/` perform analysis and generate the outputs reported in the manuscript and appendices.

### Memory and Runtime Requirements

The code was last run on a **8-core Intel-based PC with 64 GB of RAM running Windows 10 Education version 1809 OC Build 17763,1577**. Compute time for the analysis files was negligible.

## Instructions

* Edit line 2 in `$TRUNK/programs/paths.do` to define the project trunk location. In general, it should be the location of this README.
* If available, extract the analysis data files from `CSS_ManSci_AnalysisData.zip` to `$TRUNK/data/input`. Note these files are confidential. See access details above.
* (Optional) Execute `$TRUNK/data/input/verify_analysis_data.do` to verify the analysis data files.
* Execute `runall.do` from within `TRUNK/programs/`
  
### Details

* The sequence in which the analysis programs are run is not important
* The full sequence was last run from start to finish on 24 November, 2020

## List of exhibits and programs

The following table lists which part of the code generates each of the exhibits that appear in the main text.

### Main text exhibits

Exhibit #|Program|Output File|
|--------|-------|-----------|
Table 1  |`BBCVW_replication_plant_panel.do`|`BBCVW_sumstats.tex`|
Figure 1 |`BBCVW_replication_plant_panel.do`|`BBCVW_fig_4.pdf`|
Table 2  |`BBCVW_replication_plant_panel.do`|`BBCVW_tab2_rep_and_ext.tex`|
Figure 2 |`BBCVW_replication_plant_panel.do`|`BBCVW_fig_7.pdf`|
Table 3  |`BBCVW_replication_plant_panel.do`|`BBCVW_tab8_rep_sd.tex`|
Table 4  |`BBCVW_replication_flows.do`|`BBCVW_tab6_rep_abbrv.tex`|
Figure 3a|`CSS_hiring_regressions.do`|`CSS_hirereg_fig_mngr.pdf`|
Figure 3b|`CSS_hiring_regressions.do`|`CSS_hirereg_fig_labr.pdf`|
Table 5  |`CSS_predict_retained_worker_quality.do`|`CSS_pred_zpe_both_1.tex`|
Table 6  |`BBCVW_replication_flows.do`|`BBCVW_tab7_rep.tex`|
Figure 4 |`CSS_analysis_firing.do`|`fig_firing_binscatter.pdf`|

### Appendix exhibits

Almost all of the appendix exhibits are generated from code included with this archive. The included file [`$TRUNK/exhibits_list.xlsx`](./exhibits_list.xlsx) associates each exhibit with the program that generates it and the relevant output file.

Exhibit Tables D.7-D.11 are produced in the process of creating the analysis files and the code that generates them is included with the Data Preparation Code Archive.

The code used to generate the exhibits in Appendix B is available upon request
