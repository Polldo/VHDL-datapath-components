the external memory used to fill/spill windows should use:
	-DATAIN bus of the window register file to FILL registers, one at a time, starting from the first(0) to the last(2*N-1).
	 The addresses are updated INTERNALLY, so the memory has just to send one register per clock cycle.
	-OUT1 bus of the Window_register_file to SPILL registers, as for the FILL. During a SPILL the correct addresses of the registers to be saved are
	 INTERNALLY selected and automatically output in OUT1. the memory just has to read and save the value from OUT1 every clock cycle. The signal used to enable the RD1 operation
	 is always HIGH during a SPILL operation.

in the testbench of the window_registerfile is shown this process:
	-a register of the global window is written to, and the READ2 of the wind_regfile is set to always read this global register.
	 even changing windows this READ will remain the same (global window is the same for all).	
	-the first 5 registers of the first window are written to.
	-the current window will change 3 times due to 3 consequent CALL. For the last change a SPILL is executed because the last window is going to be
	 used and its OUT block will overlap the IN block of the first window. So the first window must be saved.
	 During this SPILL the value of the registers to be saved(registers of the first window) will be output in OUT1.
	-after the SPILL operation the Current window becomes the last window (42ns in the simulation). Now I perform a Write and then a Read on the same
	 register to verify that the addresses are correctly calculated and that the registers of the current window are accessible.
the complete waveform is saved in file 'wind_rf_wave.ps'. 
I also split this waveform in 'wind_rf_wave_part1.ps' and 'wind_rf_wave_part2.ps' because maybe is more readable. 
