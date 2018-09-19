* Programming

* Define program with syntax

	cap program drop cleandata
	program define cleandata

		syntax anything 	/// <- accepts variable list to clean
			[if] [in] 		/// <- subsets data as part of process


		marksample touse 	// <- after [syntax], parses [if/in]
			keep if `touse'	// <- subsets data based on [marksample]

		foreach var of varlist `anything' { // <- `anything' is set by [syntax]
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

	cleandata price mpg

	* saveold ... , version(12)

* Have a lovely day!
