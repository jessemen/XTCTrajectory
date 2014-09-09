#-------------------------------------------------------------------------------
# . File      : XTCTrajectoryFileReader.pxd
# . Program   : pDynamo-1.8.0                           (http://www.pdynamo.org)
# . Copyright : CEA, CNRS, Martin  J. Field  (2007-2012),
#                          Mikolaj J. Feliks (2014)
# . License   : CeCILL French Free Software License     (http://www.cecill.info)
#-------------------------------------------------------------------------------
from pCore.cDefinitions     cimport Boolean, CFalse, CTrue, Integer, Real

from pCore.Coordinates3     cimport Coordinates3
# from pCore.Status           cimport Status, Status_Continue


cdef extern from "xdrfile.h":
    ctypedef  float      matrix[3][3]
    ctypedef  float      rvec[3]
    ctypedef  struct     CXDRFILE "XDRFILE"
    cdef      CXDRFILE  *xdrfile_open  (char *path, char *mode)
    cdef      int        xdrfile_close (CXDRFILE *xfp)


cdef extern from "xdrfile_xtc.h":
    cdef int read_xtc_natoms (char *fn, int *natoms)


cdef extern from "Coordinates3.h":
    ctypedef struct CCoordinates3 "Coordinates3"
    cdef CCoordinates3 *Coordinates3_Allocate (Integer extent)


cdef extern from "wrapper.h":
    cdef rvec     *Buffer_Allocate             (Integer natoms)
    cdef void      Buffer_Deallocate           (rvec **fb)
    cdef Boolean   ReadXTCFrame_ToCoordinates3 (CXDRFILE *xd, CCoordinates3 *coordinates3, rvec *fb, Integer natoms, Integer *step)


cdef class XTCTrajectoryFileReader:
    cdef public object  isOpen
    cdef public object  owner
    cdef public object  path
    cdef public object  numberOfFrames
    cdef public object  numberOfAtoms
    cdef public object  currentFrame
    cdef CXDRFILE       *xdrfile
    cdef rvec           *fb
