#include <cstdio>
#include <cstring>
#include <cstdlib>

#include <iostream>
#include <iomanip>
#include <map>

#include "disasm.h"
#include "proto.h"

using namespace std;

void main (int argc, char *argv[])
{
  Disassembler disasm;
  Request request;

  int i, cc;
  unsigned char code, a, b;
  char s2[80];
  
  flag = 0;

  if (argc < 2){
    printf(USAGE);
    exit(-1);
  }  
  
  srcfile = fopen(argv[--argc],"rb");
  if (srcfile == NULL){
    printf("Could not open %s for reading.\n", argv[argc]);
    exit(-1);
  }
  
  //skip header
  fseek(srcfile, 512, 0);
  i = 1;

  unsigned char bank = 0;

  //process arguments
  for(int i = 1; i < argc; ++i){
    string current(argv[i]);

    if (current == "-q")
      disasm.m_quiet = true;
    else if (current == "-d")
      request.m_dcb = true;
    else if (current == "-a")
      request.m_accum_16;
    else if (current == "-x")
      request.m_index_16;

    else if (current == "--data" && ++i < argc)
      loaddata(argv[i]);
    else if (current == "--sym" && ++i < argc)
      loadsymbols(argv[i]);

    else if (current == "--rts")
      request.m_stop_at_rts = true;
    else if (current == "--hirom")
      disasm.m_hirom = true;
    else if (current == "--nmi")
      request.m_nmi = true;
    else if (current == "--reset")
      request.m_reset = true;
    else if (current == "--irq")
      request.m_irq = true;

    else if (current == "--help"){
      printf(USAGE);
      printf(HELP);
      exit(-1);
    }


    else if(current.length() > 2 && current[0] == '-'){
      if(current[1] == 'c'){
	const char* s = &(current.c_str()[2]);
	disasm.m_comment_level = hex(s);
      }
      else if(current[1] == 'b'){
	const char* s = &(current.c_str()[2]);
	int full = hex(s);
	request.m_start_addr = (full & 0x0FFFF);
	request.m_start_bank = ((full >> 16) & 0x0FF);
      }
      else if(current[1] == 'e'){
	const char* s = &(current.c_str()[2]);
	int full = hex(s);
	request.m_end_addr = (full & 0x0FFFF);
	request.m_end_bank = ((full >> 16) & 0x0FF);
      }      
    }
  }


  pc = request.m_start_addr;
  bank = request.m_start_bank;
  pc_end = request.m_end_addr; 
  end_bank = request.m_end_bank;

  accum = request.m_accum_16;
  index = request.m_index_16;
  int rts = request.m_stop_at_rts;
  comments = disasm.m_comment_level;
  quiet = disasm.m_quiet;
    
  if(request.m_nmi){
    if (disasm.m_hirom)
      fseek(srcfile, 0xffea, 1);
    else
      fseek(srcfile, 0x7fea, 1);
    a = read_char(srcfile); b = read_char(srcfile);
    if (feof(srcfile)){
      printf("Error -- could not locate NMI vector\n");
      exit(-1);
    }
    pc = b * 256 + a;
    if (disasm.m_hirom)
      fseek(srcfile, -0xffec, 1);
    else
      fseek(srcfile, -0x7fec, 1);
  }

  if(request.m_reset){
    if (disasm.m_hirom)
      fseek(srcfile, 0xfffc, 1);
    else
      fseek(srcfile, 0x7ffc, 1);
    a = read_char(srcfile); b = read_char(srcfile);
    if (feof(srcfile)){
      printf("Error -- could not locate RESET vector\n");
      exit(-1);
    }
    pc = b * 256 + a;
    if (disasm.m_hirom)
      fseek(srcfile, -0xfffe, 1);
    else
      fseek(srcfile, -0x7ffe, 1);
  }

  if(request.m_irq){        
    if (disasm.m_hirom)
      fseek(srcfile, 0xffee, 1);
    else
      fseek(srcfile, 0x7fee, 1);
    a = read_char(srcfile); b = read_char(srcfile);
    if (feof(srcfile)){      
      printf("Error -- could not locate IRQ vector\n");
      exit(-1);
    }
    pc = b * 256 + a;
    if (disasm.m_hirom)
      fseek(srcfile, -0xfff0, 1);
    else
      fseek(srcfile, -0x7ff0, 1);
  }
  
  for(cc=0; cc<bank; cc++)  /* skip over each bank */
    if (disasm.m_hirom)
      fseek(srcfile, 65536, 1);
    else
      fseek(srcfile, 32768, 1);
  
  if (disasm.m_hirom)
    fseek(srcfile, pc, 1);
  else
    fseek(srcfile, pc - 0x8000, 1);

  /*printf("; Disassembly of %s by mikeyk\n", argv[argc-1]);
  printf("; Begin: $%.2X%.4X  End: ", bank, pc);
  if (rts)
    printf("RTS/RTL/RTI\n");
  else
    printf("$%.2X%.4X\n", end_bank, pc_end);
  
  printf("; Hirom: ");
  if (disasm.m_hirom) printf("Yes"); else printf("No ");
  printf("  Quiet: ");
  if (quiet) printf("Yes"); else printf("No ");
  printf("  Comments: %d  DCB: ", comments);
  if (request.m_dcb) printf("Yes"); else printf("No ");
  printf("  65816: ");
  if (asmbler) printf("Yes"); else printf("No ");*/
    
  if (request.m_dcb){
    disasm.dodcb(bank, pc, end_bank, pc_end);
    exit(-1);
  }

  printf("\n\n");

  while( (!feof(srcfile)) && (bank * 65536 + pc < end_bank * 65536 + pc_end)
	 && (rts >= 0) ){

    code = read_char(srcfile);
    Instruction instr = disasm.m_instruction_lookup[code];
    
    if (!feof(srcfile)){

      //adjust pc address
      sprintf(s2, "%.4X", pc);
      if (strlen(s2) == 5){
	bank++;
	if (disasm.m_hirom)
	  pc -= 0x10000;
	else
	  pc -= 0x8000;
      }

      string label = get_label(Instruction("",0,ALWAYS_USE_LABEL), bank, pc);
      cout << left << setw(20) << label;

      if (!quiet) cout << to_string(code, 2) << " ";

      sprintf(buff2, "%s ", instr.name().c_str());

      pc++;
      high = 0; low = 0; flag = 0;
      dotype(instr, bank);
      if (!quiet) printf("  ");
      cout << buff2;
      if (!quiet) printf("     ");
      if (instr.name() == "RTS" || instr.name() == "RTI" || instr.name() == "RTL" ){
	printf("\t\t; Return\n");
	if(rts) rts = -1;
      }
      if (high) comment(low, high);
      if (flag > 0){

    	printf("\t;");
	if (flag & 0x10) printf(" Index (16 bit)");
	if (flag & 0x20) printf(" Accum (16 bit)");
      }
      else if (flag < 0){

	printf("\t;");
	if ( (-flag) & 0x10) printf(" Index (8 bit)");
	if ( (-flag) & 0x20) printf(" Accum (8 bit)");
      }
      printf("\n");
    }
    if (feof(srcfile)) printf("; End of file.\n");
  }
}



