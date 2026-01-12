module Data_path(
    input wire clk,
    input wire reset,
    input wire A_Sel,
    input wire B_Sel,
    input wire [1:0] ALU_Op,
    input wire [1:0] PcSrc,
    input wire RegWrite,
    input wire MemWrite,
    input wire [1:0] MemtoReg,
    input wire [2:0] ImmSrc,


    output wire [6:0] Opcode
);


//Instance Declaration

    wire [31:0] pc_prev;
    wire [31:0] pc_next;

    wire [31:0] pc_plus4;
    
    wire [31:0] instr;

    wire [31:0] rs1_output;
    wire [31:0] rs2_output;
    wire [31:0] write_back_line;

    wire [31:0] imm;

    wire [3:0] alu_op;

    wire [31:0] a;
    wire [31:0] b;
    wire [31:0] alu_out;

    wire breq;
    wire brlt;
    wire brltu;

    wire [1:0] pcsrc;

    wire [31:0] mem_output;
//---------------------------------



/* ---PC BLOCK---*/
    PC pc_inst (
        .clk(clk),
        .reset(reset),
        .input_next_address(pc_prev),
        .output_next_address(pc_next)
    );
    
     PC_Next pc_next_inst(
        .Current_pc(pc_next),
        .Imm(imm),
        .ALU_Output(alu_out),
        .PcSrc(pcsrc),
        .Next_Address(pc_prev),
        .Pc_Plus4(pc_plus4)

    );
//-------------------


//-------IM Block------
    IM im_inst (
        .next_address(pc_next),
        .Instr(instr)
    );
//----------------------


//For Control Unit input
assign Opcode = instr[6:0];


//------Reg Block-------
    Reg_File reg_inst(
        .clk(clk),
        .reset(reset),
        .RegWrite(RegWrite),
        .rs1(instr[19:15]),
        .rs2(instr[24:20]),
        .rd(instr[11:7]),
        .WD(write_back_line),

        .rs1_output(rs1_output),
        .rs2_output(rs2_output)
    );
//----------------------


//------ImmGen Block-------
    ImmGen immgen_inst (
        .instr(instr),
        .immSrc(ImmSrc),
        .Imm(imm)
    );
//-------------------------


//------ALU Related Block----
    Mux_2to1 a_selec_mux(
        .a(rs1_output),
        .b(pc_next),
        .sel(A_Sel),
        .out(a)
    );

    Mux_2to1 b_selec_muxo(
        .a(rs2_output),
        .b(imm),
        .sel(B_Sel),
        .out(b)
    );

    ALU_Control alu_con_inst(
        .Instr(instr),
        .ALU_Op(ALU_Op),
        .alu_op(alu_op)
    );

    ALU alu_inst (
        .a(a),
        .b(b),
        .alu_op(alu_op),
        .result(alu_out),
        .BrEq(breq),
        .BrLt(brlt),
        .BrLtU(brltu)
    );
//-----------------------------


//----------Branch Block-----------
    Branch_Unit branch_inst (
        .PcSrc(PcSrc),
        .BrEq(breq),
        .BrLt(brlt),
        .BrLtU(brltu),
        .funct3(instr[14:12]),
        .pcsrc(pcsrc)
    );
//----------------------------------


//----------Memory Block------------
    Memory mem_inst (
        .clk(clk),
        .MemWrite(MemWrite),
        .memory_address(alu_out),
        .WD2(rs2_output),
        .Data(mem_output)
    );
//---------------------------------


//----------Write Back MUx------------
    Mux_4to1 mux4to1_inst(
        .a(alu_out),
        .b(mem_output),
        .c(imm),
        .d(pc_plus4),

        .sel(MemtoReg),
        .out(write_back_line)
    );
   

endmodule