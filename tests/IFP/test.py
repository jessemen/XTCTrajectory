# Example script for the XTCTrajectory module

from pCore         import logFile
from pBabel        import CHARMMParameterFiles_ToParameters, CHARMMPSFFile_ToSystem
from XTCTrajectory import XTCTrajectoryFileReader


#===========================================================
logFile.Header ("Infrared fluorescent protein (parent)")


parameters = (
"par_all27_prot_na.inp",
"par.inp",
)

mol = CHARMMPSFFile_ToSystem ("parent_waterbox.psf", isXPLOR = True, parameters = CHARMMParameterFiles_ToParameters (parameters))
mol.Summary ()

trajectory = XTCTrajectoryFileReader ("heat.xtc", mol)
trajectory.Summary ()
trajectory.RestoreOwnerData ()

# while trajectory.RestoreOwnerData ():
#     pass


#===========================================================
logFile.Footer ()
