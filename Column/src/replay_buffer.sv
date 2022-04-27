/*
================================================================
* Implements the compression logic of input spikes
* Authors: Rushat Rout, Rishi Malladi
* Date: 04/06/2022
================================================================

*/



module replay_buffer_body(
  
  input data_in,
  input rst,
  input grst,
  input clk,
  output logic data_out 

);

    parameter BUFFER_DEPTH = 'd16;
    
    bit [BUFFER_DEPTH-1:0] buffer[1:0];
    bit [1:0] en;
    bit enable;
    bit [$clog2(BUFFER_DEPTH):0]count, pre_idx, idx;
    bit start_count;
    
    assign idx = pre_idx * 'd2;
    assign data_out = enable? buffer[1][idx] : buffer[0][idx];
    
    always_ff@(posedge clk) begin
        
        if(rst) begin
            count <= 'd0;
            pre_idx <= 'd0; 
        end
        else begin
            if(start_count) begin
                if(count > 'd8) begin 
                    count         <= 'd0; 
                end
                else begin
                    count         <= count + 1'd1; 
                end
                if(pre_idx > 'd3) begin
                    pre_idx <= 'd0;
                end
                else begin
                    pre_idx <= pre_idx + 'd1;
                end
            end else begin
                count <= 'd0;
                pre_idx <= 'd0;
            end
    
            if(enable) begin
                buffer[0][count] <= data_in; 
            end else begin 
               buffer[1][count] <= data_in; 
            end
        end
    
    end
    
    
    always_ff @(posedge grst) begin
        if(rst) begin
            en[0] <= 1'd1;
            en[1] <= 1'd0;
            start_count <= 'd0;
            enable <= 1'd0;
            
        end
        else begin
            en[0] <= en[1];
            en[1] <= ~en[1];
            start_count <= 'd1;
            enable <= ~enable;
        end
    end

endmodule

module mux #(parameter NUM_INPUTS = 'd2) (
  input [NUM_INPUTS-1:0] in,
  input [$clog2(NUM_INPUTS)-1:0] sel,
  output logic out
);

  always_comb begin
    out = in[sel];
  end

endmodule


module replay_buffer
#(
  parameter NUM_INPUTS = 'd2
  ) (
  
  input [NUM_INPUTS-1: 0] data_in,
  input rst,
  input grst,
  input clk,
  output logic data_out 

);

  wire [NUM_INPUTS-1:0] interim_out;

  logic sel;

  always_ff@(posedge grst) begin // SYNTH FAILED if both edges in sensitivity list
    if(rst) begin
      sel <= 'd0;
    end else begin
      sel <= ~sel;
    end
  end

  genvar i;
  
  for(i=0; i<NUM_INPUTS; i++) begin
    replay_buffer_body rbb (data_in[i],rst,grst,clk,interim_out[i]);
  end

  mux #(.NUM_INPUTS(NUM_INPUTS)) m0 (.in(interim_out), .sel(sel), .out(data_out));

endmodule


`ifdef REPLAY_BUFFER_TB
module buffer_test;

   bit rst, grst, clk; 
   bit [1:0] data_in;
   bit data_out; 


   muxed_replay_buffer #(.NUM_INPUTS(2)) m_rp0 (.data_in(data_in), .rst(rst), .grst(grst), .clk(clk), .data_out(data_out));


   always #10 clk = ~clk;
   always #100 grst = ~grst;

   initial begin 
        rst = 1'd1;
        clk = 'd1;
        grst = 'd0;
        data_in = 'd0;

        #60
        rst = 1'd0;
        #10
        for(int i = 0; i < 100; i = i+1) begin 
               #20 data_in = $random;
        end

        rst = 1'd1;
        clk = 'd1;
        grst = 'd0;
        data_in = 'd0;

        #60
        rst = 1'd0;
        #10
        for(int i = 0; i < 100; i = i+1) begin 
               #20 data_in = $random;
        end

   #100     
   $finish;  
   end

endmodule
`endif



 
