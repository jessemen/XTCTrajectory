INCLUDE = ../cinclude
CFLAGS  = -fPIC -c -W -Wall -pedantic -I$(INCLUDE) -I$(PDYNAMO_PCORE)/extensions/cinclude 
CC      = gcc

all: wrapper.o xdrfile.o xdrfile_xtc.o

wrapper.o: wrapper.c
	$(CC) $(CFLAGS) wrapper.c     -o wrapper.o

xdrfile.o: xdrfile.c
	$(CC) $(CFLAGS) xdrfile.c     -o xdrfile.o

xdrfile_xtc.o: xdrfile_xtc.c
	$(CC) $(CFLAGS) xdrfile_xtc.c -o xdrfile_xtc.o

clean:
	if [ -e wrapper.o     ] ; then rm wrapper.o     ; fi
	if [ -e xdrfile.o     ] ; then rm xdrfile.o     ; fi
	if [ -e xdrfile_xtc.o ] ; then rm xdrfile_xtc.o ; fi
