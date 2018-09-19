* Programming

* Define no-argument program

	cap program drop cleandata
	program define cleandata

		foreach var of varlist * {
		// Clean all variable labels and drop unlabeled variables
			local theLabel : var label `var'
			local theNewLabel = trim(itrim(proper("`theLabel'")))
			label var `var' "`theNewLabel'"

			if "`theNewLabel'" == "" drop `var'
		}

		compress // Minimize storage space

	end

* Use the program

	sysuse auto.dta , clear

	cleandata

	* saveold ... , version(12)

* Have a lovely day!
