# Makefile for 18-743 Lab Assignment 2
# Author: Prabhu Vellaisamy


.PHONY: help
help:
	@echo ""
	@echo "	S Y N T A X "
	@echo ""
	@echo " make [args.] "
	@echo ""
	@echo " Arguments: "
	@echo "   macrocolumn-sim:  RTL sim. of macrocolumn "
	@echo "   macrocolumn-wave:  waveform gui of macrocolumn "
	@echo "   macrocolumn-synth: synthesis run for macrocolumn "
	@echo ""
	@echo " "

SIM := ${CURDIR}/SIM
SRC:= ${CURDIR}/src
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
	
	

#.PHONY: snl-synth
#snl-synth:
#	
#	if [ ! -d "$(SYNTH)" ]; then \
#		mkdir $(SYNTH) && mkdir $(SYNTH)/snl_neuron;\
#		cd $(SYNTH)/snl_neuron && dc_shell -f $(CURDIR)/tcl/synth_snl.tcl;\
#	elif [ ! -d "$(SYNTH)/snl_neuron" ]; then \
#		mkdir $(SYNTH)/snl_neuron;\
#		cd $(SYNTH)/snl_neuron && dc_shell -f $(CURDIR)/tcl/synth_snl.tcl;\
#	else \
#		cd $(SYNTH)/snl_neuron && dc_shell -f $(CURDIR)/tcl/synth_snl.tcl;\
#	fi;
#	
#.PHONY: rnl-synth
#rnl-synth:
#		
#	if [ ! -d "$(SYNTH)" ]; then \
#		mkdir $(SYNTH) && mkdir $(SYNTH)/rnl_neuron;\
#		cd $(SYNTH)/rnl_neuron && dc_shell -f $(CURDIR)/tcl/synth_rnl.tcl;\
#	elif [ ! -d "$(SYNTH)/rnl_neuron" ]; then \
#		mkdir $(SYNTH)/rnl_neuron;\
#		cd $(SYNTH)/rnl_neuron && dc_shell -f $(CURDIR)/tcl/synth_rnl.tcl;\
#	else \
#		cd $(SYNTH)/rnl_neuron && dc_shell -f $(CURDIR)/tcl/synth_rnl.tcl;\
#	fi;
#
#.PHONY: bitonic-synth
#bitonic-synth:
#	
#	if [ ! -d "$(SYNTH)" ]; then \
#		mkdir $(SYNTH) && mkdir $(SYNTH)/bitonic;\
#		cd $(SYNTH)/bitonic && dc_shell -f $(CURDIR)/tcl/synth_bitonic.tcl;\
#	elif [ ! -d "$(SYNTH)/bitonic" ]; then \
#		mkdir $(SYNTH)/bitonic;\
#		cd $(SYNTH)/bitonic && dc_shell -f $(CURDIR)/tcl/synth_bitonic.tcl;\
#	else \
#		cd $(SYNTH)/bitonic && dc_shell -f $(CURDIR)/tcl/synth_bitonic.tcl;\
#	fi;
#	
#.PHONY: synapse-synth
#synapse-synth:
#		
#	if [ ! -d "$(SYNTH)" ]; then \
#		mkdir $(SYNTH) && mkdir $(SYNTH)/synapse;\
#		cd $(SYNTH)/synapse && dc_shell -f $(CURDIR)/tcl/synth_synapse.tcl;\
#	elif [ ! -d "$(SYNTH)/synapse" ]; then \
#		mkdir $(SYNTH)/synapse;\
#		cd $(SYNTH)/synapse && dc_shell -f $(CURDIR)/tcl/synth_synapse.tcl;\
#	else \
#		cd $(SYNTH)/synapse && dc_shell -f $(CURDIR)/tcl/synth_synapse.tcl;\
#	fi;
#
	

.PHONY: cleanall
cleanall:
	rm -rf $(CURDIR)/SIM $(CURDIR)/SYNTH $(CURDIR)/PNR
	#find . -maxdepth 1 -type d | grep "./" | xargs -I {} make clean -C {}
