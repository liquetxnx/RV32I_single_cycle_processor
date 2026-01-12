`timescale 1ns/1ps

module tb_ImmGen;

reg [31:0] instr;
reg [2:0] immSrc;
wire [31:0] Imm;

integer i;

ImmGen DUT(
    .instr(instr),
    .immSrc(immSrc),
    .Imm(Imm)
);

initial begin
    $dumpfile("waves_ImmGen.vcd");
    $dumpvars(0,tb_ImmGen);
end

initial instr =32'b10101010101010101010101010101010;

initial begin
    immSrc =3'b000;
    for(i=0;i<4;i=i+1) begin
        #100
        immSrc=immSrc+1;
    end
end

initial begin
    #1000
    $finish;
end

endmodule
