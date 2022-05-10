/*
================================================================
* Implements the a simple count enable that tells us where to 
* start counting from at reset
* Authors: Rushat Rout, Rishi Malladi
* Date: 04/06/2022
================================================================

*/

module start_counting (
    input logic rst,
    input logic grst,
    output logic start_count

);

always_ff @(posedge grst) begin
    if(rst) begin
        start_count <= 'd0;
        
    end
    else begin
        start_count <= 'd1;
    end
end

endmodule
