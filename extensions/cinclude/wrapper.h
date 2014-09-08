/*------------------------------------------------------------------------------
! . File      : wrapper.h
! . Program   : pDynamo-1.8.0                           (http://www.pdynamo.org)
! . Copyright : CEA, CNRS, Martin  J. Field  (2007-2012),
!                          Mikolaj J. Feliks (2014)
! . License   : CeCILL French Free Software License     (http://www.cecill.info)
!-----------------------------------------------------------------------------*/
#ifndef _WRAPPER
#define _WRAPPER

#include "xdrfile.h"
#include "xdrfile_xtc.h"

#include "Real.h"
#include "Boolean.h"
#include "Integer.h"
#include "Memory.h"
#include "Coordinates3.h"


extern rvec *Buffer_Allocate (Integer natoms);

extern void Buffer_Deallocate (rvec **buffer);

extern Boolean ReadXTCFrame_ToCoordinates3 (XDRFILE *xd, Coordinates3 *coordinates3, rvec *buffer, Integer natoms, Integer *step);

#endif
