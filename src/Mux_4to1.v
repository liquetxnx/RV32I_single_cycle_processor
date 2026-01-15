/*
    Mux 4 to 1 made by liquetxnx on 2025/12

*/


module Mux_4to1(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [31:0] c,
    input wire [31:0] d,
    input wire [1:0] sel,

    output reg [31:0] out
);

always @(*) begin
    case(sel)
    2'b00 : out = a;
    2'b01 : out = b;
    2'b10 : out = c;
    2'b11 : out = d;
    endcase
end

endmodule