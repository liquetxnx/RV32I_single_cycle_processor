module Memory(
    input clk,
    input wire MemWrite,
    input wire [31:0] memory_address,
    input wire [31:0] WD2,

    output reg [31:0] Data

);

reg [31:0] RAM [0:1023];

/*
    Data will be written on Testbench source code.

*/
wire [9:0] DMEM_index = memory_address[11:2];

always @(posedge clk) begin
    if(MemWrite) begin
        RAM[DMEM_index] <= WD2;
        Data <= 32'd0;
    end

    else begin
        Data <= RAM[DMEM_index];
    end
end



endmodule