* Make PDF

	global directory "/Users/bbdaniels/desktop"

	import excel using "${directory}/Q1_universe_durban.xlsx" , clear first sheet(Sheet1) // <-- why is sheet1 not the first sheet???

	cap putpdf clear
	qui count
	forvalues i = 2/`r(N)' {

		local theID = clinic_id[`i']
		putpdf begin

		foreach var of varlist prov_name clinic_name {

			local title = `var'[1]
			local value = `var'[`i']

			putpdf paragraph
			putpdf text ("`title': ") , bold
			putpdf text ("`value'")
			putpdf paragraph
		}

		putpdf save "${directory}/reports/report`theID'.pdf", replace

	}

* Have a lovely day!
