#ifndef PROTO_H
#define PROTO_H

#include <string>
#include <iostream>
#include <map>

#define HELP "help!\n"
extern FILE *srcfile;

class Instruction;

unsigned int hex(const char *s);
void spaces(int number);
char read_char(FILE * stream);
std::string to_string(int i, int length, bool in_hex=true);
std::istream& get_address(std::istream& in, unsigned char& bank, unsigned int& addr);
int full_address(int bank, int pc);

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

    inline std::string name(bool accum16 = false) const { 
        if (m_address_mode == 1 && accum16 == 1) return (m_name + ".W");
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

struct DisassemblerProperties{
  DisassemblerProperties() :
    m_comment_level(1),
    m_quiet(false),
    m_accum_16(false),
    m_index_16(false),
    m_stop_at_rts(false),
    m_start_bank(0x00),
    m_start_addr(0x8000), 
    m_end_bank(0xFF),
    m_end_addr(0xFFFF)
  {}  

  int m_comment_level;

  bool m_quiet;
  bool m_accum_16;
  bool m_index_16;
  bool m_stop_at_rts;

  unsigned char m_start_bank; 
  unsigned int m_start_addr;
  
  unsigned char m_end_bank;
  unsigned int m_end_addr;
};




#endif
