/*
============================================================================
* Implements the de-multiplexing logic of multiplexed output signals so that 
* the outputs corresponding to a specific network are segregated. 
* Authors: Rushat Rout, Rishi Malladi
* Date: 04/26/2022
============================================================================


*/
module replay_buffer_demux_per_wire # (
                  parameter GAMMA_CYCLE_LENGTH = 'd18
                  ) 
( 
    input logic muxed_output_spikes,
    input logic clk,
    input logic rst,
    input start_count,
    input buf_sel,
    input network_buf_sel,
    input [$clog2(GAMMA_CYCLE_LENGTH)-1:0] cycle_counter,
    input [$clog2(GAMMA_CYCLE_LENGTH)-1:0] wr_idx,
    output logic [1:0]demuxed_output_spikes
         
); 
logic [GAMMA_CYCLE_LENGTH-1:0] demuxed_buffer1 [1:0];
logic [GAMMA_CYCLE_LENGTH-1:0] demuxed_buffer2 [1:0];

    always_ff@(posedge clk) begin
        if(rst | ~start_count) begin
            demuxed_output_spikes[0] <= 'd0;
            demuxed_output_spikes[1] <= 'd0;
            demuxed_buffer1[0] <= {GAMMA_CYCLE_LENGTH{1'd0}};
            demuxed_buffer1[1] <= {GAMMA_CYCLE_LENGTH{1'd0}};
            demuxed_buffer2[0] <= {GAMMA_CYCLE_LENGTH{1'd0}};
            demuxed_buffer2[1] <= {GAMMA_CYCLE_LENGTH{1'd0}};
        end
        else begin
            if (buf_sel) begin
                //storing input data
                if(network_buf_sel) begin
                    demuxed_buffer1[0][wr_idx] <= muxed_output_spikes;
                    demuxed_buffer1[0][wr_idx+1] <= muxed_output_spikes;
                end else begin
                    demuxed_buffer1[1][wr_idx] <= muxed_output_spikes;
                    demuxed_buffer1[1][wr_idx+1] <= muxed_output_spikes;
                end
                //Writing output serially
                demuxed_output_spikes[0] <= demuxed_buffer2[0][cycle_counter];
                demuxed_output_spikes[1] <= demuxed_buffer2[1][cycle_counter];
            end else begin 
                //storing input data
                if(network_buf_sel) begin
                    demuxed_buffer2[0][wr_idx] <= muxed_output_spikes;
                    demuxed_buffer2[0][wr_idx+1] <= muxed_output_spikes;
                end else begin
                    demuxed_buffer2[1][wr_idx] <= muxed_output_spikes;
                    demuxed_buffer2[1][wr_idx+1] <= muxed_output_spikes;
                end
                //Writing output serially
                demuxed_output_spikes[0] <= demuxed_buffer1[0][cycle_counter];
                demuxed_output_spikes[1] <= demuxed_buffer1[1][cycle_counter];
            end
        end
    end

endmodule

module replay_buffer_demux # (
                  parameter Q='d2,
                  parameter GAMMA_CYCLE_LENGTH = 'd18
                  ) 
( 
    input logic [Q-1:0] muxed_output_spikes,
    input logic clk,
    input logic grst,
    input logic grst_2x,
    input logic rst,
    input start_count,
    input [$clog2(GAMMA_CYCLE_LENGTH)-1:0] cycle_counter,
    input [$clog2(GAMMA_CYCLE_LENGTH/2)-1:0] half_cycle_counter,
    output logic [Q-1:0][1:0]demuxed_output_spikes
         
); 

     

bit [$clog2(GAMMA_CYCLE_LENGTH)-1:0] wr_idx;
logic network_buf_sel, buf_sel;
assign wr_idx = half_cycle_counter * 'd2;
assign network_buf_sel = grst_2x;
assign buf_sel = grst;

genvar i;

for(i=0; i<Q; i++) begin
    replay_buffer_demux_per_wire #(.GAMMA_CYCLE_LENGTH(GAMMA_CYCLE_LENGTH))
                                rb_per_wire (
                                    .muxed_output_spikes(muxed_output_spikes[i]),
                                    .clk(clk),
                                    .rst(rst),
                                    .start_count(start_count),
                                    .buf_sel(buf_sel),
                                    .network_buf_sel(network_buf_sel),
                                    .cycle_counter(cycle_counter),
                                    .wr_idx(wr_idx),
                                    .demuxed_output_spikes(demuxed_output_spikes[i])
                                );
end

endmodule


`ifdef RB_DEMUX_TB
module demux_tb();

    parameter GAMMA_CYCLE_LENGTH = 'd18;
    parameter Q = 'd2;

    bit [Q-1:0] muxed_output_spikes;
    bit clk;
    bit grst;
    bit grst_2x;
    bit rstb;
    bit start_count;
    bit [$clog2(GAMMA_CYCLE_LENGTH)-1:0] cycle_counter;
    bit [$clog2(GAMMA_CYCLE_LENGTH/2)-1:0] half_cycle_counter;
    bit [Q-1:0][1:0]demuxed_output_spikes;


always #10 clk = ~clk;
always #360 grst = ~grst;
always #180 grst_2x = ~grst_2x;


start_counting sc0 (.rst(rstb), .grst(grst), .start_count(start_count));

cycle_counter #(.GAMMA_CYCLE_LENGTH(GAMMA_CYCLE_LENGTH)) c_counter (.rst(rstb), .clk(clk), .start_count(start_count), .counter(cycle_counter));

cycle_counter #(.GAMMA_CYCLE_LENGTH(GAMMA_CYCLE_LENGTH/2)) c_half_counter (.rst(rstb), .clk(clk), .start_count(start_count), .counter(half_cycle_counter));

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
                        .demuxed_output_spikes(demuxed_output_spikes)
                    ); 
        

initial begin 

        rstb = 1'd1;
        clk = 1'd1;
        grst = 1'd0;
        grst_2x = 1'd1;
        muxed_output_spikes = 'd0;
        #100
        rstb = 1'd0;

        for(int i = 0; i < 100; i = i+1) begin 
                #20 muxed_output_spikes = $random;
                
        end

        


#1000
$finish;
end

endmodule
`endif
