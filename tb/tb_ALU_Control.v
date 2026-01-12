`timescale 1ns/1ps

module tb_ALU_Control;

reg [31:0] instr;
reg [1:0] in_alu_op;
wire [3:0] out_alu_op;

ALU_Control DUT(
    .Instr(instr),
    .ALU_Op(in_alu_op),
    .alu_op(out_alu_op)
);

initial begin
    $dumpfile("waves_ALU_Control.vcd");
    $dumpvars(0,tb_ALU_Control);
end

initial begin
    instr =32'h00000000;
    in_alu_op=2'b00;
end

initial begin
    forever begin
        #100;
        in_alu_op=in_alu_op+2'b01;
        
        instr[14:12] = 3'b111;
    end
end
initial begin
    forever begin
        #5;
        instr[30] = ~instr[30];
    end
end

initial begin
    forever begin
        #10;
        instr[14:12] = instr[14:12]+3'b001;
    end
end


initial begin
    #1000;
    $finish;
end

endmodule
