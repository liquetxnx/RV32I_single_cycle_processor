module IM(
    input wire [31:0] next_address,
    output wire [31:0] Instr
);

//4KB IM
reg [7:0] mem [0:8191];//mem은 총 32 index를 가지며 각 index마다 1024bit의 값을 가진다. , that is, word-addressed.

//wire [9:0] idx = next_address[11:2]; 

/*mem[0]=32'h00200093;
mem[1]=32'h00300113;
mem[2]=32'h001101B3;
*/
initial begin
    $display("Start");
    $readmemh("prog.hex", mem);
    $display("end");
end

assign Instr={mem[next_address+3], mem[next_address+2], mem[next_address+1], mem[next_address] };
endmodule