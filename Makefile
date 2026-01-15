# ---- toolchain ----
CC      := riscv64-unknown-elf-gcc
OBJDUMP := riscv64-unknown-elf-objdump
OBJCOPY := riscv64-unknown-elf-objcopy

IVERILOG := iverilog
VVP      := vvp
GTKWAVE  := gtkwave

# ---- flags ----
CFLAGS  := -march=rv32i -mabi=ilp32 -O0 -ffreestanding -fno-builtin -nostdlib
LDFLAGS := -Wl,--entry=main -Wl,-Ttext=0x0

VERILOG := verilog          # objcopy -O verilog (대문자 X)
VERFLAG := -g2005

# ---- files ----
ELF := prog.elf
SRC := prog.c
HEX := prog.hex

SRCS := $(wildcard src/*.v)
TB   := tb/tb_cpu.v
SIM  := sim

TB2 := tb/tb_base.v
SIM2 := sim2

VCD := waves_cpu.vcd
VCD2 := waves_base.vcd

# ELF/HEX/시뮬레이터까지
all: $(ELF) $(HEX) $(SIM) $(VCD)

$(ELF): $(SRC)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

$(HEX): $(ELF)
	$(OBJCOPY) -O $(VERILOG) $< $@  

$(SIM): $(TB) $(SRCS)
	$(IVERILOG) $(VERFLAG) -o $@ $^  
	
$(VCD): $(SIM)
	$(VVP) $^


dump: $(ELF)
	$(OBJDUMP) -d -M no-aliases,numeric $(ELF) > prog.dump


clean:
	rm -f $(ELF) $(HEX) $(SIM) $(VCD) prog.dump trace.log Verification_result


.PHONY: all dump base clean 
