//RV32I ALU
//ADD, SUB, AND, OR ,XOR, SLL, SRL, SRA, SLT, SLTU

module ALU(

    input wire [31:0] a,
    input wire [31:0] b,
    input wire [3:0] alu_op,
    
    output reg [31:0] result,
    output wire BrEq, // branch 용 output. 
    output wire BrLt,
    output wire BrLtU
);

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

wire signed [31:0] sa = a;
wire signed [31:0] sb = b;
wire [4:0] shamt = b[4:0];


always @(*) begin
    case(alu_op)
        ADD: result = a+b;
        SUB: result = a-b;
        AND: result = a&b;
        OR : result = a|b;
        XOR: result = a^b;
        SLL: result = a << shamt;
        SRL: result = a >> shamt;
        SRA: result = sa >>> shamt;//verilog는 산술 시프트도 제공한다. 개꿀
        SLT: result = (sa < sb);//참이면 알아서 1을 result에 저장, 아니면 0 저장
        SLTU:result = (a < b);
        default: result = 32'b0;
        
    endcase
end

    wire overflow = (a[31] == b[31]) && (result[31] != a[31]);

    assign BrEq = (result==32'b0);
    assign BrLt = overflow^result[31];
    assign BrLtU = result[31];

    
    //질문 : r, i type에서 계산결과가 0일수도 있는거 아닌가? 그럼 zero는 1을 가져 branch가 일어나는거 아님?
    // 답 : control unit에서 branch일 경우 opcode를 zero와 연산해서 pcsrc를 조절하면 됨.

endmodule
