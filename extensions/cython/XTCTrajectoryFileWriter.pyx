#-------------------------------------------------------------------------------
# . File      : XTCTrajectoryFileWriter.pyx
# . Program   : pDynamo-1.8.0                           (http://www.pdynamo.org)
# . Copyright : CEA, CNRS, Martin  J. Field  (2007-2012),
#                          Mikolaj J. Feliks (2014)
# . License   : CeCILL French Free Software License     (http://www.cecill.info)
#-------------------------------------------------------------------------------
"""XTCTrajectoryFileWriter is a class for writing XTC trajectories."""

from pCore    import logFile, LogFileActive, CLibraryError
from pBabel   import SystemGeometryTrajectory


cdef class XTCTrajectoryFileWriter:
    """XTC trajectory file writer."""

    def __dealloc__ (self):
        """Finalization."""
        Buffer_Deallocate (&self._buffer)
        self.Close ()


    def __init__ (self, path, owner, compression="medium"):
        """Constructor."""
        if owner.coordinates3 is None:
            raise CLibraryError ("System is missing coordinates.")

        if compression == "low":
            self._precision = 1000
        elif compression == "medium":
            self._precision = 100
        elif compression == "high":
            self._precision = 10
        else:
            raise CLibraryError ("Compression level can only adopt values of low, medium or high.")

        self.path            = path
        self.owner           = owner
        self._numberOfAtoms  = len (owner.atoms)
        self._numberOfFrames = 0
        self._currentFrame   = 0

        self._buffer = Buffer_Allocate (self._numberOfAtoms)
        if self._buffer == NULL:
            raise CLibraryError ("Cannot allocate frame buffer.")

        self.Open ()
        # self._Initialize     ()
        # self._Allocate       ()
        # self.AssignOwnerData ()


    def Close (self):
        """Close the file."""
        if self.isOpen:
            xdrfile_close (self._xdrfile)
            self.isOpen = False


    def Open (self):
        """Open the file."""
        cdef char *path
        if self.isOpen:
            raise CLibraryError ("File has already been opened.")
        else:
            path = self.path
            self._xdrfile = xdrfile_open (path, "w")
            if (self._xdrfile == NULL):
                raise CLibraryError ("Cannot open file %s" % self.path)
            self.isOpen  = True


    def Summary (self, log=logFile):
        """Summary."""
        if LogFileActive (log):
            # The condition is commented out to make it work with ConjugateGradientMinimize_SystemGeometry
            # if self.isOpen:
            summary = log.GetSummary ()
            summary.Start ("XTC File Writer")
            summary.Entry ("Number of Atoms"    , "%s" % self._numberOfAtoms  )
            summary.Entry ("Frames Written"     , "%s" % self._numberOfFrames )
            summary.Entry ("Level of Precision" , "%d" % self._precision      )
            summary.Stop ()


    def WriteFooter (self):
        """Write the trajectory footer."""
        pass


    def WriteHeader (self):
        """Write the trajectory header."""
        pass


    def AssignOwnerData (self):
        """Assign owner data to the trajectory."""
        pass


    def WriteOwnerData (self):
        """Write data from the owner to a frame."""
        cdef Coordinates3   coordinates3
        cdef Boolean        result

        coordinates3  = self.owner.coordinates3
        result = WriteXTCFrame_FromCoordinates3 (self._xdrfile, coordinates3.cObject, self._buffer, self._numberOfAtoms, self._currentFrame, self._precision, self._errorMessage)
        if result == CTrue:
            self._currentFrame   = self._currentFrame + 1
            self._numberOfFrames = self._currentFrame
            return True
        else:
            return False


    def __getmodule__ (self):
        return "XTCTrajectory"


    # The following methods convert C variables to Python objects
    def __len__ (self):     return self._numberOfFrames

    property currentFrame:
        def __get__ (self): return self._currentFrame

    property numberOfFrames:
        def __get__ (self): return self._numberOfFrames

    property precision:
        def __get__ (self): return self._precision

    property message:
        def __get__ (self): return self._errorMessage


#===============================================================================
# Helper functions
#===============================================================================
def XTCTrajectory_FromSystemGeometryTrajectory (outPath, inPath, system):
    """Convert a SystemGeometryTrajectory to an XTC trajectory."""
    inTrajectory  = SystemGeometryTrajectory (inPath,  system, mode = "r")
    outTrajectory = XTCTrajectoryFileWriter  (outPath, system)

    outTrajectory.WriteHeader ()
    while inTrajectory.RestoreOwnerData (): outTrajectory.WriteOwnerData ()

    inTrajectory.Close  ()
    outTrajectory.Close ()
