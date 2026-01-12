# RV32I-single_cycle_processor

# 0.TL

- Core : RV32I single cycle processor (Verilog)
- Support : R, I, S, B, J, U type
- Addressing : PC is byte-addressed otherwise, IM and Memory are word-addressed
- Verification : Directed and self-checking ([N] test cases excuted by tb_cpu.v)
- Run : iverilog && vvp command

## Environment :
-	Icarus Verilog
-	GTKWave for wave form viewing
## Run (manual)
-	iverilog -g2005 -o sim tb/tb_cpu.v src/Top_module.v src/*.v
-	vvp sim
-	gtkwave cpu.vcd

## Expected output
[Test] add sub … (PASS)

[Test] lw sw … (PASS)

[Test] branch… (PASS)

[SUMMARY] PASS=[N] FAIL=[0]


# 1.Project Overview

**Goals**
-	Clean and readable datapath/control
-	Deterministric simulation
-	Verification-first work flow
**None Goals**
-	No CSR/privilege/interrupt
-	No MUL and DIV for (RV32M)
-	Misaligned access handling

# 2. Architecture

- Block Diagaram

![risc-v rv32i-47](https://github.com/user-attachments/assets/0d38109a-828e-4713-a727-f238f6038ecf)


- Top module

	-Control unit

	-Data path

		-PC(register)

		-PC_next

		-Instruction Memory(IM)	

		-Register File

		-ALU

		-ALU_Control

		-Immediate Generation(ImmGen)

		-Memory

		-Branch_Unit

		-Mux 2 to 1

		-Mux 4 to 1


# 3. Addressing

- PC is byte address (increments by 4 byte) :
    - pc_next = pc + 4 (unless branch/jump)
- IM is stored as 32-bit words (array of mem[word_index])
- Instruction fetch uses word index :
	- im_index = pc >> 2
	- It is implemented by im_index = pc[6:2]
-  Therefore pc address must be word-aligned for correct instruction fetch.

- Data memory is also stored as 32-bit words like IM (array of mem[word_index])
- Effective address is byte addresses; use
	- DMEM_index = alu_result >> 2
	- It is implemented by DMEM_index = alu_result[6:2]
- lb/lh/sb/sh are not supported in my processor.

# 4. Implmented Instructions

All type on official RV32I document excepted lw sw are implemented.

I will update soon.

# 5. Verification 

I will update soon.


