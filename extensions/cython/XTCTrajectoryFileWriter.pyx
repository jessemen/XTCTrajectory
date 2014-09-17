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

    def __getmodule__ (self):
        return "XTCTrajectory"


    def __len__ (self):
        return self.numberOfFrames


    def __dealloc__ (self):
        """Finalization."""
        Buffer_Deallocate (&self.fb)
        self.Close ()


    def __init__ (self, path, owner, precision = 100):
        """Constructor."""
        cdef Integer natoms

        if owner.coordinates3 is None:
            raise CLibraryError ("System is missing coordinates.")

        if not any ((precision == 10, precision == 100, precision == 1000, )):
            raise CLibraryError ("Precision can only adopt values of 10, 100 and 1000.")

        self.path           = path
        self.owner          = owner
        self.precision      = precision
        self.numberOfAtoms  = len (owner.coordinates3)
        self.numberOfFrames = 0
        self.currentFrame   = 0

        natoms = self.numberOfAtoms
        self.fb = Buffer_Allocate (natoms)
        if self.fb == NULL:
            raise CLibraryError ("Cannot allocate frame buffer.")

        self.Open ()
        # self._Initialize     ()
        # self._Allocate       ()
        # self.AssignOwnerData ()


    def Close (self):
        """Close the file."""
        if self.isOpen:
            xdrfile_close (self.xdrfile)
            self.isOpen = False
        # This will never happen?
        #else:
        #    raise CLibraryError ("Cannot close file.")


    def Open (self):
        """Open the file."""
        cdef char *path
        if self.isOpen:
            raise CLibraryError ("File has already been opened.")
        else:
            path = self.path
            self.xdrfile = xdrfile_open (path, "w")
            if (self.xdrfile == NULL):
                raise CLibraryError ("Cannot open file %s" % self.path)
            self.isOpen  = True


    def Summary (self, log = logFile):
        """Summary."""
        pass


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
        cdef Integer        precision
        cdef Integer        natoms
        cdef Integer        step
        cdef Boolean        result
        coordinates3  = self.owner.coordinates3
        precision     = self.precision
        natoms        = self.numberOfAtoms
        step          = self.currentFrame

        result = WriteXTCFrame_FromCoordinates3 (self.xdrfile, coordinates3.cObject, self.fb, natoms, step, precision)
        if result != True:
            self.currentFrame   = self.currentFrame + 1
            self.numberOfFrames = self.currentFrame

        # Returns True or False
        return result


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
