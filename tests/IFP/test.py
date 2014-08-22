from pBabel  import CHARMMParameterFiles_ToParameters, CHARMMPSFFile_ToSystem, DCDTrajectoryFileReader
from pCore   import logFile


#===========================================================
logFile.Header ("Infrared fluorescent protein (parent)")


parameters = (
"par_all27_prot_na.inp",
"par.inp",
)

mol = CHARMMPSFFile_ToSystem ("parent_waterbox.psf", isXPLOR = True, parameters = CHARMMParameterFiles_ToParameters (parameters))
mol.Summary ()

trajectory = DCDTrajectoryFileReader ("heat.dcd", mol)
trajectory.ReadHeader ()

while trajectory.RestoreOwnerData ():
    pass


#===========================================================
logFile.Footer ()
