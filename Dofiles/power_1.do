* Power calcs for ZASP

	ieboilstart , version(15)
	set matsize 10000

* Confidence intervals: SP1 w two special cases

	cap mat drop results
	forvalues i = 50(10)200 {
	// sample sizes
		qui forvalues iter = 1/50 {
		// iterations

			clear

			set obs `i'
			xtile type = runiform() , n(4)
			recode type (1/2 = 1 "Naive")(3 = 2 "Diabetes")(4 = 3 "Hypertension") , gen(sp_type)
			gen correct = runiform() > .5

			reg correct i.sp_type
				mat a = r(table)
				local p2 = a[6,2] - a[5,2]
				local p3 = a[6,3] - a[5,3]


			mat results = nullmat(results) ///
				\ [`p2',`p3',`i']

		}
	}

	clear
	svmat results

	replace results1 = results1/2
	replace results2 = results2/2
	collapse (mean) results1 , by(results3) fast
		gen neg = -results1

	tw ///
		(rarea neg results1 results3, lw(none) fc(gray)) ///
		(function 0 , range(50 200) lc(black)) ///
	, ${graph_opts} legend(off) xtit("Total SP1 Observations {&rarr}") ///
		ytit("Non-rejection") ylab(-.4 "-40%" -.2 "-20%" 0 "No Effect" .2 "+20%" .4 "+40%")

			graph export "/users/bbdaniels/desktop/power_SP1.png" , replace


-
* MDE Gender: 80% power, 50% background

	cap mat drop results
	forvalues i = 50/100 {
	// effect sizes
		qui forvalues iter = 1/50 {
		// iterations

			* Clear

				clear

			* Cases

				set obs 100
					gen case = 1
				set obs 150
					replace case = 2 if case == .
				set obs 200
					replace case = 3 if case == .

			* Gender

				gen male = 0
				replace male = 1 in 1/25
				replace male = 1 in 101/125
				replace male = 1 in 151/175


			* Correctness

				gen correct = runiform() > .5
					replace correct = runiform() < `=`i'/100' if male == 1

			* Regress

				reg correct male i.case

				mat a = r(table)
				local p = a[4,1]
				local sig = `p' < 0.05

				mat results = nullmat(results) ///
					\ [`sig',`=(`i'-50)/50']
		}
	}

	* Graph

		clear
		svmat results

		tw lpoly results1 results2 ///
		, ${graph_opts} ytit("Power") ylab(${pct}) yline(.8) ///
			lc(black) lw(thick) ///
			ylab(0 "0%" .2 "20%" .4 "40%" .6 "60%" .8 "80%" 1 "100%") ///
			xtit("Minumum Detectable Effect Size {&rarr}") xlab(0 .2 "+10%" .4 "+20%" .6 "+30%" .8  "+40%" 1 "+50%")

			graph export "/users/bbdaniels/desktop/power_gender.png" , replace


* Have a lovely day!
