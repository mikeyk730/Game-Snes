#include <cstdio>
#include <cstring>

#include "disasm.h"
#include "proto.h"

void dotype(unsigned char t)
{
  unsigned char i, j, k;
  long ll;
  unsigned char h;
  char r, *msg;

  switch (t)
  {
    case 0 : if (!quiet) printf("         "); break;
    case 1 : i = read_char(srcfile); pc++; if (!quiet) printf("%.2X ", i);
/* Accum  #$xx or #$xxxx */
             ll = i; strcat(buff2,"#");
             if ( (asmbler == 1) && (accum == 0) ) strcat(buff2,"<");
             if (accum == 1) { j = read_char(srcfile); pc++; ll = j * 256 + ll;
               if (!quiet) printf("%.2X ", j); }
             msg = checksym(bank, ll); if (msg == NULL) if (accum == 0)
             sprintf(buff1, "$%.2X", ll); else sprintf(buff1, "$%.4X", ll);
             else sprintf(buff1, "%s", msg); strcat(buff2, buff1);
             if (!quiet) { printf("   "); if (accum == 0) printf("   "); }
             break;
    case 2 : i = read_char(srcfile); j = read_char(srcfile);
/* $xxxx */  if (!quiet) printf("%.2X %.2X    ",i,j);
             msg = checksym(bank, j * 256 + i); 
             if (msg == NULL) sprintf(buff1, "$%.2X%.2X", j, i); 
             else sprintf(buff1, "%s",msg);
             strcat(buff2, buff1);
             pc += 2; high = j; low = i; break;
    case 3 : i = read_char(srcfile); j = read_char(srcfile); k = read_char(srcfile);
/* $xxxxxx */ if (!quiet) printf("%.2X %.2X %.2X ", i, j, k);
             if (asmbler == 1) strcat(buff2, ">");
             msg = checksym(k, j * 256 + i); if (msg == NULL)
             sprintf(buff1, "$%.2X%.2X%.2X", k, j, i);
             else sprintf(buff1, "%s", msg);  strcat(buff2, buff1); 
             pc += 3; break;
    case 4 : i = read_char(srcfile); if (!quiet) printf("%.2X       ", i);
/* $xx */    if (asmbler == 1) strcat(buff2, "<");
             msg = checksym(bank, i); if (msg == NULL)
             sprintf(buff1, "$%.2X", i);
             else sprintf(buff1, "%s", msg); strcat(buff2, buff1);
             pc++; break;
    case 5 : i = read_char(srcfile); if (!quiet) printf("%.2X       ", i);
/* ($xx),Y */ msg = checksym(bank, i); if (msg == NULL)
             sprintf(buff1, "($%.2X),Y", i);
             else sprintf(buff1, "(%s),Y" ,msg);
             strcat(buff2, buff1); pc++; break;
    case 6 : i = read_char(srcfile); if (!quiet) printf("%.2X       ", i);
/* [$xx],Y */ msg = checksym(bank, i);  if (msg == NULL)
             sprintf(buff1, "[$%.2X],Y", i);
             else sprintf(buff1,"[%s],Y",msg);
             strcat(buff2, buff1); pc++; break; 
    case 7 : i = read_char(srcfile); if (!quiet) printf("%.2X       ", i);
/* ($xx,X) */ msg = checksym(bank, i); if (msg == NULL)
             sprintf(buff1, "($%.2X,X)", i);
             else sprintf(buff1, "(%s,X)", msg);
             strcat(buff2, buff1); pc++; break;
    case 8 : i = read_char(srcfile); if (!quiet) printf("%.2X       ", i);
/* $xx,X */  msg = checksym(bank, i); if (msg == NULL)
             sprintf(buff1, "$%.2X,X", i);
             else sprintf(buff1, "%s,X", msg);
             strcat(buff2, buff1); pc++; break;
    case 9 : i = read_char(srcfile); j = read_char(srcfile);
/* $xxxx,X */ if (!quiet) printf("%.2X %.2X    ",i,j);
             msg = checksym(bank, j * 256 + i); if (msg == NULL)
             sprintf(buff1, "$%.2X%.2X,X", j, i);
             else sprintf(buff1, "%s,X", msg);
             strcat(buff2, buff1); pc += 2; break;
    case 10: i = read_char(srcfile); j = read_char(srcfile); k = read_char(srcfile);
/* $xxxxxx,X */ if (!quiet) printf("%.2X %.2X %.2X ", i, j, k);
             if (asmbler == 1) strcat(buff2, ">");
             msg = checksym(k, j * 256 + i); if (msg == NULL)
             sprintf(buff1, "$%.2X%.2X%.2X,X", k, j, i);
             else sprintf(buff1, "%s,X", msg);
             strcat(buff2, buff1); pc += 3; break;
    case 11: i = read_char(srcfile); j = read_char(srcfile);
/* $xxxx,Y */ if (!quiet) printf("%.2X %.2X    ",i,j);
             msg = checksym(bank, j * 256 + i); if (msg == NULL)
             sprintf(buff1, "$%.2X%.2X,Y", j, i);
             else sprintf(buff1, "%s,Y", msg);
             strcat(buff2, buff1);
             pc += 2; break;
    case 12: i = read_char(srcfile); if (!quiet) printf("%.2X       ", i);
/* ($xx) */  msg = checksym(bank, i); if (msg == NULL)
             sprintf(buff1, "($%.2X)", i); else sprintf(buff1, "(%s)", msg);
             strcat(buff2, buff1); pc++; break;
    case 13: i = read_char(srcfile); if (!quiet) printf("%.2X       ", i);
/* [$xx] */  msg = checksym(bank, i); if (msg == NULL)
             sprintf(buff1, "[$%.2X]", i); else sprintf(buff1, "[%s]", msg);
             strcat(buff2, buff1); pc++; break;
    case 14: i = read_char(srcfile); if (!quiet) printf("%.2X       ", i);
/* $xx,S */  msg = checksym(bank, i); if (msg == NULL)
             sprintf(buff1, "$%.x,S", i); else sprintf(buff1, "%s,S", msg);
             strcat(buff2, buff1); pc++; break;
    case 15: i = read_char(srcfile); if (!quiet) printf("%.2X       ", i);
/* ($xx,S),Y */ msg = checksym(bank, i); if (msg == NULL)
             sprintf(buff1, "($%.2X,S),Y", i);
             else sprintf(buff1, "(%s,S),Y", msg);
             strcat(buff2, buff1); pc++; break;
    case 16: r = read_char(srcfile); h = r; if (!quiet) printf("%.2X       ", h);
/* relative */ pc++; msg = checksym(bank, pc+r); if (msg == NULL)
             sprintf(buff1, "$%.4X", pc+r); else sprintf(buff1, "%s", msg);
             strcat(buff2, buff1); break;
    case 17: i = read_char(srcfile); j = read_char(srcfile); pc += 2;
/* relative long */ if (!quiet) printf("%.2X %.2X    ",i,j);
             ll = j * 256 + i; if (ll > 32767) ll = -(65536-ll);
      msg = checksym((bank*65536+pc+ll)/0x10000, (bank*65536+pc+ll)&0xffff);
             if (msg == NULL) sprintf(buff1, "$%.6x", bank*65536+pc+ll);
             else sprintf(buff1, "%s", msg);
             strcat(buff2, buff1); break;
    case 18: i = read_char(srcfile); j = read_char(srcfile); pc += 2;
/* #$xxxx */ if (!quiet) printf("%.2X %.2X    ",i,j);
             msg = checksym(bank, j * 256 + i); if (msg == NULL)
            sprintf(buff1, "#$%.2X%.2X", j, i); else sprintf(buff1,"#%s",msg);
             strcat(buff2, buff1); break;
/*    case 19: i = read_char(srcfile); j = read_char(srcfile); pc += 2;
/* [$xxxx]  if (!quiet) printf("%.2X %.2X    ",i,j);
             msg = checksym(bank, j * 256 + i); if (msg == NULL)
             sprintf(buff1, "[$%.2X%.2X]", j, i);
             else sprintf(buff1,"[%s]",msg);
             strcat(buff2, buff1); break;
don't really need this anymore.  will just comment it out before deleting
it */
    case 20: i = read_char(srcfile); j = read_char(srcfile); pc += 2;
/* ($xxxx) */ if (!quiet) printf("%.2X %.2X    ",i,j);
             msg = checksym(bank, j * 256 + i); if (msg == NULL)
         sprintf(buff1, "($%.2X%.2X)", j, i); else sprintf(buff1, "(%s)", msg);
             strcat(buff2, buff1); break;
    case 21: i = read_char(srcfile); j = read_char(srcfile); pc += 2;
/* ($xxxx,X) */ if (!quiet) printf("%.2X %.2X    ",i,j);
             msg = checksym(bank, j * 256 + i); if (msg == NULL)
             sprintf(buff1, "($%.2X%.2X,X)", j, i);
             else sprintf(buff1, "(%s,X)", msg);
             strcat(buff2,buff1); break;
    case 22: i = read_char(srcfile); if (!quiet) printf("%.2X       ", i); pc++;
/* $xx,Y */  msg = checksym(bank, i); if (msg == NULL)
             sprintf(buff1, "$%.2X,Y", i); else sprintf(buff1, "%s,Y", msg);
             strcat(buff2, buff1); break;
    case 23: i = read_char(srcfile); if (!quiet) printf("%.2X       ", i); pc++;
/* #$xx */   msg = checksym(bank, i); if (msg == NULL)
             sprintf(buff1, "#$%.2X", i); else sprintf(buff1, "#%s", msg);
             strcat(buff2, buff1); break;
    case 24: i = read_char(srcfile); if (!quiet) printf("%.2X       ", i); pc++;
/* REP */    sprintf(buff1,"#$%.2X", i); strcat(buff2, buff1);
             if (i & 0x20) { accum = 1; flag = i; }
             if (i & 0x10) { index = 1; flag = i; }
             break;
    case 25: i = read_char(srcfile); if (!quiet) printf("%.2X       ", i); pc++;
/* SEP */    sprintf(buff1, "#$%.2X", i); strcat(buff2, buff1);
             if (i & 0x20) { accum = 0; flag = -i; }
             if (i & 0x10) { index = 0; flag = -i; }
             break;
    case 26: i = read_char(srcfile); pc++; if (!quiet) printf("%.2X ", i);
/* Index  #$xx or #$xxxx */
             ll = i; strcat(buff2,"#");
             if ( (asmbler == 1) && (index == 0) ) strcat(buff2,"<");
             if (index == 1) { j = read_char(srcfile); pc++; ll = j * 256 + ll;
               if (!quiet) printf("%.2X ", j); }
             msg = checksym(bank, ll); if (msg == NULL) if (index == 0)
             sprintf(buff1, "$%.2X", ll); else sprintf(buff1, "$%.4X", ll);
             else sprintf(buff1, "%s", msg); strcat(buff2, buff1);
             if (!quiet) { printf("   "); if (index == 0) printf("   "); }
             break;
    case 27: i = read_char(srcfile); j = read_char(srcfile); pc += 2;
/* MVN / MVP */ if (!quiet) printf("%.2X %.2X    ", i, j);
             sprintf(buff1, "$%.2X,$%.2X", i, j); strcat(buff2, buff1); break;
    default: sprintf(buff2, "???"); break;
  }
}

