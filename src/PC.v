/*
    pc resisger made by liquetxnx 2025/10
    
*/

module PC(
    input wire clk,
    input wire reset,
    input wire[31:0] input_next_address,
    output reg [31:0] output_next_address

);

always @(posedge clk) begin 
    if (reset) begin
        output_next_address = 0;
    end

    else output_next_address <= input_next_address;
end


endmodule