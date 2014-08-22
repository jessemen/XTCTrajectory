PY_INCLUDE    = /usr/include/python2.7
CFLAGS        = -fPIC -c -I../cinclude -I$(PY_INCLUDE)
CC            = gcc


default: compile link
	@echo "\n*** Use 'make all' if you want to recompile Pyrex sources ***\n"

all: pyrex compile link


pyrex: XTCTrajectory.XTCTrajectoryFileReader.pyx XTCTrajectory.XTCTrajectoryFileReader.pxd
	python pyrex_compile.py

compile: XTCTrajectory.XTCTrajectoryFileReader.c
	$(CC) $(CFLAGS) XTCTrajectory.XTCTrajectoryFileReader.c -o XTCTrajectory.XTCTrajectoryFileReader.o

link: XTCTrajectory.XTCTrajectoryFileReader.o ../csource/xdrfile.o ../csource/xdrfile_xtc.o
	$(CC) -shared XTCTrajectory.XTCTrajectoryFileReader.o ../csource/xdrfile.o ../csource/xdrfile_xtc.o -o XTCTrajectoryFileReader.so

install: XTCTrajectoryFileReader.so
	mv XTCTrajectoryFileReader.so ../../XTCTrajectory/

clean:
	rm XTCTrajectoryFileReader.o XTCTrajectoryFileReader.so
