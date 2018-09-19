// Test [ritest]

// Define sampling program

	cap program drop sample_demo
	program sample_demo

	syntax , [*]

		cap gen treatment = rnormal() > 0
		if _rc > 0 {
			replace treatment = rnormal() > 0
		}
	end

// Simulate data

	clear

	set obs 100

	gen outcome = rnormal()

// Create "true" treatment

	sample_demo

// Resampling

	ritest treatment _b[treatment] ///
		, reps(50) samplingprogram(sample_demo) ///
		// kdens kdensityop(${graph_opts} xscale(line) lc(black) lw(thick)) ///
		: regress outcome treatment

// Have a lovely day!
