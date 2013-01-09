#include <cstdio>
#include <cstring>
#include <cstdlib>

#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <iomanip>
#include <map>

#include "disasm.h"
#include "proto.h"

using namespace std;

namespace{
    map<int, string> label_lookup;
}

void add_label(int bank, int pc, const string& label)
{
    int full_addr = full_address(bank,pc);
    label_lookup.insert(make_pair(full_addr, label));
}

void loadsymbols(char *fname)
{
  fstream in(fname);
  string line;
  while (getline(in, line)){
    //skip comments
      if (line.length() < 1 || line[0] == ';')
      continue;

    int fulladdr;
    string label;
    istringstream line_stream(line);
    if(!(line_stream >> hex >> fulladdr >> label))
      continue;
    
    unsigned int addr = (fulladdr & 0x0FFFF);   
    unsigned char bank = ((fulladdr >> 16) & 0x0FF);

    add_label(bank, addr, label);
  }
}

void loaddata(char *fname)
{
  fstream in(fname);
  string line;
  while (getline(in, line)){
    //skip comments
      if (line.length() < 1 || line[0] == ';')
      continue;

    int full;
    string label;
    istringstream line_stream(line);
    if(!(line_stream >> hex >> full))
      continue;

    unsigned int addr = (full & 0x0FFFF);
    unsigned char bank = ((full >> 16) & 0x0FF);

    //no label, create one
    if(!(line_stream >> label >> label))
        label = "DATA_" + to_string(bank,2) + "_" + to_string(addr,4);
     
    add_label(bank, addr, label);
  }
}

string get_label(const Instruction& instr, unsigned char bank, int pc)
{
  string label;

  map<int, string>::iterator it = label_lookup.find(full_address(bank,pc));
  if (it != label_lookup.end())
      label = it->second;
  
  //else if (instr.alwaysUseLabel())
      //return "";

  else if(!instr.neverUseLabel() && (instr.alwaysUseLabel() || pc >= 32768) &&
      !instr.neverUseAddrLabel() && bank < 126)
        label = "ADDR_" + to_string(bank, 2) + /*"_" +*/ to_string(pc, 4);
  
  return label;
}

