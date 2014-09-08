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
        return self.nframes


    def __dealloc__ (self):
        """Finalization."""
        cdef rvec *buffer
        buffer = self.buffer
        Buffer_Deallocate (&buffer)
        self.Close ()
        

    def __init__ (self, path, owner):
        """Constructor."""
        cdef rvec *buffer
        cdef int   natoms
        cdef int   status

        # How to use exdrOK here?
        status = read_xtc_natoms (path, &natoms)
        if status != 0:
            raise CLibraryError ("Cannot read the number of atoms from %s" % path)

        buffer = Buffer_Allocate (natoms)
        if frame == NULL:
            raise CLibraryError ("Cannot allocate frame buffer.")

        self.path    = path
        self.owner   = owner
        self.buffer  = buffer
        self.natoms  = natoms
        self.nframes = 0
        self.Open ()
        # self._Initialize     ()
        # self._Allocate       ()
        # self.AssignOwnerData ()


    def Close (self):
        """Close the file."""
        if self.isOpen:
            xdrfile_close (self.xdrfile)
            self.isOpen = False
        else:
            raise CLibraryError ("Cannot close file.")


    def Open (self):
        """Open the file."""
        cdef char *path
        if self.isOpen:
            raise CLibraryError ("Cannot open file.")
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
                summary.Entry ("Number of Atoms",  "%s" % self.natoms)
                summary.Entry ("Number of Frames", "%s" % self.nframes)
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
        cdef Boolean        result
        cdef Integer        natoms
        cdef Integer        step
        cdef Coordinates3   coor
        cdef rvec           *buffer

        natoms  = self.natoms
        rvec    = self.buffer
        coor    = self.owner.coordinates3
        xdrfile = self.xdrfile

        result = ReadXTCFrame_ToCoordinates3 (xdrfile, coor, buffer, natoms, &step)
        return result

        # status = read_xtc (self.xdrfile, self.natoms, &step, &time, box, self.frame, &prec)
        # Finished reading the trajectory?
        # if status != 0:
        #    return False

        # How to use exdrOK here?
        #if status != 0:
        #    raise CLibraryError ("Error while reading XTC file.")
        # coor = self.owner.coordinates3


#         coor = self.owner.coordinates3
#         if coor is None:
#             coor = Coordinates3_Allocate (self.natoms)
#             if coor is not None:
#                 self.owner.coordinates3 = coor
#             else:
#                 raise CLibraryError ("Cannot allocate coordinates for the owner.")


#     def RestoreOwnerData ( self ):
#         """Restore data from a frame to the owner."""
#         try:
#             if self.currentFrame >= self.numberOfFrames: raise EOFError
#             DCDStatus_Check ( DCDRead_Frame ( self.cObject ) )
#             return True
#         except EOFError:
#             DCDStatus_Check ( DCDRead_GotoFrame ( self.cObject, 0 ) )
#             return False
# 
#     property currentFrame:
#         def __get__ ( self ): return DCDHandle_CurrentFrame ( self.cObject )
# 
#     property numberOfFrames:
#         def __get__ ( self ): return DCDHandle_NumberOfFrames ( self.cObject )


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
