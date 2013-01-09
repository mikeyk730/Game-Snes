#include <cstdio>
#include <cstring>

#include <iostream>
#include <string>
#include <iomanip>
#include "disasm.h"
#include "proto.h"

using namespace std;

void dodcb(int bank, int pc, int endbank, int eend)
{
  char s2[10];

  for(int i=0; bank * 65536 + pc < endbank * 65536 + eend; ++i){
    if (i%8 == 0){
      cout << endl;
      string label = get_label(Instruction("",0,ALWAYS_USE_LABEL | NO_ADDR_LABEL), bank, pc);
      cout << setw(20) << left << label;
      if (!quiet) cout << string(14, ' ');
      cout << "dcb ";
    }

    //adjust address if necessary
    pc++;
    sprintf(s2, "%.4X", pc);
    if (strlen(s2) == 5){
      bank++;
      if (hirom)
	pc -= 0x10000;
      else
	pc -= 0x8000;
    }

    //read and print byte
    unsigned char c = read_char(srcfile);
    printf("$%.2X", c);
    if (i%8 != 7 && (bank * 65536 + pc < endbank * 65536 + eend)) printf(",");
  }
}
