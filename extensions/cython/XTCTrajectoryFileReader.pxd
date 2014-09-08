#-------------------------------------------------------------------------------
# . File      : XTCTrajectoryFileReader.pxd
# . Program   : pDynamo-1.8.0                           (http://www.pdynamo.org)
# . Copyright : CEA, CNRS, Martin  J. Field  (2007-2012),
#                          Mikolaj J. Feliks (2014)
# . License   : CeCILL French Free Software License     (http://www.cecill.info)
#-------------------------------------------------------------------------------
from libc                cimport stdlib
from pCore.cDefinitions  cimport Integer, Real
from pCore.Coordinates3  cimport Coordinates3

# from pCore.Memory           cimport Memory_Allocate_Array
# from pCore.Status           cimport Status, Status_Continue
# from pCore.cDefinitions     cimport Boolean, CFalse, CTrue, Integer, Real
# from pCore.Integer1DArray   cimport CInteger1DArray, Integer1DArray
# from pCore.Real1DArray      cimport CReal1DArray, Real1DArray
# from pCore.Real2DArray      cimport CReal2DArray, Real2DArray


#-------------------------------------------------------------------------------
cdef extern from "xdrfile.h":
    ctypedef float  matrix[3][3]
    ctypedef float  rvec[3]
    ctypedef struct CXDRFILE "XDRFILE"

    cdef int       xdrfile_close (CXDRFILE *xfp)
    cdef CXDRFILE *xdrfile_open  (char *path, char *mode)


#-------------------------------------------------------------------------------
cdef extern from "xdrfile_xtc.h":
    cdef int       read_xtc_natoms (char *fn, int *natoms)
    cdef int       read_xtc        (CXDRFILE *xd, int natoms, int *step, float *time, matrix box, rvec *x, float *prec)
    cdef int       write_xtc       (CXDRFILE *xd, int natoms, int  step, float  time, matrix box, rvec *x, float  prec)


#-------------------------------------------------------------------------------
cdef extern from "Coordinates3.h":
    ctypedef struct CCoordinates3 "Coordinates3"

    cdef CCoordinates3    *Coordinates3_Allocate (Integer extent)


#-------------------------------------------------------------------------------
cdef extern from "helpers.h":
    cdef void CopyRvecToCoordinates3 (rvec *source, CCoordinates3 *destination, int natoms)


#-------------------------------------------------------------------------------
cdef class XTCTrajectoryFileReader:
    cdef public object isOpen
    cdef public object owner
    cdef public object path
    cdef CXDRFILE      *xdrfile
    cdef rvec          *frame
    cdef int           nframes
    cdef int           natoms
