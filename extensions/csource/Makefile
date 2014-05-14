INC2   = ../cinclude

CFLAGS = -fPIC -c -I$(INC2)
CC     = gcc

default:
	$(CC) $(CFLAGS) xdrfile.c     -o xdrfile.o
	$(CC) $(CFLAGS) xdrfile_xtc.c -o xdrfile_xtc.o

clean:
	rm xdrfile.o xdrfile_xtc.o
