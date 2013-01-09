#ifndef PROTO_H
#define PROTO_H

void find(unsigned char c);
void dotype(unsigned char t);
unsigned int hex(char *s);
void comment(unsigned char low, unsigned char high);
void spaces(int number);
void dodcb(int bank, int pc, int endbank, int eend);
void addlink(char *label, unsigned char b, int addr);
void loadsymbols(char *fname);
char *checksym(char bank, int pc);
char read_char(FILE * stream);

#endif
