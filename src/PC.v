/*
    일단 reset input은 안넣었음. 후에 고민해보자
    
*/

module PC(
    input wire clk,
    input wire reset,
    input wire[31:0] input_next_address,
    output reg [31:0] output_next_address

);


//assign pc_next = (PCsrc) ? (pc+imm) : (pc+32'd4); // PCsrc는 조합논리회로에서 작동한다! sequence 회로를 나타내는 always 구문안에 넣지 말자

always @(posedge clk) begin // sequence logic에서는 무조건 reg에만 할당할 수 있다!
    if (reset) begin
        output_next_address = 0;
    end

    else output_next_address <= input_next_address;
end


endmodule