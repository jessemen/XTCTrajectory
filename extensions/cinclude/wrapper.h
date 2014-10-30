/*------------------------------------------------------------------------------
! . File      : wrapper.h
! . Program   : pDynamo-1.8.0                           (http://www.pdynamo.org)
! . Copyright : CEA, CNRS, Martin  J. Field  (2007-2012),
!                          Mikolaj J. Feliks (2014)
! . License   : CeCILL French Free Software License     (http://www.cecill.info)
!-----------------------------------------------------------------------------*/
#ifndef _WRAPPER
#define _WRAPPER

#include <string.h>

#include "xdrfile.h"
#include "xdrfile_xtc.h"

#include "Real.h"
#include "Boolean.h"
#include "Integer.h"
#include "Memory.h"
#include "Coordinates3.h"

/* Converting units */
#define UNITS_LENGTH_ANGSTROMS_TO_NANOMETERS  1.0e-1
#define UNITS_LENGTH_NANOMETERS_TO_ANGSTROMS  1.0e+1


extern char *exdr_message[exdrNR];

/* Functions */
extern rvec     *Buffer_Allocate                 (Integer natoms);
extern void      Buffer_Deallocate               (rvec **buffer);
extern Boolean   ReadXTCFrame_ToCoordinates3     (XDRFILE *xd, Coordinates3 *coordinates3, rvec *buffer, Integer natoms, Integer *step, char *errorMessage);
extern Boolean   WriteXTCFrame_FromCoordinates3  (XDRFILE *xd, Coordinates3 *coordinates3, rvec *buffer, Integer natoms, Integer  step, char *errorMessage);

#endif
