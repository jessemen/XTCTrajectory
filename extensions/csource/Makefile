INCLUDE = ../cinclude
CFLAGS  = -fPIC -c -W -Wall -pedantic -I$(INCLUDE)
CC      = gcc

default:
	$(CC) $(CFLAGS) xdrfile.c     -o xdrfile.o
	$(CC) $(CFLAGS) xdrfile_xtc.c -o xdrfile_xtc.o

clean:
	rm xdrfile.o xdrfile_xtc.o
