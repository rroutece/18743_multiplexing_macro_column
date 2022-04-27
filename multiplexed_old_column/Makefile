# Makefile for 18-743 Final P
# Author: Rushat Rout


.PHONY: help
help:
	@echo ""
	@echo "	S Y N T A X "
	@echo ""
	@echo " make [args.] "
	@echo ""
	@echo " Arguments: "
	@echo "   macrocolumn-sim:  	RTL sim. of macrocolumn "
	@echo "   macrocolumn-wave:  	waveform gui of macrocolumn "
	@echo "   macrocolumn-synth: 	synthesis run for macrocolumn "
	@echo "   clean: 		cleans SIM SYNTH PNR directories "
	@echo ""
	@echo " "

SIM := ${CURDIR}/SIM
SRC:= ${CURDIR}/src/rtl
SYNTH := $(CURDIR)/SYNTH

.SILENT:
.PHONY: macrocolumn-sim
macrocolumn-sim:
	
	if [ ! -d "$(SIM)" ]; then \
        mkdir $(SIM) && mkdir $(SIM)/macrocolumn;\
		cd $(SIM)/macrocolumn && vcs -sverilog -debug_all -full64 -top multiplexed_column $(SRC)/*.sv && ./simv;\
	elif [ ! -d "$(SIM)/macrocolumn" ]; then \
        mkdir $(SIM)/macrocolumn;\
		cd $(SIM)/macrocolumn && vcs -sverilog -debug_all -full64 -top multiplexed_column $(SRC)/*.sv && ./simv;\
	else \
		cd $(SIM)/macrocolumn && vcs -sverilog -debug_all -full64 -top multiplexed_column $(SRC)/*.sv && ./simv;\
	fi;
	

.PHONY: macrocolumn-wave
macrocolumn-wave:
	
	if [ ! -d "$(SIM)" ]; then \
        @echo "Perform simulation first";\
	elif [ ! -d "$(SIM)/macrocolumn" ]; then \
        @echo "Perform simulation first";\
	else \
		cd $(SIM)/macrocolumn && ./simv -gui;\
	fi;
	

.PHONY: macrocolumn-synth
macrocolumn-synth:
	
	if [ ! -d "$(SYNTH)" ]; then \
		mkdir $(SYNTH) && mkdir $(SYNTH)/macrocolumn;\
		cd $(SYNTH)/macrocolumn && dc_shell -f $(CURDIR)/tcl/synth_macrocolumn.tcl;\
	elif [ ! -d "$(SYNTH)/macrocolumn" ]; then \
		mkdir $(SYNTH)/macrocolumn;\
		cd $(SYNTH)/macrocolumn && dc_shell -f $(CURDIR)/tcl/synth_macrocolumn.tcl;\
	else \
		cd $(SYNTH)/macrocolumn && dc_shell -f $(CURDIR)/tcl/synth_macrocolumn.tcl;\
	fi;
	

.PHONY: clean
clean:
	rm -rf $(CURDIR)/SIM $(CURDIR)/SYNTH $(CURDIR)/PNR
