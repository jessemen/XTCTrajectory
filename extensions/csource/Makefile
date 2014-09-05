INCLUDE = ../cinclude
CFLAGS  = -fPIC -c -W -Wall -pedantic -I$(INCLUDE) -I$(PDYNAMO_PCORE)/extensions/cinclude 
CC      = gcc

all: helpers.o xdrfile.o xdrfile_xtc.o

helpers.o: helpers.c
	$(CC) $(CFLAGS) helpers.c -o helpers.o

xdrfile.o: xdrfile.c
	$(CC) $(CFLAGS) xdrfile.c     -o xdrfile.o

xdrfile_xtc.o: xdrfile_xtc.c
	$(CC) $(CFLAGS) xdrfile_xtc.c -o xdrfile_xtc.o

clean:
	if [ -e helpers.o     ] ; then rm helpers.o     ; fi
	if [ -e xdrfile.o     ] ; then rm xdrfile.o     ; fi
	if [ -e xdrfile_xtc.o ] ; then rm xdrfile_xtc.o ; fi
