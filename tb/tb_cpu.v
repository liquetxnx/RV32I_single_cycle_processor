`timescale 1ns/1ps

module tb_cpu;

reg clk;
reg reset;
Top_module DUT(
    .clk(clk),
    .reset(reset)
);


integer cycles;
parameter MAX_CYCLES = 2000;

initial begin
    $dumpfile("waves_cpu.vcd");
    $dumpvars(0,tb_cpu.DUT.datapath_inst.pc_inst);
    $dumpvars(0,tb_cpu.DUT.datapath_inst.reg_inst);
    $dumpvars(0,tb_cpu.DUT.datapath_inst.alu_inst);   

end
initial clk=0 ;
initial reset=0;
initial cycles=0;

initial #2 reset=1;
initial #4 reset = 0;
always #1 clk = ~clk;


/*initial begin
  $dumpvars(0, DUT.datapath_inst.reg_inst.rg[3]); // reg array 자체를 dump
end
*/

always @(posedge clk)begin
    cycles <= cycles +1;
    if(cycles > MAX_CYCLES) begin
        $display("Timeout");
        $finish;
    end
end

endmodule
