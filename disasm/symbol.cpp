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

    add_label(bank, addr, label);
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
     
    add_label(bank, addr, label);
    count++;
  }

  //printf("; Loaded %d symbols from %s\n", count, fname);
}

string get_label(const Instruction& instr, char bank, int pc)
{
  string the_label;
  map<int, string>::iterator it = label_lookup.find(full_address(bank,pc));
  if (it != label_lookup.end())
      return it->second;

  if(!instr.neverUseLabel() && (instr.alwaysUseLabel() || pc >= 32768) && bank < 126){
    if (!instr.neverUseAddrLabel())
        the_label = "ADDR_" + to_string(bank, 2) + "_" + to_string(pc, 4);
    else
        the_label = "            ";
  }
  return the_label;
}

