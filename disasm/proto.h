#ifndef PROTO_H
#define PROTO_H

#include <string>

class Instruction;

void dotype(const Instruction& instr, unsigned char bank);
unsigned int hex(char *s);
void comment(unsigned char low, unsigned char high);
void spaces(int number);
void dodcb(int bank, int pc, int endbank, int eend);
void addlink(const char *label, unsigned char b, int addr);
void loaddata(char *fname);
void loadsymbols(char *fname);
std::string get_label(const Instruction& instr, char bank, int pc);
char read_char(FILE * stream);
std::string to_string(int i, int fill, bool in_hex=true);

const int ALWAYS_USE_LABEL = 0x01;
const int NO_ADDR_LABEL = 0x02;

class Instruction{
public:
    Instruction() :
        m_name(""), 
        m_address_mode(-1), 
        m_bitmask(0)
    {}

    Instruction(const std::string& name, unsigned char address_mode, int bitmask=0) :
        m_name(name), 
        m_address_mode(address_mode), 
        m_bitmask(bitmask)
    { }

    inline std::string name() const { 
        if (m_address_mode == 1 && accum == 1) return (m_name + ".W");
        return m_name; 
    }
    inline unsigned char addressMode() const { return m_address_mode; }
    inline bool alwaysUseLabel() const { return (m_bitmask & ALWAYS_USE_LABEL); }
    inline bool neverUseLabel() const { return (m_address_mode == 1); }
    inline bool neverUseAddrLabel() const { return (m_bitmask & NO_ADDR_LABEL); }

private:
    std::string m_name;
    unsigned char m_address_mode;
    int m_bitmask;
};

#endif
