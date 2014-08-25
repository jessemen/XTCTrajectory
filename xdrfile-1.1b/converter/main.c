/*------------------------------------------------------------------------------
! . File      : main.c
! . Program   : converter
! . Copyright : Mikolaj J. Feliks (2014)
! . License   : GNU General Public License v3.0
!-----------------------------------------------------------------------------*/
#define _GNU_SOURCE /* fastio does not work without it; enables non-POSIX GNU extensions */

#include <stdio.h>
#include <fcntl.h>
#include "fastio.h"
#include "endianswap.h"

#include "Coordinates3.h"
#include "DCDHandle.h"
#include "DCDRead.h"

#include "xdrfile.h"
#include "xdrfile_xtc.h"


int main (void) {
    DCDHandle    *handle;
    DCDStatus     status;
    Integer       natoms, nframes, frame = 0;
    Coordinates3 *coordinates;


    handle = DCDHandle_Allocate ();
    if (handle == NULL) {
        printf ("Cannot allocate DCD handle.\n");
        return 1;
    }

    status = DCDRead_Open (handle, "../../tests/IFP/heat.dcd");
    if (status != DCDStatus_Normal) {
        printf ("There has been an error while opening the file: %d\n", status);
        return status;
    }

    status = DCDRead_Header (handle);
    if (status != DCDStatus_Normal) {
        printf ("There has been an error while reading the header: %d\n", status);
        return status;
    }

    nframes = handle->numberOfFrames;
    printf ("Number of frames: %d\n", nframes);

    natoms = handle->numberOfAtoms;
    printf ("Number of atoms: %d\n", natoms);

    coordinates = Coordinates3_Allocate (natoms);
    if (coordinates == NULL) {
        printf ("Cannot allocate coordinates.\n");
        return 2;
    }



    status = DCDHandle_SetData3 (handle, coordinates);
    if (status != DCDStatus_Normal) {
        printf ("There has been an error while allocating the coordinates: %d\n", status);
        return status;
    }


    do {
        status = DCDRead_Frame (handle);
        printf ("Frame: %d\n", frame++);
    } while (status == DCDStatus_Normal);


    /*
    DCDHandle_SetData3 (handle, coordinates);
    DCDHandle_CheckNumberOfAtoms (handle, &natoms);
    printf ("Number of atoms: %d\n", natoms);
    DCDRead_Frame (handle);
    */


    DCDRead_Close (handle);

    DCDHandle_Deallocate (&handle);

    return 0;
}

/*
    char       *filename = "../../tests/IFP/heat.xtc", *filename_out = "out.xtc";
    XDRFILE    *readfile, *writefile;
    int         natoms, result, step;
    matrix      box;
    float       prec = 1000.0, time;
    rvec        *frame;


    result = read_xtc_natoms (filename, &natoms);
    if (exdrOK != result) {
        return 1;
    }

    printf ("Number of atoms: %d\n", natoms);

    frame = calloc (natoms, sizeof (rvec));



    readfile  = xdrfile_open (filename,     "r");
    writefile = xdrfile_open (filename_out, "w");

    result = 0;
    do {
        result = read_xtc (readfile, natoms, &step, &time, box, frame, &prec);

        write_xtc (writefile, natoms, step, time, box, frame, prec);

    } while (result == 0);


    xdrfile_close (writefile);
    xdrfile_close (readfile);
*/
