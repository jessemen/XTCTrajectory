# Example script for the XTCTrajectory module

from pCore         import logFile
from pBabel        import CHARMMParameterFiles_ToParameters, CHARMMPSFFile_ToSystem, XYZFile_ToCoordinates3, XYZFile_FromSystem
from XTCTrajectory import XTCTrajectoryFileReader, XTCTrajectory_ToSystemGeometryTrajectory

import os


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

while trajectory.RestoreOwnerData ():
    logFile.Text ("Frame count: %d\n" % trajectory.currentFrame)
    #XYZFile_FromSystem ("sav%3d.xyz" % trajectory.currentFrame, mol)


#===========================================================
# This part takes a bit more time to execute, uncomment if you like
# direc = "traj"
# 
# if not os.path.exists (direc):
#     os.makedirs (direc)
# 
# XTCTrajectory_ToSystemGeometryTrajectory ("heat.xtc", direc, mol)


#===========================================================
logFile.Footer ()
