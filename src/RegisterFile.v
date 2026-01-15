/*
    Register_file made by liquetxnx on 2025/10

*/


module Reg_File(
    input wire clk,
    input wire reset,


    input wire RegWrite,


    input wire [4:0] rs1,// register r1 : instr[19:15]
    input wire [4:0] rs2, // register r2 : instr[24:20]
    input wire [4:0] rd, // register rd : instr[11:7]
    input wire [31:0] WD, // Write Data to Reg


    output wire [31:0] rs1_output, // this output go to ALU A input
    output wire [31:0] rs2_output
);

integer i;
reg [31:0] rg [31:0];


always @(posedge clk) begin
    rg[0] = 32'h0; //always fix x0 to 0
    if (reset) begin
        rg[2] = 32'h4000;//fix stack pointer 
    end

    if(RegWrite==1 && rd != 5'b0) begin
        rg[rd] <= WD;
    end
end


assign rs1_output = (rs1 == 5'b0)? 32'b0 : rg[rs1];
assign rs2_output = (rs2 == 5'b0)? 32'b0 : rg[rs2];

endmodule