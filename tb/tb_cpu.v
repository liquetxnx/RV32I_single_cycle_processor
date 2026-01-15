/*
    Sigle cycle processor Testbench made by liquetxnx 2026/1
*/

`timescale 1ns/1ps

module tb_cpu;

integer fd;
initial fd=$fopen("trace.log","w");

integer result;
initial result=$fopen("Verification_result","w");


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
    $dumpvars(0,tb_cpu.DUT.datapath_inst);
    $dumpvars(0,tb_cpu.DUT.datapath_inst.pc_next_inst);
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
`define RAM DUT.datapath_inst.mem_inst.RAM

initial begin
     $fdisplay(fd,"Type:: pc: hexa  reg_indx: deci, mem_addr: hexa  wdata: deci\n");
end

reg done;  // timeout 검사 1회만 실행하기 위한 플래그
initial done = 0;

integer pass_cnt, fail_cnt;

task automatic CHECK_RAM;
    input integer fd;
    input integer idx;
    input [31:0] expect;
    input [200:0] name;
    reg [31:0] actual;
begin
    actual = `RAM[idx];
    if (actual === expect) begin
        $fdisplay(fd, "%s : PASS  (RAM[%0d]=0x%08h)", name, idx, actual);
        pass_cnt = pass_cnt + 1;
    end else begin
        $fdisplay(fd, "%s : FAIL  (RAM[%0d]=0x%08h, expect=0x%08h)", name, idx, actual, expect);
        fail_cnt = fail_cnt + 1;
    end
end
endtask


always @(posedge clk) begin
    cycles <= cycles + 1;

    if (!reset) begin
        if (`REG_SIG) $fdisplay(fd,"REG :: pc= %h \treg_indx=%8d  \t wdata=%8d", `PC_SIG, `INSTR[11:7], `WDATA);
        if (`MEM_SIG) $fdisplay(fd,"MEM :: pc= %h \tmem_addr=%08h \t wdata=%8d", `PC_SIG, `ALU_OUT, `MEM_DATA);
    end

    // timeout 시점에서 딱 1번만 실행
    if ((cycles > MAX_CYCLES) && !done) begin
        done = 1;

        pass_cnt = 0;
        fail_cnt = 0;

        // =========================================================
        // (0)Load, Store 결과 검사 (RAM[128]~RAM[137])
        // =========================================================
        CHECK_RAM(result, 128, 32'hFFFF_FFFC, "I-type : lw"); 
        CHECK_RAM(result, 128, 32'hFFFF_FFFC, "S-type : sw"); 


        // =========================================================
        // (1)R-type 결과 검사 (RAM[128]~RAM[137])
        // =========================================================
        CHECK_RAM(result, 128, 32'hFFFF_FFFC, "R-type : add");

        CHECK_RAM(result, 129, 32'd16,        "R-type : sub");
        CHECK_RAM(result, 130, 32'd1536,      "R-type : sll");

        CHECK_RAM(result, 131, 32'h3FFF_FFFD, "R-type : srl");

        CHECK_RAM(result, 132, 32'hFFFF_FFFD, "R-type : sra");      // -3

        CHECK_RAM(result, 133, 32'd1,         "R-type : slt");
        CHECK_RAM(result, 134, 32'd0,         "R-type : sltu");

        CHECK_RAM(result, 135, 32'hFFFF_F9FD, "R-type : xor");
        CHECK_RAM(result, 136, 32'hFFFF_FFFD, "R-type : or");
        CHECK_RAM(result, 137, 32'h0000_0600, "R-type : and");


        // =========================================================
        //  (2) I type 검사
        // =========================================================
        CHECK_RAM(result, 138, 32'hFFFF_FFFC, "I-type : addi");
        CHECK_RAM(result, 139, 32'd1536,      "I-type : slli");
        CHECK_RAM(result, 140, 32'hFFFF_FFFD, "I-type : srli");
        CHECK_RAM(result, 141, 32'h3FFF_FFFD, "I-type : srai");
        CHECK_RAM(result, 142, 32'd1,         "I-type : slti");
        CHECK_RAM(result, 143, 32'd0,         "I-type : sltui");
        CHECK_RAM(result, 144, 32'd14,        "I-type : xori");
        CHECK_RAM(result, 145, 32'd14,        "I-type : ori");
        CHECK_RAM(result, 146, 32'd0,         "I-type : andi");
        CHECK_RAM(result, 147, 32'd7,         "I-type : jalr");

        // =========================================================
        // (3) 추가: jal, branch, lui 검사
        // =========================================================
        
        CHECK_RAM(result, 148, 32'd1,         "B-type : beq and bne");
        CHECK_RAM(result, 149, 32'd1,         "B-type : blt and bge");
        CHECK_RAM(result, 150, 32'd0,         "B-type : bltu and bgeu");

        CHECK_RAM(result, 151, 32'h0012_3456, "U-type : lui");
        CHECK_RAM(result, 151, 32'h0012_3456, "J-type : JAL");
        CHECK_RAM(result, 152, 32'h7FFF_FFFF, "sig[23] = 0x7FFFFFFF : end sign");

        // =========================================================
        // 요약 출력
        // =========================================================
        $fdisplay(result, "==================================");
        $fdisplay(result, "TOTAL PASS = %0d", pass_cnt);
        $fdisplay(result, "TOTAL FAIL = %0d", fail_cnt);
        $fdisplay(result, "==================================");

        if (fail_cnt == 0) $display("ALL TEST PASSED ✅");
        else               $display("TEST FAILED ❌ fail=%0d", fail_cnt);

        $fflush(result);
        $fclose(result);

        $display("Timeout");
        $display("Complete Compiled");
        $finish;
    end
end

endmodule
