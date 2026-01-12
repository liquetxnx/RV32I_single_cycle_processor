`timescale 1ns/1ps

module tb_ALU;

reg [31:0] a;
reg [31:0] b;

reg [3:0] alu_op;

wire [31:0] result;
wire BrEq;
wire BrLt;
wire BrLtU;
integer i;

ALU DUT(
    .a(a),
    .b(b),
    .alu_op(alu_op),
    .result(result),
    .BrEq(BrEq),
    .BrLt(BrLt),
    .BrLtU(BrLtU)
);

initial begin
    $dumpfile("waves_ALU.vcd");
    $dumpvars(0,tb_ALU);
end

initial a =32'b10101010101010101010101010101010;
initial b =32'b10101010101010101010101010101010;


initial begin
    #500
    a=~a;
    b=~b;
end
initial begin
    alu_op =4'b0001;
    for(i=0;i<10;i=i+1) begin
        #50;
        alu_op=alu_op+1;
    end
end

initial begin
    #1000;
    $finish;
end

endmodule
