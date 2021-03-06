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
	@echo "   macrocolumn_tb-sim:  	RTL sim. of macrocolumn_tb "
	@echo "   macrocolumn_tb-wave:  	waveform gui of macrocolumn_tb "
	@echo "   macrocolumn-sim:  	RTL sim. of macrocolumn "
	@echo "   macrocolumn-wave:  	waveform gui of macrocolumn "
	@echo "   macrocolumn-synth: 	synthesis run for macrocolumn "
	@echo "   replay_buffer-sim:  	RTL sim. of Replay Buffer "
	@echo "   replay_buffer-wave:	waveform gui of Replay Buffer "
	@echo "   rb_demux-sim:  	RTL sim. of Replay Buffer Demux "
	@echo "   rb_demux-wave:	waveform gui of Replay Buffer Demux "
	@echo "   clean: 		cleans SIM SYNTH PNR directories "
	@echo ""
	@echo " "

SIM := ${CURDIR}/SIM
SRC:= ${CURDIR}/src/rtl
SYNTH := $(CURDIR)/SYNTH
REPLAY_BUFFER_FLAGS = +define+REPLAY_BUFFER_TB
MUXED_COL_FLAGS = +define+MULTIPLEXED_COLUMN_TB
RB_DEMUX_TB_FLAGS = +define+RB_DEMUX_TB

.SILENT:
.PHONY: macrocolumn_tb-sim
macrocolumn_tb-sim:
	
	if [ ! -d "$(SIM)" ]; then \
        mkdir $(SIM) && mkdir $(SIM)/macrocolumn_tb;\
		cd $(SIM)/macrocolumn_tb && vcs -sverilog -debug_all -full64 -top macroculumn_tb $(SRC)/*.sv $(MUXED_COL_FLAGS) && ./simv;\
	elif [ ! -d "$(SIM)/macrocolumn_tb" ]; then \
        mkdir $(SIM)/macrocolumn_tb;\
		cd $(SIM)/macrocolumn_tb && vcs -sverilog -debug_all -full64 -top macroculumn_tb $(SRC)/*.sv $(MUXED_COL_FLAGS) && ./simv;\
	else \
		cd $(SIM)/macrocolumn_tb && vcs -sverilog -debug_all -full64 -top macroculumn_tb $(SRC)/*.sv $(MUXED_COL_FLAGS) && ./simv;\
	fi;
	

.PHONY: macrocolumn_tb-wave
macrocolumn_tb-wave:
	
	if [ ! -d "$(SIM)" ]; then \
        @echo "Perform simulation first";\
	elif [ ! -d "$(SIM)/macrocolumn_tb" ]; then \
        @echo "Perform simulation first";\
	else \
		cd $(SIM)/macrocolumn_tb && ./simv -gui;\
	fi;

	
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
	

.PHONY: rb_demux-sim
rb_demux-sim:
	
	if [ ! -d "$(SIM)" ]; then \
        mkdir $(SIM) && mkdir $(SIM)/replay_buffer_demux;\
		cd $(SIM)/replay_buffer_demux && vcs -sverilog -debug_all -full64 -top demux_tb $(SRC)/*.sv $(RB_DEMUX_TB_FLAGS) && ./simv;\
	elif [ ! -d "$(SIM)/replay_buffer_demux" ]; then \
        mkdir $(SIM)/replay_buffer_demux;\
		cd $(SIM)/replay_buffer_demux && vcs -sverilog -debug_all -full64 -top demux_tb $(SRC)/*.sv $(RB_DEMUX_TB_FLAGS) && ./simv;\
	else \
		cd $(SIM)/replay_buffer_demux && vcs -sverilog -debug_all -full64 -top demux_tb $(SRC)/*.sv $(RB_DEMUX_TB_FLAGS) && ./simv;\
	fi;
	

.PHONY: rb_demux-wave
rb_demux-wave:
	
	if [ ! -d "$(SIM)" ]; then \
        @echo "Perform simulation first";\
	elif [ ! -d "$(SIM)/replay_buffer_demux" ]; then \
        @echo "Perform simulation first";\
	else \
		cd $(SIM)/replay_buffer_demux && ./simv -gui;\
	fi;
	


.PHONY: clean
clean:
	rm -rf $(CURDIR)/SIM $(CURDIR)/SYNTH $(CURDIR)/PNR
