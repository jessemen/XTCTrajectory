#-------------------------------------------------------------------------------
# . File      : XTCTrajectoryFileReader.pyx
# . Program   : pDynamo-1.8.0                           (http://www.pdynamo.org)
# . Copyright : CEA, CNRS, Martin  J. Field  (2007-2012),
#                          Mikolaj J. Feliks (2014)
# . License   : CeCILL French Free Software License     (http://www.cecill.info)
#-------------------------------------------------------------------------------
"""XTCTrajectoryFileReader is a class for reading XTC trajectories."""

from pCore    import logFile, LogFileActive, CLibraryError
from pBabel   import SystemGeometryTrajectory


cdef class XTCTrajectoryFileReader:
    """XTC trajectory file reader."""

    def __dealloc__ (self):
        """Finalization."""
        Buffer_Deallocate (&self._buffer)
        self.Close ()


    def __init__ (self, path, owner):
        """Constructor."""
        cdef Integer  numberOfSystemAtoms
        cdef Integer  status

        if owner.coordinates3 is None:
            raise CLibraryError ("Allocate system coordinates first.")

        # How to use exdrOK here? (exdrOK = 0)
        status = read_xtc_natoms (path, &self._numberOfAtoms)
        if status != 0:
            raise CLibraryError ("Cannot read the number of atoms from %s" % path)

        numberOfSystemAtoms = len (owner.atoms)
        if (numberOfSystemAtoms != self._numberOfAtoms):
            raise CLibraryError ("System has %d atoms but there are %d atoms in XTC file." (numberOfSystemAtoms, self._numberOfAtoms))

        self._buffer = Buffer_Allocate (self._numberOfAtoms)
        if self._buffer == NULL:
            raise CLibraryError ("Cannot allocate frame buffer.")

        self.path            = path
        self.owner           = owner
        self._numberOfFrames = 0
        self._currentFrame   = 0
        self._precision      = 0
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
            self._xdrfile = xdrfile_open (path, "r")
            if (self._xdrfile == NULL):
                raise CLibraryError ("Cannot open file %s" % self.path)
            self.isOpen  = True


    def Summary (self, log=logFile):
        """Summary."""
        if LogFileActive (log):
            if self.isOpen:
                summary = log.GetSummary ()
                summary.Start ("XTC File Reader")
                summary.Entry ("Number of Atoms"    , "%s" % self._numberOfAtoms  )
                summary.Entry ("Frames Read"        , "%s" % self._numberOfFrames )
                summary.Entry ("Level of Precision" , "%d" % self._precision      )
                summary.Stop ()


    def ReadFooter (self):
        """Read the trajectory footer."""
        pass


    def ReadHeader (self):
        """Read the trajectory header."""
        pass


    def AssignOwnerData (self):
        """Assign owner data to the trajectory."""
        pass


    def RestoreOwnerData (self):
        """Restore data from a frame to the owner."""
        cdef Coordinates3   coordinates3
        cdef Boolean        result
        cdef Integer        foo

        coordinates3  = self.owner.coordinates3
        result = ReadXTCFrame_ToCoordinates3 (self._xdrfile, coordinates3.cObject, self._buffer, self._numberOfAtoms, &foo, &self._precision, self._errorMessage)
        if result == CFalse:
            # Rewind the file to frame 0 (is there a better way than close and open?)
            self._currentFrame = 0
            self.Close ()
            self.Open  ()
            return False
        else:
            self._currentFrame = self._currentFrame + 1
            if self._numberOfFrames < self._currentFrame:
                self._numberOfFrames = self._currentFrame

            # This does not seem to work with files produced by MDAnalysis
            # if self._currentFrame > self._numberOfFrames:
            #    self._numberOfFrames = self._numberOfFrames + 1
            return True


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
def XTCTrajectory_ToSystemGeometryTrajectory (inPath, outPath, system):
    """Convert an XTC trajectory to a SystemGeometryTrajectory."""
    inTrajectory  = XTCTrajectoryFileReader  (inPath,  system)
    outTrajectory = SystemGeometryTrajectory (outPath, system, mode = "w")

    inTrajectory.ReadHeader ()
    while inTrajectory.RestoreOwnerData (): outTrajectory.WriteOwnerData ()

    inTrajectory.Close  ()
    outTrajectory.Close ()
