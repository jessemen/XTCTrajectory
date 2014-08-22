#-------------------------------------------------------------------------------
# . File      : pBabel.XTCTrajectoryFileReader.pxd
# . Program   : pDynamo-1.8.0                           (http://www.pdynamo.org)
# . Copyright : CEA, CNRS, Martin  J. Field  (2007-2012),
#                          Mikolaj J. Feliks (2014)
# . License   : CeCILL French Free Software License     (http://www.cecill.info)
#-------------------------------------------------------------------------------


# The file xdrfile_own.h exists because XDR and XDRFILE is not defined in xdrfile.h
#cdef extern from "xdrfile_own.h":
#    pass


cdef extern from "xdrfile.h":
    ctypedef float  matrix[3][3]
    ctypedef float  rvec[3]

    ctypedef struct CXDRFILE "XDRFILE":
        pass
#        FILE  *fp
#        XDR   *xdr
#        char   mode
#        int   *buf1
#        int    buf1size
#        int   *buf2
#        int    buf2size


    cdef int       xdrfile_close (CXDRFILE *xfp)
    cdef CXDRFILE *xdrfile_open  (char *path, char *mode)


cdef extern from "xdrfile_xtc.h":
    cdef int       read_xtc_natoms (char *fn, int *natoms)
    cdef int       read_xtc        (CXDRFILE *xd, int natoms, int *step, float *time, matrix box, rvec *x, float *prec)
    cdef int       write_xtc       (CXDRFILE *xd, int natoms, int  step, float  time, matrix box, rvec *x, float  prec)


#-------------------------------------------------------------------------------
cdef class XTCTrajectoryFileReader:
    cdef CXDRFILE      *cObject
    cdef public object  isOpen
    cdef public object  owner
    cdef public object  path
