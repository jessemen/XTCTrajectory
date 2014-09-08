PDYNAMO_PCORE = /home/mikolaj/local/opt/pDynamo-1.8.0/pCore-1.8.0
PY_INCLUDE    = /usr/include/python2.7
C_SOURCE      = ../csource
CFLAGS        = -fPIC -c -I$(PDYNAMO_PCORE)/extensions/cinclude -I$(PY_INCLUDE) -I../cinclude 
CC            = gcc

default: XTCTrajectoryFileReader.so
	@echo "\n*** Use 'make clean_all' and then 'make' if you want to recompile Cython sources ***\n"

$(C_SOURCE)/wrapper.o: $(C_SOURCE)/wrapper.c
	+$(MAKE) -C $(C_SOURCE)

$(C_SOURCE)/xdrfile_xtc.o: $(C_SOURCE)/xdrfile_xtc.c
	+$(MAKE) -C $(C_SOURCE)

$(C_SOURCE)/xdrfile.o: $(C_SOURCE)/xdrfile.c
	+$(MAKE) -C $(C_SOURCE)

XTCTrajectoryFileReader.so: $(C_SOURCE)/wrapper.o $(C_SOURCE)/xdrfile.o $(C_SOURCE)/xdrfile_xtc.o XTCTrajectoryFileReader.o
	$(CC) -shared $(C_SOURCE)/wrapper.o $(C_SOURCE)/xdrfile.o $(C_SOURCE)/xdrfile_xtc.o XTCTrajectoryFileReader.o -o XTCTrajectoryFileReader.so

XTCTrajectoryFileReader.c: XTCTrajectoryFileReader.pyx XTCTrajectoryFileReader.pxd
	python cython_compile.py $(PDYNAMO_PCORE)

XTCTrajectoryFileReader.o: XTCTrajectoryFileReader.c
	$(CC) $(CFLAGS) XTCTrajectoryFileReader.c -o XTCTrajectoryFileReader.o

install: XTCTrajectoryFileReader.so
	mv XTCTrajectoryFileReader.so ../../XTCTrajectory/

clean:
	if [ -e XTCTrajectoryFileReader.o  ] ; then rm XTCTrajectoryFileReader.o  ; fi
	if [ -e XTCTrajectoryFileReader.so ] ; then rm XTCTrajectoryFileReader.so ; fi
	+$(MAKE) -C $(C_SOURCE) clean

clean_all: clean
	if [ -e XTCTrajectoryFileReader.c  ] ; then rm XTCTrajectoryFileReader.c  ; fi
