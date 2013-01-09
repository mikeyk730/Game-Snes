#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <iomanip>
#include "disasm.h"
#include "proto.h"

using namespace std;

string to_string(int i, int fill, bool in_hex)
{
    ostringstream ss;
    ss.setf(ios::uppercase);
    
    if (in_hex)
        ss << hex << setfill('0') << setw(fill) << i;
    else
        ss << dec << setfill('0') << setw(fill) << i;

    return ss.str();
}

void addlink(const char *label, unsigned char b, int addr)
{
  link *newlink;

  newlink = (link *)malloc(sizeof(link));
  strcpy(newlink->label, label);
  newlink->bank = b;
  newlink->address = addr;
  newlink->next = first;
  first = newlink;
}

void loadsymbols(char *fname)
{
  fstream in(fname);
  int count = 0;

  string line;
  while (getline(in, line)){
    if (line.length() < 1 || line[0] == ';')
      continue;
    int fulladdr;
    string label;
    istringstream line_stream(line);
    if(!(line_stream >> hex >> fulladdr >> label))
      continue;
    
    unsigned int addr = (fulladdr & 0x0FFFF);   
    unsigned char bank = ((fulladdr >> 16) & 0x0FF);

    addlink(label.c_str(), bank, addr);
    //cout << label << int(bank) << addr << endl;
    count++;
  }
}

void loaddata(char *fname)
{
  fstream in(fname);
  int count = 0;

  string line;
  while (getline(in, line)){
    if (line.length() < 1 || line[0] == ';')
      continue;
    int fulladdr;
    string label;
    istringstream line_stream(line);
    if(!(line_stream >> hex >> fulladdr >> label))
      continue;

    unsigned int addr = (fulladdr & 0x0FFFF);
    unsigned char bank = ((fulladdr >> 16) & 0x0FF);

    //no label, create one
    if(!(line_stream >> label)){
        ostringstream ss;
        ss.setf(ios::uppercase);
        ss << "DATA_" 
           << hex << setfill('0') << setw(2) << int(bank)
           << "_"
           << hex << setfill('0') << setw(2) << addr;
        label = ss.str();
    }
     
    addlink(label.c_str(), bank, addr);
    count++;
  }

  //printf("; Loaded %d symbols from %s\n", count, fname);
}

string get_label(const Instruction& instr, char bank, int pc)
{
  string the_label;

  for (link *ptr = first; ptr; ptr = ptr->next){
      if (ptr->bank * 65536 + ptr->address == bank * 65536 + pc)
        return string(ptr->label);
  }

  if(!instr.neverUseLabel() && (instr.alwaysUseLabel() || pc >= 32768) && bank < 126){
    if (!instr.neverUseAddrLabel())
        the_label = "ADDR_" + to_string(bank, 2) + "_" + to_string(pc, 4);
    else
        the_label = "            ";
  }
  return the_label;
}

