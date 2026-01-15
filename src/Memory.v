module Memory(
    input clk,
    input wire MemWrite,
    input wire [31:0] memory_address,
    input wire [31:0] WD2,

    output wire [31:0] Data

);

reg [31:0] RAM [0:4095];

/*
    Data will be written on Testbench source code.

*/
wire [11:0] DMEM_index = memory_address[13:2];
    
assign Data = RAM[DMEM_index];
    
always @(posedge clk) begin
    if(MemWrite) begin
        RAM[DMEM_index] <= WD2;
    end
end



endmodule