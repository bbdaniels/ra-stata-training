* Check villages for balanced panel

use "${dtFin}/analysis_households.dta"

* Household-level indicators

	levelsof year , local(theYears)

	foreach year in `theYears' {
		gen year_`theYear' = (year == `theYear')
		// Creates binary indicator for each year
	}

* Village indicators on hh-level data

	foreach var of varlist year_* {
		bys id_village : ///
			egen vil_`var'_any = max(`var')
			// All households in village get a "1" if any vill in that year
	}

* Create overall indicator and clean up

	egen panel_tokeep = rowmean(vil_*_any)
		// Households get 1 if at least one hh in vil from every year

	drop vil_*_any year_*

* Have a lovely day!
