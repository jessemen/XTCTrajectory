/*------------------------------------------------------------------------------
! . File      : helpers.c
! . Program   : pDynamo-1.8.0                           (http://www.pdynamo.org)
! . Copyright : CEA, CNRS, Martin  J. Field  (2007-2012),
!                          Mikolaj J. Feliks (2014)
! . License   : CeCILL French Free Software License     (http://www.cecill.info)
!-----------------------------------------------------------------------------*/
#include "helpers.h"

void copy_coor (rvec *source, Coordinates3 *destination, int natoms) {
    float  *s = (float *) source;
    Real   *d = destination->data;
    int     counter;

    for (counter = 0; counter < natoms; counter++, s += 3, d += 3) {
        *(d    ) = *(s    );
        *(d + 1) = *(s + 1);
        *(d + 2) = *(s + 2);
    }

    return;
}
