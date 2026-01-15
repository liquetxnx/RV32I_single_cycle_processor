/*
    Control unit made by liquetxnx on 2025/12

*/

module Control_Unit(
    input wire [6:0] opcode,

    output reg A_Sel,
    output reg B_Sel,
    output reg [1:0] ALU_Op,
    output reg [1:0] PcSrc,
    output reg RegWrite,
    output reg MemWrite,
    output reg [1:0] MemtoReg, 
    output reg [2:0] ImmSrc
);

localparam R_type = 7'b0110011; 
localparam I_type = 7'b0010011; 
localparam IL_type =7'b0000011; 
localparam S_type = 7'b0100011; 
localparam B_type = 7'b1100011; 
localparam U_type = 7'b0110111; 
localparam AUI_type= 7'b0010111; 
localparam J_type = 7'b1101111; 
localparam JALR   = 7'b1100111;


always @(*) begin
    case(opcode)

    R_type: begin
        A_Sel=0; B_Sel=0; ALU_Op=2'b10; PcSrc =2'b00; RegWrite= 1; MemWrite=0; MemtoReg = 2'b00; ImmSrc = 3'b101;
    end

    I_type: begin
        A_Sel=0; B_Sel=1; ALU_Op=2'b11; PcSrc =2'b00; RegWrite= 1; MemWrite=0; MemtoReg = 2'b00; ImmSrc = 3'b000;

    end

    IL_type: begin
        A_Sel=0; B_Sel=1; ALU_Op=2'b00; PcSrc =2'b00; RegWrite= 1; MemWrite=0; MemtoReg = 2'b01; ImmSrc = 3'b000;
    end


    S_type: begin
        A_Sel=0; B_Sel=1; ALU_Op=2'b00; PcSrc =2'b00; RegWrite= 0; MemWrite=1; MemtoReg = 2'b00;/*default*/ ImmSrc = 3'b001;
    end
        
    B_type:begin
        A_Sel=0; B_Sel=0; ALU_Op=2'b01; PcSrc =2'b01; RegWrite= 0; MemWrite=0; MemtoReg = 2'b00; ImmSrc = 3'b010;
    end

    U_type:begin
        A_Sel=0; B_Sel=0; ALU_Op=2'b00; PcSrc =2'b00; RegWrite= 1; MemWrite=0; MemtoReg = 2'b10; ImmSrc = 3'b100;
    end

    AUI_type : begin
        A_Sel=1; B_Sel=1; ALU_Op=2'b00; PcSrc =2'b00; RegWrite= 1; MemWrite=0; MemtoReg = 2'b00; ImmSrc = 3'b100;
    end

    J_type:begin
        A_Sel=0;/*default*/ B_Sel=0;/*default*/ ALU_Op=2'b00;/*default*/ PcSrc =2'b10; RegWrite= 1; MemWrite=0; MemtoReg = 2'b11;/*default*/ ImmSrc = 3'b011;
    end


    JALR : begin
        A_Sel=0; B_Sel=1; ALU_Op=2'b00; PcSrc =2'b11; RegWrite= 1; MemWrite=0; MemtoReg = 2'b11; ImmSrc = 3'b000;
         
    end


    default : begin
        A_Sel=0; B_Sel=0; ALU_Op=2'b00; PcSrc =2'b00; RegWrite= 0; MemWrite=0; MemtoReg = 2'b00; ImmSrc = 3'b000;
    end
    endcase


end

endmodule