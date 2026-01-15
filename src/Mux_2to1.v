/*
    Mux 2 to 1 made by liquetxnx on 2025/12

*/

module Mux_2to1(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire sel,

    output wire [31:0] out
);

assign out=(sel)? b:a;

endmodule