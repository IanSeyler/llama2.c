# choose your compiler, e.g. gcc/clang
# example override to clang: make run CC=clang
CC = gcc

# the most basic way of building that is most likely to work on most systems
.PHONY: run
run: run.c tokenizer_data.h
	$(CC) -O3 -o run run.c -lm

# useful for a debug build, can then e.g. analyze with valgrind, example:
# $ valgrind --leak-check=full ./run out/model.bin -n 3
rundebug: run.c tokenizer_data.h
	$(CC) -g -o run run.c -lm

# https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html
# https://simonbyrne.github.io/notes/fastmath/
# -Ofast enables all -O3 optimizations.
# Disregards strict standards compliance.
# It also enables optimizations that are not valid for all standard-compliant programs.
# It turns on -ffast-math, -fallow-store-data-races and the Fortran-specific
# -fstack-arrays, unless -fmax-stack-var-size is specified, and -fno-protect-parens.
# It turns off -fsemantic-interposition.
# In our specific application this is *probably* okay to use
.PHONY: runfast
runfast: run.c tokenizer_data.h
	$(CC) -Ofast -o run run.c -lm

# additionally compiles with OpenMP, allowing multithreaded runs
# make sure to also enable multiple threads when running, e.g.:
# OMP_NUM_THREADS=4 ./run out/model.bin
.PHONY: runomp
runomp: run.c tokenizer_data.h
	$(CC) -Ofast -fopenmp -march=native run.c  -lm  -o run

# compiles with gnu99 standard flags for amazon linux, coreos, etc. compatibility
.PHONY: rungnu
rungnu: run.c tokenizer_data.h
	$(CC) -Ofast -std=gnu11 -o run run.c -lm

.PHONY: runompgnu
runompgnu: run.c tokenizer_data.h
	$(CC) -Ofast -fopenmp -std=gnu11 run.c  -lm  -o run

# run all tests
.PHONY: test
test:
	pytest

# run only tests for run.c C implementation (is a bit faster if only C code changed)
.PHONY: testc
testc:
	pytest -k runc

# run the C tests, without touching pytest / python
# to increase verbosity level run e.g. as `make testcc VERBOSITY=1`
VERBOSITY ?= 0
.PHONY: testcc
testcc: tokenizer_data.h
	$(CC) -DVERBOSITY=$(VERBOSITY) -O3 -o testc test.c -lm
	./testc

# embedded model builds - include both tokenizer and model data in the executable
.PHONY: runembedded
runembedded: run.c tokenizer_data.h stories15M_data.h
	$(CC) -O3 -DEMBED_MODEL -o run run.c -lm

.PHONY: runembeddedfast
runembeddedfast: run.c tokenizer_data.h stories15M_data.h
	$(CC) -Ofast -DEMBED_MODEL -o run run.c -lm

.PHONY: runembeddedomp
runembeddedomp: run.c tokenizer_data.h stories15M_data.h
	$(CC) -Ofast -fopenmp -march=native -DEMBED_MODEL run.c -lm -o run

# generate tokenizer data header file
tokenizer_data.h: tokenizer.bin
	xxd -i tokenizer.bin > tokenizer_data.h

# generate model data header file
stories15M_data.h: stories15M.bin
	xxd -i stories15M.bin > stories15M_data.h

.PHONY: clean
clean:
	rm -f run tokenizer_data.h stories15M_data.h
