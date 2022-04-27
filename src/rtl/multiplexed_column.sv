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
                  parameter THRESHOLD='d133
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
     input logic rstb,
     output logic [Q-1:0] output_spikes1,
     output logic [Q-1:0] output_spikes2
         
); 


logic [P-1:0]data_in;

replay_buffer #(.P(P)) rb (.data_in1(data_in1), .data_in2(data_in2), .rst(rstb), .grst(grst), .clk(clk), .data_out(data_in));


/* column instantiation*/

//TODO generate 2x Gamma clock to be passed as input to column instance

             
   column  #(
                .P(P),
                .Q(Q),
                .WRES(WRES),
                .THRESHOLD(THRESHOLD)
            )
                        
            col_test (
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
