PDYNAMO_PCORE     = /home/mikolaj/local/opt/pDynamo-1.8.0/pCore-1.8.0
PDYNAMO_PBABEL    = /home/mikolaj/local/opt/pDynamo-1.8.0/pBabel-1.8.0
PDYNAMO_PMOLECULE = /home/mikolaj/local/opt/pDynamo-1.8.0/pMolecule-1.8.0

CFLAGS            = -c -W -Wall -pedantic -I./ -I$(PDYNAMO_PCORE)/extensions/cinclude/ -I$(PDYNAMO_PBABEL)/extensions/cinclude/ -I$(PDYNAMO_PMOLECULE)/extensions/cinclude/
CC                = gcc

default: compile

compile:
	$(CC) $(CFLAGS) DCDHandle.c          -o DCDHandle.o
	$(CC) $(CFLAGS) DCDRead.c            -o DCDRead.o
	$(CC) $(CFLAGS) xdrfile.c            -o xdrfile.o
	$(CC) $(CFLAGS) xdrfile_xtc.c        -o xdrfile_xtc.o
	$(CC) $(CFLAGS) main.c               -o main.o


LINK_DEPS = $(wildcard *.o *.a)

link: $(LINK_DEPS)
	$(CC) DCDHandle.o DCDRead.o xdrfile.o xdrfile_xtc.o main.o pcore.a f2clapack.a f2cdlamch.a f2cblas.a f2c.a cblas.a -o converter -lm

clean:
	rm *.o converter
