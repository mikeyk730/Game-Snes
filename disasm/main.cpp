#include <cstdio>
#include <cstring>
#include <cstdlib>

#include <iostream>
#include <iomanip>
#include <map>

#include "proto.h"
#include "disassembler.h"
#include "request.h"

using namespace std;

FILE *srcfile;

void main (int argc, char *argv[])
{
    Disassembler disasm;

    if (argc < 2 || string(argv[1]) == "--help"){
        printf(HELP);
        exit(-1);
    }  

    srcfile = fopen(argv[--argc],"rb");
    if (srcfile == NULL){
        printf("Could not open %s for reading.\n", argv[argc]);
        exit(-1);
    }

    //process arguments
    for(int i = 1; i < argc; ++i){
        string current(argv[i]);
        if (current == "--data" && ++i < argc)
            disasm.load_data(argv[i]);
        else if (current == "--sym" && ++i < argc)
            disasm.load_symbols(argv[i]);
         else if (current == "--sym2" && ++i < argc)
            disasm.load_symbols2(argv[i]);
        else if (current == "--accum" && ++i < argc)
            disasm.load_accum_bytes(argv[i], true);
        else if (current == "--index" && ++i < argc)
            disasm.load_accum_bytes(argv[i], false);
        else if (current == "--hirom")
            disasm.m_hirom = true;
    }

    while(1){

        fseek(srcfile, 512, 0);

        Request request;
        if (!request.get(cin, disasm.m_hirom))
            break;
        disasm.handleRequest(request);

        printf("\n");

    }
}


