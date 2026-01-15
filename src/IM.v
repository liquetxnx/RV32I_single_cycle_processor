/*
    IM made by liquetxnx on 2026/1

*/

module IM(
    input wire [31:0] next_address,
    output wire [31:0] Instr
);

//8KB IM
reg [7:0] mem [0:8191];

initial begin
    $readmemh("prog.hex", mem);
end

//little-endian

assign Instr={mem[next_address+3], mem[next_address+2], mem[next_address+1], mem[next_address] };
endmodule