#include <cstdio>
#include <cstring>
#include <cstdlib>

#include <iostream>
#include <iomanip>
#include <map>

#include "disasm.h"
#include "proto.h"

using namespace std;

namespace
{
  int rts;
  map<unsigned char, Instruction> instruction_lookup;
}

void initialize_instruction_lookup();


void main (int argc, char *argv[])
{
  initialize_instruction_lookup();

  int i, cc;
  unsigned char code, a, b;
  char s2[80];
  link *ptr;

  flag = 0;

  if (argc < 2)
  {
    printf(USAGE);
    exit(-1);
  }

  if (!strcmp(argv[1], "-help"))
  {
    printf(USAGE);
    printf(HELP);
    exit(-1);
  }

  srcfile = fopen(argv[argc-1],"rb");
  if (srcfile == NULL)
  {
    printf("Could not open %s for reading.\n", argv[argc-1]);
    exit(-1);
  }
  fseek(srcfile, 0, 0);
  i = 1; rts = 0;

  unsigned char bank = 0;
  while ( (argc > 2) && ( (argv[i][0] == '/') || (argv[i][0] == '-') ) )
  {
    if ( (argv[i][0] == '/') || (argv[i][0] == '-') )
    {
      argv[i]++;
      switch(argv[i][0])
      {
        case 'b':
          argv[i]++;
          ptr = first;
          while (ptr != NULL)
          {
            if (!strcmp(ptr->label, argv[i]))
            {
              bank = ptr->bank;
              pc = ptr->address;
              flag = 1;
            }
            ptr = ptr->next;
          }
          if (flag == 0)
          {
            if (strlen(argv[i]) != 6)
            {
              printf("Beginning address invalid.\n");
              exit(-1);
            }
            char * s = argv[i] + strlen(argv[i]) - 4;/*last 4 #s .. ie 018000,s=8000 */
            sprintf(s2, "%.2s", argv[i]);
            pc = hex(s);
            bank = hex(s2);
          }
          flag = 0;
          break;

        case 'e':
          argv[i]++;
          ptr = first;
          while (ptr != NULL)
          {
              if (!strcmp(ptr->label, argv[i])) 
            {
                endbank = ptr->bank;
                eend = ptr->address;
                flag = 1;
            }
            ptr = ptr->next;
          }
          if (flag == 0)
          {
            if (strlen(argv[i]) != 6)
            {
              printf("Ending address invalid.\n");
              exit(-1);
            }
            char *s = argv[i] + strlen(argv[i]) - 4;/*last 4 #s .. ie 018000,s=8000 */
            sprintf(s2, "%.2s", argv[i]);
            endbank = hex(s2);
            eend = hex(s);
          }
          flag = 0;
          break;

        case 'a':
          argv[i]++;
          if (argv[i][0] == '8') accum = 0;
          if (!strcmp(argv[i], "16")) accum = 1;
          break;

        case 'x':
          argv[i]++;
          if (argv[i][0] == '8') index = 0;
          if (!strcmp(argv[i], "16")) index = 1;
          break;

        case 's':
          if (argv[i][1] == 'k')
            fseek(srcfile, 512, 0);
          if (argv[i][1] == 'y')
          {
            sym_filename = argv[++i];
            loadsymbols(sym_filename);
          }
          if (argv[i][1] == 'u')
          {
            sym_filename = argv[++i];
            loaddata(sym_filename);
          }
          break;

        case 'h':
          hirom = 1;
          break;

        case 'n':
          if (hirom)
            fseek(srcfile, 0xffea, 1);
          else
            fseek(srcfile, 0x7fea, 1);
          a = read_char(srcfile); b = read_char(srcfile);
          if (feof(srcfile))
          {
            printf("Error -- could not locate NMI vector\n");
           exit(-1);
          }
          pc = b * 256 + a;
          if (hirom)
            fseek(srcfile, -0xffec, 1);
          else
            fseek(srcfile, -0x7fec, 1);
          break;

        case 'r':
          if (hirom)
            fseek(srcfile, 0xfffc, 1);
          else
            fseek(srcfile, 0x7ffc, 1);
          a = read_char(srcfile); b = read_char(srcfile);
          if (feof(srcfile))
          {
           printf("Error -- could not locate RESET vector\n");
           exit(-1);
          }
          pc = b * 256 + a;
          if (hirom)
            fseek(srcfile, -0xfffe, 1);
          else
            fseek(srcfile, -0x7ffe, 1);
          break;

        case 'i':
          if (hirom)
            fseek(srcfile, 0xffee, 1);
          else
            fseek(srcfile, 0x7fee, 1);
          a = read_char(srcfile); b = read_char(srcfile);
          if (feof(srcfile))
          {
           printf("Error -- could not locate IRQ vector\n");
           exit(-1);
          }
          pc = b * 256 + a;
          if (hirom)
            fseek(srcfile, -0xfff0, 1);
          else
            fseek(srcfile, -0x7ff0, 1);
          break;

        case 't':
          rts = 1;
          break;

        case 'c':
          argv[i]++;
          comments = atoi(argv[i]);
          break;

        case 'q':
          quiet = 1;
          break;

        case 'j':
          asmbler = 1; /* Jeremy Gordon's Assembler */
          break;

        case 'd':
          dcb = 1;
          break;
      }
    }
    i++;
  }

  for(cc=0; cc<bank; cc++)  /* skip over each bank */
    if (hirom)
      fseek(srcfile, 65536, 1);
    else
      fseek(srcfile, 32768, 1);

  if (hirom)
    fseek(srcfile, pc, 1);
  else
    fseek(srcfile, pc - 0x8000, 1);

  /*printf("; Disassembly of %s by mikeyk\n", argv[argc-1]);
  printf("; Begin: $%.2X%.4X  End: ", bank, pc);
  if (rts)
    printf("RTS/RTL/RTI\n");
  else
    printf("$%.2X%.4X\n", endbank, eend);

  printf("; Hirom: ");
  if (hirom) printf("Yes"); else printf("No ");
  printf("  Quiet: ");
  if (quiet) printf("Yes"); else printf("No ");
  printf("  Comments: %d  DCB: ", comments);
  if (dcb) printf("Yes"); else printf("No ");
  printf("  Symbols: ");
  if (first != NULL) printf("Yes"); else printf("No ");
  printf("  65816: ");
  if (asmbler) printf("Yes"); else printf("No ");*/
  //

  if (dcb)
  {
    dodcb(bank, pc, endbank, eend);
    exit(-1);
  }

  printf("\n\n");

  while( (!feof(srcfile)) && (bank * 65536 + pc < endbank * 65536 + eend)
    && (rts >= 0) )
  {
    code = read_char(srcfile);
    Instruction instr = instruction_lookup[code];
    
    if (!feof(srcfile))
    {
      sprintf(s2, "%.4X", pc);
      if (strlen(s2) == 5)
      {
        bank++;
        if (hirom)
          pc -= 0x10000;
        else
          pc -= 0x8000;
      }

      string the_label = get_label(Instruction("",0,ALWAYS_USE_LABEL), bank, pc);
      if (the_label != "")
        cout << left << setw(20) << the_label;
      else if (!quiet)
        printf("%.2X%.4X", bank, pc);

      if (!quiet)
        printf(" %.2X ", code);
      else printf("	"); /* print tab (it's there!) */

      sprintf(buff2, "%s ", instr.name().c_str());
      if (rts)
        if (instr.name() == "RTS" || instr.name() == "RTI" ||
           instr.name() == "RTL" )
          rts = -1;
      pc++;
      high = 0; low = 0; flag = 0;
      dotype(instr, bank);
      if (!quiet) printf("  ");
      printf("%s", buff2);
      if (!quiet) printf("     ");
    if (instr.name() == "RTS" || instr.name() == "RTI" || instr.name() == "RTL" )
        printf(" ;\n");//<------------------------------------------------>");
      if (high) comment(low, high);
      if (flag > 0)
      {
	printf("	;");
        if (flag & 0x10) printf(" Index (16 bit)");
        if (flag & 0x20) printf(" Accum (16 bit)");
      } else if (flag < 0)
      {
	printf("	;");
        if ( (-flag) & 0x10) printf(" Index (8 bit)");
        if ( (-flag) & 0x20) printf(" Accum (8 bit)");
      }
      printf("\n");
    }
    if (feof(srcfile)) printf("; End of file.\n");
  }
}


void initialize_instruction_lookup()
{
  instruction_lookup.insert(make_pair(0x69, Instruction("ADC", 1)));
  instruction_lookup.insert(make_pair(0x6D, Instruction("ADC", 2)));
  instruction_lookup.insert(make_pair(0x6F, Instruction("ADC", 3)));
  instruction_lookup.insert(make_pair(0x65, Instruction("ADC", 4)));
  instruction_lookup.insert(make_pair(0x71, Instruction("ADC", 5)));
  instruction_lookup.insert(make_pair(0x77, Instruction("ADC", 6)));
  instruction_lookup.insert(make_pair(0x61, Instruction("ADC", 7)));
  instruction_lookup.insert(make_pair(0x75, Instruction("ADC", 8)));
  instruction_lookup.insert(make_pair(0x7D, Instruction("ADC", 9)));
  instruction_lookup.insert(make_pair(0x7F, Instruction("ADC", 10)));
  instruction_lookup.insert(make_pair(0x79, Instruction("ADC", 11)));
  instruction_lookup.insert(make_pair(0x72, Instruction("ADC", 12)));
  instruction_lookup.insert(make_pair(0x67, Instruction("ADC", 13)));
  instruction_lookup.insert(make_pair(0x63, Instruction("ADC", 14)));
  instruction_lookup.insert(make_pair(0x73, Instruction("ADC", 15)));
  instruction_lookup.insert(make_pair(0x29, Instruction("AND", 1)));
  instruction_lookup.insert(make_pair(0x2D, Instruction("AND", 2)));
  instruction_lookup.insert(make_pair(0x2F, Instruction("AND", 3)));
  instruction_lookup.insert(make_pair(0x25, Instruction("AND", 4)));
  instruction_lookup.insert(make_pair(0x31, Instruction("AND", 5)));
  instruction_lookup.insert(make_pair(0x37, Instruction("AND", 6)));
  instruction_lookup.insert(make_pair(0x21, Instruction("AND", 7)));
  instruction_lookup.insert(make_pair(0x35, Instruction("AND", 8)));
  instruction_lookup.insert(make_pair(0x3D, Instruction("AND", 9)));
  instruction_lookup.insert(make_pair(0x3F, Instruction("AND", 10)));
  instruction_lookup.insert(make_pair(0x39, Instruction("AND", 11)));
  instruction_lookup.insert(make_pair(0x32, Instruction("AND", 12)));
  instruction_lookup.insert(make_pair(0x27, Instruction("AND", 13)));
  instruction_lookup.insert(make_pair(0x23, Instruction("AND", 14)));
  instruction_lookup.insert(make_pair(0x33, Instruction("AND", 15)));
  instruction_lookup.insert(make_pair(0x0E, Instruction("ASL", 2)));
  instruction_lookup.insert(make_pair(0x06, Instruction("ASL", 4)));
  instruction_lookup.insert(make_pair(0x0A, Instruction("ASL", 0)));
  instruction_lookup.insert(make_pair(0x16, Instruction("ASL", 8)));
  instruction_lookup.insert(make_pair(0x1E, Instruction("ASL", 9)));
  instruction_lookup.insert(make_pair(0x90, Instruction("BCC", 16, ALWAYS_USE_LABEL)));
  instruction_lookup.insert(make_pair(0xB0, Instruction("BCS", 16, ALWAYS_USE_LABEL)));
  instruction_lookup.insert(make_pair(0xF0, Instruction("BEQ", 16, ALWAYS_USE_LABEL)));
  instruction_lookup.insert(make_pair(0x30, Instruction("BMI", 16, ALWAYS_USE_LABEL)));
  instruction_lookup.insert(make_pair(0xD0, Instruction("BNE", 16, ALWAYS_USE_LABEL)));
  instruction_lookup.insert(make_pair(0x10, Instruction("BPL", 16, ALWAYS_USE_LABEL)));
  instruction_lookup.insert(make_pair(0x80, Instruction("BRA", 16, ALWAYS_USE_LABEL)));
  instruction_lookup.insert(make_pair(0x82, Instruction("BRL", 17)));
  instruction_lookup.insert(make_pair(0x50, Instruction("BVC", 16)));
  instruction_lookup.insert(make_pair(0x70, Instruction("BVS", 16)));
  instruction_lookup.insert(make_pair(0x89, Instruction("BIT", 1)));
  instruction_lookup.insert(make_pair(0x2C, Instruction("BIT", 2)));
  instruction_lookup.insert(make_pair(0x24, Instruction("BIT", 4)));
  instruction_lookup.insert(make_pair(0x34, Instruction("BIT", 8)));
  instruction_lookup.insert(make_pair(0x3C, Instruction("BIT", 9)));
  instruction_lookup.insert(make_pair(0x00, Instruction("BRK", 0)));
  instruction_lookup.insert(make_pair(0x18, Instruction("CLC", 0)));
  instruction_lookup.insert(make_pair(0xD8, Instruction("CLD", 0)));
  instruction_lookup.insert(make_pair(0x58, Instruction("CLI", 0)));
  instruction_lookup.insert(make_pair(0xB8, Instruction("CLV", 0)));
  instruction_lookup.insert(make_pair(0xC9, Instruction("CMP", 1)));
  instruction_lookup.insert(make_pair(0xCD, Instruction("CMP", 2)));
  instruction_lookup.insert(make_pair(0xCF, Instruction("CMP", 3)));
  instruction_lookup.insert(make_pair(0xC5, Instruction("CMP", 4)));
  instruction_lookup.insert(make_pair(0xD1, Instruction("CMP", 5)));
  instruction_lookup.insert(make_pair(0xD7, Instruction("CMP", 6)));
  instruction_lookup.insert(make_pair(0xC1, Instruction("CMP", 7)));
  instruction_lookup.insert(make_pair(0xD5, Instruction("CMP", 8)));
  instruction_lookup.insert(make_pair(0xDD, Instruction("CMP", 9)));
  instruction_lookup.insert(make_pair(0xDF, Instruction("CMP", 10)));
  instruction_lookup.insert(make_pair(0xD9, Instruction("CMP", 11)));
  instruction_lookup.insert(make_pair(0xD2, Instruction("CMP", 12)));
  instruction_lookup.insert(make_pair(0xC7, Instruction("CMP", 13)));
  instruction_lookup.insert(make_pair(0xC3, Instruction("CMP", 14)));
  instruction_lookup.insert(make_pair(0xD3, Instruction("CMP", 15)));
  instruction_lookup.insert(make_pair(0xE0, Instruction("CPX", 26)));
  instruction_lookup.insert(make_pair(0xEC, Instruction("CPX", 2)));
  instruction_lookup.insert(make_pair(0xE4, Instruction("CPX", 4)));
  instruction_lookup.insert(make_pair(0xC0, Instruction("CPY", 26)));
  instruction_lookup.insert(make_pair(0xCC, Instruction("CPY", 2)));
  instruction_lookup.insert(make_pair(0xC4, Instruction("CPY", 4)));
  instruction_lookup.insert(make_pair(0xCE, Instruction("DEC", 2)));
  instruction_lookup.insert(make_pair(0xC6, Instruction("DEC", 4)));
  instruction_lookup.insert(make_pair(0x3A, Instruction("DEC", 0)));
  instruction_lookup.insert(make_pair(0xD6, Instruction("DEC", 8)));
  instruction_lookup.insert(make_pair(0xDE, Instruction("DEC", 9)));
  instruction_lookup.insert(make_pair(0xCA, Instruction("DEX", 0)));
  instruction_lookup.insert(make_pair(0x88, Instruction("DEY", 0)));
  instruction_lookup.insert(make_pair(0x49, Instruction("EOR", 1)));
  instruction_lookup.insert(make_pair(0x4D, Instruction("EOR", 2)));
  instruction_lookup.insert(make_pair(0x4F, Instruction("EOR", 3)));
  instruction_lookup.insert(make_pair(0x45, Instruction("EOR", 4)));
  instruction_lookup.insert(make_pair(0x51, Instruction("EOR", 5)));
  instruction_lookup.insert(make_pair(0x57, Instruction("EOR", 6)));
  instruction_lookup.insert(make_pair(0x41, Instruction("EOR", 7)));
  instruction_lookup.insert(make_pair(0x55, Instruction("EOR", 8)));
  instruction_lookup.insert(make_pair(0x5D, Instruction("EOR", 9)));
  instruction_lookup.insert(make_pair(0x5F, Instruction("EOR", 10)));
  instruction_lookup.insert(make_pair(0x59, Instruction("EOR", 11)));
  instruction_lookup.insert(make_pair(0x52, Instruction("EOR", 12)));
  instruction_lookup.insert(make_pair(0x47, Instruction("EOR", 13)));
  instruction_lookup.insert(make_pair(0x43, Instruction("EOR", 14)));
  instruction_lookup.insert(make_pair(0x53, Instruction("EOR", 15)));
  instruction_lookup.insert(make_pair(0xEE, Instruction("INC", 2)));
  instruction_lookup.insert(make_pair(0xE6, Instruction("INC", 4)));
  instruction_lookup.insert(make_pair(0x1A, Instruction("INC", 0)));
  instruction_lookup.insert(make_pair(0xF6, Instruction("INC", 8)));
  instruction_lookup.insert(make_pair(0xFE, Instruction("INC", 9)));
  instruction_lookup.insert(make_pair(0xE8, Instruction("INX", 0)));
  instruction_lookup.insert(make_pair(0xC8, Instruction("INY", 0)));
  instruction_lookup.insert(make_pair(0x5C, Instruction("JMP", 3)));
  instruction_lookup.insert(make_pair(0xDC, Instruction("JML", 20)));
  instruction_lookup.insert(make_pair(0x4C, Instruction("JMP", 2)));
  instruction_lookup.insert(make_pair(0x6C, Instruction("JMP", 20)));
  instruction_lookup.insert(make_pair(0x7C, Instruction("JMP", 21)));
  instruction_lookup.insert(make_pair(0x22, Instruction("JSL", 3)));
  instruction_lookup.insert(make_pair(0x20, Instruction("JSR", 2)));
  instruction_lookup.insert(make_pair(0xFC, Instruction("JSR", 21)));
  instruction_lookup.insert(make_pair(0xA9, Instruction("LDA", 1)));
  instruction_lookup.insert(make_pair(0xAD, Instruction("LDA", 2)));
  instruction_lookup.insert(make_pair(0xAF, Instruction("LDA", 3)));
  instruction_lookup.insert(make_pair(0xA5, Instruction("LDA", 4)));
  instruction_lookup.insert(make_pair(0xB1, Instruction("LDA", 5)));
  instruction_lookup.insert(make_pair(0xB7, Instruction("LDA", 6)));
  instruction_lookup.insert(make_pair(0xA1, Instruction("LDA", 7)));
  instruction_lookup.insert(make_pair(0xB5, Instruction("LDA", 8)));
  instruction_lookup.insert(make_pair(0xBD, Instruction("LDA", 9)));
  instruction_lookup.insert(make_pair(0xBF, Instruction("LDA", 10)));
  instruction_lookup.insert(make_pair(0xB9, Instruction("LDA", 11)));
  instruction_lookup.insert(make_pair(0xB2, Instruction("LDA", 12)));
  instruction_lookup.insert(make_pair(0xA7, Instruction("LDA", 13)));
  instruction_lookup.insert(make_pair(0xA3, Instruction("LDA", 14)));
  instruction_lookup.insert(make_pair(0xB3, Instruction("LDA", 15)));
  instruction_lookup.insert(make_pair(0xA2, Instruction("LDX", 26)));
  instruction_lookup.insert(make_pair(0xAE, Instruction("LDX", 2)));
  instruction_lookup.insert(make_pair(0xA6, Instruction("LDX", 4)));
  instruction_lookup.insert(make_pair(0xB6, Instruction("LDX", 22)));
  instruction_lookup.insert(make_pair(0xBE, Instruction("LDX", 11)));
  instruction_lookup.insert(make_pair(0xA0, Instruction("LDY", 26)));
  instruction_lookup.insert(make_pair(0xAC, Instruction("LDY", 2)));
  instruction_lookup.insert(make_pair(0xA4, Instruction("LDY", 4)));
  instruction_lookup.insert(make_pair(0xB4, Instruction("LDY", 8)));
  instruction_lookup.insert(make_pair(0xBC, Instruction("LDY", 9)));
  instruction_lookup.insert(make_pair(0x4E, Instruction("LSR", 2)));
  instruction_lookup.insert(make_pair(0x46, Instruction("LSR", 4)));
  instruction_lookup.insert(make_pair(0x4A, Instruction("LSR", 0)));
  instruction_lookup.insert(make_pair(0x56, Instruction("LSR", 8)));
  instruction_lookup.insert(make_pair(0x5E, Instruction("LSR", 9)));
  instruction_lookup.insert(make_pair(0xEA, Instruction("NOP", 0)));
  instruction_lookup.insert(make_pair(0x09, Instruction("ORA", 1)));
  instruction_lookup.insert(make_pair(0x0D, Instruction("ORA", 2)));
  instruction_lookup.insert(make_pair(0x0F, Instruction("ORA", 3)));
  instruction_lookup.insert(make_pair(0x05, Instruction("ORA", 4)));
  instruction_lookup.insert(make_pair(0x11, Instruction("ORA", 5)));
  instruction_lookup.insert(make_pair(0x17, Instruction("ORA", 6)));
  instruction_lookup.insert(make_pair(0x01, Instruction("ORA", 7)));
  instruction_lookup.insert(make_pair(0x15, Instruction("ORA", 8)));
  instruction_lookup.insert(make_pair(0x1D, Instruction("ORA", 9)));
  instruction_lookup.insert(make_pair(0x1F, Instruction("ORA", 10)));
  instruction_lookup.insert(make_pair(0x19, Instruction("ORA", 11)));
  instruction_lookup.insert(make_pair(0x12, Instruction("ORA", 12)));
  instruction_lookup.insert(make_pair(0x07, Instruction("ORA", 13)));
  instruction_lookup.insert(make_pair(0x03, Instruction("ORA", 14)));
  instruction_lookup.insert(make_pair(0x13, Instruction("ORA", 15)));
  instruction_lookup.insert(make_pair(0xF4, Instruction("PEA", 18)));
  instruction_lookup.insert(make_pair(0xD4, Instruction("PEI", 23)));
  instruction_lookup.insert(make_pair(0x62, Instruction("PER", 18)));
  instruction_lookup.insert(make_pair(0x48, Instruction("PHA", 0)));
  instruction_lookup.insert(make_pair(0x8B, Instruction("PHB", 0)));
  instruction_lookup.insert(make_pair(0x0B, Instruction("PHD", 0)));
  instruction_lookup.insert(make_pair(0x4B, Instruction("PHK", 0)));
  instruction_lookup.insert(make_pair(0x08, Instruction("PHP", 0)));
  instruction_lookup.insert(make_pair(0xDA, Instruction("PHX", 0)));
  instruction_lookup.insert(make_pair(0x5A, Instruction("PHY", 0)));
  instruction_lookup.insert(make_pair(0x68, Instruction("PLA", 0)));
  instruction_lookup.insert(make_pair(0xAB, Instruction("PLB", 0)));
  instruction_lookup.insert(make_pair(0x2B, Instruction("PLD", 0)));
  instruction_lookup.insert(make_pair(0x28, Instruction("PLP", 0)));
  instruction_lookup.insert(make_pair(0xFA, Instruction("PLX", 0)));
  instruction_lookup.insert(make_pair(0x7A, Instruction("PLY", 0)));
  instruction_lookup.insert(make_pair(0xC2, Instruction("REP", 24)));
  instruction_lookup.insert(make_pair(0x2E, Instruction("ROL", 1)));
  instruction_lookup.insert(make_pair(0x26, Instruction("ROL", 4)));
  instruction_lookup.insert(make_pair(0x2A, Instruction("ROL", 0)));
  instruction_lookup.insert(make_pair(0x36, Instruction("ROL", 8)));
  instruction_lookup.insert(make_pair(0x3E, Instruction("ROL", 9)));
  instruction_lookup.insert(make_pair(0x6E, Instruction("ROR", 1)));
  instruction_lookup.insert(make_pair(0x66, Instruction("ROR", 4)));
  instruction_lookup.insert(make_pair(0x6A, Instruction("ROR", 0)));
  instruction_lookup.insert(make_pair(0x76, Instruction("ROR", 8)));
  instruction_lookup.insert(make_pair(0x7E, Instruction("ROR", 9)));
  instruction_lookup.insert(make_pair(0x40, Instruction("RTI", 0)));
  instruction_lookup.insert(make_pair(0x6B, Instruction("RTL", 0)));
  instruction_lookup.insert(make_pair(0x60, Instruction("RTS", 0)));
  instruction_lookup.insert(make_pair(0xE9, Instruction("SBC", 1)));
  instruction_lookup.insert(make_pair(0xED, Instruction("SBC", 2)));
  instruction_lookup.insert(make_pair(0xEF, Instruction("SBC", 3)));
  instruction_lookup.insert(make_pair(0xE5, Instruction("SBC", 4)));
  instruction_lookup.insert(make_pair(0xF1, Instruction("SBC", 5)));
  instruction_lookup.insert(make_pair(0xF7, Instruction("SBC", 6)));
  instruction_lookup.insert(make_pair(0xE1, Instruction("SBC", 7)));
  instruction_lookup.insert(make_pair(0xF5, Instruction("SBC", 8)));
  instruction_lookup.insert(make_pair(0xFD, Instruction("SBC", 9)));
  instruction_lookup.insert(make_pair(0xFF, Instruction("SBC", 10)));
  instruction_lookup.insert(make_pair(0xF9, Instruction("SBC", 11)));
  instruction_lookup.insert(make_pair(0xF2, Instruction("SBC", 12)));
  instruction_lookup.insert(make_pair(0xE7, Instruction("SBC", 13)));
  instruction_lookup.insert(make_pair(0xE3, Instruction("SBC", 14)));
  instruction_lookup.insert(make_pair(0xF3, Instruction("SBC", 15)));
  instruction_lookup.insert(make_pair(0x38, Instruction("SEC", 0)));
  instruction_lookup.insert(make_pair(0xF8, Instruction("SED", 0)));
  instruction_lookup.insert(make_pair(0x78, Instruction("SEI", 0)));
  instruction_lookup.insert(make_pair(0xE2, Instruction("SEP", 25)));
  instruction_lookup.insert(make_pair(0x8D, Instruction("STA", 2)));
  instruction_lookup.insert(make_pair(0x8F, Instruction("STA", 3)));
  instruction_lookup.insert(make_pair(0x85, Instruction("STA", 4)));
  instruction_lookup.insert(make_pair(0x91, Instruction("STA", 5)));
  instruction_lookup.insert(make_pair(0x97, Instruction("STA", 6)));
  instruction_lookup.insert(make_pair(0x81, Instruction("STA", 7)));
  instruction_lookup.insert(make_pair(0x95, Instruction("STA", 8)));
  instruction_lookup.insert(make_pair(0x9D, Instruction("STA", 9)));
  instruction_lookup.insert(make_pair(0x9F, Instruction("STA", 10)));
  instruction_lookup.insert(make_pair(0x99, Instruction("STA", 11)));
  instruction_lookup.insert(make_pair(0x92, Instruction("STA", 12)));
  instruction_lookup.insert(make_pair(0x87, Instruction("STA", 13)));
  instruction_lookup.insert(make_pair(0x83, Instruction("STA", 14)));
  instruction_lookup.insert(make_pair(0x93, Instruction("STA", 15)));
  instruction_lookup.insert(make_pair(0xDB, Instruction("STP", 0)));
  instruction_lookup.insert(make_pair(0x8E, Instruction("STX", 2)));
  instruction_lookup.insert(make_pair(0x86, Instruction("STX", 4)));
  instruction_lookup.insert(make_pair(0x96, Instruction("STX", 8)));
  instruction_lookup.insert(make_pair(0x8C, Instruction("STY", 2)));
  instruction_lookup.insert(make_pair(0x84, Instruction("STY", 4)));
  instruction_lookup.insert(make_pair(0x94, Instruction("STY", 8)));
  instruction_lookup.insert(make_pair(0x9C, Instruction("STZ", 2)));
  instruction_lookup.insert(make_pair(0x64, Instruction("STZ", 4)));
  instruction_lookup.insert(make_pair(0x74, Instruction("STZ", 8)));
  instruction_lookup.insert(make_pair(0x9E, Instruction("STZ", 9)));
  instruction_lookup.insert(make_pair(0xAA, Instruction("TAX", 0)));
  instruction_lookup.insert(make_pair(0xA8, Instruction("TAY", 0)));
  instruction_lookup.insert(make_pair(0x5B, Instruction("TCD", 0)));
  instruction_lookup.insert(make_pair(0x1B, Instruction("TCS", 0)));
  instruction_lookup.insert(make_pair(0x7B, Instruction("TDC", 0)));
  instruction_lookup.insert(make_pair(0x1C, Instruction("TRB", 2)));
  instruction_lookup.insert(make_pair(0x14, Instruction("TRB", 4)));
  instruction_lookup.insert(make_pair(0x0C, Instruction("TSB", 2)));
  instruction_lookup.insert(make_pair(0x04, Instruction("TSB", 4)));
  instruction_lookup.insert(make_pair(0x3B, Instruction("TSC", 0)));
  instruction_lookup.insert(make_pair(0xBA, Instruction("TSX", 0)));
  instruction_lookup.insert(make_pair(0x8A, Instruction("TXA", 0)));
  instruction_lookup.insert(make_pair(0x9A, Instruction("TXS", 0)));
  instruction_lookup.insert(make_pair(0x9B, Instruction("TXY", 0)));
  instruction_lookup.insert(make_pair(0x98, Instruction("TYA", 0)));
  instruction_lookup.insert(make_pair(0xBB, Instruction("TYX", 0)));
  instruction_lookup.insert(make_pair(0xCB, Instruction("WAI", 0)));
  instruction_lookup.insert(make_pair(0xEB, Instruction("XBA", 0)));
  instruction_lookup.insert(make_pair(0xFB, Instruction("XCE", 0)));
  instruction_lookup.insert(make_pair(0x02, Instruction("COP", 0)));
  instruction_lookup.insert(make_pair(0x54, Instruction("MVN", 27)));
  instruction_lookup.insert(make_pair(0x44, Instruction("MVP", 27)));
}

