PROGRAM=double-dabble

all: $(PROGRAM).bin

$(PROGRAM).bin: $(PROGRAM).s
	vasm6502_oldstyle -Fbin -dotdir $< -o $@

program: $(PROGRAM).bin
	minipro -p AT28C256 -w $(PROGRAM).bin

run: $(PROGRAM).bin
	py65mon -m 65c02 -o 6000 -r $(PROGRAM).bin

clean:
	rm -f *.bin
