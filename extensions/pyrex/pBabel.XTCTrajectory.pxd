#-------------------------------------------------------------------------------
# . File      : pBabel.XTCTrajectory.pxd
# . Program   : pDynamo-1.8.0                           (http://www.pdynamo.org)
# . Copyright : CEA, CNRS, Martin  J. Field  (2007-2012),
#                          Mikolaj J. Feliks (2014)
# . License   : CeCILL French Free Software License     (http://www.cecill.info)
#-------------------------------------------------------------------------------

cdef extern from "xdrfile.h":
    pass

cdef extern from "xdrfile_xtc.h":
    cdef int read_xtc_natoms (char *fn, int *natoms)
    cdef int read_xtc  (XDRFILE *xd, int natoms, int *step, float *time, matrix box, rvec *x, float *prec)
    cdef int write_xtc (XDRFILE *xd, int natoms, int  step, float  time, matrix box, rvec *x, float  prec)
