# Example script for the XTCTrajectory module

from pCore         import logFile
from pBabel        import CHARMMParameterFiles_ToParameters, CHARMMPSFFile_ToSystem, XYZFile_ToCoordinates3, XYZFile_FromSystem
from XTCTrajectory import XTCTrajectoryFileReader


#===========================================================
logFile.Header ("Infrared fluorescent protein (parent)")


parameters = (
"par_all27_prot_na.inp",
"par.inp",
)

mol = CHARMMPSFFile_ToSystem ("parent_waterbox.psf", isXPLOR = True, parameters = CHARMMParameterFiles_ToParameters (parameters))

mol.coordinates3 = XYZFile_ToCoordinates3 ("geometry.xyz")

mol.Summary ()

trajectory = XTCTrajectoryFileReader ("heat.xtc", mol)
trajectory.Summary ()
trajectory.RestoreOwnerData ()

frameCount = 0

while trajectory.RestoreOwnerData ():
    logFile.Text ("Loading frame %d\n" % frameCount)

    #XYZFile_FromSystem ("dump%0d.xyz" % frameCount, mol)

    frameCount += 1


#===========================================================
logFile.Footer ()
