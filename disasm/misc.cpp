#include <cstdio>
#include <cstring>

#include <iomanip>
#include <iostream>
#include <map>
#include <string>
#include <sstream>

#include "disasm.h"
#include "proto.h"

using namespace std;

string to_string(int i, int length, bool in_hex)
{
    ostringstream ss;
    ss.setf(ios::uppercase);
    
    if (in_hex)
        ss << hex << setfill('0') << setw(length) << i;
    else
        ss << dec << setfill('0') << setw(length) << i;

    return ss.str();
}

int full_address(int bank, int pc){
    return bank * 65536 + pc;
}


unsigned int hex(char *s)
{
    istringstream ss(s);
    unsigned int total;
    ss >> hex >> total;
    return total;
}

void spaces(int number)
{
  cout << endl << string(number, ' ');
}

char read_char(FILE * stream)
{
    char c;
    fread (&c, 1, 1, stream);
    return c;
}