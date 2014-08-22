INCLUDE = ./
CFLAGS  = -c -W -Wall -pedantic -I$(INCLUDE)
CC      = gcc

default: library test link

library: xdrfile.c xdrfile_xtc.c
	$(CC) $(CFLAGS) xdrfile.c     -o xdrfile.o
	$(CC) $(CFLAGS) xdrfile_xtc.c -o xdrfile_xtc.o

test: test.c
	$(CC) $(CFLAGS) test.c

link: xdrfile.o xdrfile_xtc.o test.o
	$(CC) xdrfile.o xdrfile_xtc.o test.o -o test

clean:
	rm xdrfile.o xdrfile_xtc.o test.o test
