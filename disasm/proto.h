#ifndef PROTO_H
#define PROTO_H

#include <string>
#include <iostream>
#include <map>

#define HELP "disasm.exe ROM_FILENAME\n"
extern FILE *srcfile;

class Instruction;
struct StateContext;
struct DisasmState;
struct InstructionOutput;

unsigned int hex(const char *s);
std::string spaces(int number);
char read_char(FILE * stream);
std::string to_string(int i, int length, bool in_hex=true);
std::istream& get_address(std::istream& in, unsigned char& bank, unsigned int& addr);
int full_address(int bank, int pc);

const int IS_BRANCH = 0x01;
const int NO_ADDR_LABEL = 0x02;
const int LINE_LABEL = 0x04;

class Instruction{
    typedef void(*HandlerPtr)(DisasmState*, StateContext*, InstructionOutput*);
    typedef std::string(*BarPtr)(bool, bool);
public:
    Instruction() :
        m_name(""), 
        m_address_mode_handler(0), 
        m_bitmask(0)
    {}

    Instruction(const std::string& name, HandlerPtr address_mode_handler, BarPtr bar = 0, int bitmask = 0) :
        m_name(name), 
        m_address_mode_handler(address_mode_handler),
        m_bar(bar),
        m_bitmask(bitmask)
    { }

    inline std::string name() const { 
        return m_name; 
    }

    inline std::string annotated_name(bool is_accum_16, bool is_index_16) const {
        if (m_bar){
            return m_name + (*m_bar)(is_accum_16, is_index_16);
        }
        return m_name ;
    }

    //int(*)(FILE *, char *, char *, bool, bool) a();// { return m_address_mode_handler; }
    inline bool isBranch() const { return (m_bitmask & IS_BRANCH); }
    inline bool neverUseAddrLabel() const { return (m_bitmask & NO_ADDR_LABEL); }
    inline bool isLineLabel() const { return (m_bitmask & LINE_LABEL); }
    bool isCodeBreak() const{
        return (m_name == "RTS" || m_name == "RTI" || m_name == "RTL"
            || m_name == "JMP" || m_name == "BRA");
    }
    
    HandlerPtr m_address_mode_handler;
    BarPtr m_bar;
private:
    std::string m_name;
    
    int m_bitmask;
};






#endif
