//무조건!! boolean logic으로 디코딩만 한다. 즉 일반연산 기호(+,- .. )는 사용하지 않는다. 왜? 여기에 ripple adder 같은거 생기면 안되기 때문


module Control_Unit(
    input wire [6:0] opcode,

    output reg A_Sel,
    output reg B_Sel,
    output reg [1:0] ALU_Op,//초기값 00으로 고정(더하기 연산)
    output reg [1:0] PcSrc,
    output reg RegWrite,
    output reg MemWrite,
    output reg [1:0] MemtoReg, // default 00으로 고정
    output reg [2:0] ImmSrc
);

localparam R_type = 7'b0110011; // ADD x3 x1 x2 (그냥 연산, x3 <- x1 + x2) 10가지 연산 구분 필요 : 10
localparam I_type = 7'b0010011; // ADDI x2 x1 10 (상수 연산, x2 <- x1+10) sub 제외 9가지 연산 구분 필요 : 11
localparam IL_type =7'b0000011; // LW x1 10(x2) (메모리 읽기(x1 <- MEM(x2+10))) 더하기 연산 필요 :00
localparam S_type = 7'b0100011; // SW x1 10(x2) (메모리 쓰기(x1 -> MEM[x2+10])) 더하기 연산 필요 :00
localparam B_type = 7'b1100011; // BEQ x1 x2 offset (조건 분기) 뺄셈 연산 필요 :01
localparam U_type = 7'b0110111; // LUI x1 imm20 (큰 상수 상위 20비트 로드) 연산 상관X->00
localparam AUI_type= 7'b0010111; // AUIPC : PC+상위 20 bit를 rd에 load->00
localparam J_type = 7'b1101111; // JAL x1 offset (무조건 점프) 연산 상관X : 00
localparam JALR   = 7'b1100111; //I-type형 점프 , 더하기 연산 필요 : 00


always @(*) begin
    case(opcode)

    R_type: begin
        A_Sel=0; B_Sel=0; ALU_Op=2'b10; PcSrc =2'b00; RegWrite= 1; MemWrite=0; MemtoReg = 2'b00; ImmSrc = 3'b101;//안쓰는것 중 하나 그냥 고르기 어차피 연산에 영향 X
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
        A_Sel=0;/*default*/ B_Sel=0;/*default*/ ALU_Op=2'b00;/*default*/ PcSrc =2'b01; RegWrite= 1; MemWrite=0; MemtoReg = 2'b00;/*default*/ ImmSrc = 3'b011;
    end


    JALR : begin
        A_Sel=0; B_Sel=1; ALU_Op=2'b00; PcSrc =2'b10; RegWrite= 1; MemWrite=0; MemtoReg = 2'b11; ImmSrc = 3'b100;
         //jalr은 top module에서 따로 LSB 0으로 추가하는 코드 써줘야함. 기억하자.
    end


    default : begin
        A_Sel=0; B_Sel=0; ALU_Op=2'b00; PcSrc =2'b00; RegWrite= 0; MemWrite=0; MemtoReg = 2'b00; ImmSrc = 3'b000;
    end
    endcase


end

endmodule