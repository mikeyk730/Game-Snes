#ifndef DISASM_H
#define DISASM_H

#include <cstdio>

#define USAGE "65816 SNES Disassembler   v2.0  (C)opyright 1994  by John \
Corey\ndisasm [options] <filename>\nfor help use: disasm -help\n"

#define HELP "  -skip     skip header (512 bytes)\n \
 -hirom    force HiRom disassembly\n \
 -nmi      begin disassembling at address in the NMI vector\n \
 -reset    begin disassembling at address in the RESET vector\n \
 -irq      begin disassembling at address in the IRQ vector\n \
 -bxxyyyy  begin  (default $008000)\n \
 -exxyyyy  end  (default $ffffff)\n \
             xx = bank number (in hex)\n \
             yyyy = address (in hex)\n \
 -t        stop disassembling at first RTS, RTL or RTI\n \
 -d        do NOT disassemble, convert block of code into dcb's.\n \
 -as       set accumulator size  (default 8)\n \
 -xs       set index size  (default 8)\n \
             s = 8 for 8 bit, s = 16 for 16 bit\n \
 -sym f    load up a symbol table.  f = filename\n \
 -q        quiet mode enable\n \
 -65816    disassemble with < and >'s\n \
 -cx       commenting level (default is 1)\n \
            x = 0 for no commenting, 1 for short comments, 2 for long comments\n"

extern FILE *srcfile;
extern char buff1[];
extern char buff2[];
extern int high, low, flag;


#endif
