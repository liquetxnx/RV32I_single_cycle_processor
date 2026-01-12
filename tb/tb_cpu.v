`timescale 1ns/1ps

module tb_cpu;

integer fd;
initial fd=$fopen("trace.log","w");

integer cycles;

localparam integer MAX_CYCLES = 2000;

reg clk;
reg reset;
Top_module DUT(
    .clk(clk),
    .reset(reset)
);


initial begin
    $dumpfile("waves_cpu.vcd");
    $dumpvars(0,tb_cpu.DUT.datapath_inst.pc_inst);
    $dumpvars(0,tb_cpu.DUT.datapath_inst.reg_inst);
    $dumpvars(0,tb_cpu.DUT.datapath_inst.alu_inst);   
    $dumpvars(0,tb_cpu.DUT.datapath_inst.immgen_inst);      

end

initial clk=0 ;
initial reset=0;
initial cycles=0;

initial #2 reset=1;
initial #4 reset = 0;
always #1 clk = ~clk;

`define PC_SIG DUT.datapath_inst.pc_next
`define WDATA DUT.datapath_inst.write_back_line
`define REG_SIG DUT.RegWrite
`define MEM_SIG DUT.MemWrite
`define MEM_DATA DUT.datapath_inst.rs2_output
`define INSTR DUT.datapath_inst.instr  
`define ALU_OUT DUT.datapath_inst.alu_out



always @(posedge clk)begin
    cycles <= cycles +1;

     if (!reset) begin
        if (`REG_SIG) $fdisplay(fd,"pc=%h rd=%d wdata=%d", `PC_SIG, `INSTR[11:7], `WDATA);
        if (`MEM_SIG) $fdisplay(fd,"pc=%h store addr=%h wdata=%d", `PC_SIG, `ALU_OUT, `MEM_DATA); //store
end
    
    if(cycles > MAX_CYCLES) begin
        $display("Timeout");
        $display("Complete Complied");
        $finish;
    end
end
endmodule
