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

    def __getmodule__ (self):
        return "XTCTrajectory"


    def __len__ (self):
        return self.numberOfFrames


    def __dealloc__ (self):
        """Finalization."""
        Buffer_Deallocate (&self.fb)
        self.Close ()


    def __init__ (self, path, owner):
        """Constructor."""
        cdef Integer  numberOfAtoms
        cdef Integer  status

        if owner.coordinates3 is None:
            raise CLibraryError ("Allocate system coordinates first.")

        # How to use exdrOK here? (exdrOK = 0)
        status = read_xtc_natoms (path, &numberOfAtoms)
        if status != 0:
            raise CLibraryError ("Cannot read the number of atoms from %s" % path)

        systemNumberOfAtoms = len (owner.atoms)
        if (numberOfAtoms != systemNumberOfAtoms):
            raise CLibraryError ("System has %d atoms but there are %d atoms in XTC file." (systemNumberOfAtoms, numberOfAtoms))

        self.fb = Buffer_Allocate (numberOfAtoms)
        if self.fb == NULL:
            raise CLibraryError ("Cannot allocate frame buffer.")

        self.path           = path
        self.owner          = owner
        self.numberOfAtoms  = numberOfAtoms
        self.numberOfFrames = 0
        self.currentFrame   = 0
        self.Open ()
        # self._Initialize     ()
        # self._Allocate       ()
        # self.AssignOwnerData ()


    def Close (self):
        """Close the file."""
        if self.isOpen:
            xdrfile_close (self.xdrfile)
            self.isOpen = False
        #else:
        #    raise CLibraryError ("Cannot close file.")


    def Open (self):
        """Open the file."""
        cdef char *path
        if self.isOpen:
            raise CLibraryError ("File has already been opened.")
        else:
            path = self.path
            self.xdrfile = xdrfile_open (path, "r")
            if (self.xdrfile == NULL):
                raise CLibraryError ("Cannot open file %s" % self.path)
            self.isOpen  = True


    def Summary (self, log = logFile):
        """Summary."""
        if LogFileActive (log):
            if self.isOpen:
                summary = log.GetSummary ()
                summary.Start ("XTC file")
                summary.Entry ("Number of Atoms",  "%s" % self.numberOfAtoms)
                summary.Entry ("Number of Frames", "%s" % self.numberOfFrames)
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
        cdef Integer        numberOfAtoms
        cdef Integer        step
        numberOfAtoms = self.numberOfAtoms
        coordinates3  = self.owner.coordinates3

        result = ReadXTCFrame_ToCoordinates3 (self.xdrfile, coordinates3.cObject, self.fb, numberOfAtoms, &step)
        self.currentFrame = step

        if result != True:
            self.numberOfFrames = step - 1
        # Returns True or False
        return result


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
