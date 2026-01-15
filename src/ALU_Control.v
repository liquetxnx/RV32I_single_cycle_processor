/*
    ALU control made by liquetxnx on 2025/12

    ALU_control is separated by Control_ unit 

    : Control unit is too heavy if add alu_control

*/


module ALU_Control(
    input wire [31:0] Instr,
    input wire [1:0] ALU_Op,
    
    output reg [3:0] alu_op

);

wire [2:0] funct3 = Instr[14:12];
wire [6:0] funct7 = Instr[31:25];

localparam ADD = 4'b0001;
localparam SUB = 4'b0010;
localparam AND = 4'b0011;
localparam OR  = 4'b0100;
localparam XOR = 4'b0101;
localparam SLL = 4'b0110; // just shift left
localparam SRL = 4'b0111; // just shift right
localparam SRA = 4'b1000; // shift right but remain original sign
localparam SLT = 4'b1001; // set less than
localparam SLTU= 4'b1010; // not considered signed : less than


always @(*) begin
    case(ALU_Op)
    2'b00 : alu_op=ADD;
    2'b01 : alu_op=SUB;
    2'b10 : begin
        //R-Type
        case (funct3)
        3'b000 : alu_op=(funct7[5] ? SUB : ADD);
        3'b001 : alu_op=SLL;
        3'b010 : alu_op=SLT;
        3'b011 : alu_op=SLTU;
        3'b100 : alu_op=XOR;
        3'b101 : alu_op=(funct7[5] ? SRA : SRL);
        3'b110 : alu_op=OR;
        3'b111 : alu_op=AND;
        default: alu_op=ADD;

        endcase
    end
    
    2'b11 : begin
        //I-type
        case(funct3)
        3'b000 : alu_op=ADD;
        3'b001 : alu_op=SLL;
        3'b010 : alu_op=SLT;
        3'b011 : alu_op=SLTU;
        3'b100 : alu_op=XOR;
        3'b101 : alu_op=(funct7[5] ? SRA : SRL);
        3'b110 : alu_op=OR;
        3'b111 : alu_op=AND;
        default: alu_op=ADD;
        endcase
    end
    
    default:alu_op= ADD;
    endcase
end
endmodule