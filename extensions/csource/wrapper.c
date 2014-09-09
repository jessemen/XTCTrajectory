/*------------------------------------------------------------------------------
! . File      : wrapper.c
! . Program   : pDynamo-1.8.0                           (http://www.pdynamo.org)
! . Copyright : CEA, CNRS, Martin  J. Field  (2007-2012),
!                          Mikolaj J. Feliks (2014)
! . License   : CeCILL French Free Software License     (http://www.cecill.info)
!-----------------------------------------------------------------------------*/
#include "wrapper.h"


rvec *Buffer_Allocate (Integer natoms) {
    rvec *fb;

    MEMORY_ALLOCATEARRAY (fb, natoms, rvec);
    return fb; /* If failed, NULL is returned */
}

void Buffer_Deallocate (rvec **fb) {
    if ((fb != NULL) && (*fb != NULL)) {
        MEMORY_DEALLOCATE (*fb);
    }

    /* If deallocation fails, do nothing */
}

Boolean ReadXTCFrame_ToCoordinates3 (XDRFILE *xd, Coordinates3 *coordinates3, rvec *fb, Integer natoms, Integer *step) {
    Real    *d = coordinates3->data;
    Integer atomindex;

    /* xdrfile variables */
    float   *s = (float *) fb;
    float   time;
    float   prec;
    matrix  box;

    if (read_xtc (xd, natoms, step, &time, box, fb, &prec) != exdrOK) {
        return False;
    }

    /* Copy converting floats to Reals (doubles) */
    for (atomindex = 0; atomindex < natoms; atomindex++, s += 3, d += 3) {
        *(d    ) = (Real) *(s    );
        *(d + 1) = (Real) *(s + 1);
        *(d + 2) = (Real) *(s + 2);
    }

    return True;
}

/*
enum { exdrOK, exdrHEADER, exdrSTRING, exdrDOUBLE, 
    exdrINT, exdrFLOAT, exdrUINT, exdr3DX, exdrCLOSE, exdrMAGIC,
    exdrNOMEM, exdrENDOFFILE, exdrFILENOTFOUND, exdrNR };

char *exdr_message[exdrNR] = {
    "OK", 
    "Header",
    "String", 
    "Double",
    "Integer",
    "Float",
    "Unsigned integer",
    "Compressed 3D coordinate",
    "Closing file",
    "Magic number",
    "Not enough memory",
    "End of file",
    "File not found" 
};
*/
