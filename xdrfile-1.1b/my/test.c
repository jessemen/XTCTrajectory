/*
    Testing the xtc library.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "xdrfile.h"
#include "xdrfile_xtc.h"



int main (void) {
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

    return 0;
}
