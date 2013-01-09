#include <cstdio>
#include <cstring>

#include <iomanip>
#include <iostream>
#include <map>
#include <string>
#include <sstream>

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

istream& get_address(istream& in, unsigned char& bank, unsigned int& addr)
{
    unsigned int full;
    if(!(in >> hex >> full))
        return in;

    addr = (full & 0x0FFFF);
    bank = ((full >> 16) & 0x0FF);
    return in;
}

unsigned int hex(const char *s)
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
