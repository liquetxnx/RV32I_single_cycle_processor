# RV32I-single_cycle_processor

# 0.TL

- Core : RV32I single cycle processor (Verilog)
- Support : R, I, S, B, J, U type (only lw and sw are supported in loading and store instrution)
- Addressing : PC and IM is byte-addressed otherwise, Memory are word-addressed.
- Endians : Little - endians (RISC-V default)
- Verification : self-checking C-code excuted by tb_cpu.v
- Run : make, (and "gtkwave waves_cpu.vcd")

## Environment :
- 	Linux
-	Icarus Verilog
-	GTKWave for wave form viewing

## Run (manual)
-	make
-	gtkwave cpu.vcd

## Expected output(file)
- trace.log (log data when reg_write, mem_write happen)
- waves_cpu.v (simulation data)

# 1.Project Overview

**Goals**
-	Make single core which can excute c code
-	Clean and readable datapath/control
-	Deterministric simulation
-	Verification-first work flow

**None Goals**
-	No CSR/privilege/interrupt
-	No MUL and DIV for (RV32M)
-	Misaligned access handling

# 2. Architecture

- Block Diagaram

![Block diagram](Image/risc-v rv32i-47.jpg)

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
- Effective address is byte addresses; 
	- DMEM_index = alu_result >> 2
	- It is implemented by DMEM_index = alu_result[6:2]
- ***lb/lh/sb/sh are not supported*** in my processor.

- Instrution is stored by 2-byte little endians in IM.
	- For example, Instruction `0x01020304` is stored by `04 03 02 01` in IM

# 4. Implmented Instructions

> Note: Only **word** load/store are implemented: `lw`, `sw`  
> Byte/halfword memory ops are **not** supported: `lb/lh/lbu/lhu/sb/sh`

| Type | Instructions | Status | Notes |
|---|---|---:|---|
| R | `add`, `sub`, `sll`, `slt`, `sltu`, `xor`, `srl`, `sra`, `or`, `and` | ✅ | Full RV32I R-type ALU ops |
| I (ALU) | `addi`, `slti`, `sltiu`, `xori`, `ori`, `andi`, `slli`, `srli`, `srai` | ✅ | Shift-immediate included |
| I (Load) | `lw` | ✅ | **Word only** |
| S (Store) | `sw` | ✅ | **Word only** |
| B | `beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu` | ✅ | Branch compare + PC redirect |
| U | `lui`, `auipc` | ✅ | Large constant / PC-relative |
| J | `jal` | ✅ | Link register writeback |
| I (Jump) | `jalr` | ✅ | Target = `(rs1 + imm) & ~1` |
| System | `ecall`, `ebreak` | ❌ | Not implemented (no trap/CSR) |
| FENCE | `fence`, `fence.i` | ❌ | Not implemented |
| Misaligned | — | ❌ | Misaligned memory access not handled |
| RV32M | `mul/div/rem*` | ❌ | Not implemented |



# 5. Verification 


## What this verifies

- Branch path: loop condition A < B, z==B and early break

- Jump/Link path: jalr via function pointer call (fp(A)) and jal path

- ALU + immediate generation: addi-style arithmetic and immediate decoding

- Large constant generation: 0x123456 produced by lui + addi

- Data memory path: sw then lw through a fixed memory-mapped address (0x200)

## Simulation outputs

- trace.log
	- prints register writeback events: pc, rd, wdata
	- prints store events: pc, store addr, wdata
	- (cycle count is not printed)

- waves_cpu.vcd
	- waveform dump for debugging in GTKWave