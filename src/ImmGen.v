/*
    ImmGen made by liquetxnx on 2025/10

*/

module ImmGen(
    input wire [31:0] instr,
    input wire [2:0] immSrc,


    output reg [31:0] Imm
);

/*
    immSrc
    000 : I-type

    001 : S-type

    010 : B-type

    011 : J-type
    
    100 : U-type

    101, 110, 111 : are not used
*/
wire [31:0] imm_i = {{20{instr[31]}},instr[31:20]};
wire [31:0] imm_s = {{20{instr[31]}},instr[31:25],instr[11:7]};
wire [31:0] imm_b = {{20{instr[31]}},instr[7], instr[30:25], instr[11:8], 1'b0};
wire [31:0] imm_j = {{12{instr[31]}},instr[19:12],instr[20],instr[30:21],1'b0};
wire [31:0] imm_u = {instr[31:12],12'b0};


always @(*) begin
    case(immSrc) 
        3'b000 : Imm = imm_i;
        3'b001 : Imm = imm_s;
        3'b010 : Imm = imm_b;
        3'b011 : Imm = imm_j;
        3'b100 : Imm = imm_u;
        default : Imm = 32'd0;
    endcase

end


endmodule