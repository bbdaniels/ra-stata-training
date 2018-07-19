* Simulation: Broken or Fixed Effects?

set matsize 5000
clear all

global graph_opts ///
	title(, justification(left) color(black) span pos(11)) ///
	graphregion(color(white) lc(white) lw(med) la(center)) /// <- Delete la(center) for version < 15
	ylab(,angle(0) nogrid) xtit(,placement(left) justification(left)) ///
	yscale(noline) xscale(noline) legend(region(lc(none) fc(none)))

* Run a simulation

	foreach sampleSize of numlist 1 2 3 4 {
		qui forvalues iteration = 1/50 {

			* Create data

				clear
				local nuids = 10^`sampleSize'
				set obs `nuids'
				gen fe = rnormal()
				gen uid = _n
				expand 10
				gen x_vary = rnormal() + fe
				gen y = x_vary + fe + rnormal()

			* Run a regression

				xtset uid

				xtreg y x_vary
				local err_re = abs(1-_b[x_vary])

				xtreg y x_vary , fe
				local err_fe = abs(1-_b[x_vary])

				mat results = ///
					nullmat(results) \ [`err_re',`err_fe',`nuids']

		}
	}

* Visualize the simulation

	clear
	svmat results

	tw ///
		(lpolyci results1 results3 , lw(thick)) ///
		(lpolyci results2 results3 , lw(thick)) ///
	, ${graph_opts} ///
		xscale(log) xlab(10 100 1000 10000) ///
		xtitle("Observations{&rarr}") ///
		ytitle(" ") yline(0 , lw(thin)) ///
		legend(c(1) ring(0) pos(3) ///
			order(0 "Average Error:" 2 "Random Effects" 4 "Fixed Effects"))

* Have a lovely day!
