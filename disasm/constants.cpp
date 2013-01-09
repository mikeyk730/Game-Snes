#include "disasm.h"


FILE *srcfile;
int accum = 0, index = 0;  /* 0 = 8 bit, 1 = 16 bit */
unsigned int pc = 0x8000, eend = 0xffff;
unsigned char endbank = 0xff;
char buff1[80];
char buff2[80];
int hirom = 0;	  /* 1 = HiRom */
int comments = 1; /* 0 = No Comments, 1 = Short Comments, 2 = Long Comments */
int quiet = 0;
int high, low, flag;
int asmbler = 0, dcb = 0;
char *sym_filename;
char mylabel[20];

