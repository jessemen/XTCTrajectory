# Example script for the XTCTrajectory module

from pCore             import logFile
from pBabel            import CHARMMParameterFiles_ToParameters, CHARMMPSFFile_ToSystem, XYZFile_ToCoordinates3, XYZFile_FromSystem, SystemGeometryTrajectory
from pMolecule         import NBModelABFS
from pMoleculeScripts  import ConjugateGradientMinimize_SystemGeometry
from XTCTrajectory     import XTCTrajectoryFileWriter, XTCTrajectory_FromSystemGeometryTrajectory

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

nb_model = NBModelABFS ()
mol.DefineNBModel (nb_model)


#===========================================================
# traj  = XTCTrajectoryFileWriter  ("saved_geometry.xtc",  mol)
# traj.WriteOwnerData ()
# traj.Summary ()


#===========================================================
traj3  = XTCTrajectoryFileWriter  ("optimize.xtc",  mol)
ConjugateGradientMinimize_SystemGeometry (mol, logFrequency = 1, maximumIterations = 50, rmsGradientTolerance = 0.04, trajectories = [(traj3, 1)])
traj3.Summary ()


# This will write 189 MB of PKL files
# traj2 = SystemGeometryTrajectory ("optimize_traj", mol, mode = "w")
# ConjugateGradientMinimize_SystemGeometry (mol, logFrequency = 1, maximumIterations = 50, rmsGradientTolerance = 0.04, trajectories = [(traj, 1), (traj2, 1)])


#===========================================================
logFile.Footer ()
