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

Boolean ReadXTCFrame_ToCoordinates3 (XDRFILE *xd, Coordinates3 *coordinates3, rvec *buffer, Integer natoms, Integer *step, char *errorMessage) {
    Real    *d = coordinates3->data;
    Integer atomindex;

    /* xdrfile variables */
    float   *s = (float *) buffer;
    float   prec;
    float   time;
    matrix  box;
    /* Result will be of enum type - is that correct? */
    int     result;

    result = read_xtc (xd, natoms, step, &time, box, buffer, &prec);
    /* DEBUG
    printf ("%8.3f  %8.3f  %8.3f\n", box[0][0], box[0][1], box[0][2]);
    printf ("%8.3f  %8.3f  %8.3f\n", box[1][0], box[1][1], box[1][2]);
    printf ("%8.3f  %8.3f  %8.3f\n", box[2][0], box[2][1], box[2][2]);
    */

    strcpy (errorMessage, exdr_message[result]);

    if (result != exdrOK) {
        return False;
    }
    else {
        /* Copy converting rvec (=floats) to Reals (=doubles) */
        for (atomindex = 0; atomindex < natoms; atomindex++, s += 3, d += 3) {
            *(d    ) = (Real) (*(s    ) * UNITS_LENGTH_NANOMETERS_TO_ANGSTROMS);
            *(d + 1) = (Real) (*(s + 1) * UNITS_LENGTH_NANOMETERS_TO_ANGSTROMS);
            *(d + 2) = (Real) (*(s + 2) * UNITS_LENGTH_NANOMETERS_TO_ANGSTROMS);
        }
    
        return True;
    }
}

Boolean WriteXTCFrame_FromCoordinates3 (XDRFILE *xd, Coordinates3 *coordinates3, rvec *buffer, Integer natoms, Integer step, char *errorMessage) {
    Real    *s = coordinates3->data;
    Integer atomindex;

    /* xdrfile variables */
    float   *d = (float *) buffer;
    float   prec = 1000.;
    float   time = 0.;
    float   cx, cy, cz, minx, miny, minz, maxx, maxy, maxz;
    matrix  box;
    /* Result will be of enum type - is that correct? */
    int     result;

    /* Clear the box */
    memset (box, 0, sizeof (box));
    memset (&minx, 0, sizeof (float) * 6);

    /* Copy converting from Reals (=doubles) to rvec (=floats) */
    for (atomindex = 0; atomindex < natoms; atomindex++, s += 3, d += 3) {
        cx = (float) (*(s    ) * UNITS_LENGTH_ANGSTROMS_TO_NANOMETERS);
        cy = (float) (*(s + 1) * UNITS_LENGTH_ANGSTROMS_TO_NANOMETERS);
        cz = (float) (*(s + 2) * UNITS_LENGTH_ANGSTROMS_TO_NANOMETERS);

        if      (cx < minx) minx = cx;
        else if (cx > maxx) maxx = cx;
        if      (cy < miny) miny = cy;
        else if (cy > maxy) maxy = cy;
        if      (cz < minz) minz = cz;
        else if (cz > maxz) maxz = cz;
        *(d    ) = cx;
        *(d + 1) = cy;
        *(d + 2) = cz;
    }

    box[0][0] = maxx - minx;
    box[1][1] = maxy - miny;
    box[2][2] = maxz - minz;

    result = write_xtc (xd, natoms, step, time, box, buffer, prec); 
    strcpy (errorMessage, exdr_message[result]);
    if (result != exdrOK) {
        return False;
    }
    else {
        return True;
    }
}
