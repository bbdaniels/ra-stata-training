* Measurement error simulations

	global graph_opts ///
		title(, justification(left) color(black) span pos(11)) ///
		graphregion(color(white) lc(white) lw(med) la(center)) /// <- Delete la(center) for version < 15
		ylab(,angle(0) nogrid) xtit(,placement(left) justification(left)) ///
		yscale(noline) xscale(noline) legend(region(lc(none) fc(none)))

*  Cross Section

	cap prog drop regSim
	prog def regSim , rclass

	syntax ///
		, [Noise(real 1)] [Reps(real 100)]

		preserve

		tempname results
		cap mat drop `results'
		qui forvalues i = 1/`reps' {
			clear
			set obs 100
			gen x = rnormal()
			gen y = x + rnormal()
			gen z = x + `noise'*rnormal()

			reg y z
			mat `results' = nullmat(`results') ///
				\ [_b[z],`noise']
		}

		return matrix results = `results'

	end

* Loop

	cap mat drop results

	local x = 1/(2^5)
	forvalues i = 1/10 {
		regSim , noise(`x')
		local theLabels `"`theLabels' `x' "`=1/`x''" "'
		local x = 2*`x'
		mat results = nullmat(results) ///
			\ r(results)
	}

* Visualize

	clear
	svmat results

	collapse ///
		(mean) b   = results1 ///
		(p5)   p5  = results1 ///
		(p95)  p95 = results1 ///
	, by(results2) fast

	tw ///
	(rarea p5 p95 results2 ///
		, fc(gray) lw(none)) ///
	(line b results2 ///
		, lc(maroon) lw(thick)) ///
	, xtit("Signal/Noise {&rarr}") yline(1) ///
		ylab(1 "True {&beta}" 0 "Zero") ///
		${graph_opts} xscale(log) xlab(`theLabels') ///
		legend(order(2 "Average {&beta}" 1 "95% CI"))


* Have a lovely day!
