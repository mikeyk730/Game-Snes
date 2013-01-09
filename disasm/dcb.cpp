#include <cstdio>
#include <cstring>

#include "disasm.h"
#include "proto.h"

void dodcb(int bank, int pc, int endbank, int eend)
{
  unsigned char c;
  int i = 0;
  char s2[10];

  while (bank * 65536 + pc < endbank * 65536 + eend)
  {
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

    if (!i) printf("\n	dcb ");
    printf("$%.2X", c);
    i++;
    if (i < 8) printf(",");
    else i = 0;
  }
  printf("\n");
}
