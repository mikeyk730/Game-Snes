#include <sstream>
#include <iomanip>
#include "request.h"
#include "utils.h"

using namespace std;
using namespace Address;

namespace{
    //unsigned int get_start_from_address(long offset, bool hirom){
    //    if (hirom)
    //        offset += 0x8000;
    //    fseek(srcfile, offset, 1);

    //    unsigned char a, b;
    //    a = read_char(srcfile); b = read_char(srcfile);
    //    if (feof(srcfile)){
    //        printf("Error -- could not locate vector\n");
    //        exit(-1);
    //    }
    //    return address_16bit(a, b);
    //}

    unsigned int hex(const char *s)
    {
        istringstream ss(s);
        unsigned int total;
        ss >> std::hex >> total;
        return total;
    }
}

bool Request::get(istream & in, bool hirom)
{
    string line;
    if (!getline(in, line))
        return false;

    unsigned int pc = 0x8000;    
    unsigned char bank = 0;

    int address_count = 0;
    istringstream ss(line);
    string current; 
    if (!(ss >> current)) return false;
    do{
        if (current == "data" || current == "dcb")
            m_type = Dcb;
        else if (current == "asm")
            m_type = Asm;
        else if (current == "-q")
            m_properties.m_quiet = true;
        else if (current == "-a")
            m_properties.m_start_w_accum_16 = true;
        else if (current == "-i")
            m_properties.m_start_w_index_16 = true;
        else if (current == "-r")
            m_properties.m_stop_at_rts = true;
        else if (current == "-e")
            m_properties.m_use_extern_symbols = true;
        else if (current == "-p")
            m_properties.m_passes = 2;
        //else if (current == "nmi"){
        //    pc = get_start_from_address(0x7fea, hirom);
        //    address_count++;
        //}
        //else if (current == "reset"){
        //    pc = get_start_from_address(0x7ffc, hirom);
        //    address_count++;
        //}
        //else if (current == "irq"){
        //    pc = get_start_from_address(0x7fee, hirom);
        //    address_count++;
        //}
        else if (current == "quit" || current == "exit"){
            m_quit = true;
            return true;
        }
        else if(current.length() > 2 && current[0] == '-' && current[1] == 'c'){
            const char* s = &(current.c_str()[2]);  
            m_properties.m_comment_level = hex(s);
        }
        else if(address_count == 0){
            int full = hex(current.c_str());
            pc = addr16_from_addr24(full);
            bank = bank_from_addr24(full);
            address_count++;
        }
        else if(address_count == 1){
            int full = hex(current.c_str());
            m_properties.m_end_addr = addr16_from_addr24(full);
            m_properties.m_end_bank = bank_from_addr24(full);
            address_count++;
        }
        else if(address_count > 1){
            cout << "bad usage" << endl << endl;
            return false;
        }
    } while(ss >> current);

    if (address_count == 0){
        cout << "bad usage" << endl << endl;
        return false;
    }
    else if(address_count == 1){
        m_properties.m_end_bank = bank;
        m_properties.m_end_addr = pc + 0x080;
    }

    m_properties.m_start_addr = pc;
    m_properties.m_start_bank = bank;

    return true;
}
