/*
============================================================================
* Implements the multiplexing of compressed signals from the replay buffer
* In this design, the multiplexed signals are passed through the column and
* the processing is done at 2x the normal gamma clock. It generates a multi-
* plexed version of the output spikes 
* Authors: Rushat Rout, Rishi Malladi
* Date: 04/26/2022
============================================================================


*/

module multiplexed_column # (parameter P='d64,
                  parameter Q='d2,
                  parameter WRES='d3,
                  parameter THRESHOLD='d133,
                  parameter GAMMA_CYCLE_LENGTH = 'd18,
                  parameter WEIGHT_LOAD_LATENCY = 'd1,
                  parameter WEIGHT_WRITE_LATENCY = 'd1
                  ) 
( 
     input logic [P-1:0]data_in1,
     input logic [P-1:0]data_in2,
     
     input logic [1:0][Q-1:0][P-1:0][WRES-1:0] w_init,
     input logic [Q-1:0][P-1:0] capture_brv,
     input logic [Q-1:0][P-1:0] minus_brv,
     input logic [Q-1:0][P-1:0] search_brv,
     input logic [Q-1:0][P-1:0] backoff_brv,
     input logic [Q-1:0][P-1:0] min_brv,
     input logic [Q-1:0][(1<<WRES)-3:0] F_brv,
     input logic clk,
     input logic grst,
     input logic grst_2x,
     input logic rstb,
     output logic [Q-1:0] output_spikes1,
     output logic [Q-1:0] output_spikes2
         
); 


logic [P-1:0]data_in;
logic [$clog2(GAMMA_CYCLE_LENGTH)-1:0] cycle_counter;
logic [$clog2(GAMMA_CYCLE_LENGTH/2)-1:0] half_cycle_counter;
bit start_count;
bit alt_grst_2x; //alternating signal on every grst_2x clk
logic [Q-1:0] muxed_output_spikes;

always @(posedge grst_2x) begin
    if(rstb) begin
        alt_grst_2x <= 'd0;
    end
    else begin
        alt_grst_2x <= ~alt_grst_2x;
    end
end

start_counting sc0 (.rst(rstb), .grst(grst), .start_count(start_count));

//counter 
cycle_counter #(.GAMMA_CYCLE_LENGTH(GAMMA_CYCLE_LENGTH)) c_counter (.rst(rstb), .clk(clk), .start_count(start_count), .counter(cycle_counter));

cycle_counter #(.GAMMA_CYCLE_LENGTH(GAMMA_CYCLE_LENGTH/2)) c_half_counter (.rst(rstb), .clk(clk), .start_count(start_count), .counter(half_cycle_counter));

replay_buffer #(.P(P), .BUFFER_DEPTH(GAMMA_CYCLE_LENGTH)) rb (.data_in1(data_in1), .data_in2(data_in2), .rst(rstb), .grst(grst), .clk(clk), .start_count(start_count), .wr_idx(cycle_counter), .data_out(data_in));

/* column instantiation*/

//TODO generate 2x Gamma clock to be passed as input to column instance

             
   column  #(
                .P(P),
                .Q(Q),
                .WRES(WRES),
                .THRESHOLD(THRESHOLD),
                .GAMMA_CYCLE_LENGTH(GAMMA_CYCLE_LENGTH)
            )
                        
            col (
                .input_spikes(data_in),
                .network_w_init(w_init),
                .capture_brv(capture_brv),
                .minus_brv(minus_brv),
                .search_brv(search_brv),
                .backoff_brv(backoff_brv),
                .min_brv(min_brv),
                .F_brv(F_brv),
                .clk(clk),
                .grst(grst_2x),
                .rstb(rstb),
                .cycle_counter(cycle_counter),
                .alt_grst(alt_grst_2x),
                .output_spikes(muxed_output_spikes)       //TODO write demuxing
            );


    replay_buffer_demux # (
                            .Q(Q), 
                            .GAMMA_CYCLE_LENGTH(GAMMA_CYCLE_LENGTH)
                          )
 
                    demux_rp ( 
                        .muxed_output_spikes(muxed_output_spikes),
                        .clk(clk),
                        .grst(grst),
                        .grst_2x(grst_2x),
                        .rst(rstb),
                        .start_count(start_count),
                        .cycle_counter(cycle_counter),
                        .half_cycle_counter(half_cycle_counter),
                        .demuxed_output_spikes({output_spikes2,output_spikes1})
                    ); 

endmodule


`ifdef MULTIPLEXED_COLUMN_TB 
module macroculumn_tb ();
    parameter P='d64;
    parameter Q='d2;
    parameter WRES='d3;

    bit rst, grst, grst_2x, clk;
    bit [P-1:0]data_in1;
    bit [P-1:0]data_in2;
    bit [1:0][Q-1:0][P-1:0][WRES-1:0] w_init;
    bit [Q-1:0][P-1:0] capture_brv;
    bit [Q-1:0][P-1:0] minus_brv;
    bit [Q-1:0][P-1:0] search_brv;
    bit [Q-1:0][P-1:0] backoff_brv;
    bit [Q-1:0][P-1:0] min_brv;
    bit [Q-1:0][(1<<WRES)-3:0] F_brv;

    multiplexed_column #(
                            .GAMMA_CYCLE_LENGTH(36)
                        ) 
                    mc0 (
                            .data_in1(data_in1),
                            .data_in2(data_in2),
                            .w_init(w_init),
                            .capture_brv(capture_brv),
                            .minus_brv(minus_brv),
                            .search_brv(search_brv),
                            .backoff_brv(backoff_brv),
                            .min_brv(min_brv),
                            .F_brv(F_brv),
                            .clk(clk),
                            .grst(grst),
                            .grst_2x(grst_2x),
                            .rstb(rst),
                            .output_spikes1(),
                            .output_spikes2()
                        );

    always #10 clk = ~clk;
    always #360 grst = ~grst;
    always #180 grst_2x = ~grst_2x;

    initial begin
        rst = 1'd1;
        grst = 1'd0;
        grst_2x = 1'd1;
        clk = 1'd1;
        data_in1 = 'd0;
        data_in2 = 'd0;
        w_init[0][0] = $random+'d1;
        w_init[0][1] = $random+'d2;
        w_init[1][0] = $random+'d3;
        w_init[1][1] = $random+'d4;
        capture_brv = 'd0;
        minus_brv = 'd0;
        search_brv = 'd0;
        backoff_brv = 'd0;
        min_brv = 'd0;
        F_brv = 'd0;

        #100 rst = 1'd0;

        for(int i = 0; i < 100; i = i+1) begin 
            #20 data_in1 = $random;
            #20 data_in2 = $random;
            #20 capture_brv = $random;
            #20 minus_brv = $random;
            #20 search_brv = $random;
            #20 backoff_brv = $random;
            #20 min_brv = $random;
            #20 F_brv = $random;
        end


        #10000     
        $finish;  

    end
endmodule
`endif
