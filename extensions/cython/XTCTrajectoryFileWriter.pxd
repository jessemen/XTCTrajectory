#-------------------------------------------------------------------------------
# . File      : XTCTrajectoryFileWriter.pxd
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


cdef extern from "Coordinates3.h":
    ctypedef struct CCoordinates3 "Coordinates3"
    cdef CCoordinates3 *Coordinates3_Allocate (Integer extent)


cdef extern from "wrapper.h":
    cdef rvec     *Buffer_Allocate                (Integer natoms)
    cdef void      Buffer_Deallocate              (rvec **buffer)
    cdef Boolean   WriteXTCFrame_FromCoordinates3 (CXDRFILE *xd, CCoordinates3 *coordinates3, rvec *buffer, Integer natoms, Integer step, Integer prec, char *errorMessage)


cdef class XTCTrajectoryFileWriter:
    cdef public object  isOpen
    cdef public object  owner
    cdef public object  path
    cdef char           _errorMessage[256]
    cdef Integer        _numberOfFrames
    cdef Integer        _numberOfAtoms
    cdef Integer        _currentFrame
    cdef Integer        _precision
    cdef CXDRFILE       *_xdrfile
    cdef rvec           *_buffer
