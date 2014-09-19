/*------------------------------------------------------------------------------
! . File      : wrapper.c
! . Program   : pDynamo-1.8.0                           (http://www.pdynamo.org)
! . Copyright : CEA, CNRS, Martin  J. Field  (2007-2012),
!                          Mikolaj J. Feliks (2014)
! . License   : CeCILL French Free Software License     (http://www.cecill.info)
!-----------------------------------------------------------------------------*/
#include "wrapper.h"


rvec *Buffer_Allocate (Integer natoms) {
    rvec *buffer;
    MEMORY_ALLOCATEARRAY (buffer, natoms, rvec);

    /* If failed, NULL is returned */
    return buffer; 
}

void Buffer_Deallocate (rvec **buffer) {
    if ((buffer != NULL) && (*buffer != NULL)) {
        MEMORY_DEALLOCATE (*buffer);
    }

    /* If deallocation fails, do nothing */
}

Boolean ReadXTCFrame_ToCoordinates3 (XDRFILE *xd, Coordinates3 *coordinates3, rvec *buffer, Integer natoms, Integer *step, Integer *prec, char *errorMessage) {
    Real    *d = coordinates3->data;
    Integer atomindex;

    /* xdrfile variables */
    float   *s = (float *) buffer;
    float   precf;
    float   time;
    matrix  box;
    /* Result will be of enum type - is that correct? */
    int     result;

    result = read_xtc (xd, natoms, step, &time, box, buffer, &precf);
    strcpy (errorMessage, exdr_message[result]);

    if (result != exdrOK) {
        return False;
    }
    else {
        *prec = (Integer) precf;
    
        /* Copy converting rvec (=floats) to Reals (=doubles) */
        for (atomindex = 0; atomindex < natoms; atomindex++, s += 3, d += 3) {
            *(d    ) = (Real) *(s    );
            *(d + 1) = (Real) *(s + 1);
            *(d + 2) = (Real) *(s + 2);
        }
    
        return True;
    }
}

Boolean WriteXTCFrame_FromCoordinates3 (XDRFILE *xd, Coordinates3 *coordinates3, rvec *buffer, Integer natoms, Integer step, Integer prec, char *errorMessage) {
    Real    *s = coordinates3->data;
    Integer atomindex;

    /* xdrfile variables */
    float   *d = (float *) buffer;
    float   time;
    matrix  box;
    /* Result will be of enum type - is that correct? */
    int     result;

    /* Copy converting from Reals (=doubles) to rvec (=floats) */
    for (atomindex = 0; atomindex < natoms; atomindex++, s += 3, d += 3) {
        *(d    ) = (float) *(s    );
        *(d + 1) = (float) *(s + 1);
        *(d + 2) = (float) *(s + 2);
    }

    result = write_xtc (xd, natoms, step, time, box, buffer, (float) prec); 
    strcpy (errorMessage, exdr_message[result]);

    if (result != exdrOK) {
        return False;
    }
    else {
        return True;
    }
}
