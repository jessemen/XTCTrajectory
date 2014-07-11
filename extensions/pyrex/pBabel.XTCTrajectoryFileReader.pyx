#-------------------------------------------------------------------------------
# . File      : pBabel.XTCTrajectoryFileReader.pyx
# . Program   : pDynamo-1.8.0                           (http://www.pdynamo.org)
# . Copyright : CEA, CNRS, Martin  J. Field  (2007-2012),
#                          Mikolaj J. Feliks (2014)
# . License   : CeCILL French Free Software License     (http://www.cecill.info)
#-------------------------------------------------------------------------------
"""XTCTrajectoryFileReader is a class for reading XTC trajectories."""


cdef class XTCTrajectoryFileReader:
    """XTC trajectory file reader."""

    def __dealloc__ (self):
        """Finalization."""
        self.Close ()

    def __init__ (self, path, owner):
        """Constructor."""
        self._Initialize     ()
        self._Allocate       ()
        self.path  = path
        self.owner = owner
        self.AssignOwnerData ()
        self.Open            ()

    def __len__ (self): return self.numberOfFrames

    def _Allocate (self):
        """Allocation."""
        self.cObject = DCDHandle_Allocate ( )
        if self.cObject == NULL: DCDStatus_Check ( CDCDStatus_MemoryAllocationFailure )

    def _Initialize (self):
        """Initialization."""
        self.cObject = NULL
        self.isOpen  = False
        self.owner   = None
        self.path    = None

    def Close (self):
        """Close the file."""
        pass

    def Open (self):
        """Open the file."""
        pass

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

"""
    def __getmodule__ (self): return "pBabel.XTCTrajectoryFileReader"


"""

#===============================================================================
# Helper functions
#===============================================================================
def XTCTrajectory_ToSystemGeometryTrajectory (inPath, outPath, system):
    """Convert an XTC trajectory to a SystemGeometryTrajectory."""
    inTrajectory  = XTCTrajectoryFileReader  (inPath , system)
    outTrajectory = SystemGeometryTrajectory (outPath, system, mode = "w")

    inTrajectory.ReadHeader ()
    while inTrajectory.RestoreOwnerData (): outTrajectory.WriteOwnerData ()

    inTrajectory.Close  ()
    outTrajectory.Close ()
