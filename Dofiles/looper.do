* Some loops

sysuse auto.dta, clear

* Foreach – varlist

	foreach var of varlist * {
	// "of" tells [foreach] to parse
		qui su `var'
		di "`var' mean: `r(mean)'"
	}

* Foreach - local

	local testList `" "Local Items" "Remote Items" "Other Items" "'

	foreach type in `testList' {
	// "in" tells [foreach] to reach everything
		di `" Preparing to Count `type' "'
	}

* Forvalues - numlist

	forvalues year = 2011/2015 {
	// uses normal [numlist] format options
		gen age_`year' = `year' - age_birthyear
			label var age_`year' "Age in `year'"
	}

* Have a lovely day!
