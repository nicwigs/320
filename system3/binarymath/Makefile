project = binarymath

objs = main.o $(project).o
testobjs = tests.o $(project).o
filesdir = /user/cse320/files
testdir = $(filesdir)/tests/$(project)

CC=gcc
CFLAGS := $(CFLAGS) -Wall

CLEANEXTS   = o

outputfile  = $(project)

# Default target
.PHONY: all
all: $(outputfile)

$(outputfile): $(objs)
	gcc -o $(outputfile) $(objs) $(LDLIBS)

.PHONY: clean 
clean:
	rm -f $(outputfile)
	rm -f test320
	for file in $(CLEANEXTS); do rm -f *.$$file; done

test320: $(testobjs)
	gcc -o test320 $(testobjs) -L$(filesdir)/lib -l320

.PHONY: test
test: test320
	./test320
	valgrind --leak-check=yes --error-exitcode=1 ./test320

.PHONY: tests
tests: test
 
tests.o: $(testdir)/tests.c $(project).h
	gcc -c $(CFLAGS) -I. -I$(filesdir)/include $(testdir)/tests.c

# Indicate dependencies of .ccp files on .hpp files
main.c: $(project).h
$(project).c: $(project).h
