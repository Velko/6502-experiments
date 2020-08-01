PROGRAM=hello-world-final

all: $(PROGRAM).bin

$(PROGRAM).bin: $(PROGRAM).s
	vasm6502_oldstyle -Fbin -dotdir $< -o $@

program: $(PROGRAM).bin
	minipro -p AT28C256 -w $(PROGRAM).bin

clean:
	rm -f *.bin
