/*
    Top_module made by liquetxnx on 2025/12

*/

module Top_module(
    input reset,
    input clk
);

wire [6:0] opcode;

wire A_Sel;
wire B_Sel;
wire [1:0] ALU_Op;
wire [1:0] PcSrc;
wire RegWrite;
wire MemWrite;
wire [1:0] MemtoReg;
wire [2:0] ImmSrc;


Control_Unit control_inst(
    .opcode(opcode),
    .A_Sel(A_Sel),
    .B_Sel(B_Sel),
    .ALU_Op(ALU_Op),
    .PcSrc(PcSrc),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .ImmSrc(ImmSrc)
    
);

Data_path datapath_inst(
    .reset(reset),
    .clk(clk),
    .A_Sel(A_Sel),
    .B_Sel(B_Sel),
    .ALU_Op(ALU_Op),
    .PcSrc(PcSrc),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .ImmSrc(ImmSrc),

    .Opcode(opcode)
);


endmodule



