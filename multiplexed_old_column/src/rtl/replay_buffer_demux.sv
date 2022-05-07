/*
============================================================================
* Implements the multiplexing logic of input spikes from different networks 
* Authors: Rushat Rout, Rishi Malladi
* Date: 04/26/2022
============================================================================


*/

module replay_buffer_demux # (
                  parameter Q='d2,
                  parameter GAMMA_CYCLE_LENGTH = 'd18,
                  ) 
( 
    input logic [Q-1:0] muxed_output_spikes,
    input logic clk,
    input logic grst,
    input logic rstb,
    input start_count,
    input [$clog2(GAMMA_CYCLE_LENGTH)-1:0] count,
    output logic [1:0][Q-1:0]demuxed_output_spikes
         
); 

     

logic [1:0]demuxed_buffer[Q-1:0];
bit [$clog2(GAMMA_CYCLE_LENGTH)-1:0] pre_idx, idx;
logic buf_sel = grst;
assign wr_idx = pre_idx * 'd2;




    always_ff@(posedge clk) begin
        
        if(rstb) begin
            pre_idx <= 'd0; 
        end
        else begin
            if(start_count) begin
                if(pre_idx > (GAMMA_CYCLE_LENGTH/2)-1) begin
                    pre_idx <= 'd0;
                end
                else begin
                    pre_idx <= pre_idx + 'd1;
                end
            end else begin
                pre_idx <= 'd0;
            end
  //TODO: Check  
            if(buf_sel) begin
                demuxed_buffer[0][wr_idx] <= muxed_output_spikes; 
                demuxed_buffer[0][wr_idx+1] <= muxed_output_spikes; 
            end else begin 
                demuxed_buffer[1][wr_idx] <= muxed_output_spikes; 
                demuxed_buffer[1][wr_idx+1] <= muxed_output_spikes; 
            end
            //Writing output serially
            demuxed_output_spikes[0] <= demuxed_buffer[0][count];
            demuxed_output_spikes[1] <= demuxed_buffer[1][count];
        end
    
    end

  always_ff @(posedge grst) begin
        if(rstb) begin
           // en[0] <= 1'd1;
           // en[1] <= 1'd0;
            start_count <= 'd0;
            enable <= 1'd0;
            
        end
        else begin
            //en[0] <= en[1];
            //en[1] <= ~en[1];
            start_count <= 'd1;
            enable <= ~enable;
        end
    end

//always_ff@(posedge inv_grst) begin 
//        if(rstb) begin 
//                demuxed_buffer[1] <= 'd0;
//        end
//        else begin 
//             for(int k=0; k < P; k=k+1) begin 
//                 demuxed_buffer[1][k] <= muxed_output_spikes[1];
//             end
//        
//        end
//end

//TODO: Using idx to assign
//assign data_out = enable? buffer[1][idx] : buffer[0][idx];

endmodule
