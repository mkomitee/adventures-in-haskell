.PHONY: clean all

all: bin/sum bin/filter bin/dmesg

bin/%: %.hs
	ghc $< -o $@

clean:
	rm -f *.o *.hi bin/*
