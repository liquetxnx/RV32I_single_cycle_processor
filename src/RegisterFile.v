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


/*`ifdef SIM 
initial begin
    for(i=0;i<32;i++) rg[i]=32'b0; 
end
`endif
*/

always @(posedge clk) begin
    rg[0] = 32'h0; 
    if (reset) begin
        rg[2] = 32'h4000;//fix stack pointer 
    end

    if(RegWrite==1 && rd != 5'b0) begin
        rg[rd] <= WD;
    end
end


assign rs1_output = (rs1 == 5'b0)? 32'b0 : rg[rs1];
assign rs2_output = (rs2 == 5'b0)? 32'b0 : rg[rs2];

//assign WD2 = (rs2 == 5'b0) ? 32'b0 : rg[rs2];


//그냥 할당해도 되지만, 이건 시뮬레이션 상에서 reg를 초기화 했기 때문에 rg[0]이 정의가 된거지, 실제 칩상에서는 보장되지 않아서 이렇게 강제적으로 할당해줘야함.
endmodule