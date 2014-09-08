/*------------------------------------------------------------------------------
! . File      : wrapper.c
! . Program   : pDynamo-1.8.0                           (http://www.pdynamo.org)
! . Copyright : CEA, CNRS, Martin  J. Field  (2007-2012),
!                          Mikolaj J. Feliks (2014)
! . License   : CeCILL French Free Software License     (http://www.cecill.info)
!-----------------------------------------------------------------------------*/
#include "wrapper.h"

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

rvec *Buffer_Allocate (Integer natoms) {
    rvec *buffer;

    MEMORY_ALLOCATEARRAY (buffer, natoms, rvec) ;
    return buffer;
}

void Buffer_Deallocate (rvec **buffer) {
    if ((buffer != NULL) && (*buffer != NULL)) {
        MEMORY_DEALLOCATE (*buffer);
    }
}

Boolean ReadXTCFrame_ToCoordinates3 (XDRFILE *xd, Coordinates3 *coordinates3, rvec *buffer, Integer natoms, Integer *step) {
    Real    *d = coordinates3->data;
    Integer atomindex;

    /* xdrfile variables */
    float   *s = (float *) buffer;
    float   time;
    float   prec;
    matrix  box;

    if (read_xtc (xd, natoms, step, &time, box, buffer, &prec) != exdrOK) {
        return False;
    }

    /* Copy converting floats to doubles */
    for (atomindex = 0; atomindex < natoms; atomindex++, s += 3, d += 3) {
        *(d    ) = *(s    );
        *(d + 1) = *(s + 1);
        *(d + 2) = *(s + 2);
    }

    return True;
}
