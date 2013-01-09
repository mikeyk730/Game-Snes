#ifndef PROTO_H
#define PROTO_H

#include <string>

class Instruction;

void dotype(const Instruction& instr, unsigned char bank);
unsigned int hex(char *s);
void comment(unsigned char low, unsigned char high);
void spaces(int number);
void dodcb(int bank, int pc, int endbank, int eend);
void addlink(char *label, unsigned char b, int addr);
void loadsymbols(char *fname);
char *checksym(char bank, int pc);
char read_char(FILE * stream);

const int ALWAYS_USE_LABEL = 0x01;
const int NEEDS_W_IN_16_MODE = 0x02;

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
    {}

    inline std::string name() const { return m_name; }
    inline unsigned char addressMode() const { return m_address_mode; }
    inline bool alwaysUseLabel() const { return (m_bitmask & ALWAYS_USE_LABEL); }
    inline bool needsW() const { return (m_bitmask & NEEDS_W_IN_16_MODE); }

private:
    std::string m_name;
    unsigned char m_address_mode;
    int m_bitmask;
};

#endif
