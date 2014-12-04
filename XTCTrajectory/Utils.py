#-------------------------------------------------------------------------------
# . File      : Utils.py
# . Program   : pDynamo-1.8.0                           (http://www.pdynamo.org)
# . Copyright : CEA, CNRS, Martin  J. Field  (2007-2012),
#                          Mikolaj J. Feliks (2014)
# . License   : CeCILL French Free Software License     (http://www.cecill.info)
#-------------------------------------------------------------------------------
"""Utility functions for the XTCTrajectory module."""

from pBabel                  import SystemGeometryTrajectory
from XTCTrajectoryFileReader import XTCTrajectoryFileReader
from XTCTrajectoryFileWriter import XTCTrajectoryFileWriter


def XTCTrajectory_ToSystemGeometryTrajectory (inPath, outPath, system):
    """Convert an XTC trajectory to a SystemGeometryTrajectory."""
    inTrajectory  = XTCTrajectoryFileReader  (inPath,  system)
    outTrajectory = SystemGeometryTrajectory (outPath, system, mode="w")

    inTrajectory.ReadHeader ()
    while inTrajectory.RestoreOwnerData (): outTrajectory.WriteOwnerData ()

    inTrajectory.Close  ()
    outTrajectory.Close ()


def XTCTrajectory_FromSystemGeometryTrajectory (outPath, inPath, system):
    """Convert a SystemGeometryTrajectory to an XTC trajectory."""
    inTrajectory  = SystemGeometryTrajectory (inPath,  system, mode="r")
    outTrajectory = XTCTrajectoryFileWriter  (outPath, system)

    outTrajectory.WriteHeader ()
    while inTrajectory.RestoreOwnerData (): outTrajectory.WriteOwnerData ()

    inTrajectory.Close  ()
    outTrajectory.Close ()


#===============================================================================
# Testing
#===============================================================================
if __name__ == "__main__": pass
