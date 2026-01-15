module Branch_Unit(
    input wire [1:0] PcSrc,
    input wire BrEq,
    input wire BrLt,
    input wire BrLtU,

    input wire [2:0] funct3,

    output reg [1:0] pcsrc
);

always @(*) begin
    if(PcSrc == 2'b01) begin
        
        case(funct3)
            3'b000 : pcsrc = (BrEq ? PcSrc : 2'b00 );
            3'b001 : pcsrc = (~BrEq ? PcSrc : 2'b00 );
            3'b100 : pcsrc = (BrLt ? PcSrc : 2'b00 );
            3'b101 : pcsrc = (~BrLt ? PcSrc : 2'b00 );
            3'b110 : pcsrc = (BrLtU ? PcSrc : 2'b00 );
            3'b111 : pcsrc = (~BrLtU ? PcSrc : 2'b00 );
            
            default pcsrc= PcSrc;
        endcase
    end

    else begin
        pcsrc = PcSrc;
    end

end


endmodule