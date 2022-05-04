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
	@echo "   replay_buffer-sim:  	RTL sim. of Replay Buffer "
	@echo "   replay_buffer-wave:	waveform gui of Replay Buffer "
	@echo "   clean: 		cleans SIM SYNTH PNR directories "
	@echo ""
	@echo " "

SIM := ${CURDIR}/SIM
SRC:= ${CURDIR}/src/rtl
SYNTH := $(CURDIR)/SYNTH
REPLAY_BUFFER_FLAGS = +define+REPLAY_BUFFER_TB

.SILENT:
.PHONY: macrocolumn-sim
macrocolumn-sim:
	
	if [ ! -d "$(SIM)" ]; then \
        mkdir $(SIM) && mkdir $(SIM)/macrocolumn;\
		cd $(SIM)/macrocolumn && vcs -sverilog -debug_all -full64 -top macroculumn_tb $(SRC)/*.sv && ./simv;\
	elif [ ! -d "$(SIM)/macrocolumn" ]; then \
        mkdir $(SIM)/macrocolumn;\
		cd $(SIM)/macrocolumn && vcs -sverilog -debug_all -full64 -top macroculumn_tb $(SRC)/*.sv && ./simv;\
	else \
		cd $(SIM)/macrocolumn && vcs -sverilog -debug_all -full64 -top macroculumn_tb $(SRC)/*.sv && ./simv;\
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
	

.PHONY: replay_buffer-sim
replay_buffer-sim:
	
	if [ ! -d "$(SIM)" ]; then \
        mkdir $(SIM) && mkdir $(SIM)/replay_buffer;\
		cd $(SIM)/replay_buffer && vcs -sverilog -debug_all -full64 -top buffer_test $(SRC)/*.sv  $(REPLAY_BUFFER_FLAGS) && ./simv;\
	elif [ ! -d "$(SIM)/replay_buffer" ]; then \
        mkdir $(SIM)/replay_buffer;\
		cd $(SIM)/replay_buffer && vcs -sverilog -debug_all -full64 -top buffer_test $(SRC)/*.sv $(REPLAY_BUFFER_FLAGS) && ./simv;\
	else \
		cd $(SIM)/replay_buffer && vcs -sverilog -debug_all -full64 -top buffer_test $(SRC)/*.sv $(REPLAY_BUFFER_FLAGS) && ./simv;\
	fi;
	

.PHONY: replay_buffer-wave
replay_buffer-wave:
	
	if [ ! -d "$(SIM)" ]; then \
        @echo "Perform simulation first";\
	elif [ ! -d "$(SIM)/replay_buffer" ]; then \
        @echo "Perform simulation first";\
	else \
		cd $(SIM)/replay_buffer && ./simv -gui;\
	fi;
	

.PHONY: clean
clean:
	rm -rf $(CURDIR)/SIM $(CURDIR)/SYNTH $(CURDIR)/PNR

