/*------------------------------------------------------------------------------
! . File      : helpers.h
! . Program   : pDynamo-1.8.0                           (http://www.pdynamo.org)
! . Copyright : CEA, CNRS, Martin  J. Field  (2007-2012),
!                          Mikolaj J. Feliks (2014)
! . License   : CeCILL French Free Software License     (http://www.cecill.info)
!-----------------------------------------------------------------------------*/
#ifndef _HELPERS
#define _HELPERS

#include "xdrfile.h"

#include "Real.h"
#include "Coordinates3.h"


extern void copy_coor (rvec *source, Coordinates3 *destination, int natoms);

#endif
