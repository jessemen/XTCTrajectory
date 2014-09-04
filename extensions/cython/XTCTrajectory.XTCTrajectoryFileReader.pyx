#-------------------------------------------------------------------------------
# . File      : pBabel.XTCTrajectoryFileReader.pyx
# . Program   : pDynamo-1.8.0                           (http://www.pdynamo.org)
# . Copyright : CEA, CNRS, Martin  J. Field  (2007-2012),
#                          Mikolaj J. Feliks (2014)
# . License   : CeCILL French Free Software License     (http://www.cecill.info)
#-------------------------------------------------------------------------------
"""XTCTrajectoryFileReader is a class for reading XTC trajectories."""

from pCore                      import logFile, LogFileActive, CLibraryError
#from SystemGeometryTrajectory   import SystemGeometryTrajectory


cdef class XTCTrajectoryFileReader:
    """XTC trajectory file reader."""

    #def __getmodule__ (self):
    #    return "pBabel.XTCTrajectoryFileReader"


    def __len__ (self): return self.nframes


    def __dealloc__ (self):
        """Finalization."""
        self.Close ()


    def __init__ (self, path, owner):
        """Constructor."""
        cdef int natoms
        cdef int status
        status = read_xtc_natoms (path, &natoms)
        if status != 0:  #exdrOK
            raise CLibraryError ("Cannot read the number of atoms from %s" % path)

        self.path    = path
        self.owner   = owner
        self.natoms  = natoms
        self.nframes = 0
        self.Open ()
        # self._Initialize     ()
        # self._Allocate       ()
        # self.AssignOwnerData ()


    def Close (self):
        """Close the file."""
        xdrfile_close (self.cObject)


    def Open (self):
        """Open the file."""
        self.cObject = xdrfile_open (self.path, "r")


    def Summary (self, log = logFile):
        """Summary."""
        pass


    def ReadFooter (self):
        """Read the trajectory footer."""
        pass


    def ReadHeader (self):
        """Read the trajectory header."""
        pass


    def RestoreOwnerData (self):
        """Restore data from a frame to the owner."""
        pass


    def AssignOwnerData (self):
        """Assign owner data to the trajectory."""
        pass


#===============================================================================
# Helper functions
#===============================================================================
def XTCTrajectory_ToSystemGeometryTrajectory (inPath, outPath, system):
    """Convert an XTC trajectory to a SystemGeometryTrajectory."""
    pass
#     inTrajectory  = XTCTrajectoryFileReader  (inPath,  system)
#     outTrajectory = SystemGeometryTrajectory (outPath, system, mode = "w")
# 
#     inTrajectory.ReadHeader ()
#     while inTrajectory.RestoreOwnerData (): outTrajectory.WriteOwnerData ()
# 
#     inTrajectory.Close  ()
#     outTrajectory.Close ()
