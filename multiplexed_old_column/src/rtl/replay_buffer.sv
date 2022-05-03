/*
================================================================
* Implements the compression logic of input spikes
* Authors: Rushat Rout, Rishi Malladi
* Date: 04/06/2022
================================================================

*/



module replay_buffer_body
#(
    parameter BUFFER_DEPTH = 'd16
) (
    input data_in,
    input rst,
    input grst,
    input clk,
    input buf_sel,
    input [$clog2(BUFFER_DEPTH):0]wr_idx,
    input [$clog2(BUFFER_DEPTH):0]rd_idx,
    input start_count,
    output logic data_out 

);
    
    bit [BUFFER_DEPTH-1:0] buffer[1:0];

    assign data_out = buf_sel ? buffer[1][rd_idx] : buffer[0][rd_idx];
    
    always_ff@(posedge clk) begin
        
        if(rst) begin
            buffer[0][wr_idx] <= 'd0; 
            buffer[1][wr_idx] <= 'd0; 
        end
        else begin
            if(buf_sel) begin
                buffer[0][wr_idx] <= data_in; 
            end else begin 
                buffer[1][wr_idx] <= data_in; 
            end
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

module replay_buffer_per_ip
#(
    parameter NUM_INPUTS = 'd2,
    parameter BUFFER_DEPTH = 'd16
 ) (
    
    input [NUM_INPUTS-1: 0] data_in,
    input rst,
    input grst,
    input clk,
    input buf_sel,
    input [$clog2(BUFFER_DEPTH):0]wr_idx,
    input [$clog2(BUFFER_DEPTH):0]rd_idx,
    input start_count,
    input mux_sel,
    output logic data_out 

);

    wire [NUM_INPUTS-1:0] interim_out;

    genvar i;
    
    for(i=0; i<NUM_INPUTS; i++) begin
      replay_buffer_body #(.BUFFER_DEPTH(BUFFER_DEPTH)) rbb (.data_in(data_in[i]), .rst(rst), .grst(grst), .clk(clk), .buf_sel(buf_sel), .wr_idx(wr_idx), .rd_idx(rd_idx), .start_count(start_count), .data_out(interim_out[i]));
    end
    
    mux #(.NUM_INPUTS(NUM_INPUTS)) m0 (.in(interim_out), .sel(mux_sel), .out(data_out));

endmodule


module replay_buffer
#(
    parameter NUM_INPUTS = 'd2,
    parameter BUFFER_DEPTH = 'd16,
    parameter P='d64
) (
    input [P-1: 0] data_in1,
    input [P-1: 0] data_in2,
    input rst,
    input grst,
    input clk,
    input start_count,
    output logic [P-1: 0] data_out 
);
    bit buf_sel;
    bit [$clog2(BUFFER_DEPTH):0]wr_idx, pre_wr_idx, rd_idx;
    //bit start_count;

    logic mux_sel;
    
    assign rd_idx = pre_wr_idx * 'd2;

    assign mux_sel = grst;
    
    //Generating common clock and idx for all buffers
    always_ff@(posedge clk) begin
        
        if(rst) begin
            wr_idx <= 'd0;
            pre_wr_idx <= 'd0; 
        end
        else begin
            if(start_count) begin
                if(wr_idx < BUFFER_DEPTH-1) begin 
                    wr_idx         <= wr_idx + 1'd1; 
                end
                else begin
                    wr_idx         <= 'd0; 
                end
                if(pre_wr_idx < (BUFFER_DEPTH/2)-1) begin
                    pre_wr_idx <= pre_wr_idx + 'd1;
                end
                else begin
                    pre_wr_idx <= 'd0;
                end
            end else begin
                wr_idx <= 'd0;
                pre_wr_idx <= 'd0;
            end
        end
    
    end

    //always_ff @(posedge grst) begin
    //    if(rst) begin
    //        start_count <= 'd0;
    //        buf_sel <= 1'd0;
    //        
    //    end
    //    else begin
    //        start_count <= 'd1;
    //        buf_sel <= ~buf_sel;
    //    end
    //end

    genvar i;

    for(i=0; i<P; i++) begin
        replay_buffer_per_ip #(.BUFFER_DEPTH(BUFFER_DEPTH), .NUM_INPUTS(NUM_INPUTS)) rbb_ip (.data_in({data_in1[i],data_in2[i]}), .rst(rst), .grst(grst), .clk(clk), .buf_sel(buf_sel), .wr_idx(wr_idx), .rd_idx(rd_idx), .start_count(start_count), .mux_sel(mux_sel), .data_out(data_out[i]));
    end
    
endmodule

`ifdef REPLAY_BUFFER_TB
module buffer_test;

   bit rst, grst, clk; 
   bit [63:0] data_in1, data_in2;
   bit [63:0] data_out; 


    replay_buffer #(.P(64)) m_rp0 (.data_in1(data_in1), .data_in2(data_in2), .rst(rst), .grst(grst), .clk(clk), .data_out(data_out));


   always #10 clk = ~clk;
   always #100 grst = ~grst;

   initial begin 
        rst = 1'd1;
        clk = 'd1;
        grst = 'd0;
        data_in1 = 64'd0;
        data_in2 = 64'd0;

        #60
        rst = 1'd0;
        #10
        for(int i = 0; i < 100; i = i+1) begin 
               #20 data_in1 = $random;
               #20 data_in2 = $random;
        end

        rst = 1'd1;
        clk = 'd1;
        grst = 'd0;
        data_in1 = 64'd0;
        data_in2 = 64'd0;

        #60
        rst = 1'd0;
        #10
        for(int i = 0; i < 100; i = i+1) begin 
               #20 data_in1 = $random;
               #20 data_in2 = $random;
        end

   #100     
   $finish;  
   end

endmodule
`endif



 
