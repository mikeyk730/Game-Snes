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

    if (fopen_s(&srcfile, argv[--argc], "rb") != 0){
        printf("Could not open %s for reading.\n", argv[argc]);
        exit(-1);
    }

    //process arguments
    for(int i = 1; i < argc; ++i){
        string current(argv[i]);
        if (current == "--data" && ++i < argc)
            disasm.load_data(argv[i]);
        else if (current == "--ptr" && ++i < argc)
            disasm.load_data(argv[i], true);
        else if (current == "--sym" && ++i < argc)
            disasm.load_symbols(argv[i]);
        else if (current == "--ram" && ++i < argc)
            disasm.load_symbols(argv[i], true);
        else if (current == "--sym2" && ++i < argc)
            disasm.load_symbols2(argv[i]);
        else if (current == "--comment" && ++i < argc)
            disasm.load_comments(argv[i]);
		else if (current == "--offsets" && ++i < argc)
			disasm.load_offsets(argv[i]);
		else if (current == "--accum" && ++i < argc)
            disasm.load_accum_bytes(argv[i], true);
        else if (current == "--index" && ++i < argc)
            disasm.load_accum_bytes(argv[i], false);
        else if (current == "--hirom")
            disasm.hirom(true);
        else if (current == "--quiet")
            disasm.quiet(true);
        else if (current == "--2pass")
            disasm.passes(2);

    }

    if (!disasm.quiet()){
        cout << "Ready to disassemble..." << endl;
    }

    while(1){
        fseek(srcfile, 512, 0);

        Request request;
        if (!request.get(cin, disasm.hirom()))
            continue;
        if (request.m_quit)
            break;
        disasm.handleRequest(request);

        printf("\n");
    }
}


