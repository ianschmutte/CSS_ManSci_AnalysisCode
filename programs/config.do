/* 
config.do

Acknowledgement:
  Adapted from Lars Vilhuber's version
  Creates a reproducible Stata sequence by calling this program from every other program in your sequence
  Get it at: https://gist.github.com/larsvilhuber/6bcf4ff820285a1f1b9cfff2c81ca02b 
*/

do "./paths.do"

/* Create a log file */
local c_date = c(current_date)
local cdate = subinstr("`c_date'", " ", "_", .)
log using "${filestub}_`cdate'.log", replace text  // filestub must be defined in the calling program

/* install any packages locally */
sysdir set PERSONAL "$adobase/ado/personal"
sysdir set PLUS     "$adobase/ado/plus"
sysdir set SITE     "$adobase/ado/site"

/* See https://www.stata.com/manuals13/pcreturn.pdf#pcreturn */
local variant = cond(c(MP),"MP",cond(c(SE),"SE",c(flavor)) )  

di "=== SYSTEM DIAGNOSTICS ==="
di "Stata version: `c(stata_version)'"
di "Updated as of: `c(born_date)'"
di "Variant:       `variant'"
di "Processors:    `c(processors)'"
di "OS:            `c(os)' `c(osdtl)'"
di "Machine type:  `c(machine_type)'"
di "=========================="
