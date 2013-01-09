#include <sstream>

#include "proto.h"

using namespace std;

namespace{
    unsigned int get_start_from_address(long offset, bool hirom){
        if (hirom)
            offset += 0x8000;
        fseek(srcfile, offset, 1);

        unsigned char a, b;
        a = read_char(srcfile); b = read_char(srcfile);
        if (feof(srcfile)){
            printf("Error -- could not locate vector\n");
            exit(-1);
        }
        return (b * 256 + a);
    }
}

bool Request::get(istream & in, bool hirom)
{
    string line;
    if (!getline(in, line))
        return false;

    unsigned int pc = 0x8000;    
    unsigned char bank = 0;

    istringstream ss(line);
    string current;    
    while(ss >> current){
        if (current == "-d")
            m_dcb = true;
        else if (current == "-q")
            m_properties.m_quiet = true;
        else if (current == "-a")
            m_properties.m_accum_16 = true;
        else if (current == "-x")
            m_properties.m_index_16 = true;
        else if (current == "--rts")
            m_properties.m_stop_at_rts = true;
        else if (current == "--nmi")
            pc = get_start_from_address(0x7fea, hirom);
        else if (current == "--reset")
            pc = get_start_from_address(0x7ffc, hirom);
        else if (current == "--irq")
            pc = get_start_from_address(0x7fee, hirom);
        else if(current.length() > 2 && current[0] == '-'){
            if(current[1] == 'c'){
                const char* s = &(current.c_str()[2]);
                m_properties.m_comment_level = hex(s);
            }
            else if(current[1] == 'b'){
                const char* s = &(current.c_str()[2]);
                int full = hex(s);
                pc = (full & 0x0FFFF);
                bank = ((full >> 16) & 0x0FF);
            }
            else if(current[1] == 'e'){
                const char* s = &(current.c_str()[2]);
                int full = hex(s);
                m_properties.m_end_addr = (full & 0x0FFFF);
                m_properties.m_end_bank = ((full >> 16) & 0x0FF);
            }      
        }
    }

    m_properties.m_start_addr = pc;
    m_properties.m_start_bank = bank;
}
