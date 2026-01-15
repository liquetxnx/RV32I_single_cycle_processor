module PC_Next(
    input wire [31:0] Current_pc,
    input wire [31:0] Imm,
    input wire [31:0] ALU_Output,
    input wire [1:0] PcSrc,

    output reg [31:0] Next_Address,
    output wire [31:0] Pc_Plus4
);

wire [31:0] pc_plus4;
wire [31:0] pc_branch;
wire [31:0] pc_jalr;

assign pc_plus4 = Current_pc + 32'd4;
assign pc_branch = Current_pc + Imm;
assign pc_jalr = {ALU_Output[31:1],1'b0};

always @(*) begin
    
    case(PcSrc)
    2'b00 : Next_Address=pc_plus4;
    2'b01 : Next_Address=pc_branch;
    2'b10 : Next_Address=pc_branch;
    2'b11 : Next_Address=pc_jalr;
    default : Next_Address=pc_plus4;

    endcase

end

assign Pc_Plus4=pc_plus4;

endmodule