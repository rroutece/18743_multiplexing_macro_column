/*
============================================================================
* Implements the multiplexing logic of input spikes from different networks 
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
     
     input logic [Q-1:0][P-1:0][WRES-1:0] w_init,
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
logic [$clog2(GAMMA_CYCLE_LENGTH)-1:0] counter;
bit start_count;

start_counting sc0 (.rst(rstb), .grst(grst), .start_count(start_count));

replay_buffer #(.P(P), .BUFFER_DEPTH(GAMMA_CYCLE_LENGTH)) rb (.data_in1(data_in1), .data_in2(data_in2), .rst(rstb), .grst(grst), .clk(clk), .start_count(start_count), .data_out(data_in));


//counter 
cycle_counter #(.GAMMA_CYCLE_LENGTH(GAMMA_CYCLE_LENGTH)) c_counter (.rst(rstb), .clk(clk), .start_count(start_count), .counter(counter));

/* column instantiation*/

//TODO generate 2x Gamma clock to be passed as input to column instance

             
   column  #(
                .P(P),
                .Q(Q),
                .WRES(WRES),
                .THRESHOLD(THRESHOLD)
            )
                        
            col (
                .input_spikes(data_in),
                .w_init(w_init),
                .capture_brv(capture_brv),
                .minus_brv(minus_brv),
                .search_brv(search_brv),
                .backoff_brv(backoff_brv),
                .min_brv(min_brv),
                .F_brv(F_brv),
                .clk(clk),
                .grst(grst),
                .rstb(rstb),
                .output_spikes(output_spikes1)       //TODO write demuxing
            );


assign output_spikes2 = output_spikes1;             //TODO remove after demuxing blok has been written

endmodule


module macroculumn_tb ();

    bit rst, grst, grst_2x, clk;

    multiplexed_column #(.GAMMA_CYCLE_LENGTH(18)) mc0 (.rstb(rst), .grst(grst), .grst_2x(grst_2x), .clk(clk));

    always #10 clk = ~clk;
    always #180 grst = ~grst;
    always #90 grst_2x = ~grst_2x;

    initial begin
        rst = 1'd1;
        grst = 1'd0;
        grst_2x = 1'd1;
        clk = 1'd1;

        #100 rst = 1'd0;

        #10000     
        $finish;  

    end
endmodule
