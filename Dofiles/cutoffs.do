sysuse census.dta, clear

	global graph_opts ///
		title(, justification(left) color(black) span pos(11)) ///
		graphregion(color(white) lc(white) lw(med) la(center)) /// <- Delete la(center) for version < 15
		ylab(,angle(0) nogrid) xtit(,placement(left) justification(left)) ///
		yscale(noline) xscale(noline) legend(region(lc(none) fc(none)))


	global hist_opts ylab(, angle(0) axis(2)) yscale(noline alt axis(2)) ///
	 	ytit(, axis(2)) ytit(, axis(1)) yscale(off axis(2)) yscale(alt)


gen divorce_pc = divorce/pop
gen death_pc = death/pop

cap mat drop results_
tempvar cutoff
gen `cutoff' = .

qui foreach i of numlist 1/50 {
	replace `cutoff' = 0
	replace `cutoff' = 1 ///
		if divorce_pc >= `=.0025 + `i'/10000'

	reg death_pc `cutoff'
		matlist r(table)
		mat a = r(table)
		mat result = a[1...,1]\[`=.0025 + `i'/10000']

		mat results_ = nullmat(results_) ///
			\ result'
	}

	tempfile temp
		save `temp'

	clear
	svmat results_ , names(matcol)
		append using `temp'

		-

tw ///
	(histogram divorce_pc ///
		if divorce_pc < .01 ///
		, w(.0005) yaxis(2) lw(thin) lc(black) fc(none)) ///
	(rarea results_ll results_ul results_r10 ///
		, fc(gray) lw(none)) ///
	(line results_b results_r10 ///
		if results_ll < . ///
		, lc(maroon) lw(thick)) ///
	, xtit("Cutoff {&rarr}") yline(0 )///
		${graph_opts} ${hist_opts}
