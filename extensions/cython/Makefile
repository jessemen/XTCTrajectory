PDYNAMO_PCORE = /home/mikolaj/local/opt/pDynamo-1.8.0/pCore-1.8.0
PY_INCLUDE    = /usr/include/python2.7
CFLAGS        = -fPIC -c -I$(PDYNAMO_PCORE)/extensions/cinclude -I$(PY_INCLUDE) -I../cinclude 
CC            = gcc

default: XTCTrajectoryFileReader.so
	@echo "\n*** Use 'make clean_all' and then 'make' if you want to recompile Cython sources ***\n"

../csource/xdrfile_xtc.o:
	+$(MAKE) -C ../csource

../csource/xdrfile.o:
	+$(MAKE) -C ../csource

XTCTrajectoryFileReader.so: ../csource/xdrfile.o ../csource/xdrfile_xtc.o XTCTrajectory.XTCTrajectoryFileReader.o
	$(CC) -shared XTCTrajectory.XTCTrajectoryFileReader.o ../csource/xdrfile.o ../csource/xdrfile_xtc.o -o XTCTrajectoryFileReader.so

XTCTrajectory.XTCTrajectoryFileReader.c: XTCTrajectory.XTCTrajectoryFileReader.pyx XTCTrajectory.XTCTrajectoryFileReader.pxd
	python cython_compile.py  $(PDYNAMO_PCORE)

XTCTrajectory.XTCTrajectoryFileReader.o: XTCTrajectory.XTCTrajectoryFileReader.c
	$(CC) $(CFLAGS) XTCTrajectory.XTCTrajectoryFileReader.c -o XTCTrajectory.XTCTrajectoryFileReader.o

install: XTCTrajectoryFileReader.so
	mv XTCTrajectoryFileReader.so ../../XTCTrajectory/

clean:
	if [ -e XTCTrajectoryFileReader.o  ] ; then rm XTCTrajectoryFileReader.o  ; fi
	if [ -e XTCTrajectoryFileReader.so ] ; then rm XTCTrajectoryFileReader.so ; fi
	+$(MAKE) -C ../csource clean

clean_all: clean
	if [ -e XTCTrajectoryFileReader.c  ] ; then rm XTCTrajectoryFileReader.c  ; fi
