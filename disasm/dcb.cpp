#include <cstdio>
#include <cstring>

#include <iostream>
#include <string>

#include "disasm.h"
#include "proto.h"

using namespace std;

void dodcb(int bank, int pc, int endbank, int eend)
{
  string label;
  unsigned char c;
  int i = 0;
  char s2[10];

  while (bank * 65536 + pc < endbank * 65536 + eend)
  {
 
      if (i%8 == 0){
        cout << endl;
        label = get_label(Instruction("",0,ALWAYS_USE_LABEL | NO_ADDR_LABEL), bank, pc);
        if (label != "")
            cout << label;
        if (!quiet) cout << "           ";
        cout << "    dcb ";
      }

    c = read_char(srcfile);
    pc++;
      sprintf(s2, "%.4X", pc);
      if (strlen(s2) == 5)
      {
        bank++;
        if (hirom)
          pc -= 0x10000;
        else
          pc -= 0x8000;
      }

    //    if (!i) printf("\n	dcb ");
    printf("$%.2X", c);
    i++;
    if (i%8 < 8 && (bank * 65536 + pc < endbank * 65536 + eend)) printf(",");
  }
  //printf("\n");
}
