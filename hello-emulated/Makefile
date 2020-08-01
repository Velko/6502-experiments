PROGRAM=hello-world-emulated

all: $(PROGRAM).bin

$(PROGRAM).bin: $(PROGRAM).s
	vasm6502_oldstyle -Fbin -dotdir $< -o $@

run: $(PROGRAM).bin
	py65mon -m 65c02 -o 6000 -r $(PROGRAM).bin

clean:
	rm -f *.bin
