/*
================================================================
* Implements a counter that counts the number of clock cycles
* in a gamma-cycle
* Authors: Rushat Rout, Rishi Malladi
* Date: 04/06/2022
================================================================

*/

module cycle_counter #(
    GAMMA_CYCLE_LENGTH = 'd18
) (
    input logic rst,
    input logic clk,
    input logic start_count,
    output logic [$clog2(GAMMA_CYCLE_LENGTH)-1:0] counter
);

always @(posedge clk) begin
    if(rst) begin
        counter <= 'd0;
    end
    else begin
        if(start_count) begin
            if(counter < GAMMA_CYCLE_LENGTH-1) begin
                counter <= counter + 'd1;
            end
            else begin
                counter <= 'd0;
            end
        end else begin
            counter <= 'd0;
        end
    end
end


endmodule
