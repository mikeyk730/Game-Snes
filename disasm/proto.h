#ifndef PROTO_H
#define PROTO_H

#include <string>
#include <iostream>
#include <map>

#define HELP "disasm.exe ROM_FILENAME\n"
extern FILE *srcfile;

struct DisassemblerContext;
struct DisasmState;
struct Instruction;

unsigned int hex(const char *s);
std::string spaces(int number);
std::string to_string(int i, int length, bool in_hex=true);
std::istream& get_address(std::istream& in, unsigned char& bank, unsigned int& addr);



#endif
