* MDE Gender: 80% power, 50% background

cap prog drop zasp_gender
prog def zasp_gender

syntax , sp1(integer) sp2(integer) sp2_fem(real) type(string asis)

	cap mat drop results
	forvalues i = 50(5)100 {
	// effect sizes
		qui forvalues iter = 1/10 {
		// iterations

			* Clear

				clear

			* Cases

				set obs `sp1'
					gen case = 1
				set obs `=`sp1'+`sp2''
					replace case = 2 if case == .
				set obs `=`sp1'+`sp2'+`sp2''
					replace case = 3 if case == .

			* Gender

				gen male = 0
				replace male = 1 in 1/`=.25*`sp1''
				cap replace male = 1 in `=`sp1'+1'/`=`sp1'+`sp2_fem'*`sp2''
				replace male = 1 in `=`sp1'+`sp2'+1'/`=`sp1'+`sp2'+0.5*`sp2''


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
		gen type = "`type'"

end

* Run!

	clear
	tempfile all
		save `all' , emptyok

	zasp_gender , sp1(100) sp2(50) sp2_fem(.5) type(A)

		append using `all'
			save `all' , replace

	zasp_gender , sp1(100) sp2(50) sp2_fem(0) type(B)

		append using `all'
			save `all' , replace

	zasp_gender , sp1(200) sp2(100) sp2_fem(.5) type(C)

		append using `all'
			save `all' , replace

	zasp_gender , sp1(200) sp2(100) sp2_fem(.25) type(D)

		append using `all'
			save `all' , replace

	zasp_gender , sp1(200) sp2(100) sp2_fem(0) type(E)

		append using `all'
			save `all' , replace

* Visualize

	tw ///
		(lpoly results1 results2 if type == "A" , lw(thick)) ///
		(lpoly results1 results2 if type == "B" , lw(thick)) ///
		(lpoly results1 results2 if type == "C" , lw(thick)) ///
		(lpoly results1 results2 if type == "D" , lw(thick)) ///
		(lpoly results1 results2 if type == "E" , lw(thick)) ///
	, ${graph_opts} ytit("Power") ylab(${pct}) yline(.8) ///
		ylab(0 "0%" .2 "20%" .4 "40%" .6 "60%" .8 "80%" 1 "100%") ///
		legend(pos(5) ring(0) c(1) symysize(large) symxsize(small) order(1 "A" 2 "B" 3 "C" 4 "D" 5 "E")) ///
		xtit("Minumum Detectable Effect Size {&rarr}") xlab(0 .2 "+10%" .4 "+20%" .6 "+30%" .8  "+40%" 1 "+50%")

		graph export "/users/bbdaniels/desktop/power_gender.png" , replace


* OK!
